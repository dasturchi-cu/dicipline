import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/achievement_unlock_repository.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';

import '../helpers/isar_test_helper.dart';

void main() {
  late TestIsarHandle handle;
  late AchievementService service;

  setUpAll(() async {
    await ensureIsarCoreInitialized();
  });

  setUp(() async {
    handle = await openTestIsar();
    service = AchievementService(
      unlockRepo: AchievementUnlockRepository(handle.isar),
    );
  });

  tearDown(() async {
    await closeTestIsar(handle);
  });

  test('AchievementService unlocks first task achievement', () async {
    final tasks = [
      TaskEntity.create(title: 'Test')..isCompleted = true,
    ];

    final achievements = await service.computeAndSync(
      tasks: tasks,
      habits: [],
      goals: [],
      journal: [],
    );

    final first = achievements.firstWhere((a) => a.id == 'first_task');
    expect(first.unlocked, isTrue);
  });

  test('AchievementService unlocks 7 day streak', () async {
    final today = DateTime.now();
    final habit = HabitEntity.create(name: 'O\'qish', emoji: '📚');
    for (var i = 0; i < 7; i++) {
      habit.completedDates.add(
        DateTime(today.year, today.month, today.day - i),
      );
    }

    final achievements = await service.computeAndSync(
      tasks: [],
      habits: [habit],
      goals: [],
      journal: [],
    );

    final streak = achievements.firstWhere((a) => a.id == 'streak_7');
    expect(streak.unlocked, isTrue);
  });

  test('AchievementService unlocks journal achievement', () async {
    final journal = List.generate(
      3,
      (i) => JournalEntryEntity.create(
        date: DateTime(2025, 1, i + 1),
        content: 'Kun $i',
        mood: 4,
      ),
    );

    final achievements = await service.computeAndSync(
      tasks: [],
      habits: [],
      goals: [],
      journal: journal,
    );

    final j = achievements.firstWhere((a) => a.id == 'journal_3');
    expect(j.unlocked, isTrue);
  });
}
