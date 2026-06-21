import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/features/life_twin/domain/twin_profile_engine.dart';

void main() {
  group('TwinProfileEngine', () {
    const engine = TwinProfileEngine();

    test('detects morning person from task completion times', () {
      final now = DateTime.now();
      final tasks = List.generate(
        8,
        (i) => TaskEntity.create(
          title: 'Task $i',
          isCompleted: true,
          updatedAt: DateTime(now.year, now.month, now.day, 8),
        ),
      );

      final profile = engine.compute(
        tasks: tasks,
        habits: const [],
        goals: const [],
        journal: const [],
      );

      expect(profile.chronotype, 'morning_person');
    });

    test('learns active goals', () {
      final goals = [
        GoalEntity.create(title: 'Ingliz tili', progress: 40),
        GoalEntity.create(title: 'Sport', progress: 100),
      ];

      final profile = engine.compute(
        tasks: const [],
        habits: const [],
        goals: goals,
        journal: const [],
      );

      expect(profile.learnedGoals, contains('Ingliz tili'));
      expect(profile.learnedGoals, isNot(contains('Sport')));
    });

    test('detects mood trend from journal', () {
      final base = DateTime(2026, 1, 1);
      final journal = [
        for (var i = 0; i < 7; i++)
          JournalEntryEntity.create(date: base.add(Duration(days: i)), mood: 2),
        for (var i = 7; i < 14; i++)
          JournalEntryEntity.create(
            date: base.add(Duration(days: i)),
            mood: 4,
          ),
      ];

      final profile = engine.compute(
        tasks: const [],
        habits: const [],
        goals: const [],
        journal: journal,
      );

      expect(profile.moodTrend, 'improving');
    });
  });
}
