import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';

/// Kayfiyat ↔ samaradorlik korrelatsiyasi.
class MoodProductivityCorrelation {
  const MoodProductivityCorrelation({
    required this.avgMoodOnProductiveDays,
    required this.avgMoodOnLowDays,
    required this.insight,
  });

  final double avgMoodOnProductiveDays;
  final double avgMoodOnLowDays;
  final String insight;
}

/// Kun bo'yicha samaradorlik profili.
class DayPerformanceProfile {
  const DayPerformanceProfile({
    required this.bestDay,
    required this.worstDay,
    required this.bestDayRate,
    required this.worstDayRate,
  });

  final String bestDay;
  final String worstDay;
  final double bestDayRate;
  final double worstDayRate;
}

/// Burnout signali.
class BurnoutSignal {
  const BurnoutSignal({
    required this.level,
    required this.message,
  });

  final String level;
  final String message;
}

/// Life Twin naqshlarini mahalliy hisoblaydi (AI shart emas).
class CoachPatternEngine {
  const CoachPatternEngine();

  static const _dayNames = [
    '',
    'Dushanba',
    'Seshanba',
    'Chorshanba',
    'Payshanba',
    'Juma',
    'Shanba',
    'Yakshanba',
  ];

  MoodProductivityCorrelation analyzeMoodProductivity({
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
  }) {
    if (journal.isEmpty || tasks.isEmpty) {
      return const MoodProductivityCorrelation(
        avgMoodOnProductiveDays: 0,
        avgMoodOnLowDays: 0,
        insight: 'Ko\'proq kundalik va vazifa ma\'lumoti kerak.',
      );
    }

    final completedByDay = <DateTime, int>{};
    for (final task in tasks.where((t) => t.isCompleted)) {
      final day = DateTime(
        task.updatedAt.year,
        task.updatedAt.month,
        task.updatedAt.day,
      );
      completedByDay[day] = (completedByDay[day] ?? 0) + 1;
    }

    final productiveMoods = <int>[];
    final lowMoods = <int>[];

    for (final entry in journal) {
      final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
      final completed = completedByDay[day] ?? 0;
      if (completed >= 3) {
        productiveMoods.add(entry.mood);
      } else if (completed <= 1) {
        lowMoods.add(entry.mood);
      }
    }

    final avgProd = productiveMoods.isEmpty
        ? 0.0
        : productiveMoods.reduce((a, b) => a + b) / productiveMoods.length;
    final avgLow = lowMoods.isEmpty
        ? 0.0
        : lowMoods.reduce((a, b) => a + b) / lowMoods.length;

    String insight;
    if (productiveMoods.isEmpty) {
      insight =
          'Kayfiyat va vazifa bog\'liqligini aniqlash uchun ma\'lumot yetarli emas.';
    } else if (avgLow > 0 && avgProd - avgLow >= 1) {
      insight =
          'Yuqori kayfiyat kunlarida vazifa bajarish ${((avgProd - avgLow) / avgLow * 100).clamp(10, 50).round()}% ko\'proq.';
    } else {
      insight = 'Kayfiyatingiz barqaror — bu yaxshi belgi.';
    }

    return MoodProductivityCorrelation(
      avgMoodOnProductiveDays: avgProd,
      avgMoodOnLowDays: avgLow,
      insight: insight,
    );
  }

  DayPerformanceProfile analyzeDayOfWeek(List<TaskEntity> tasks) {
    final completed = tasks.where((t) => t.isCompleted).toList();
    if (completed.isEmpty) {
      return const DayPerformanceProfile(
        bestDay: '—',
        worstDay: '—',
        bestDayRate: 0,
        worstDayRate: 0,
      );
    }

    final counts = List.filled(8, 0);
    for (final task in completed) {
      counts[task.updatedAt.weekday]++;
    }

    var bestW = 1;
    var worstW = 1;
    for (var w = 1; w <= 7; w++) {
      if (counts[w] > counts[bestW]) bestW = w;
      if (counts[w] < counts[worstW]) worstW = w;
    }

    final total = completed.length;
    return DayPerformanceProfile(
      bestDay: _dayNames[bestW],
      worstDay: _dayNames[worstW],
      bestDayRate: counts[bestW] / total,
      worstDayRate: counts[worstW] / total,
    );
  }

  BurnoutSignal? detectBurnout({
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
  }) {
    if (journal.length < 5) return null;

    final recent = journal.toList()..sort((a, b) => b.date.compareTo(a.date));
    final last7 = recent.take(7).toList();
    if (last7.length < 5) return null;

    final avgMood =
        last7.map((e) => e.mood).reduce((a, b) => a + b) / last7.length;

    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentTasks = tasks.where((t) => t.updatedAt.isAfter(weekAgo));
    final completionRate = recentTasks.isEmpty
        ? 1.0
        : recentTasks.where((t) => t.isCompleted).length / recentTasks.length;

    if (avgMood < 2.5 && completionRate < 0.4) {
      return const BurnoutSignal(
        level: 'high',
        message:
            'Kayfiyat va samaradorlik tushmoqda. Dam olish va yengil maqsadlar tavsiya etiladi.',
      );
    }
    if (avgMood < 3 && completionRate < 0.55) {
      return const BurnoutSignal(
        level: 'moderate',
        message:
            'Yengil charchash belgilari bor. Bugun o\'zingizga mehribon bo\'ling.',
      );
    }
    return null;
  }

  List<String> buildPatternInsights({
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
  }) {
    final insights = <String>[];
    final moodCorr = analyzeMoodProductivity(journal: journal, tasks: tasks);
    if (moodCorr.insight.isNotEmpty) insights.add(moodCorr.insight);

    final dayProfile = analyzeDayOfWeek(tasks);
    if (dayProfile.bestDayRate > 0) {
      insights.add(
        'Eng samarali kuningiz: ${dayProfile.bestDay} '
        '(${(dayProfile.bestDayRate * 100).round()}% vazifalar).',
      );
    }

    final burnout = detectBurnout(journal: journal, tasks: tasks);
    if (burnout != null) insights.add(burnout.message);

    return insights;
  }
}
