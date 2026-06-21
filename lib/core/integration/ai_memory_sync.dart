import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/platform/presentation/providers/platform_providers.dart';
import '../../features/retention/presentation/providers/retention_providers.dart';
import '../providers/repository_providers.dart';

/// AI xotirasini throttled yangilaydi — har 24 soatda bir marta.
class AiMemorySync {
  AiMemorySync._();

  static DateTime? _lastSync;
  static const _minInterval = Duration(hours: 24);

  static Future<void> syncIfNeeded(
    WidgetRef ref, {
    bool force = false,
  }) async {
    final now = DateTime.now();
    if (!force &&
        _lastSync != null &&
        now.difference(_lastSync!) < _minInterval) {
      return;
    }
    _lastSync = now;

    final memory = ref.read(aiMemoryServiceProvider);
    await memory.analyzeAndStore(
      tasks: await ref.read(taskRepositoryProvider).getAll(),
      habits: await ref.read(habitRepositoryProvider).getAll(),
      goals: await ref.read(goalRepositoryProvider).getAll(),
      finance: await ref.read(financeRepositoryProvider).getAll(),
      workouts: await ref.read(workoutRepositoryProvider).getAll(),
      studySessions: await ref.read(studyRepositoryProvider).getAllSessions(),
      journal: await ref.read(journalRepositoryProvider).getAll(),
    );

    ref.invalidate(aiMemoriesProvider);
    ref.invalidate(aiMemoryInsightsProvider);

    final retriever = ref.read(memoryRetrieverProvider);
    final habits = await ref.read(habitRepositoryProvider).getAll();
    final journal = await ref.read(journalRepositoryProvider).getAll();
    final tasks = await ref.read(taskRepositoryProvider).getAll();
    final goals = await ref.read(goalRepositoryProvider).getAll();
    final workouts = await ref.read(workoutRepositoryProvider).getAll();
    final sessions = await ref.read(studyRepositoryProvider).getAllSessions();
    final studyMin = sessions.fold<int>(0, (s, e) => s + e.durationMinutes);
    final mood = journal.isNotEmpty
        ? journal.map((j) => j.mood).reduce((a, b) => a + b) / journal.length
        : 0.0;
    final longestStreak = habits.isEmpty
        ? 0
        : habits.map(habitStreak).fold(0, (a, b) => a > b ? a : b);
    final topGoal = goals.isEmpty
        ? null
        : (List.of(goals)..sort((a, b) => b.progress.compareTo(a.progress)))
            .first
            .title;
    final avgProgress = goals.isEmpty
        ? 0.0
        : goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;

    await retriever.enrichFromLifeData(
      repository: ref.read(aiMemoryRepositoryProvider),
      completedTasks: tasks.where((t) => t.isCompleted).length,
      longestHabitStreak: longestStreak,
      journalDays: journal.where((j) => j.content.trim().isNotEmpty).length,
      studyMinutes: studyMin,
      workoutCount: workouts.length,
      avgGoalProgress: avgProgress,
      avgMood7d: mood,
      topGoalTitle: topGoal,
    );
  }
}

/// App ochilganda va CEO hisobotida — majburiy sinxronizatsiya.
Future<void> syncAiMemoryOnReview(WidgetRef ref) =>
    AiMemorySync.syncIfNeeded(ref, force: true);

/// Vazifa/odat bajarilganda — throttled.
Future<void> syncAiMemoryThrottled(WidgetRef ref) =>
    AiMemorySync.syncIfNeeded(ref);
