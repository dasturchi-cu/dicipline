import 'package:flutter_test/flutter_test.dart';

import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/inbox_item_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/intelligence/life_context_assembler.dart';

void main() {
  group('LifeContextAssembler', () {
    final assembler = LifeContextAssembler();
    final now = DateTime(2026, 6, 21, 12);

    test('builds today snapshot with overdue and inbox', () {
      final tasks = [
        TaskEntity.create(
          title: 'Overdue',
          dueDate: now.subtract(const Duration(days: 2)),
        ),
        TaskEntity.create(
          title: 'Today',
          dueDate: now,
        ),
      ];
      final habits = <HabitEntity>[
        HabitEntity.create(name: 'Read'),
      ];
      final inbox = [
        InboxItemEntity.create(title: 'Idea', captureType: 'note'),
        InboxItemEntity.create(title: 'Done', captureType: 'note', status: 'processed'),
      ];
      final goals = [
        GoalEntity.create(
          title: 'Stalled goal',
          progress: 10,
          createdAt: now.subtract(const Duration(days: 10)),
        ),
      ];

      final context = assembler.assemble(
        journal: const [],
        tasks: tasks,
        habits: habits,
        inbox: inbox,
        goals: goals,
        rpgLevel: 3,
        rpgTotalXp: 450,
        asOf: now,
      );

      expect(context.today.tasksOverdue, 1);
      expect(context.today.tasksDueToday, 1);
      expect(context.today.inboxPending, 1);
      expect(context.today.habitsTotal, 1);
      expect(context.rpg?.level, 3);
      expect(context.goalsAtRisk, isNotEmpty);
      expect(context.goalsAtRisk.first.goalTitle, 'Stalled goal');
    });

    test('detects journal written today', () {
      final journal = [
        JournalEntryEntity.create(
          date: now,
          content: 'Bugun yaxshi kun',
          mood: 4,
        ),
      ];

      final context = assembler.assemble(
        journal: journal,
        tasks: const [],
        asOf: now,
      );

      expect(context.today.journalWrittenToday, isTrue);
      expect(context.moodTrend.hasSufficientData, isFalse);
    });
  });
}
