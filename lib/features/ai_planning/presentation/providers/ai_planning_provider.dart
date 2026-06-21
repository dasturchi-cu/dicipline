import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/schemas/plan_entity.dart';
import '../../../../core/database/schemas/task_entity.dart';
import '../../../../core/integration/provider_sync.dart';
import '../../../../core/notifications/plan_notification_helper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../ai_coach/presentation/providers/ai_coach_provider.dart';
import '../../../gamification/presentation/providers/gamification_providers.dart';
import '../../domain/ai_planning_service.dart';
import '../../domain/auto_reschedule_service.dart';
import '../../domain/daily_review_service.dart';
import '../../domain/life_score_service.dart';
import '../../domain/models/plan_models.dart';
import '../../domain/plan_task_sync_service.dart';
import '../../domain/schedule_optimizer.dart';
import '../../domain/weekly_review_service.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

final aiPlanningServiceProvider = Provider<AiPlanningService>((ref) {
  return AiPlanningService(aiService: ref.watch(aiServiceProvider));
});

final planTaskSyncServiceProvider = Provider<PlanTaskSyncService>((ref) {
  return PlanTaskSyncService(
    ref.watch(taskRepositoryProvider),
    ref.watch(planRepositoryProvider),
  );
});

final autoRescheduleServiceProvider = Provider<AutoRescheduleService>((ref) {
  return AutoRescheduleService(ref.watch(planRepositoryProvider));
});

final lifeScoreServiceProvider = Provider<LifeScoreService>((ref) {
  return LifeScoreService();
});

final dailyReviewServiceProvider = Provider<DailyReviewService>((ref) {
  return DailyReviewService(
    habitRepository: ref.watch(habitRepositoryProvider),
  );
});

final weeklyReviewServiceProvider = Provider<WeeklyReviewService>((ref) {
  return WeeklyReviewService(
    habitRepository: ref.watch(habitRepositoryProvider),
  );
});

final planPreviewProvider = StateProvider<GeneratedPlan?>((ref) => null);

final activePlanDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final planGeneratingProvider = StateProvider<bool>((ref) => false);

final lifeScoreProvider = FutureProvider<LifeScoreBreakdown>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(todayPlanProvider);

  final weekly = ref.watch(weeklyReviewServiceProvider);
  final todayPlan = await ref.watch(planRepositoryProvider).getToday();
  return weekly.lifeScore(
    tasks: await ref.watch(taskRepositoryProvider).getAll(),
    habits: await ref.watch(habitRepositoryProvider).getAll(),
    goals: await ref.watch(goalRepositoryProvider).getAll(),
    finance: await ref.watch(financeRepositoryProvider).getAll(),
    workouts: await ref.watch(workoutRepositoryProvider).getAll(),
    studySessions: await ref.watch(studyRepositoryProvider).getAllSessions(),
    todayPlan: todayPlan,
  );
});

final dailyReviewProvider = FutureProvider<DailyReviewReport>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(todayPlanProvider);

  final service = ref.watch(dailyReviewServiceProvider);
  final today = DateTime.now();
  final plan = await ref.watch(planRepositoryProvider).getForDate(today);
  return service.generate(
    date: today,
    plan: plan,
    tasks: await ref.watch(taskRepositoryProvider).getAll(),
    habits: await ref.watch(habitRepositoryProvider).getAll(),
    goals: await ref.watch(goalRepositoryProvider).getAll(),
  );
});

final weeklyReviewProvider = FutureProvider<WeeklyReviewReport>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(plansProvider);

  final service = ref.watch(weeklyReviewServiceProvider);
  final plans = await ref.watch(planRepositoryProvider).getAll();
  return service.generate(
    tasks: await ref.watch(taskRepositoryProvider).getAll(),
    habits: await ref.watch(habitRepositoryProvider).getAll(),
    goals: await ref.watch(goalRepositoryProvider).getAll(),
    finance: await ref.watch(financeRepositoryProvider).getAll(),
    workouts: await ref.watch(workoutRepositoryProvider).getAll(),
    studySessions: await ref.watch(studyRepositoryProvider).getAllSessions(),
    plans: plans,
  );
});

final rescheduleSuggestionsProvider =
    FutureProvider<List<RescheduleSuggestion>>((ref) async {
  await ref.watch(planRepositoryProvider).markMissedItems(DateTime.now());
  return ref.watch(autoRescheduleServiceProvider).suggestForToday();
});

class AiPlanningNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  void _invalidatePlanProviders({DateTime? planDate}) {
    ref.invalidate(plansProvider);
    ref.invalidate(todayPlanProvider);
    ref.invalidate(upcomingPlanProvider);
    if (planDate != null) {
      ref.invalidate(planForDateProvider(planDate));
    }
    ref.invalidate(aiTipsProvider);
    ref.invalidate(lifeScoreProvider);
    ref.invalidate(dailyReviewProvider);
    ref.invalidate(weeklyReviewProvider);
    ref.invalidate(rescheduleSuggestionsProvider);
    ref.invalidate(achievementsProvider);
  }

  Future<void> _syncPlanNotifications(PlanEntity plan) async {
    final settings = ref.read(settingsProvider);
    if (!settings.notificationEnabled) return;
    await ref.read(planNotificationHelperProvider).syncPlan(
          plan: plan,
          notificationsEnabled: true,
          leadMinutes: settings.notificationLeadMinutes,
        );
  }

  Future<GeneratedPlan?> generateFromInput(String input) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(aiPlanningServiceProvider);
      final plan = await service.generatePlan(input: input);
      ref.read(planPreviewProvider.notifier).state = plan;
      ref.read(activePlanDateProvider.notifier).state = DateTime(
        plan.planDate.year,
        plan.planDate.month,
        plan.planDate.day,
      );
      state = const AsyncData(null);
      return plan;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<GeneratedPlan?> optimizePreview() async {
    final preview = ref.read(planPreviewProvider);
    if (preview == null) return null;

    final resolved = ScheduleOptimizer.resolveOverlaps(preview.items);
    final optimized = ScheduleOptimizer.optimize(
      preview.copyWith(items: resolved),
    );
    ref.read(planPreviewProvider.notifier).state = optimized;
    return optimized;
  }

  Future<PlanEntity?> confirmPlan() async {
    final preview = ref.read(planPreviewProvider);
    if (preview == null || preview.items.isEmpty) return null;

    state = const AsyncLoading();
    try {
      final optimized = ScheduleOptimizer.optimize(preview);
      final repo = ref.read(planRepositoryProvider);
      final items = optimized.items.map((item) {
        final day = DateTime(
          optimized.planDate.year,
          optimized.planDate.month,
          optimized.planDate.day,
        );
        final start = item.startTime ??
            DateTime(day.year, day.month, day.day, 8, 0);
        return item.copyWith(startTime: start).toEmbedded();
      }).toList();

      if (items.isEmpty) {
        state = AsyncError('Reja bandlari yo\'q', StackTrace.current);
        return null;
      }

      final saved = await repo.upsertForDate(
        planDate: optimized.planDate,
        sourceText: optimized.sourceText.isNotEmpty
            ? optimized.sourceText
            : preview.sourceText,
        items: items,
      );

      await ref.read(planTaskSyncServiceProvider).syncPlanToTasks(saved);
      await _syncPlanNotifications(saved);

      ref.read(activePlanDateProvider.notifier).state = DateTime(
        saved.planDate.year,
        saved.planDate.month,
        saved.planDate.day,
      );

      ref.invalidate(tasksProvider);
      _invalidatePlanProviders(planDate: saved.planDate);
      ref.read(planPreviewProvider.notifier).state = null;
      state = const AsyncData(null);
      return saved;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<void> toggleItem(PlanEntity plan, int itemIndex) async {
    final updated =
        await ref.read(planRepositoryProvider).toggleItemComplete(plan.id, itemIndex);
    if (updated != null) {
      await _syncPlanNotifications(updated);
    }
    _invalidatePlanProviders(planDate: plan.planDate);
  }

  Future<void> applyReschedule() async {
    final plan = await ref.read(planRepositoryProvider).getToday();
    if (plan == null) return;

    final suggestions =
        await ref.read(autoRescheduleServiceProvider).suggestForToday();
    final updated = await ref
        .read(autoRescheduleServiceProvider)
        .applySuggestions(plan, suggestions);
    if (updated != null) {
      await _syncPlanNotifications(updated);
    }
    _invalidatePlanProviders(planDate: plan.planDate);
  }

  Future<void> moveMissedToTomorrow() async {
    final updated = await ref
        .read(autoRescheduleServiceProvider)
        .moveMissedToTomorrow(DateTime.now());
    if (updated != null) {
      await ref.read(planTaskSyncServiceProvider).syncPlanToTasks(updated);
      await _syncPlanNotifications(updated);
    }
    _invalidatePlanProviders();
  }
}

final aiPlanningNotifierProvider =
    NotifierProvider<AiPlanningNotifier, AsyncValue<void>>(AiPlanningNotifier.new);

/// Vazifa bajarilganda reja bandini sinxronlashtirish.
Future<void> syncTaskWithPlan(WidgetRef ref, TaskEntity task) async {
  await ref.read(planTaskSyncServiceProvider).syncTaskCompletionToPlan(task);
  invalidatePlanProviders(ref, planDate: task.dueDate);
}
