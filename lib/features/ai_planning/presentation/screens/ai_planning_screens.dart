import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/schemas/plan_entity.dart';
import '../../../../core/notifications/plan_notification_helper.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../domain/models/plan_models.dart';
import '../providers/ai_planning_provider.dart';

class AiPlanningScreen extends ConsumerStatefulWidget {
  const AiPlanningScreen({super.key});

  @override
  ConsumerState<AiPlanningScreen> createState() => _AiPlanningScreenState();
}

class _AiPlanningScreenState extends ConsumerState<AiPlanningScreen>
    with SingleTickerProviderStateMixin {
  final _inputController = TextEditingController();
  final _speech = SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _confirming = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize();
    if (mounted) {
      setState(() => _speechAvailable = available);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _tabController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleVoice() async {
    if (!_speechAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.voiceNotAvailable)),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        _inputController.text = result.recognizedWords;
        _inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: _inputController.text.length),
        );
      },
      localeId: 'uz_UZ',
      listenMode: ListenMode.dictation,
    );
  }

  Future<void> _generatePlan({bool saveAfter = false}) async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    ref.read(planGeneratingProvider.notifier).state = true;
    await ref.read(aiPlanningNotifierProvider.notifier).generateFromInput(input);
    ref.read(planGeneratingProvider.notifier).state = false;

    if (!mounted) return;
    final preview = ref.read(planPreviewProvider);
    if (preview == null || preview.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.planSaveFailed)),
      );
      return;
    }

    if (saveAfter) {
      await _confirmPlan();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_tabController.index != 1) {
        _tabController.animateTo(1);
      }
    });
  }

  Future<void> _generateAndSavePlan() => _generatePlan(saveAfter: true);

  Future<void> _confirmPlan() async {
    if (_confirming) return;
    _confirming = true;

    try {
      final saved =
          await ref.read(aiPlanningNotifierProvider.notifier).confirmPlan();
      if (!mounted) return;

      if (saved == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.planSaveFailed)),
        );
        return;
      }

      final settings = ref.read(settingsProvider);
      if (settings.notificationEnabled) {
        try {
          await ref.read(planNotificationHelperProvider).syncPlan(
                plan: saved,
                notificationsEnabled: true,
                leadMinutes: settings.notificationLeadMinutes,
              );
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reja saqlandi, lekin eslatma ruxsati berilmagan.',
              ),
            ),
          );
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.planSavedFor} ${AppDateFormat.formatDate(saved.planDate)}',
          ),
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_tabController.index != 2) {
          _tabController.animateTo(2);
        }
      });
    } finally {
      _confirming = false;
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _inputController.text = data!.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final generating = ref.watch(planGeneratingProvider);
    final planningState = ref.watch(aiPlanningNotifierProvider);

    return ModuleScreen(
      title: AppStrings.aiPlanning,
      showBackButton: true,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: AppStrings.voiceToPlan),
              Tab(text: AppStrings.planPreview),
              Tab(text: AppStrings.todaySchedule),
              Tab(text: AppStrings.lifeScore),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _InputTab(
                  controller: _inputController,
                  isListening: _isListening,
                  speechAvailable: _speechAvailable,
                  generating: generating || planningState.isLoading,
                  onVoice: _toggleVoice,
                  onPaste: _pasteFromClipboard,
                  onGenerate: () => _generatePlan(),
                  onGenerateAndSave: _generateAndSavePlan,
                ),
                _PreviewTab(
                  onOptimize: () =>
                      ref.read(aiPlanningNotifierProvider.notifier).optimizePreview(),
                  onConfirm: _confirmPlan,
                ),
                const _ScheduleTab(),
                const _ReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputTab extends StatelessWidget {
  const _InputTab({
    required this.controller,
    required this.isListening,
    required this.speechAvailable,
    required this.generating,
    required this.onVoice,
    required this.onPaste,
    required this.onGenerate,
    required this.onGenerateAndSave,
  });

  final TextEditingController controller;
  final bool isListening;
  final bool speechAvailable;
  final bool generating;
  final VoidCallback onVoice;
  final VoidCallback onPaste;
  final VoidCallback onGenerate;
  final VoidCallback onGenerateAndSave;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: ContentInsets.scrollPadding(context),
      children: [
        Text(
          AppStrings.voiceToPlanDesc,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: controller,
          hint: AppStrings.planInputHint,
          maxLines: 5,
          minLines: 3,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: isListening ? 'To\'xtatish' : AppStrings.voiceRecord,
                icon: isListening ? Icons.stop_rounded : Icons.mic_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: speechAvailable ? onVoice : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: AppStrings.pastePlan,
                icon: Icons.content_paste_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: onPaste,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: AppStrings.generateAndSavePlan,
          icon: Icons.save_rounded,
          isExpanded: true,
          isLoading: generating,
          onPressed: generating ? null : onGenerateAndSave,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: AppStrings.previewPlanOnly,
          icon: Icons.auto_awesome_rounded,
          isExpanded: true,
          variant: AppButtonVariant.secondary,
          isLoading: generating,
          onPressed: generating ? null : onGenerate,
        ),
      ],
    );
  }
}

