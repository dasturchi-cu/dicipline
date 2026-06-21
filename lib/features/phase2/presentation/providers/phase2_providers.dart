import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/intelligence/coach_context_providers.dart';
import 'package:rejabon_ai/core/life_os/life_os_engine.dart';
import 'package:rejabon_ai/core/providers/core_providers.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/repositories/action_plan_repository.dart';
import 'package:rejabon_ai/core/repositories/coach_conversation_repository.dart';
import 'package:rejabon_ai/core/repositories/future_letter_repository.dart';
import 'package:rejabon_ai/core/repositories/twin_profile_repository.dart';
import 'package:rejabon_ai/core/voice/speech_capture_service.dart';
import 'package:rejabon_ai/core/voice/voice_ai_service.dart';
import 'package:rejabon_ai/features/action_engine/domain/action_engine_service.dart';
import 'package:rejabon_ai/features/ai_memory/domain/ai_memory_service.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/decision_assistant/domain/decision_assistant_service.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_letter_service.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_simulator_service.dart';
import 'package:rejabon_ai/features/capture/presentation/providers/capture_providers.dart';
import 'package:rejabon_ai/core/integration/ai_memory_sync.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/goal_execution/domain/goal_execution_service.dart';
import 'package:rejabon_ai/features/life_map/domain/life_map_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/coach_pattern_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/digital_twin_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';
import 'package:rejabon_ai/features/life_twin/domain/twin_profile_engine.dart';
import 'package:rejabon_ai/features/platform/presentation/providers/platform_providers.dart';
import 'package:rejabon_ai/features/retention/domain/daily_retention_engine.dart';
import 'package:rejabon_ai/features/social/presentation/providers/social_providers.dart';

// ── Repositories ─────────────────────────────────────────────────────────────

final futureLetterRepositoryProvider = Provider<FutureLetterRepository>((ref) {
  return FutureLetterRepository(ref.watch(isarServiceProvider).isar);
});

final coachConversationRepositoryProvider =
    Provider<CoachConversationRepository>((ref) {
  return CoachConversationRepository(ref.watch(isarServiceProvider).isar);
});

final twinProfileRepositoryProvider = Provider<TwinProfileRepository>((ref) {
  return TwinProfileRepository(ref.watch(isarServiceProvider).isar);
});

final actionPlanRepositoryProvider = Provider<ActionPlanRepository>((ref) {
  return ActionPlanRepository(ref.watch(isarServiceProvider).isar);
});

// ── Services ─────────────────────────────────────────────────────────────────

final coachPatternEngineProvider = Provider<CoachPatternEngine>((ref) {
  return const CoachPatternEngine();
});

final twinProfileEngineProvider = Provider<TwinProfileEngine>((ref) {
  return TwinProfileEngine(habitRepo: ref.watch(habitRepositoryProvider));
});

final digitalTwinEngineProvider = Provider<DigitalTwinEngine>((ref) {
  return DigitalTwinEngine(
    profileRepo: ref.watch(twinProfileRepositoryProvider),
    memoryRepo: ref.watch(aiMemoryRepositoryProvider),
    habitRepo: ref.watch(habitRepositoryProvider),
    patternEngine: ref.watch(coachPatternEngineProvider),
    profileEngine: ref.watch(twinProfileEngineProvider),
  );
});

