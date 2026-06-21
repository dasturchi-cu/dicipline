import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/router/app_router.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/core/utils/format_money.dart';
import 'package:rejabon_ai/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';

import '../widgets/dashboard_widgets.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 18) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  int _longestStreak(List<dynamic> habits) {
    if (habits.isEmpty) return 0;
    return habits.map((h) => habitStreak(h)).fold(0, (a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final habitsAsync = ref.watch(habitsProvider);
    final goalsAsync = ref.watch(goalsProvider);
    final financeAsync = ref.watch(financeTransactionsProvider);
    final tipsAsync = ref.watch(aiTipsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final todayPlanAsync = ref.watch(todayPlanProvider);
    final upcomingPlanAsync = ref.watch(upcomingPlanProvider);
    final userName = ref.watch(settingsProvider).userName;

    final isLoading = tasksAsync.isLoading ||
        habitsAsync.isLoading ||
        financeAsync.isLoading ||
        goalsAsync.isLoading;

    if (isLoading) {
      return const Scaffold(
        body: SafeArea(child: AppLoadingState()),
      );
    }

    if (tasksAsync.hasError ||
        habitsAsync.hasError ||
        financeAsync.hasError ||
        goalsAsync.hasError) {
      return Scaffold(
        body: SafeArea(
          child: AppErrorState(
            onRetry: () {
              ref.invalidate(tasksProvider);
              ref.invalidate(habitsProvider);
              ref.invalidate(financeTransactionsProvider);
              ref.invalidate(goalsProvider);
              ref.invalidate(aiTipsProvider);
              ref.invalidate(achievementsProvider);
              ref.invalidate(todayPlanProvider);
            },
          ),
        ),
      );
    }

    final tasks = tasksAsync.value ?? [];
    final habits = habitsAsync.value ?? [];
    final goals = goalsAsync.value ?? [];
    final finance = financeAsync.value ?? [];
    final achievements = achievementsAsync.valueOrNull ?? [];
    final today = AppDateFormat.dateOnly(DateTime.now());

    final todayActiveTasks = tasks.where((t) => !t.isCompleted).where((t) {
      if (t.dueDate == null) return true;
      return AppDateFormat.isSameDay(t.dueDate!, today) ||
          t.dueDate!.isBefore(today.add(const Duration(days: 1)));
    }).toList();

    final todayCompletedTasks = tasks
        .where((t) => t.isCompleted)
        .where((t) => AppDateFormat.isSameDay(t.updatedAt, today))
        .length;

    final habitsDone = habits
        .where((h) => h.completedDates.any((d) => AppDateFormat.isSameDay(d, today)))
        .length;
    final habitsTotal = habits.length;
    final habitsProgress = habitsTotal > 0 ? habitsDone / habitsTotal : 0.0;
    final balance = FinanceRepository.balance(finance);
    final primaryTip = tipsAsync.valueOrNull?.firstOrNull;
    final todayPlan = todayPlanAsync.valueOrNull;
    final upcomingPlan = upcomingPlanAsync.valueOrNull;
    final displayPlan = (todayPlan != null && todayPlan.items.isNotEmpty)
        ? todayPlan
        : upcomingPlan;
    final planSectionTitle = (todayPlan != null && todayPlan.items.isNotEmpty)
        ? AppStrings.todaySchedule
        : (displayPlan != null ? AppStrings.upcomingPlan : null);
    final mainGoal = goals.isEmpty
        ? null
        : (List.of(goals)..sort((a, b) => b.progress.compareTo(a.progress))).first;

    final greeting =
        userName.isNotEmpty ? '${_greeting()}, $userName' : _greeting();

    final bottomPadding = MediaQuery.paddingOf(context).bottom + 88;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(tasksProvider);
            ref.invalidate(habitsProvider);
            ref.invalidate(goalsProvider);
            ref.invalidate(financeTransactionsProvider);
            ref.invalidate(aiTipsProvider);
            ref.invalidate(achievementsProvider);
            ref.invalidate(todayPlanProvider);
            ref.invalidate(upcomingPlanProvider);
            ref.invalidate(lifeScoreProvider);
          },
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DashboardHeroHeader(
                      greeting: greeting,
                      dateLabel: AppDateFormat.formatDate(DateTime.now()),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DashboardAiPlanningCard(
                      onTap: () => context.pushOnce('/reja'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DashboardStreakCard(
                      streak: _longestStreak(habits),
                      habitsDone: habitsDone,
                      habitsTotal: habitsTotal,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DashboardMainGoalCard(goal: mainGoal),
                    const SizedBox(height: AppSpacing.md),
                    DashboardMomentumRow(
                      tasksDone: todayCompletedTasks,
                      tasksTotal: todayActiveTasks.length + todayCompletedTasks,
                      habitsProgress: habitsProgress,
                      balanceLabel: formatMoney(balance),
                      balancePositive: balance >= 0,
                    ),
                    if (displayPlan != null &&
                        displayPlan.items.isNotEmpty &&
                        planSectionTitle != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      DashboardTodaySchedule(
                        plan: displayPlan,
                        sectionTitle: planSectionTitle,
                        onTap: () => context.pushOnce('/reja'),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    DashboardLifeScoreCard(
                      onTap: () => context.pushOnce('/reja'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DashboardTodayPlan(
                      tasks: todayActiveTasks.take(5).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DashboardAiCard(
                      tipText: primaryTip?.displayText ?? AppStrings.noTipsDesc,
                      actionRoute: primaryTip?.actionRoute,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DashboardAchievementsStrip(
                      achievements: achievements,
                      unlockedCount: AchievementService.unlockedCount(achievements),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const DashboardQuickActions(),
                    SizedBox(height: bottomPadding),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
