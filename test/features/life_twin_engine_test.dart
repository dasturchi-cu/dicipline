import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';

void main() {
  group('LifeTwinEngine', () {
    final engine = LifeTwinEngine();

    test('detects daily study style from habits and journal', () {
      const profile = LifeTwinProfile(
        lifeScore: 65,
        patternInsights: [],
        memoryInsights: [],
        burnout: null,
        bestDay: 'Dushanba',
        twinMessage: 'Test',
      );

      final habits = [
        HabitEntity.create(name: 'IELTS o\'qish'),
        HabitEntity.create(name: 'Ingliz study'),
      ];

      final journal = List.generate(
        10,
        (i) => JournalEntryEntity.create(
          date: DateTime(2026, 1, i + 1),
          content: 'Bugun o\'qidim',
        ),
      );

      final analysis = engine.analyze(
        profile: profile,
        tasks: const [],
        habits: habits,
        goals: [GoalEntity.create(title: 'IELTS 7.0', progress: 10)],
        journal: journal,
      );

      expect(analysis.learningStyle, 'daily_sessions');
      expect(
        analysis.recommendations.any((r) => r.id == 'learn_daily'),
        isTrue,
      );
    });

    test('generates peak hours insight from completed tasks', () {
      const profile = LifeTwinProfile(
        lifeScore: 70,
        patternInsights: [],
        memoryInsights: [],
        burnout: null,
        bestDay: 'Seshanba',
        twinMessage: 'Test',
      );

      final now = DateTime.now();
      final tasks = List.generate(
        12,
        (i) => TaskEntity.create(
          title: 'Task $i',
          isCompleted: true,
          updatedAt: DateTime(now.year, now.month, now.day, 9 + (i % 2)),
        ),
      );

      final analysis = engine.analyze(
        profile: profile,
        tasks: tasks,
        habits: const [],
        goals: const [],
        journal: const [],
      );

      expect(analysis.insights.any((i) => i.id == 'peak_hours'), isTrue);
      expect(analysis.peakHoursLabel, isNotEmpty);
    });
  });
}