final lifeTwinServiceProvider = Provider<LifeTwinService>((ref) {
  return LifeTwinService(
    conversationRepo: ref.watch(coachConversationRepositoryProvider),
    memoryService: ref.watch(aiMemoryServiceProvider),
    twinEngine: ref.watch(digitalTwinEngineProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

final decisionAssistantServiceProvider = Provider<DecisionAssistantService>((ref) {
  return DecisionAssistantService(
    conversationRepo: ref.watch(coachConversationRepositoryProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

final futureSimulatorServiceProvider = Provider<FutureSimulatorService>((ref) {
  return FutureSimulatorService();
});

final futurePredictionEngineProvider = Provider<FuturePredictionEngine>((ref) {
  return FuturePredictionEngine(habitRepo: ref.watch(habitRepositoryProvider));
});

final futureLetterServiceProvider = Provider<FutureLetterService>((ref) {
  return FutureLetterService(ref.watch(futureLetterRepositoryProvider));
});

final actionEngineServiceProvider = Provider<ActionEngineService>((ref) {
  return ActionEngineService(
    actionPlanRepo: ref.watch(actionPlanRepositoryProvider),
    planRepo: ref.watch(planRepositoryProvider),
  );
});

final lifeTwinEngineProvider = Provider<LifeTwinEngine>((ref) {
  return LifeTwinEngine(habitRepo: ref.watch(habitRepositoryProvider));
});

final goalExecutionServiceProvider = Provider<GoalExecutionService>((ref) {
  return GoalExecutionService(
    goalRepo: ref.watch(goalRepositoryProvider),
    taskRepo: ref.watch(taskRepositoryProvider),
    planRepo: ref.watch(planRepositoryProvider),
    twinEngine: ref.watch(lifeTwinEngineProvider),
  );
});

final dailyRetentionEngineProvider = Provider<DailyRetentionEngine>((ref) {
  return DailyRetentionEngine();
});

final lifeOsEngineProvider = Provider<LifeOsEngine>((ref) {
  return LifeOsEngine(
    twinEngine: ref.watch(lifeTwinEngineProvider),
    actionEngine: ref.watch(actionEngineServiceProvider),
    goalExecution: ref.watch(goalExecutionServiceProvider),
    retention: ref.watch(dailyRetentionEngineProvider),
    predictions: ref.watch(futurePredictionEngineProvider),
  );
});

/// Oxirgi bootstrapda bajarilgan proaktiv harakatlar soni.
final proactiveActionsCountProvider = StateProvider<int>((ref) => 0);

final lifeMapServiceProvider = Provider<LifeMapService>((ref) {
  return LifeMapService();
});

final voiceAiServiceProvider = Provider<VoiceAiService>((ref) {
  return VoiceAiService(
    speech: SpeechCaptureService.instance,
    twinService: ref.watch(lifeTwinServiceProvider),
    taskRepo: ref.watch(taskRepositoryProvider),
    habitRepo: ref.watch(habitRepositoryProvider),
    planRepo: ref.watch(planRepositoryProvider),
    aiService: ref.watch(aiServiceProvider),
  );
});

// ── Data providers ───────────────────────────────────────────────────────────

final lifeTwinProfileProvider = FutureProvider<LifeTwinProfile>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(journalProvider);
  ref.watch(aiMemoriesProvider);

  final breakdown = await ref.watch(lifeScoreProvider.future);
  return ref.watch(lifeTwinServiceProvider).buildProfile(
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        journal: await ref.watch(journalRepositoryProvider).getAll(),
        lifeScore: breakdown,
      );
});

final lifeTwinAnalysisProvider = FutureProvider<LifeTwinAnalysis>((ref) async {
  final profile = await ref.watch(lifeTwinProfileProvider.future);
  final engine = ref.watch(lifeTwinEngineProvider);
  return engine.analyze(
    profile: profile,
    tasks: await ref.watch(taskRepositoryProvider).getAll(),
    habits: await ref.watch(habitRepositoryProvider).getAll(),
    goals: await ref.watch(goalRepositoryProvider).getAll(),
    journal: await ref.watch(journalRepositoryProvider).getAll(),
    storedProfile: profile.twinProfile,
  );
});

final lifeOsStateProvider = FutureProvider<LifeOsState>((ref) async {
  ref.watch(tasksProvider);
  ref.watch(habitsProvider);
  ref.watch(goalsProvider);
  ref.watch(journalProvider);
  ref.watch(coachContextProvider);

  final coachContext = ref.watch(coachContextProvider);
  final profile = await ref.watch(lifeTwinProfileProvider.future);
  final breakdown = await ref.watch(lifeScoreProvider.future);
  final player = ref.watch(playerProfileProvider).valueOrNull;
  final dailyXp =
      await ref.watch(xpEventRepositoryProvider).getTodayXpTotal();

  return ref.watch(lifeOsEngineProvider).compute(
        coachContext: coachContext,
        twinProfile: profile,
        breakdown: breakdown,
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        journal: await ref.watch(journalRepositoryProvider).getAll(),
        playerLevel: player?.level ?? 1,
        dailyXpEarned: dailyXp,
        proactiveActionsTaken: ref.watch(proactiveActionsCountProvider),
      );
});

final dailyRetentionBundleProvider =
    FutureProvider<DailyRetentionBundle>((ref) async {
  final state = await ref.watch(lifeOsStateProvider.future);
  return state.dailyBundle;
});

final decisionRecommendationsProvider =
    FutureProvider<List<DecisionRecommendation>>((ref) async {
  final profile = await ref.watch(lifeTwinProfileProvider.future);
  final twinAnalysis = await ref.watch(lifeTwinAnalysisProvider.future);
  final memories = await ref.watch(aiMemoryServiceProvider).getTopInsights();
  return ref.watch(decisionAssistantServiceProvider).generateRecommendations(
        profile: profile,
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        memoryInsights: memories,
        twinAnalysis: twinAnalysis,
      );
});

final simulationResultsProvider =
    FutureProvider<List<SimulationResult>>((ref) async {
  final breakdown = await ref.watch(lifeScoreProvider.future);
  return ref.watch(futureSimulatorServiceProvider).simulateAll(
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        breakdown: breakdown,
      );
});

final futurePredictionsProvider = FutureProvider<FuturePredictions>((ref) async {
  return ref.watch(futurePredictionEngineProvider).predict(
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        habits: await ref.watch(habitRepositoryProvider).getAll(),
        tasks: await ref.watch(taskRepositoryProvider).getAll(),
        journal: await ref.watch(journalRepositoryProvider).getAll(),
      );
});

final lifeMapDataProvider = FutureProvider<LifeMapData>((ref) async {
  return ref.watch(lifeMapServiceProvider).build(
        goals: await ref.watch(goalRepositoryProvider).getAll(),
        milestones: await ref.watch(milestoneRepositoryProvider).getAll(),
        achievements:
            await ref.watch(achievementUnlockRepositoryProvider).getAll(),
        xpEvents: await ref.watch(xpEventRepositoryProvider).getAll(),
      );
});

final actionPlansProvider = StreamProvider((ref) {
  return ref.watch(actionPlanRepositoryProvider).watchAll();
});

final pendingActionPlansProvider = StreamProvider((ref) {
  return ref.watch(actionPlanRepositoryProvider).watchPending();
});

final futureLettersProvider = StreamProvider((ref) {
  return ref.watch(futureLetterRepositoryProvider).watchAll();
});

final pendingLettersProvider = StreamProvider((ref) {
  return ref.watch(futureLetterRepositoryProvider).watchPending();
});

final coachConversationProvider = StreamProvider((ref) {
  return ref.watch(coachConversationRepositoryProvider).watchRecent(limit: 100);
});

final decisionConversationProvider = StreamProvider((ref) {
  return ref
      .watch(coachConversationRepositoryProvider)
      .watchByContext('decision', limit: 50);
});

final twinChatConversationProvider = StreamProvider((ref) {
  return ref
      .watch(coachConversationRepositoryProvider)
      .watchByContext('twin_chat', limit: 50);
});

/// Phase 2 provayderlarini yangilaydi.
void invalidatePhase2Providers(WidgetRef ref) {
  ref.invalidate(lifeTwinProfileProvider);
  ref.invalidate(lifeTwinAnalysisProvider);
  ref.invalidate(lifeOsStateProvider);
  ref.invalidate(dailyRetentionBundleProvider);
  ref.invalidate(decisionRecommendationsProvider);
  ref.invalidate(simulationResultsProvider);
  ref.invalidate(futurePredictionsProvider);
  ref.invalidate(lifeMapDataProvider);
  ref.invalidate(futureLettersProvider);
  ref.invalidate(actionPlansProvider);
  ref.invalidate(pendingActionPlansProvider);
  ref.invalidate(coachConversationProvider);
  ref.invalidate(decisionConversationProvider);
  ref.invalidate(twinChatConversationProvider);
}

/// Phase 2 bootstrap — xotira, xatlar, twin profil, AI tahlil, proaktiv harakatlar.
Future<void> runPhase2Bootstrap(WidgetRef ref) async {
  await ref.read(futureLetterServiceProvider).processDeliveries();

  await syncAiMemoryOnReview(ref);

  final breakdown = await ref.read(lifeScoreProvider.future);
  final profile = await ref.read(lifeTwinServiceProvider).buildProfile(
        tasks: await ref.read(taskRepositoryProvider).getAll(),
        habits: await ref.read(habitRepositoryProvider).getAll(),
        goals: await ref.read(goalRepositoryProvider).getAll(),
        journal: await ref.read(journalRepositoryProvider).getAll(),
        lifeScore: breakdown,
      );

  final coachContext = ref.read(coachContextProvider);
  final player = ref.read(playerProfileProvider).valueOrNull;
  final dailyXp =
      await ref.read(xpEventRepositoryProvider).getTodayXpTotal();
  final engine = ref.read(lifeOsEngineProvider);

  final state = engine.compute(
    coachContext: coachContext,
    twinProfile: profile,
    breakdown: breakdown,
    tasks: await ref.read(taskRepositoryProvider).getAll(),
    habits: await ref.read(habitRepositoryProvider).getAll(),
    goals: await ref.read(goalRepositoryProvider).getAll(),
    journal: await ref.read(journalRepositoryProvider).getAll(),
    playerLevel: player?.level ?? 1,
    dailyXpEarned: dailyXp,
  );

  final proactiveCount = await engine.runProactiveActions(
    state: state,
    profile: profile,
    breakdown: breakdown,
    tasks: await ref.read(taskRepositoryProvider).getAll(),
    habits: await ref.read(habitRepositoryProvider).getAll(),
    goals: await ref.read(goalRepositoryProvider).getAll(),
    journal: await ref.read(journalRepositoryProvider).getAll(),
  );

  ref.read(proactiveActionsCountProvider.notifier).state = proactiveCount;
  ref.invalidate(aiMemoriesProvider);
  invalidatePhase2Providers(ref);
  await runSocialBootstrap(ref);
}
