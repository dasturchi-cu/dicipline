import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// AI Life Twin — profil, tahlil, tavsiyalar va matnli suhbat.
class LifeTwinScreen extends ConsumerStatefulWidget {
  const LifeTwinScreen({super.key});

  @override
  ConsumerState<LifeTwinScreen> createState() => _LifeTwinScreenState();
}

class _LifeTwinScreenState extends ConsumerState<LifeTwinScreen> {
  final _chatCtrl = TextEditingController();
  var _sending = false;

  @override
  void dispose() {
    _chatCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendChat(LifeTwinProfile profile) async {
    final msg = _chatCtrl.text.trim();
    if (msg.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(lifeTwinServiceProvider).chat(
            userMessage: msg,
            profile: profile,
          );
      ref.invalidate(twinChatConversationProvider);
      _chatCtrl.clear();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(lifeTwinProfileProvider);
    final analysisAsync = ref.watch(lifeTwinAnalysisProvider);
    final chatAsync = ref.watch(twinChatConversationProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.lifeTwin,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.mic_rounded),
          tooltip: AppStrings.voiceCoach,
          onPressed: () => context.push('/boshqa/murabbiy/ovoz'),
        ),
      ],
      body: profileAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
        data: (profile) => Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => runPhase2Bootstrap(ref),
                color: AppColors.primary,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  children: [
                    _TwinHeroCard(profile: profile, brightness: brightness),
                    const SizedBox(height: AppSpacing.lg),
                    if (profile.burnout != null) ...[
                      AppCard(
                        variant: AppCardVariant.outlined,
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: AppColors.warning),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                profile.burnout!.message,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    analysisAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (analysis) => _AnalysisSection(
                        analysis: analysis,
                        brightness: brightness,
                      ),
                    ),
                    if (profile.personalitySummary != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(AppStrings.personalityProfile,
                          style: AppTypography.sectionLabel(brightness)),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        variant: AppCardVariant.filled,
                        child: Text(profile.personalitySummary!),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Text(AppStrings.twinPatterns,
                        style: AppTypography.sectionLabel(brightness)),
                    const SizedBox(height: AppSpacing.sm),
                    ...profile.patternInsights.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          variant: AppCardVariant.filled,
                          child: Text(p),
                        ),
                      ),
                    ),
                    if (profile.memoryInsights.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(AppStrings.twinMemory,
                          style: AppTypography.sectionLabel(brightness)),
                      const SizedBox(height: AppSpacing.sm),
                      ...profile.memoryInsights.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🧠', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(child: Text(m)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Text(AppStrings.askTwin,
                        style: AppTypography.sectionLabel(brightness)),
                    const SizedBox(height: AppSpacing.sm),
                    chatAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (messages) {
                        if (messages.isEmpty) {
                          return Text(
                            AppStrings.voiceCoachEmpty,
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        }
                        return Column(
                          children: messages.reversed.take(8).map((m) {
                            final isUser = m.role == 'user';
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.78,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? AppColors.primary
                                          .withValues(alpha: 0.12)
                                      : AppColors.surface(brightness),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                ),
                                child: Text(m.message),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    SizedBox(height: ContentInsets.shellScrollBottom(context)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                ContentInsets.shellScrollBottom(context),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _chatCtrl,
                      label: AppStrings.askTwin,
                      onSubmitted: (_) => _sendChat(profile),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _sending ? null : () => _sendChat(profile),
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisSection extends StatelessWidget {
  const _AnalysisSection({
    required this.analysis,
    required this.brightness,
  });

  final LifeTwinAnalysis analysis;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.twinInsights,
            style: AppTypography.sectionLabel(brightness)),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          variant: AppCardVariant.filled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Peak: ${analysis.peakHoursLabel}'),
              Text('O\'rganish: ${analysis.learningStyle}'),
            ],
          ),
        ),
        if (analysis.insights.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ...analysis.insights.take(4).map(
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(i.headline,
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(i.body),
                      ],
                    ),
                  ),
                ),
              ),
        ],
        if (analysis.strengths.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.twinStrengths,
              style: AppTypography.sectionLabel(brightness)),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: analysis.strengths
                .map((s) => Chip(label: Text(s), backgroundColor: AppColors.success.withValues(alpha: 0.12)))
                .toList(),
          ),
        ],
        if (analysis.weaknesses.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.twinWeaknesses,
              style: AppTypography.sectionLabel(brightness)),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: analysis.weaknesses
                .map((w) => Chip(label: Text(w), backgroundColor: AppColors.warning.withValues(alpha: 0.12)))
                .toList(),
          ),
        ],
        if (analysis.recommendations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.twinRecommendations,
              style: AppTypography.sectionLabel(brightness)),
          const SizedBox(height: AppSpacing.sm),
          ...analysis.recommendations.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                onTap: r.actionRoute != null
                    ? () => context.push(r.actionRoute!)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(r.description),
                    if (r.actionLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          r.actionLabel!,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TwinHeroCard extends StatelessWidget {
  const _TwinHeroCard({
    required this.profile,
    required this.brightness,
  });

  final LifeTwinProfile profile;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProgressRing(
                progress: profile.lifeScore / 100,
                size: 56,
                strokeWidth: 5,
                color: AppColors.primary,
                child: Text(
                  '${profile.lifeScore}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.lifeTwin,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '${AppStrings.bestDay}: ${profile.bestDay}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary(brightness),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.twinMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
