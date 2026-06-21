import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';

void main() {
  test('AchievementService unlocks first task achievement', () {
    final tasks = [
      TaskEntity.create(title: 'Test')..isCompleted = true,
    ];

    final achievements = AchievementService.compute(
      tasks: tasks,
      habits: [],
      goals: [],
      journal: [],
      habitRepo: null,
    );

    final first = achievements.firstWhere((a) => a.id == 'first_task');
    expect(first.unlocked, isTrue);
  });

  test('AchievementService unlocks 7 day streak', () {
    final today = DateTime.now();
    final habit = HabitEntity.create(name: 'O\'qish', emoji: '📚');
    for (var i = 0; i < 7; i++) {
      habit.completedDates.add(
        DateTime(today.year, today.month, today.day - i),
      );
    }

    final achievements = AchievementService.compute(
      tasks: [],
      habits: [habit],
      goals: [],
      journal: [],
      habitRepo: null,
    );

    final streak = achievements.firstWhere((a) => a.id == 'streak_7');
    expect(streak.unlocked, isTrue);
  });

  test('AchievementService unlocks journal achievement', () {
    final journal = List.generate(
      3,
      (i) => JournalEntryEntity.create(
        date: DateTime(2025, 1, i + 1),
        content: 'Kun $i',
        mood: 4,
      ),
    );

    final achievements = AchievementService.compute(
      tasks: [],
      habits: [],
      goals: [],
      journal: journal,
      habitRepo: null,
    );

    final j = achievements.firstWhere((a) => a.id == 'journal_3');
    expect(j.unlocked, isTrue);
  });
}
