import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/intelligence/life_brain_facade.dart';
import 'package:rejabon_ai/core/intelligence/models/coach_context.dart';
import 'package:rejabon_ai/core/intelligence/models/life_insight.dart';
import 'package:rejabon_ai/features/ai_coach/domain/ai_coach_service.dart';
import 'package:rejabon_ai/features/journal/domain/mood_trend_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/coach_pattern_engine.dart';

void main() {
  group('LifeBrainFacade', () {
    final facade = const LifeBrainFacade();

    test('prioritizes burnout over coach tips', () {
      final context = CoachContext(
        asOf: DateTime(2026, 6, 21),
        moodTrend: MoodTrendReport(
          last7Days: [],
          average7d: 2,
          trend: 'down',
          insight: 'Past',
          hasSufficientData: true,
          burnoutRisk: true,
        ),
        burnout: BurnoutSignal(
          level: 'high',
          message: 'Dam oling.',
        ),
      );

      final insights = facade.generateInsights(
        context: context,
        coachTips: const [
          AiTip(title: 'Vazifa', description: 'Bugun 3 ta vazifa'),
        ],
      );

      expect(insights.first.id, 'burnout_high');
      expect(insights.first.priority, greaterThan(70));
    });

    test('prioritizes goal drift over coach tips', () {
      final context = CoachContext(
        asOf: DateTime(2026, 6, 21),
        moodTrend: MoodTrendReport(
          last7Days: [],
          average7d: 4,
          trend: 'stable',
          insight: 'Yaxshi',
          hasSufficientData: true,
        ),
        goalsAtRisk: const [
          GoalDriftSignal(
            goalTitle: 'Kitob yozish',
            daysInactive: 14,
            progress: 5,
          ),
        ],
      );

      final insights = facade.generateInsights(
        context: context,
        coachTips: const [
          AiTip(title: 'Vazifa', description: 'Bugun 3 ta vazifa'),
        ],
      );

      expect(insights.first.id, contains('goal_drift'));
      expect(insights.first.priority, 75);
    });

    test('returns default encouragement when no signals', () {
      final context = CoachContext(
        asOf: DateTime(2026, 6, 21),
        moodTrend: MoodTrendReport(
          last7Days: [],
          average7d: 0,
          trend: 'stable',
          insight: 'Ma\'lumot yetarli emas',
          hasSufficientData: false,
        ),
      );

      final top = facade.topInsight(context: context, coachTips: const []);
      expect(top?.id, 'default_encourage');
    });
  });
}
