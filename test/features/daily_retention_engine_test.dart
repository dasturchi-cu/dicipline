import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/intelligence/models/coach_context.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';
import 'package:rejabon_ai/features/journal/domain/mood_trend_service.dart';
import 'package:rejabon_ai/features/retention/domain/daily_retention_engine.dart';

void main() {
  group('DailyRetentionEngine', () {
    final engine = DailyRetentionEngine();

    test('builds complete daily bundle', () {
      const twinAnalysis = LifeTwinAnalysis(
        insights: [
          TwinInsight(
            id: '1',
            category: 'productivity',
            headline: 'Peak',
            body: '9-12 daqiqa eng yaxshi',
            confidence: 0.9,
          ),
        ],
        recommendations: const [],
        peakHoursLabel: '09:00–12:00',
        learningStyle: 'daily_sessions',
        strengths: const ['Odat'],
        weaknesses: const [],
      );

      const predictions = FuturePredictions(
        goalPredictions: [],
        streakRisks: [],
        trends: [],
      );

      const breakdown = LifeScoreBreakdown(
        overall: 70,
        discipline: 65,
        health: 60,
        learning: 55,
        finance: 50,
        sleep: 45,
        goals: 40,
      );

      final coachContext = CoachContext(
        asOf: DateTime(2026, 6, 21),
        moodTrend: const MoodTrendReport(
          last7Days: [],
          average7d: 3.5,
          trend: 'stable',
          insight: 'Barqaror',
          hasSufficientData: true,
        ),
        today: TodaySnapshot(habitsCompletedToday: 2),
      );

      final bundle = engine.buildDailyBundle(
        twinAnalysis: twinAnalysis,
        predictions: predictions,
        breakdown: breakdown,
        playerLevel: 5,
        dailyXpEarned: 30,
        coachContext: coachContext,
      );

      expect(bundle.dailyInsight, contains('9-12'));
      expect(bundle.progressLine, contains('70'));
      expect(bundle.returnReason, isNotEmpty);
      expect(bundle.streakHint, contains('2'));
    });
  });
}
