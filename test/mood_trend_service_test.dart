import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/features/journal/domain/mood_trend_service.dart';

void main() {
  group('MoodTrendService', () {
    const service = MoodTrendService();
    final today = DateTime(2026, 6, 21);

    test('returns insufficient data insight with few entries', () {
      final report = service.compute(
        [
          JournalEntryEntity.create(
            date: today,
            mood: 4,
          ),
        ],
        asOf: today,
      );

      expect(report.hasSufficientData, isFalse);
      expect(report.insight, contains('3 kun'));
    });

    test('detects upward trend', () {
      final journal = <JournalEntryEntity>[];
      for (var i = 0; i < 7; i++) {
        journal.add(
          JournalEntryEntity.create(
            date: today.subtract(Duration(days: i)),
            mood: i < 3 ? 2 : 5,
          ),
        );
      }
      for (var i = 7; i < 14; i++) {
        journal.add(
          JournalEntryEntity.create(
            date: today.subtract(Duration(days: i)),
            mood: 2,
          ),
        );
      }

      final report = service.compute(journal, asOf: today);

      expect(report.hasSufficientData, isTrue);
      expect(report.trend, 'up');
    });
  });
}
