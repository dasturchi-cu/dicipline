import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/hub_module_card.dart';

class LifeHubScreen extends ConsumerWidget {
  const LifeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final goalsAsync = ref.watch(goalsProvider);
    final journalAsync = ref.watch(journalProvider);
    final workoutsAsync = ref.watch(workoutsProvider);
    final subjectsAsync = ref.watch(studySubjectsProvider);

    final loading = habitsAsync.isLoading ||
        goalsAsync.isLoading ||
        journalAsync.isLoading;

    if (loading) {
      return const Scaffold(
        body: SafeArea(child: AppLoadingState()),
      );
    }

    if (habitsAsync.hasError || goalsAsync.hasError) {
      return Scaffold(
        body: SafeArea(
          child: AppErrorState(
            onRetry: () {
              ref.invalidate(habitsProvider);
              ref.invalidate(goalsProvider);
            },
          ),
        ),
      );
    }

    final habits = habitsAsync.value ?? [];
    final goals = goalsAsync.value ?? [];
    final journal = journalAsync.value ?? [];
    final workouts = workoutsAsync.value ?? [];
    final subjects = subjectsAsync.value ?? [];
    final today = AppDateFormat.dateOnly(DateTime.now());

    final longestStreak = habits.isEmpty
        ? 0
        : habits.map(habitStreak).fold(0, (a, b) => a > b ? a : b);
    final habitsDone = habits
        .where((h) => h.completedDates.any((d) => AppDateFormat.isSameDay(d, today)))
        .length;
    final topGoal = goals.isEmpty
        ? null
        : (List.of(goals)..sort((a, b) => b.progress.compareTo(a.progress))).first;
    final todayJournal =
        journal.where((j) => AppDateFormat.isSameDay(j.date, today));
    final hasJournalToday =
        todayJournal.any((j) => j.content.trim().isNotEmpty);
    final workoutThisWeek = workouts.where((w) {
      final diff = today.difference(AppDateFormat.dateOnly(w.date)).inDays;
      return diff >= 0 && diff < 7;
    }).length;
    final studyMinutes = subjects.fold<int>(0, (s, sub) => s + sub.totalMinutes);

    final brightness = Theme.of(context).brightness;
    final bottomPad = MediaQuery.paddingOf(context).bottom + 88;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          children: [
            FadeIn(
              index: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.lifeHub.toUpperCase(),
                    style: AppTypography.sectionLabel(brightness).copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.lifeHubSubtitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            HubModuleCard(
              index: 1,
              title: AppStrings.habits,
              subtitle: habits.isEmpty
                  ? AppStrings.noHabitsDesc
                  : '$habitsDone/${habits.length} ${AppStrings.todayHabits.toLowerCase()} · $longestStreak ${AppStrings.streak.toLowerCase()}',
              icon: Icons.local_fire_department_rounded,
              accentColor: AppColors.fire,
              gradient: longestStreak >= 3 ? AppColors.streakGradient : null,
              badge: habits.isNotEmpty ? '$longestStreak🔥' : null,
              onTap: () => context.push('/hayot/odatlar'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 2,
              title: AppStrings.goals,
              subtitle: topGoal != null
                  ? '${displayWithEmoji(title: topGoal.title, emoji: topGoal.emoji)} · ${topGoal.progress.round()}%'
                  : AppStrings.noGoalsDesc,
              icon: Icons.flag_rounded,
              accentColor: AppColors.primary,
              badge: goals.isNotEmpty ? '${goals.length}' : null,
              onTap: () => context.push('/hayot/maqsadlar'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 3,
              title: AppStrings.journal,
              subtitle: hasJournalToday
                  ? '${AppStrings.today} — ${AppStrings.saved.toLowerCase()} ✓'
                  : AppStrings.noJournalDesc,
              icon: Icons.menu_book_rounded,
              accentColor: AppColors.accent,
              onTap: () => context.push('/hayot/kundalik'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 4,
              title: AppStrings.workout,
              subtitle: workouts.isEmpty
                  ? AppStrings.noWorkoutsDesc
                  : '${AppStrings.thisWeek}: $workoutThisWeek · ${workouts.length} ${AppStrings.totalSessions.toLowerCase()}',
              icon: Icons.fitness_center_rounded,
              accentColor: AppColors.error,
              onTap: () => context.push('/hayot/mashq'),
            ),
            const SizedBox(height: AppSpacing.sm),
            HubModuleCard(
              index: 5,
              title: AppStrings.study,
              subtitle: subjects.isEmpty
                  ? AppStrings.noStudyDesc
                  : '${subjects.length} ${AppStrings.subjects.toLowerCase()} · $studyMinutes daq',
              icon: Icons.school_rounded,
              accentColor: AppColors.gold,
              onTap: () => context.push('/hayot/ta\'lim'),
            ),
            SizedBox(height: bottomPad),
          ],
        ),
      ),
    );
  }
}
