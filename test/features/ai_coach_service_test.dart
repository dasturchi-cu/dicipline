import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/finance_transaction_entity.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/finance_repository.dart';
import 'package:rejabon_ai/features/ai_coach/domain/ai_coach_service.dart';

void main() {
  group('AiCoachService.generateFromData', () {
    test('returns default encouragement when no issues', () {
      final tips = AiCoachService.generateFromData(
        tasks: const [],
        habits: const [],
        goals: const [],
        finance: [
          FinanceTransactionEntity.create(
            type: FinanceRepository.typeIncome,
            amount: 1000,
            category: 'Maosh',
          ),
        ],
        journalToday: JournalEntryEntity.create(
          date: DateTime.now(),
          content: 'Bugun yaxshi kun',
          mood: 4,
        ),
      );

      expect(tips, hasLength(1));
      expect(tips.first.title, 'Ajoyib ish!');
      expect(tips.first.actionRoute, '/hayot/maqsadlar');
    });

    test('surfaces overdue tasks', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final tasks = [
        TaskEntity.create(
          title: 'Hisobot',
          dueDate: yesterday,
        ),
      ];

      final tips = AiCoachService.generateFromData(
        tasks: tasks,
        habits: const [],
        goals: const [],
        finance: const [],
      );

      expect(tips.any((t) => t.title.contains('Muddat')), isTrue);
      expect(
        tips.any((t) => t.description.contains('Hisobot')),
        isTrue,
      );
    });

    test('mentions incomplete habits with streak context', () {
      final habit = HabitEntity.create(
        name: 'Yugurish',
        completedDates: [
          DateTime.now().subtract(const Duration(days: 1)),
        ],
      );

      final tips = AiCoachService.generateFromData(
        tasks: const [],
        habits: [habit],
        goals: const [],
        finance: const [],
      );

      expect(tips.any((t) => t.title == 'Odat bajarilmagan'), isTrue);
      expect(
        tips.any((t) => t.description.contains('Yugurish')),
        isTrue,
      );
    });

    test('suggests journaling when today entry missing', () {
      final tips = AiCoachService.generateFromData(
        tasks: const [],
        habits: const [],
        goals: const [],
        finance: const [],
        journalToday: null,
      );

      expect(tips.any((t) => t.title == 'Kundalik yozilmagan'), isTrue);
    });

    test('generateTipStrings returns display text', () {
      final goal = GoalEntity.create(
        title: 'Ingliz tili',
        progress: 10,
      );

      final strings = AiCoachService.generateTipStrings(
        tasks: const [],
        habits: const [],
        goals: [goal],
        finance: const [],
      );

      expect(strings, isNotEmpty);
      expect(strings.first, contains('Ingliz tili'));
    });

    test('finance tips for negative balance', () {
      final tips = AiCoachService.generateFromData(
        tasks: const [],
        habits: const [],
        goals: const [],
        finance: [
          FinanceTransactionEntity.create(
            type: FinanceRepository.typeExpense,
            amount: 5000,
            category: 'Oziq-ovqat',
          ),
        ],
      );

      expect(tips.any((t) => t.title == 'Salbiy balans'), isTrue);
    });
  });
}
