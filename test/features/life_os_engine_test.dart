import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/intelligence/models/coach_context.dart';
import 'package:rejabon_ai/core/life_os/life_os_engine.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/journal/domain/mood_trend_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/retention/domain/daily_retention_engine.dart';

void main() {
  group('LifeOsEngine', () {
    final engine = LifeOsEngine(
      actionEngine: null,
      goalExecution: null,
      retention: DailyRetentionEngine(),
      predictions: FuturePredictionEngine(),
    );

    test('mood lowers productivity multiplier on burnout risk', () {
      const profile = LifeTwinProfile(
        lifeScore: 55,
        patternInsights: [],
        memoryInsights: [],
        burnout: null,
        bestDay: 'Dushanba',
        twinMessage: 'Test',
      );

      const breakdown = LifeScoreBreakdown(
        overall: 55,
        discipline: 60,
        health: 50,
        learning: 45,
        finance: 50,
        sleep: 40,
        goals: 35,
      );

      final coachContext = CoachContext(
        asOf: DateTime(2026, 6, 21),
        moodTrend: const MoodTrendReport(
          last7Days: [],
          average7d: 2.0,
          trend: 'down',
          insight: 'Burnout xavfi',
          hasSufficientData: true,
          burnoutRisk: true,
        ),
      );

      final state = engine.compute(
        coachContext: coachContext,
        twinProfile: profile,
        breakdown: breakdown,
        tasks: const [],
        habits: const [],
        goals: const [],
        journal: const [],
        playerLevel: 3,
        dailyXpEarned: 10,
      );

      expect(state.moodMultiplier, lessThan(1.0));
      expect(state.productivityScore, lessThan(breakdown.discipline));
      expect(state.dailyBundle.returnReason, isNotEmpty);
    });
  });
}
