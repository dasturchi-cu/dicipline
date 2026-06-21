import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/time_log_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';

enum TimePeriod { day, week, month, year }

class TimeCategoryTotal {
  const TimeCategoryTotal({
    required this.sessionType,
    required this.label,
    required this.emoji,
    required this.hours,
    required this.seconds,
  });

  final String sessionType;
  final String label;
  final String emoji;
  final double hours;
  final int seconds;
}

class TimeAnalyticsReport {
  const TimeAnalyticsReport({
    required this.period,
    required this.periodStart,
    required this.periodEnd,
    required this.categories,
    required this.totalHours,
    required this.hasData,
  });

  final TimePeriod period;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<TimeCategoryTotal> categories;
  final double totalHours;
  final bool hasData;
}

DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

class TimeAnalyticsService {
  const TimeAnalyticsService();

  static const _labels = {
    'study': ('Ta\'lim', '📚'),
    'programming': ('Dasturlash', '💻'),
    'workout': ('Mashq', '💪'),
    'focus': ('Fokus', '🎯'),
    'reading': ('O\'qish', '📖'),
  };

  TimeAnalyticsReport compute({
    required List<TimeLogEntity> timeLogs,
    required List<StudySessionEntity> studySessions,
    required List<WorkoutEntity> workouts,
    TimePeriod period = TimePeriod.week,
    DateTime? asOf,
  }) {
    final today = _norm(asOf ?? DateTime.now());
    final (start, end) = _periodRange(today, period);

    final totals = <String, int>{
      'study': 0,
      'programming': 0,
      'workout': 0,
      'focus': 0,
      'reading': 0,
    };

    for (final log in timeLogs) {
      if (log.startedAt.isBefore(start) || log.startedAt.isAfter(end)) {
        continue;
      }
      totals[log.sessionType] =
          (totals[log.sessionType] ?? 0) + log.durationSeconds;
    }

    for (final s in studySessions) {
      final d = _norm(s.date);
      if (d.isBefore(start) || d.isAfter(end)) continue;
      totals['study'] = (totals['study'] ?? 0) + s.durationMinutes * 60;
    }

    for (final w in workouts) {
      final d = _norm(w.date);
      if (d.isBefore(start) || d.isAfter(end)) continue;
      totals['workout'] = (totals['workout'] ?? 0) + w.durationMinutes * 60;
    }

    final categories = totals.entries
        .where((e) => e.value > 0)
        .map((e) {
          final meta = _labels[e.key]!;
          return TimeCategoryTotal(
            sessionType: e.key,
            label: meta.$1,
            emoji: meta.$2,
            seconds: e.value,
            hours: e.value / 3600,
          );
        })
        .toList()
      ..sort((a, b) => b.seconds.compareTo(a.seconds));

    final totalSeconds = categories.fold<int>(0, (s, c) => s + c.seconds);

    return TimeAnalyticsReport(
      period: period,
      periodStart: start,
      periodEnd: end,
      categories: categories,
      totalHours: totalSeconds / 3600,
      hasData: totalSeconds > 0,
    );
  }

  static (DateTime, DateTime) _periodRange(DateTime today, TimePeriod period) {
    return switch (period) {
      TimePeriod.day => (today, today),
      TimePeriod.week => (
          today.subtract(Duration(days: today.weekday - 1)),
          today,
        ),
      TimePeriod.month => (DateTime(today.year, today.month, 1), today),
      TimePeriod.year => (DateTime(today.year, 1, 1), today),
    };
  }
}
