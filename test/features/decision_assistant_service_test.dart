import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/coach_conversation_repository.dart';
import 'package:rejabon_ai/features/decision_assistant/domain/decision_assistant_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';
import '../helpers/isar_test_helper.dart';

void main() {
  group('DecisionAssistantService.generateRecommendations', () {
    late TestIsarHandle handle;
    late DecisionAssistantService service;

    setUp(() async {
      handle = await openTestIsar();
      service = DecisionAssistantService(
        conversationRepo: CoachConversationRepository(handle.isar),
      );
    });

    tearDown(() => closeTestIsar(handle));

    test('surfaces overdue tasks', () {
      const profile = LifeTwinProfile(
        lifeScore: 60,
        patternInsights: [],
        memoryInsights: [],
        burnout: null,
        bestDay: 'Dushanba',
        twinMessage: 'Test',
      );

      final tasks = [
        TaskEntity.create(
          title: 'Kechikkan',
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      final recs = service.generateRecommendations(
        profile: profile,
        goals: const [],
        tasks: tasks,
        memoryInsights: const [],
      );

      expect(recs.any((r) => r.category == 'tasks'), isTrue);
    });

    test('includes twin analysis recommendations', () {
      const profile = LifeTwinProfile(
        lifeScore: 70,
        patternInsights: [],
        memoryInsights: [],
        burnout: null,
        bestDay: 'Dushanba',
        twinMessage: 'Test',
      );

      const twinAnalysis = LifeTwinAnalysis(
        insights: [
          TwinInsight(
            id: 'peak',
            category: 'productivity',
            headline: 'Peak',
            body: '9-12',
            confidence: 0.9,
          ),
        ],
        recommendations: const [],
        peakHoursLabel: '09:00–12:00',
        learningStyle: 'daily_sessions',
        strengths: const ['Odat'],
        weaknesses: const [],
      );

      final recs = service.generateRecommendations(
        profile: profile,
        goals: const [],
        tasks: const [],
        memoryInsights: const [],
        twinAnalysis: twinAnalysis,
      );

      expect(recs.any((r) => r.category == 'twin'), isTrue);
    });
  });
}
