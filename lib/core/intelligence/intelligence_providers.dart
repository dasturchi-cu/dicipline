import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ai_coach/presentation/providers/ai_coach_provider.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import 'coach_context_providers.dart';
import 'life_brain_facade.dart';
import 'ai_context_builder.dart';
import 'coaching_cadence_service.dart';
import 'recommendation_engine.dart';
import 'models/life_insight.dart';

export 'coach_context_providers.dart';

final lifeBrainFacadeProvider = Provider<LifeBrainFacade>((ref) {
  return const LifeBrainFacade();
});

final lifeBrainInsightsProvider = Provider<List<LifeInsight>>((ref) {
  final context = ref.watch(coachContextProvider);
  final tips = ref.watch(aiTipsProvider).valueOrNull ?? [];
  return ref.watch(lifeBrainFacadeProvider).generateInsights(
        context: context,
        coachTips: tips,
      );
});

final lifeBrainTopInsightProvider = Provider<LifeInsight?>((ref) {
  final insights = ref.watch(lifeBrainInsightsProvider);
  return insights.isEmpty ? null : insights.first;
});

final recommendationEngineProvider = Provider<RecommendationEngine>((ref) {
  return const RecommendationEngine();
});

final coachingCadenceServiceProvider = Provider<CoachingCadenceService>((ref) {
  return const CoachingCadenceService();
});

final aiContextBuilderProvider = Provider<AiContextBuilder>((ref) {
  return const AiContextBuilder();
});

final unifiedRecommendationsProvider = Provider((ref) {
  final context = ref.watch(coachContextProvider);
  final tips = ref.watch(aiTipsProvider).valueOrNull ?? [];
  final engine = ref.watch(recommendationEngineProvider);
  final insights = engine.brainInsights(context: context, coachTips: tips);
  return engine.merge(
    context: context,
    coachTips: tips,
    brainInsights: insights,
  );
});

final dailyCoachingProvider = Provider((ref) {
  final context = ref.watch(coachContextProvider);
  final tips = ref.watch(aiTipsProvider).valueOrNull ?? [];
  final userName = ref.watch(settingsProvider).userName;
  return ref.watch(coachingCadenceServiceProvider).daily(
        context: context,
        tips: tips,
        userName: userName,
      );
});
