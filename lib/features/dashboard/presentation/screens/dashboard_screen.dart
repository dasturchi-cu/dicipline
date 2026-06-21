import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/features/platform/presentation/providers/platform_providers.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';

import '../widgets/dashboard_calm.dart';

/// Bosh sahifa — 5 zona: brifing, maqsad, ring, AI, tez harakatlar.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshWidgetData(ref);
    });
  }

  String _greeting(String userName) {
    final hour = DateTime.now().hour;
    final timeGreeting = hour < 12
        ? AppStrings.goodMorning
        : hour < 18
            ? AppStrings.goodAfternoon
            : AppStrings.goodEvening;
    return userName.isNotEmpty ? '$timeGreeting, $userName' : timeGreeting;
  }

  GoalEntity? _mainGoal(List<GoalEntity> goals) {
    if (goals.isEmpty) return null;
    final active = goals.where((g) => g.progress < 100).toList();
    if (active.isEmpty) return goals.first;
    active.sort((a, b) => b.progress.compareTo(a.progress));
    return active.first;
  }

  Future<void> _refreshAll() async {
    ref.invalidate(tasksProvider);
    ref.invalidate(habitsProvider);
    ref.invalidate(goalsProvider);
    invalidatePhase2Providers(ref);
    await refreshWidgetData(ref);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final habitsAsync = ref.watch(habitsProvider);
    final goalsAsync = ref.watch(goalsProvider);
    final userName = ref.watch(settingsProvider).userName;

    if (tasksAsync.isLoading ||
        habitsAsync.isLoading ||
        goalsAsync.isLoading) {
      return const Scaffold(body: SafeArea(child: AppLoadingState()));
    }

    if (tasksAsync.hasError || habitsAsync.hasError) {
      return Scaffold(
        body: SafeArea(child: AppErrorState(onRetry: _refreshAll)),
      );
    }

    final goals = goalsAsync.value ?? [];
    final greeting = _greeting(userName);
    final bottomPadding = ContentInsets.shellScrollBottom(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    CalmDailyBriefing(greeting: greeting),
                    const SizedBox(height: AppSpacing.xl),
                    CalmMainGoal(goal: _mainGoal(goals)),
                    const SizedBox(height: AppSpacing.lg),
                    const CalmProgressRing(),
                    const SizedBox(height: AppSpacing.lg),
                    const CalmAiInsight(),
                    const SizedBox(height: AppSpacing.lg),
                    const CalmQuickActions(),
                    SizedBox(height: bottomPadding + AppSpacing.md),
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
