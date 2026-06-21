import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/calm_ui.dart';
import 'package:rejabon_ai/shared/widgets/hub_module_card.dart';

/// Hayot markazi — 6 asosiy modul + yig'iladigan reja.
class LifeHubScreen extends ConsumerWidget {
  const LifeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final goalsAsync = ref.watch(goalsProvider);
    final journalAsync = ref.watch(journalProvider);
    final workoutsAsync = ref.watch(workoutsProvider);
    final subjectsAsync = ref.watch(studySubjectsProvider);
    final financeAsync = ref.watch(financeBalanceProvider);

    if (habitsAsync.isLoading || goalsAsync.isLoading || journalAsync.isLoading) {
      return const Scaffold(body: SafeArea(child: AppLoadingState()));
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
    final hasJournalToday = journal.any(
      (j) => AppDateFormat.isSameDay(j.date, today) && j.content.trim().isNotEmpty,
    );
    final workoutThisWeek = workouts.where((w) {
      final diff = today.difference(AppDateFormat.dateOnly(w.date)).inDays;
      return diff >= 0 && diff < 7;
    }).length;
    final studyMinutes = subjects.fold<int>(0, (s, sub) => s + sub.totalMinutes);
    final balance = financeAsync.valueOrNull;
    final bottomPad = ContentInsets.shellScrollBottom(context);

    Widget gap() => const SizedBox(height: AppSpacing.sm);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          children: [
            CalmPageHeader(
              title: AppStrings.lifeHub,
              subtitle: AppStrings.lifeHubSubtitle,
            ),
            const CalmSectionTitle(title: AppStrings.lifeHubToday),
            HubModuleCard(
              index: 0,
              title: AppStrings.habits,
              subtitle: habits.isEmpty
                  ? AppStrings.noHabitsDesc
                  : '$habitsDone/${habits.length} bugun · $longestStreak kun streak',
              icon: Icons.local_fire_department_rounded,
              accentColor: AppColors.fire,
              onTap: () => context.push('/hayot/odatlar'),
            ),
            gap(),
            HubModuleCard(
              index: 1,
              title: AppStrings.goals,
              subtitle: topGoal != null
                  ? '${displayWithEmoji(title: topGoal.title, emoji: topGoal.emoji)} · ${topGoal.progress.round()}%'
                  : AppStrings.noGoalsDesc,
              icon: Icons.flag_rounded,
              accentColor: AppColors.primary,
              onTap: () => context.push('/hayot/maqsadlar'),
            ),
            gap(),
            HubModuleCard(
              index: 2,
              title: AppStrings.journal,
              subtitle: hasJournalToday
                  ? '${AppStrings.today} ✓'
                  : AppStrings.noJournalDesc,
              icon: Icons.menu_book_rounded,
              accentColor: AppColors.accent,
              onTap: () => context.push('/hayot/kundalik'),
            ),
            const SizedBox(height: AppSpacing.lg),
            const CalmSectionTitle(title: AppStrings.lifeHubTrack),
            HubModuleCard(
              index: 3,
              title: AppStrings.workout,
              subtitle: workouts.isEmpty
                  ? AppStrings.noWorkoutsDesc
                  : 'Bu hafta: $workoutThisWeek',
              icon: Icons.fitness_center_rounded,
              accentColor: AppColors.error,
              onTap: () => context.push('/hayot/mashq'),
            ),
            gap(),
            HubModuleCard(
              index: 4,
              title: AppStrings.study,
              subtitle: subjects.isEmpty
                  ? AppStrings.noStudyDesc
                  : '$studyMinutes daqiqa jami',
              icon: Icons.school_rounded,
              accentColor: AppColors.gold,
              onTap: () => context.push('/hayot/ta\'lim'),
            ),
            gap(),
            HubModuleCard(
              index: 5,
              title: AppStrings.finance,
              subtitle: balance == null
                  ? AppStrings.noFinanceDesc
                  : 'Balans: ${(balance.totalIncome - balance.totalExpense).toStringAsFixed(0)}',
              icon: Icons.account_balance_wallet_rounded,
              accentColor: AppColors.success,
              onTap: () => context.push('/hayot/moliya'),
            ),
            const SizedBox(height: AppSpacing.lg),
            CalmExpandableSection(
              title: AppStrings.lifeHubPlanningMore,
              children: [
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.lifeAreas,
                  subtitle: AppStrings.lifeBalanceScore,
                  icon: Icons.balance_rounded,
                  accentColor: AppColors.primary,
                  onTap: () => context.push('/hayot/sohalar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.futurePlanning,
                  subtitle: AppStrings.futurePlanningDesc,
                  icon: Icons.timeline_rounded,
                  accentColor: AppColors.accent,
                  onTap: () => context.push('/hayot/kelajak'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.visionBoard,
                  subtitle: AppStrings.visionBoardEmpty,
                  icon: Icons.auto_awesome_rounded,
                  accentColor: AppColors.secondary,
                  onTap: () => context.push('/hayot/vizion'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.timeTracking,
                  subtitle: AppStrings.sessionType,
                  icon: Icons.timer_rounded,
                  accentColor: AppColors.fire,
                  onTap: () => context.push('/hayot/vaqt'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.lifeTimeline,
                  subtitle: AppStrings.timelineEmptyDesc,
                  icon: Icons.history_rounded,
                  accentColor: AppColors.secondary,
                  onTap: () => context.push('/hayot/timeline'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.achievementTimeline,
                  subtitle: AppStrings.milestonesEmptyDesc,
                  icon: Icons.emoji_events_rounded,
                  accentColor: AppColors.gold,
                  onTap: () => context.push('/hayot/yutuqlar'),
                ),
                gap(),
                HubModuleCard(
                  index: 0,
                  title: AppStrings.futureSimulator,
                  subtitle: AppStrings.simulationDesc,
                  icon: Icons.insights_rounded,
                  accentColor: AppColors.moduleAnalytics,
                  onTap: () => context.push('/hayot/simulyator'),
                ),
              ],
            ),
            SizedBox(height: bottomPad),
          ],
        ),
      ),
    );
  }
}
