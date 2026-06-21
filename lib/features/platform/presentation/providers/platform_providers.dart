import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../core/repositories/ai_memory_repository.dart';
import '../../../../core/repositories/challenge_repository.dart';
import '../../../../core/repositories/monthly_focus_repository.dart';
import '../../../ai_memory/domain/ai_memory_service.dart';
import '../../../analytics/domain/analytics_insight_service.dart';
import '../../../challenges/domain/challenge_service.dart';
import '../../../day_builder/domain/day_builder_service.dart';
import '../../../ai_planning/presentation/providers/ai_planning_provider.dart';

// ── Repository providers ─────────────────────────────────────────────────────

final monthlyFocusRepositoryProvider = Provider<MonthlyFocusRepository>((ref) {
  return MonthlyFocusRepository(ref.watch(isarServiceProvider).isar);
});

final aiMemoryRepositoryProvider = Provider<AiMemoryRepository>((ref) {
  return AiMemoryRepository(ref.watch(isarServiceProvider).isar);
});

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository(ref.watch(isarServiceProvider).isar);
});

// ── Service providers ────────────────────────────────────────────────────────

final aiMemoryServiceProvider = Provider<AiMemoryService>((ref) {
  return AiMemoryService(
    memoryRepository: ref.watch(aiMemoryRepositoryProvider),
    habitRepository: ref.watch(habitRepositoryProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

final analyticsInsightServiceProvider = Provider<AnalyticsInsightService>((ref) {
  return AnalyticsInsightService(
    habitRepository: ref.watch(habitRepositoryProvider),
  );
});

final challengeServiceProvider = Provider<ChallengeService>((ref) {
  return ChallengeService(ref.watch(challengeRepositoryProvider));
});

final dayBuilderServiceProvider = Provider<DayBuilderService>((ref) {
  return DayBuilderService(
    planRepository: ref.watch(planRepositoryProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

// ── Data providers ───────────────────────────────────────────────────────────

final monthlyFocusProvider = StreamProvider((ref) {
  return ref
      .watch(monthlyFocusRepositoryProvider)
      .watchForMonth(DateTime.now());
});

final aiMemoriesProvider = StreamProvider((ref) {
  return ref.watch(aiMemoryRepositoryProvider).watchAll();
});

final activeChallengesProvider = StreamProvider((ref) {
  return ref.watch(challengeRepositoryProvider).watchActive();
});

final analyticsInsightsProvider = FutureProvider((ref) async {
  final service = ref.watch(analyticsInsightServiceProvider);
  final tasks = await ref.watch(taskRepositoryProvider).getAll();
  final habits = await ref.watch(habitRepositoryProvider).getAll();
  final goals = await ref.watch(goalRepositoryProvider).getAll();
  final finance = await ref.watch(financeRepositoryProvider).getAll();
  final workouts = await ref.watch(workoutRepositoryProvider).getAll();
  final sessions = await ref.watch(studyRepositoryProvider).getAllSessions();
  final journal = await ref.watch(journalRepositoryProvider).getAll();

  return service.generate(
    tasks: tasks,
    habits: habits,
    goals: goals,
    finance: finance,
    workouts: workouts,
    studySessions: sessions,
    journal: journal,
  );
});

final yesterdayReviewProvider = FutureProvider((ref) async {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  final plan = await ref.watch(planRepositoryProvider).getForDate(yesterday);
  final tasks = await ref.watch(taskRepositoryProvider).getAll();
  final habits = await ref.watch(habitRepositoryProvider).getAll();
  final goals = await ref.watch(goalRepositoryProvider).getAll();

  return ref.watch(dailyReviewServiceProvider).generate(
        date: yesterday,
        plan: plan,
        tasks: tasks,
        habits: habits,
        goals: goals,
      );
});

final aiMemoryInsightsProvider = FutureProvider<List<String>>((ref) async {
  final memories = await ref.watch(aiMemoryRepositoryProvider).getTop(limit: 3);
  return memories.map((m) => m.insight).toList();
});

/// Widget ma'lumotlarini yangilaydi.
Future<void> refreshWidgetData(WidgetRef ref) async {
  if (kIsWeb) return;
  try {
    await ref.read(widgetBridgeProvider).updateFromProviders(ref);
  } catch (_) {}
}

final widgetBridgeProvider = Provider<WidgetBridge>((ref) => WidgetBridge());

class WidgetBridge {
  static const _streakKey = 'streak';
  static const _tasksKey = 'tasks_today';
  static const _goalKey = 'main_goal';
  static const _progressKey = 'daily_progress';
  static const _appGroup = 'group.rejabon.ai';

  Future<void> updateFromProviders(WidgetRef ref) async {
    if (kIsWeb) return;

    final habits = await ref.read(habitRepositoryProvider).getAll();
    final tasks = await ref.read(taskRepositoryProvider).getAll();
    final focus = await ref.read(monthlyFocusRepositoryProvider).getForMonth(
          DateTime.now(),
        );

    final streak = habits.isEmpty
        ? 0
        : habits.map(habitStreak).fold(0, (a, b) => a > b ? a : b);

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final todayTasks = tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return true;
      final due = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return !due.isAfter(todayNorm);
    }).length;

    final completedToday = tasks
        .where((t) => t.isCompleted)
        .where((t) =>
            t.updatedAt.year == today.year &&
            t.updatedAt.month == today.month &&
            t.updatedAt.day == today.day)
        .length;

    final habitsDone = habits
        .where((h) => h.completedDates.any((d) =>
            d.year == today.year &&
            d.month == today.month &&
            d.day == today.day))
        .length;
    final habitsTotal = habits.length;
    final totalItems = todayTasks + completedToday + habitsTotal;
    final progress = totalItems > 0
        ? ((completedToday + habitsDone) / totalItems * 100).round()
        : 0;

    await HomeWidget.setAppGroupId(_appGroup);
    await HomeWidget.saveWidgetData<int>(_streakKey, streak);
    await HomeWidget.saveWidgetData<int>(_tasksKey, todayTasks);
    await HomeWidget.saveWidgetData<String>(_goalKey, focus?.focusTitle ?? 'Maqsad');
    await HomeWidget.saveWidgetData<String>('goal_emoji', focus?.emoji ?? '🎯');
    await HomeWidget.saveWidgetData<int>(_progressKey, progress);
    await HomeWidget.updateWidget(
      name: 'RejabonWidget',
      androidName: 'RejabonWidgetProvider',
      iOSName: 'RejabonWidget',
    );
  }
}