class _PreviewTab extends ConsumerWidget {
  const _PreviewTab({
    required this.onOptimize,
    required this.onConfirm,
  });

  final VoidCallback onOptimize;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = ref.watch(planPreviewProvider);

    if (preview == null) {
      return const AppEmptyState(
        icon: Icons.event_note_outlined,
        title: AppStrings.planPreview,
        description: AppStrings.noPlanTodayDesc,
      );
    }

    if (preview.items.isEmpty) {
      return const AppEmptyState(
        icon: Icons.warning_amber_rounded,
        title: AppStrings.planWarnings,
        description: 'Reja bandlari topilmadi. Boshqa matn bilan urinib ko\'ring.',
      );
    }

    return ListView(
      padding: ContentInsets.scrollPadding(context),
      children: [
        Text(
          AppDateFormat.formatDate(preview.planDate),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (preview.warnings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.planWarnings,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.warning,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...preview.warnings.map(
            (warning) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                variant: AppCardVariant.filled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(warning.message),
                    if (warning.suggestion != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        warning.suggestion!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        ...preview.items.map((item) => _PlanItemTile(draft: item)),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: AppStrings.optimizePlan,
          icon: Icons.tune_rounded,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: onOptimize,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: AppStrings.confirmPlan,
          icon: Icons.check_rounded,
          isExpanded: true,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}

class _ScheduleTab extends ConsumerWidget {
  const _ScheduleTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeDate = ref.watch(activePlanDateProvider);
    final planAsync = ref.watch(planForDateProvider(activeDate));
    final suggestionsAsync = ref.watch(rescheduleSuggestionsProvider);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final activeNorm = DateTime(activeDate.year, activeDate.month, activeDate.day);
    final isToday = activeNorm == todayNorm;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            0,
          ),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text(AppStrings.today),
                selected: isToday,
                onSelected: (_) {
                  ref.read(activePlanDateProvider.notifier).state = todayNorm;
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              ChoiceChip(
                label: Text(AppStrings.tomorrow),
                selected: !isToday &&
                    activeNorm == todayNorm.add(const Duration(days: 1)),
                onSelected: (_) {
                  ref.read(activePlanDateProvider.notifier).state =
                      todayNorm.add(const Duration(days: 1));
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: planAsync.when(
            loading: () => const AppLoadingState(),
            error: (e, _) => AppErrorState(
              onRetry: () => ref.invalidate(planForDateProvider(activeDate)),
            ),
            data: (plan) {
              if (plan == null || plan.items.isEmpty) {
                return AppEmptyState(
                  icon: Icons.today_outlined,
                  title: isToday ? AppStrings.noPlanToday : AppStrings.noPlanToday,
                  description: isToday
                      ? AppStrings.noPlanTodayDesc
                      : '${AppDateFormat.formatDate(activeDate)} uchun reja yo\'q.',
                );
              }

              final sorted = plan.items.asMap().entries.toList()
                ..sort((a, b) => a.value.startTime.compareTo(b.value.startTime));
              final hasMissed = isToday &&
                  plan.items.any((item) => item.isMissed && !item.isCompleted);

              return ListView(
                padding: ContentInsets.scrollPadding(context),
                children: [
                  Text(
                    AppDateFormat.formatDate(plan.planDate),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...sorted.map(
                    (entry) => _ScheduleItemTile(
                      plan: plan,
                      item: entry.value,
                      index: entry.key,
                    ),
                  ),
                  if (hasMissed) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: AppStrings.moveMissedToTomorrow,
                      icon: Icons.forward_rounded,
                      variant: AppButtonVariant.secondary,
                      isExpanded: true,
                      onPressed: () => ref
                          .read(aiPlanningNotifierProvider.notifier)
                          .moveMissedToTomorrow(),
                    ),
                  ],
                  suggestionsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (suggestions) {
                      if (suggestions.isEmpty || !isToday) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            AppStrings.rescheduleTitle,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...suggestions.map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: AppCard(
                                child: Text(s.reason),
                              ),
                            ),
                          ),
                          AppButton(
                            label: AppStrings.rescheduleTitle,
                            icon: Icons.update_rounded,
                            variant: AppButtonVariant.secondary,
                            isExpanded: true,
                            onPressed: () => ref
                                .read(aiPlanningNotifierProvider.notifier)
                                .applyReschedule(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReviewsTab extends ConsumerWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifeScoreAsync = ref.watch(lifeScoreProvider);
    final dailyAsync = ref.watch(dailyReviewProvider);
    final weeklyAsync = ref.watch(weeklyReviewProvider);

    if (lifeScoreAsync.isLoading) {
      return const AppLoadingState();
    }

    return ListView(
      padding: ContentInsets.scrollPadding(context),
      children: [
        lifeScoreAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => AppErrorState(
            onRetry: () => ref.invalidate(lifeScoreProvider),
          ),
          data: (score) => _LifeScoreCard(breakdown: score),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.dailyReview,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        dailyAsync.when(
          loading: () => const AppLoadingState(),
          error: (e, _) => AppErrorState(
            onRetry: () => ref.invalidate(dailyReviewProvider),
          ),
          data: (report) => _DailyReviewCard(report: report),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.weeklyReview,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        weeklyAsync.when(
          loading: () => const AppLoadingState(),
          error: (e, _) => AppErrorState(
            onRetry: () => ref.invalidate(weeklyReviewProvider),
          ),
          data: (report) => _WeeklyReviewCard(report: report),
        ),
      ],
    );
  }
}

class _PlanItemTile extends StatelessWidget {
  const _PlanItemTile({required this.draft});

  final PlanItemDraft draft;

  @override
  Widget build(BuildContext context) {
    final time = draft.startTime != null
        ? AppDateFormat.formatTime(draft.startTime!)
        : '--:--';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Row(
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(draft.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(draft.title)),
            Text(
              '${draft.durationMinutes} min',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItemTile extends ConsumerWidget {
  const _ScheduleItemTile({
    required this.plan,
    required this.item,
    required this.index,
  });

  final PlanEntity plan;
  final PlanItemEmbedded item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMissed = item.isMissed && !item.isCompleted;
    final color = item.isCompleted
        ? AppColors.success
        : isMissed
            ? AppColors.error
            : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => ref
            .read(aiPlanningNotifierProvider.notifier)
            .toggleItem(plan, index),
        child: Row(
          children: [
            Icon(
              item.isCompleted
                  ? Icons.check_circle_rounded
                  : isMissed
                      ? Icons.cancel_outlined
                      : Icons.radio_button_unchecked_rounded,
              color: color,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              AppDateFormat.formatTime(item.startTime),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(item.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                item.title,
                style: item.isCompleted
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).disabledColor,
                      )
                    : null,
              ),
            ),
            if (isMissed)
              Text(
                AppStrings.missed,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.error,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LifeScoreCard extends StatelessWidget {
  const _LifeScoreCard({required this.breakdown});

  final LifeScoreBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.filled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_outlined, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                AppStrings.lifeScore,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                '${breakdown.overall}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ScoreRow(label: AppStrings.scoreHealth, value: breakdown.health),
          _ScoreRow(label: AppStrings.scoreLearning, value: breakdown.learning),
          _ScoreRow(label: AppStrings.scoreFinance, value: breakdown.finance),
          _ScoreRow(label: AppStrings.scoreDiscipline, value: breakdown.discipline),
          _ScoreRow(label: AppStrings.scoreSleep, value: breakdown.sleep),
          _ScoreRow(label: AppStrings.scoreGoals, value: breakdown.goals),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('$value'),
        ],
      ),
    );
  }
}

class _DailyReviewCard extends StatelessWidget {
  const _DailyReviewCard({required this.report});

  final DailyReviewReport report;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(report.summary),
          const SizedBox(height: AppSpacing.md),
          if (report.completedItems.isNotEmpty) ...[
            Text(
              AppStrings.completedTasks,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            ...report.completedItems.map((item) => Text('✅ $item')),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (report.missedItems.isNotEmpty) ...[
            Text(
              AppStrings.missedTasks,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            ...report.missedItems.map((item) => Text('❌ $item')),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (report.longestStreak > 0)
            Text('🔥 ${AppStrings.streakTitle}: ${report.longestStreak} kun'),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.aiAdvice,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          ...report.advice.map((a) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text('• $a'),
              )),
        ],
      ),
    );
  }
}

class _WeeklyReviewCard extends StatelessWidget {
  const _WeeklyReviewCard({required this.report});

  final WeeklyReviewReport report;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.overallScore}: ${report.overallScore}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          _ScoreRow(label: AppStrings.productivityScore, value: report.productivityScore),
          _ScoreRow(label: AppStrings.studyScore, value: report.studyScore),
          _ScoreRow(label: AppStrings.healthScore, value: report.healthScore),
          _ScoreRow(label: AppStrings.financeScore, value: report.financeScore),
          _ScoreRow(label: AppStrings.goalScore, value: report.goalScore),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.highlights,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          ...report.highlights.map((h) => Text('• $h')),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.aiAdvice,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          ...report.advice.map((a) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text('• $a'),
              )),
        ],
      ),
    );
  }
}
