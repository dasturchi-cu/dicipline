import '../../../core/database/schemas/journal_entry_entity.dart';

class MoodDayPoint {
  const MoodDayPoint({required this.date, this.mood});

  final DateTime date;
  final int? mood;
}

class MoodTrendReport {
  const MoodTrendReport({
    required this.last7Days,
    required this.average7d,
    required this.trend,
    required this.insight,
    required this.hasSufficientData,
    this.averagePrior7d,
    this.burnoutRisk = false,
  });

  final List<MoodDayPoint> last7Days;
  final double average7d;
  final double? averagePrior7d;
  final String trend;
  final String insight;
  final bool hasSufficientData;
  final bool burnoutRisk;
}

DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Kundalik kayfiyat tendensiyasini mahalliy hisoblaydi.
class MoodTrendService {
  const MoodTrendService();

  static const _windowDays = 7;

  MoodTrendReport compute(
    List<JournalEntryEntity> journal, {
    DateTime? asOf,
  }) {
    final today = _norm(asOf ?? DateTime.now());
    final last7Days = <MoodDayPoint>[];
    final moods7 = <int>[];
    final moodsPrior = <int>[];

    for (var i = _windowDays - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final entry = _entryForDay(journal, day);
      final mood = entry?.mood;
      last7Days.add(MoodDayPoint(date: day, mood: mood));
      if (mood != null) moods7.add(mood);
    }

    for (var i = _windowDays; i < _windowDays * 2; i++) {
      final day = today.subtract(Duration(days: i));
      final entry = _entryForDay(journal, day);
      if (entry != null) moodsPrior.add(entry.mood);
    }

    final avg7 =
        moods7.isEmpty ? 0.0 : moods7.reduce((a, b) => a + b) / moods7.length;
    final avgPrior = moodsPrior.isEmpty
        ? null
        : moodsPrior.reduce((a, b) => a + b) / moodsPrior.length;

    final trend = avgPrior == null
        ? 'stable'
        : avg7 > avgPrior + 0.3
            ? 'up'
            : avg7 < avgPrior - 0.3
                ? 'down'
                : 'stable';

    final burnoutRisk = moods7.length >= 3 &&
        moods7.where((m) => m <= 2).length >= (moods7.length * 0.6).ceil();

    final insight = _buildInsight(
      avg7: avg7,
      trend: trend,
      burnoutRisk: burnoutRisk,
      entriesCount: moods7.length,
    );

    return MoodTrendReport(
      last7Days: last7Days,
      average7d: avg7,
      averagePrior7d: avgPrior,
      trend: trend,
      insight: insight,
      hasSufficientData: moods7.length >= 3,
      burnoutRisk: burnoutRisk,
    );
  }

  String _buildInsight({
    required double avg7,
    required String trend,
    required bool burnoutRisk,
    required int entriesCount,
  }) {
    if (entriesCount < 3) {
      return 'Kayfiyat tendensiyasi uchun kamida 3 kun kundalik yozing.';
    }
    if (burnoutRisk) {
      return 'So\'nggi kunlarda kayfiyat past — dam olish va yengil vazifalarga e\'tibor bering.';
    }
    if (trend == 'up') {
      return 'Kayfiyatingiz yaxshilanmoqda — bu momentumni saqlang.';
    }
    if (trend == 'down') {
      return 'Kayfiyat tushmoqda — bugun o\'zingizga mehribon bo\'ling.';
    }
    if (avg7 >= 4) {
      return 'Kayfiyatingiz barqaror va yuqori — ajoyib!';
    }
    return 'Kayfiyatingiz barqaror — kuzatishda davom eting.';
  }
}

JournalEntryEntity? _entryForDay(
  List<JournalEntryEntity> journal,
  DateTime day,
) {
  for (final entry in journal) {
    if (_sameDay(entry.date, day)) return entry;
  }
  return null;
}
