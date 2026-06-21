import '../../features/ai_coach/domain/ai_coach_service.dart';
import 'models/coach_context.dart';
import 'models/life_insight.dart';
import 'recommendation_engine.dart';

/// Kunlik / haftalik / oylik murabbiy xabarlari.
class CoachingMessage {
  const CoachingMessage({
    required this.cadence,
    required this.headline,
    required this.body,
    required this.recommendations,
    this.actionRoute,
  });

  final String cadence;
  final String headline;
  final String body;
  final List<UnifiedRecommendation> recommendations;
  final String? actionRoute;
}

class CoachingCadenceService {
  const CoachingCadenceService({RecommendationEngine? engine})
      : _engine = engine ?? const RecommendationEngine();

  final RecommendationEngine _engine;

  CoachingMessage daily({
    required CoachContext context,
    required List<AiTip> tips,
    String userName = '',
  }) {
    final insights = _engine.brainInsights(context: context, coachTips: tips);
    final merged = _engine.merge(
      context: context,
      coachTips: tips,
      brainInsights: insights,
      limit: 5,
    );
    final top = merged.isEmpty ? null : merged.first;
    final greeting = _dailyGreeting(userName);

    return CoachingMessage(
      cadence: 'daily',
      headline: greeting,
      body: top?.body ??
          'Bugun bitta vazifa yoki odat bilan kichik qadam qo\'ying.',
      recommendations: merged,
      actionRoute: top?.actionRoute ?? '/vazifalar',
    );
  }

  CoachingMessage weekly({
    required CoachContext context,
    required List<AiTip> tips,
    required int tasksCompleted,
    required int tasksMissed,
    required int overallScore,
  }) {
    final insights = _engine.brainInsights(context: context, coachTips: tips);
    final merged = _engine.merge(
      context: context,
      coachTips: tips,
      brainInsights: insights,
      limit: 6,
    );

    final wins = tasksCompleted > 0 ? '$tasksCompleted ta vazifa bajarildi' : '';
    final misses =
        tasksMissed > 0 ? '$tasksMissed ta vazifa qoldi' : 'Barcha vazifalar yopildi';
    final body = [
      if (wins.isNotEmpty) wins,
      misses,
      'Haftalik ball: $overallScore/100',
      if (merged.isNotEmpty) merged.first.body,
    ].join(' · ');

    return CoachingMessage(
      cadence: 'weekly',
      headline: 'Haftalik murabbiy xulosasi',
      body: body,
      recommendations: merged,
      actionRoute: '/boshqa/ceo',
    );
  }

  CoachingMessage monthly({
    required CoachContext context,
    required List<AiTip> tips,
    required double avgGoalProgress,
    required int longestStreak,
  }) {
    final insights = _engine.brainInsights(context: context, coachTips: tips);
    final merged = _engine.merge(
      context: context,
      coachTips: tips,
      brainInsights: insights,
      limit: 4,
    );

    return CoachingMessage(
      cadence: 'monthly',
      headline: 'Oylik strategiya',
      body: 'Maqsadlar o\'rtacha ${avgGoalProgress.round()}%. '
          'Eng uzun streak: $longestStreak kun. '
          '${merged.isNotEmpty ? merged.first.body : "Keyingi oy uchun bitta katta maqsad tanlang."}',
      recommendations: merged,
      actionRoute: '/hayot/maqsadlar',
    );
  }

  String _dailyGreeting(String userName) {
    final hour = DateTime.now().hour;
    final name = userName.trim().isEmpty ? '' : ', $userName';
    if (hour < 12) return 'Xayrli tong$name';
    if (hour < 18) return 'Xayrli kun$name';
    return 'Xayrli kech$name';
  }
}
