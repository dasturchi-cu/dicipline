import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';

void main() {
  group('FuturePredictionEngine', () {
    final engine = FuturePredictionEngine();

    test('predicts goal completion weeks', () {
      final goals = [GoalEntity.create(title: 'Maqsad', progress: 50)];
      final tasks = List.generate(
        5,
        (_) => TaskEntity.create(
          title: 'Done',
          isCompleted: true,
          updatedAt: DateTime.now(),
        ),
      );

      final predictions = engine.predict(
        goals: goals,
        habits: const [],
        tasks: tasks,
        journal: const [],
      );

      expect(predictions.goalPredictions, hasLength(1));
      expect(predictions.goalPredictions.first.weeksRemaining, greaterThan(0));
    });

    test('flags streak risk when habit not done today', () {
      final habit = HabitEntity.create(
        name: 'Yugurish',
        completedDates: [
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now().subtract(const Duration(days: 2)),
        ],
      );

      final predictions = engine.predict(
        goals: const [],
        habits: [habit],
        tasks: const [],
        journal: const [],
      );

      expect(predictions.streakRisks.first.riskLevel, isNot('low'));
    });

    test('predicts productivity trend', () {
      final now = DateTime.now();
      final tasks = [
        TaskEntity.create(
          title: 'A',
          isCompleted: true,
          updatedAt: now,
        ),
        TaskEntity.create(
          title: 'B',
          isCompleted: true,
          updatedAt: now.subtract(const Duration(days: 10)),
        ),
      ];

      final predictions = engine.predict(
        goals: const [],
        habits: const [],
        tasks: tasks,
        journal: const [],
      );

      final prod = predictions.trends.firstWhere((t) => t.metric == 'productivity');
      expect(prod.direction, isNotEmpty);
    });
  });
}
