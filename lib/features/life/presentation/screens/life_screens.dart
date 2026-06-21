import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/study_session_entity.dart';
import 'package:rejabon_ai/core/database/schemas/study_subject_entity.dart';
import 'package:rejabon_ai/core/database/schemas/workout_entity.dart';
import 'package:rejabon_ai/core/intelligence/intelligence_providers.dart';
import 'package:rejabon_ai/features/journal/presentation/widgets/mood_trend_chart.dart';
import 'package:rejabon_ai/core/integration/action_reward_bridge.dart';
import 'package:rejabon_ai/core/integration/provider_sync.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/shared/widgets/achievement_celebration.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_bottom_sheet.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_empty_state.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_feedback.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/animated_check_button.dart';
import 'package:rejabon_ai/shared/widgets/emoji_picker_field.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';
import 'package:rejabon_ai/shared/widgets/hub_module_card.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

export 'package:rejabon_ai/features/life/presentation/widgets/life_hub_screen.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final repo = ref.read(habitRepositoryProvider);

    return ModuleScreen(
      title: AppStrings.habits,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: habitsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(habitsProvider),
        ),
        data: (habits) {
          if (habits.isEmpty) {
            return AppEmptyState(
              icon: Icons.repeat_rounded,
              title: AppStrings.noHabits,
              description: AppStrings.noHabitsDesc,
              actionLabel: AppStrings.newHabit,
              onAction: () => _showHabitDialog(context, ref),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              final done = repo.isCompletedToday(habit);
              final streak = habitStreak(habit);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Material(
                  color: AppColors.surface(Theme.of(context).brightness),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    onTap: () async {
                      await repo.toggleToday(habit);
                      invalidateDerivedProviders(ref);
                      if (context.mounted && !done) {
                        await rewardHabitComplete(ref, context, habitId: habit.id);
                        showCompletedSnackBar(context);
                        await celebrateNewAchievements(ref, context);
                      }
                    },
                    onLongPress: () => _showHabitActions(context, ref, habit),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          AnimatedCheckButton(
                            checked: done,
                            activeColor: AppColors.primary,
                            celebrateOnCheck: true,
                            onChanged: (_) async {
                              await repo.toggleToday(habit);
                              invalidateDerivedProviders(ref);
                              if (context.mounted && !done) {
                                await rewardHabitComplete(
                                  ref,
                                  context,
                                  habitId: habit.id,
                                );
                                showCompletedSnackBar(context);
                                await celebrateNewAchievements(ref, context);
                              }
                            },
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayWithEmoji(
                                    title: habit.name,
                                    emoji: habit.emoji,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                if (streak > 0) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '$streak ${AppStrings.days}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showHabitActions(
    BuildContext context,
    WidgetRef ref,
    HabitEntity habit,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(AppStrings.edit),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(AppStrings.delete),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == 'edit') {
      await _showHabitDialog(context, ref, habit: habit);
    } else if (action == 'delete') {
      if (!await confirmDelete(context)) return;
      await ref.read(habitRepositoryProvider).delete(habit.id);
      if (context.mounted) showDeletedSnackBar(context);
    }
  }

  Future<void> _showHabitDialog(
    BuildContext context,
    WidgetRef ref, {
    HabitEntity? habit,
  }) async {
    final nameCtrl = TextEditingController(text: habit?.name ?? '');
    var emoji = habit?.emoji ?? '';
    final formKey = GlobalKey<FormState>();

    await showAppBottomSheet<void>(
      context,
      title: habit == null ? AppStrings.newHabit : AppStrings.editHabit,
      child: StatefulBuilder(
        builder: (ctx, setDialogState) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameCtrl,
                  label: AppStrings.habitName,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nom kerak' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                EmojiPickerField(
                  selected: emoji,
                  onSelected: (e) => setDialogState(() => emoji = e),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: AppStrings.save,
                  isExpanded: true,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final repo = ref.read(habitRepositoryProvider);
                    if (habit != null) {
                      habit
                        ..name = nameCtrl.text.trim()
                        ..emoji = emoji;
                      await repo.save(habit);
                    } else {
                      await repo.save(
                        HabitEntity.create(
                          name: nameCtrl.text.trim(),
                          emoji: emoji,
                        ),
                      );
                    }
                    if (!ctx.mounted) return;
                    Navigator.pop(ctx);
                    if (context.mounted) {
                      showSavedSnackBar(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    deferDispose(() => nameCtrl.dispose());
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Goals ─────────────────────────────────────────────────────────────────────

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return ModuleScreen(
      title: AppStrings.goals,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGoalDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: goalsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(goalsProvider),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return AppEmptyState(
              icon: Icons.flag_outlined,
              title: AppStrings.noGoals,
              description: AppStrings.noGoalsDesc,
              actionLabel: AppStrings.newGoal,
              onAction: () => _showGoalDialog(context, ref),
            );
          }
          return ListView.builder(
            padding: ContentInsets.scrollPadding(context),
            itemCount: goals.length,
            itemBuilder: (context, index) => _GoalCard(
              goal: goals[index],
              onEdit: () => _showGoalDialog(context, ref, goal: goals[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showGoalDialog(
    BuildContext context,
    WidgetRef ref, {
    GoalEntity? goal,
  }) async {
    final titleCtrl = TextEditingController(text: goal?.title ?? '');
    final descCtrl = TextEditingController(text: goal?.description ?? '');
    var emoji = goal?.emoji ?? '';
    var progress = goal?.progress ?? 0.0;
    DateTime? targetDate = goal?.targetDate;
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          insetPadding: ContentInsets.dialogInsets(ctx),
          title: Text(goal == null ? AppStrings.newGoal : AppStrings.editGoal),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: titleCtrl,
                    label: AppStrings.goalTitle,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Nom kerak' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  EmojiPickerField(
                    selected: emoji,
                    onSelected: (e) => setDialogState(() => emoji = e),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: descCtrl,
                    label: AppStrings.description,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('${AppStrings.goalProgress}: ${progress.round()}%'),
                  Slider(
                    value: progress,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${progress.round()}%',
                    onChanged: (v) => setDialogState(() => progress = v),
                  ),
                  ListTile(
                    title: const Text(AppStrings.taskDueDate),
                    subtitle: Text(
                      targetDate != null
                          ? AppDateFormat.formatDate(targetDate!)
                          : 'Tanlanmagan',
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: targetDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setDialogState(() => targetDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final repo = ref.read(goalRepositoryProvider);
                if (goal != null) {
                  goal
                    ..title = titleCtrl.text.trim()
                    ..emoji = emoji
                    ..description = descCtrl.text.trim().isEmpty
                        ? null
                        : descCtrl.text.trim()
                    ..progress = progress
                    ..targetDate = targetDate;
                  await repo.save(goal);
                } else {
                  await repo.save(
                    GoalEntity.create(
                      title: titleCtrl.text.trim(),
                      emoji: emoji,
                      description: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      progress: progress,
                      targetDate: targetDate,
                    ),
                  );
                }
                if (context.mounted) {
                  showSavedSnackBar(context);
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
    deferDispose(() {
      titleCtrl.dispose();
      descCtrl.dispose();
    });
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({
    required this.goal,
    required this.onEdit,
  });

  final GoalEntity goal;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        variant: AppCardVariant.outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressRing(
                  progress: goal.progress / 100,
                  size: 52,
                  strokeWidth: 4,
                  color: AppColors.primary,
                  child: Text(
                    '${goal.progress.round()}%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
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
                        displayWithEmoji(title: goal.title, emoji: goal.emoji),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (goal.description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          goal.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.textSecondary(Theme.of(context).brightness),
                  ),
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(AppStrings.edit),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(AppStrings.delete),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      if (!await confirmDelete(context)) return;
                      await ref.read(goalRepositoryProvider).delete(goal.id);
                      if (context.mounted) showDeletedSnackBar(context);
                    }
                  },
                ),
              ],
            ),
            if (goal.targetDate != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${AppStrings.taskDueDate}: ${AppDateFormat.formatDate(goal.targetDate!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.milestones,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            ...goal.milestones.map(
              (m) => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  m.title,
                  style: TextStyle(
                    decoration:
                        m.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                value: m.isCompleted,
                onChanged: (_) async {
                  m.isCompleted = !m.isCompleted;
                  final completed =
                      goal.milestones.where((ms) => ms.isCompleted).length;
                  goal.progress = goal.milestones.isEmpty
                      ? goal.progress
                      : (completed / goal.milestones.length) * 100;
                  await ref.read(goalRepositoryProvider).save(goal);
                },
              ),
            ),
            TextButton.icon(
              onPressed: () => _addMilestone(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: const Text(AppStrings.addMilestone),
            ),
            if (goal.milestones.isEmpty || goal.progress < 30) ...[
              const SizedBox(height: AppSpacing.xs),
              AppButton(
                label: AppStrings.executeGoal,
                icon: Icons.auto_fix_high_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: () => _executeGoal(context, ref),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _executeGoal(BuildContext context, WidgetRef ref) async {
    final analysis = await ref.read(lifeTwinAnalysisProvider.future);
    final plan = await ref.read(goalExecutionServiceProvider).executeGoal(
          goal: goal,
          twinAnalysis: analysis,
        );
    ref.invalidate(tasksProvider);
    ref.invalidate(goalsProvider);
    ref.invalidate(plansProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(plan.summary)),
      );
    }
  }

  Future<void> _addMilestone(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.addMilestone),
        content: AppTextField(controller: ctrl, label: AppStrings.goalTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text(AppStrings.add),
          ),
        ],
      ),
    );
    deferDispose(ctrl.dispose);
    if (result != null && result.isNotEmpty) {
      goal.milestones.add(MilestoneEmbedded.create(title: result));
      await ref.read(goalRepositoryProvider).save(goal);
      if (context.mounted) showSavedSnackBar(context);
    }
  }
}

// ── Journal ─────────────────────────────────────────────────────────────────

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  DateTime _selectedDate = AppDateFormat.dateOnly(DateTime.now());
  final _contentCtrl = TextEditingController();
  int _mood = 3;
  bool _loading = true;
  JournalEntryEntity? _entry;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    setState(() => _loading = true);
    final entry =
        await ref.read(journalRepositoryProvider).getByDate(_selectedDate);
    _entry = entry;
    _contentCtrl.text = entry?.content ?? '';
    _mood = entry?.mood ?? 3;
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _changeDate(int days) async {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    await _loadEntry();
  }

  Future<void> _save() async {
    late JournalEntryEntity entry;
    if (_entry != null) {
      entry = _entry!
        ..content = _contentCtrl.text.trim()
        ..mood = _mood;
    } else {
      entry = JournalEntryEntity.create(
        date: _selectedDate,
        content: _contentCtrl.text.trim(),
        mood: _mood,
      );
    }
    await ref.read(journalRepositoryProvider).save(entry);
    _entry = entry;
    invalidateDerivedProviders(ref);
    if (mounted && AppDateFormat.isSameDay(_selectedDate, DateTime.now())) {
      await rewardJournal(ref, context);
    } else if (mounted) {
      showSavedSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScreen(
      title: AppStrings.journal,
      showBackButton: true,
      body: _loading
          ? const AppLoadingState()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: () => _changeDate(-1),
                      ),
                      Column(
                        children: [
                          Text(
                            AppDateFormat.formatDate(_selectedDate),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (AppDateFormat.isToday(_selectedDate))
                            Text(
                              AppStrings.today,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.primary),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: () => _changeDate(1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.mood,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (i) {
                    final mood = i + 1;
                    final selected = _mood == mood;
                    return GestureDetector(
                      onTap: () {
                        hapticLight();
                        setState(() => _mood = mood);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: selected
                              ? Border.all(color: AppColors.primary)
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              moodEmoji(mood),
                              style: TextStyle(
                                fontSize: selected ? 36 : 26,
                              ),
                            ),
                            Text(
                              moodLabel(mood),
                              style: TextStyle(
                                fontSize: 10,
                                color: selected
                                    ? AppColors.primary
                                    : Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.md),
                MoodTrendChart(report: ref.watch(moodTrendProvider)),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _contentCtrl,
                  label: AppStrings.noteContent,
                  maxLines: 8,
                  minLines: 4,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: AppStrings.save,
                  isExpanded: true,
                  onPressed: _save,
                ),
              ],
            ),
    );
  }
}

// ── Workout ─────────────────────────────────────────────────────────────────

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutsProvider);
    final statsAsync = ref.watch(workoutStatisticsProvider);

    return ModuleScreen(
      title: AppStrings.workout,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWorkoutDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: workoutsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(workoutsProvider),
        ),
        data: (workouts) {
          if (workouts.isEmpty) {
            return AppEmptyState(
              icon: Icons.fitness_center_outlined,
              title: AppStrings.noWorkouts,
              description: AppStrings.noWorkoutsDesc,
              actionLabel: AppStrings.newWorkout,
              onAction: () => _showWorkoutDialog(context, ref),
            );
          }
          final stats = statsAsync.valueOrNull;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (stats != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    variant: AppCardVariant.filled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.statistics,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: _MiniStat(
                                label: AppStrings.totalSessions,
                                value: '${stats.totalSessions}',
                              ),
                            ),
                            Expanded(
                              child: _MiniStat(
                                label: AppStrings.thisWeek,
                                value: '${stats.thisWeekSessions}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${stats.totalMinutes} daq · ${stats.totalCalories} kcal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              Text(
                AppStrings.workoutHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...workouts.map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                w.exerciseName,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${AppDateFormat.formatDate(w.date)} · ${w.durationMinutes} daq · ${w.caloriesBurned} kcal',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (!await confirmDelete(context)) return;
                            await ref
                                .read(workoutRepositoryProvider)
                                .delete(w.id);
                            if (context.mounted) showDeletedSnackBar(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showWorkoutDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final caloriesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.newWorkout),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameCtrl,
                label: AppStrings.exerciseName,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nom kerak' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: durationCtrl,
                label: AppStrings.duration,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || int.tryParse(v) == null ? 'Raqam kiriting' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: caloriesCtrl,
                label: AppStrings.calories,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await ref.read(workoutRepositoryProvider).save(
                    WorkoutEntity.create(
                      exerciseName: nameCtrl.text.trim(),
                      durationMinutes: int.parse(durationCtrl.text),
                      caloriesBurned:
                          int.tryParse(caloriesCtrl.text) ?? 0,
                    ),
                  );
              invalidateDerivedProviders(ref);
              if (context.mounted) {
                await rewardWorkout(ref, context);
                Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
    deferDispose(() {
      nameCtrl.dispose();
      durationCtrl.dispose();
      caloriesCtrl.dispose();
    });
  }
}

// ── Study ─────────────────────────────────────────────────────────────────────

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(studySubjectsProvider);
    final sessionsAsync = ref.watch(studySessionsProvider);

    return ModuleScreen(
      title: AppStrings.study,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubjectDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: subjectsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(studySubjectsProvider),
        ),
        data: (subjects) {
          if (subjects.isEmpty) {
            return AppEmptyState(
              icon: Icons.school_outlined,
              title: AppStrings.noStudy,
              description: AppStrings.noStudyDesc,
              actionLabel: AppStrings.newSubject,
              onAction: () => _showSubjectDialog(context, ref),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                AppStrings.subjects,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...subjects.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                s.name,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_circle_outline),
                              tooltip: AppStrings.studySession,
                              onPressed: () =>
                                  _showSessionDialog(context, ref, s),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () async {
                                if (!await confirmDelete(context)) return;
                                await ref
                                    .read(studyRepositoryProvider)
                                    .deleteSubject(s.id);
                                if (context.mounted) {
                                  showDeletedSnackBar(context);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                child: LinearProgressIndicator(
                                  value: s.targetMinutes > 0
                                      ? (s.totalMinutes / s.targetMinutes)
                                          .clamp(0.0, 1.0)
                                      : 0,
                                  minHeight: 6,
                                  color: Color(s.color),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text('${s.totalMinutes} daq'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.studySession,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              sessionsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (sessions) {
                  if (sessions.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: sessions.take(10).map((session) {
                      final subjectMatches =
                          subjects.where((s) => s.id == session.subjectId);
                      final subjectName = subjectMatches.isEmpty
                          ? 'Fan'
                          : subjectMatches.first.name;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subjectName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      '${AppDateFormat.formatDate(session.date)} · ${session.durationMinutes} daq',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showSubjectDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '60');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.newSubject),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameCtrl,
                label: AppStrings.subjects,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nom kerak' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: targetCtrl,
                label: 'Maqsad (daq)',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await ref.read(studyRepositoryProvider).saveSubject(
                    StudySubjectEntity.create(
                      name: nameCtrl.text.trim(),
                      targetMinutes: int.tryParse(targetCtrl.text) ?? 60,
                    ),
                  );
              if (context.mounted) {
                showSavedSnackBar(context);
                Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
    deferDispose(() {
      nameCtrl.dispose();
      targetCtrl.dispose();
    });
  }

  Future<void> _showSessionDialog(
    BuildContext context,
    WidgetRef ref,
    StudySubjectEntity subject,
  ) async {
    final durationCtrl = TextEditingController(text: '30');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${AppStrings.studySession}: ${subject.name}'),
        content: Form(
          key: formKey,
          child: AppTextField(
            controller: durationCtrl,
            label: AppStrings.duration,
            keyboardType: TextInputType.number,
            validator: (v) =>
                v == null || int.tryParse(v) == null ? 'Raqam kiriting' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await ref.read(studyRepositoryProvider).addSession(
                    StudySessionEntity.create(
                      subjectId: subject.id,
                      durationMinutes: int.parse(durationCtrl.text),
                    ),
                  );
              if (context.mounted) {
                showSavedSnackBar(context);
                Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
    deferDispose(durationCtrl.dispose);
  }
}
