import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/intelligence/memory_retriever.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/briefing/domain/daily_briefing_service.dart';
import 'package:rejabon_ai/features/emotion/domain/emotion_intelligence_service.dart';
import 'package:rejabon_ai/features/emergency/domain/emergency_mode_service.dart';
import 'package:rejabon_ai/features/heatmap/domain/life_heatmap_service.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/features/platform/presentation/providers/platform_providers.dart';
import 'package:rejabon_ai/features/second_brain/domain/second_brain_qa_service.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';

// ── Services ─────────────────────────────────────────────────────────────────

final memoryRetrieverProvider = Provider<MemoryRetriever>((ref) {
  return const MemoryRetriever();
});

final dailyBriefingServiceProvider = Provider<DailyBriefingService>((ref) {
  return DailyBriefingService();
});

final lifeHeatmapServiceProvider = Provider<LifeHeatmapService>((ref) {
  return const LifeHeatmapService();
});

final emotionIntelligenceServiceProvider =
    Provider<EmotionIntelligenceService>((ref) {
  return EmotionIntelligenceService();
});

final emergencyModeServiceProvider = Provider<EmergencyModeService>((ref) {
  return EmergencyModeService();
});

final secondBrainQaServiceProvider = Provider<SecondBrainQaService>((ref) {
  return SecondBrainQaService();
});

// ── Data providers ───────────────────────────────────────────────────────────

final dailyBriefingProvider = Provider<DailyBriefing>((ref) {
  final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
  final habits = ref.watch(habitsProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final journal = ref.watch(journalProvider).valueOrNull ?? [];
  final userName = ref.watch(settingsProvider).userName;

  final today = DateTime.now();
  final habitsDone = habits
      .where((h) => h.completedDates.any((d) =>
          d.year == today.year &&
          d.month == today.month &&
          d.day == today.day))
      .length;
  final streak = habits.isEmpty
      ? 0
      : habits.map(habitStreak).fold(0, (a, b) => a > b ? a : b);

  return ref.watch(dailyBriefingServiceProvider).generate(
        tasks: tasks,
        habits: habits,
        goals: goals,
        journal: journal,
        longestStreak: streak,
        habitsDoneToday: habitsDone,
        habitsTotal: habits.length,
        userName: userName,
      );
});

final lifeHeatmapProvider = Provider((ref) {
  final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
  final habits = ref.watch(habitsProvider).valueOrNull ?? [];
  final journal = ref.watch(journalProvider).valueOrNull ?? [];
  final workouts = ref.watch(workoutsProvider).valueOrNull ?? [];
  final sessions = ref.watch(studySessionsProvider).valueOrNull ?? [];

  return ref.watch(lifeHeatmapServiceProvider).build(
        tasks: tasks,
        habits: habits,
        journal: journal,
        workouts: workouts,
        studySessions: sessions,
      );
});

final emotionProfileProvider = Provider((ref) {
  final journal = ref.watch(journalProvider).valueOrNull ?? [];
  final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
  return ref.watch(emotionIntelligenceServiceProvider).analyze(
        journal: journal,
        tasks: tasks,
      );
});

final emergencyResponseProvider = FutureProvider((ref) async {
  final journal = await ref.read(journalRepositoryProvider).getAll();
  final tasks = await ref.read(taskRepositoryProvider).getAll();
  final habits = await ref.read(habitRepositoryProvider).getAll();
  final goals = await ref.read(goalRepositoryProvider).getAll();
  final completed = tasks.where((t) => t.isCompleted).length;
  final streak = habits.isEmpty
      ? 0
      : habits.map(habitStreak).fold(0, (a, b) => a > b ? a : b);

  return ref.read(emergencyModeServiceProvider).generate(
        journal: journal,
        tasks: tasks,
        habits: habits,
        goals: goals,
        completedTasksTotal: completed,
        longestStreak: streak,
      );
});

final memoryContextProvider = FutureProvider((ref) async {
  final retriever = ref.watch(memoryRetrieverProvider);
  final repo = ref.watch(aiMemoryRepositoryProvider);
  return retriever.retrieve(repository: repo, limit: 5);
});

final dashboardPredictionsProvider =
    FutureProvider<FuturePredictions>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(journalProvider);
  return ref.watch(futurePredictionsProvider.future);
});

final brainQaProvider = Provider.family<BrainAnswer, String>((ref, question) {
  final notes = ref.watch(notesProvider).valueOrNull ?? [];
  final documents = ref.watch(documentsProvider).valueOrNull ?? [];
  final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
  final goals = ref.watch(goalsProvider).valueOrNull ?? [];
  final journal = ref.watch(journalProvider).valueOrNull ?? [];

  return ref.watch(secondBrainQaServiceProvider).ask(
        question: question,
        notes: notes,
        documents: documents,
        tasks: tasks,
        goals: goals,
        journal: journal,
      );
});
