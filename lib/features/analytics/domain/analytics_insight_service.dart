import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/finance_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../journal/domain/mood_trend_service.dart';

/// Analitika turi.
enum InsightCategory {
  productivity,
  learning,
  fitness,
  finance,
  habits,
  mood,
}

/// Ma'noli analitika xulosasi.
class AnalyticsInsight {
  const AnalyticsInsight({
    required this.category,
    required this.emoji,
    required this.title,
    required this.description,
    this.metric,
    this.trend, // up | down | stable
    this.dataPoints = const [],
    this.actionRoute,
    this.actionLabel,
  });

  final InsightCategory category;
  final String emoji;
  final String title;
  final String description;
  final String? metric;
  final String? trend;
  final List<double> dataPoints;
  final String? actionRoute;
  final String? actionLabel;
}

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Haqiqiy analitika — grafik emas, tushunarli xulosalar.
class AnalyticsInsightService {
  AnalyticsInsightService({
    HabitRepository? habitRepository,
    MoodTrendService? moodTrendService,
  })  : _habitRepo = habitRepository,
        _moodTrend = moodTrendService ?? const MoodTrendService();

  final HabitRepository? _habitRepo;
  final MoodTrendService _moodTrend;

  List<AnalyticsInsight> generate({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    List<JournalEntryEntity> journal = const [],
  }) {
    return [
      ..._moodInsights(journal),
      ..._productivityInsights(tasks),
      ..._habitInsights(habits),
      ..._learningInsights(studySessions),
      ..._fitnessInsights(workouts),
      ..._financeInsights(finance),
      ..._goalInsights(goals),
    ];
  }

  List<AnalyticsInsight> _moodInsights(List<JournalEntryEntity> journal) {
    final report = _moodTrend.compute(journal);
    if (!report.hasSufficientData) {
      return [
        const AnalyticsInsight(
          category: InsightCategory.mood,
          emoji: '📝',
          title: 'Kayfiyat ma\'lumoti yetarli emas',
          description:
              'Kamida 3 kun kundalik yozing va kayfiyat belgilang — trend ko\'rinadi.',
          actionRoute: '/hayot/kundalik',
          actionLabel: 'Kundalik yozish',
        ),
      ];
    }

    final trendEmoji = switch (report.trend) {
      'up' => '📈',
      'down' => '📉',
      _ => '😐',
    };

    return [
      AnalyticsInsight(
        category: InsightCategory.mood,
        emoji: trendEmoji,
        title: '7 kunlik kayfiyat',
        description: report.insight,
        metric: '${report.average7d.toStringAsFixed(1)}/5',
        trend: report.trend,
        dataPoints: report.last7Days
            .map((d) => d.mood?.toDouble() ?? 0)
            .toList(),
        actionRoute: '/hayot/kundalik',
        actionLabel: 'Kundalik',
      ),
      if (report.burnoutRisk)
        AnalyticsInsight(
          category: InsightCategory.mood,
          emoji: '⚠️',
          title: 'Burnout xavfi',
          description:
              'So\'nggi kunlarda kayfiyat past. Dam olish va yengil vazifalar rejalashtiring.',
          metric: '${report.average7d.toStringAsFixed(1)}/5',
          trend: 'down',
          actionRoute: '/hayot/kundalik',
          actionLabel: 'Kundalik yozish',
        ),
    ];
  }

  List<AnalyticsInsight> _productivityInsights(List<TaskEntity> tasks) {
    final insights = <AnalyticsInsight>[];
    final completed = tasks.where((t) => t.isCompleted).toList();
    if (completed.isEmpty) return insights;

    final hourCounts = List.filled(24, 0);
    for (final task in completed) {
      final hour = task.updatedAt.hour;
      hourCounts[hour]++;
    }

    final peakHour = hourCounts.indexOf(hourCounts.reduce((a, b) => a > b ? a : b));
    if (hourCounts[peakHour] > 0) {
      final endHour = (peakHour + 3).clamp(0, 23);
      insights.add(
        AnalyticsInsight(
          category: InsightCategory.productivity,
          emoji: '📈',
          title: 'Eng samarali vaqt',
          description:
              'Sizning eng samarali vaqtingiz ${peakHour.toString().padLeft(2, '0')}:00–${endHour.toString().padLeft(2, '0')}:00. Muhim vazifalarni shu vaqtga rejalashtiring.',
          metric: '${hourCounts[peakHour]} vazifa',
          trend: 'up',
          dataPoints: hourCounts.map((c) => c.toDouble()).toList(),
          actionRoute: '/boshqa/fokus',
          actionLabel: 'Fokus rejimi',
        ),
      );
    }

    final now = DateTime.now();
    final last14 = List.generate(14, (i) {
      final day = _normalize(now.subtract(Duration(days: 13 - i)));
      return completed
          .where((t) => _sameDay(t.updatedAt, day))
          .length
          .toDouble();
    });

    final firstWeek = last14.take(7).fold<double>(0, (a, b) => a + b);
    final secondWeek = last14.skip(7).fold<double>(0, (a, b) => a + b);
    if (firstWeek > 0 || secondWeek > 0) {
      final trend = secondWeek > firstWeek * 1.1
          ? 'up'
          : secondWeek < firstWeek * 0.9
              ? 'down'
              : 'stable';
      final trendText = switch (trend) {
        'up' => 'oxirgi haftada vazifa bajarish ko\'paydi',
        'down' => 'oxirgi haftada vazifa bajarish kamaydi',
        _ => 'vazifa bajarish barqaror',
      };
      insights.add(
        AnalyticsInsight(
          category: InsightCategory.productivity,
          emoji: '⚡',
          title: 'Vazifa trendi',
          description: 'Siz $trendText.',
          metric: '${secondWeek.round()}/7 kun',
          trend: trend,
          dataPoints: last14,
          actionRoute: '/vazifalar',
          actionLabel: 'Vazifalar',
        ),
      );
    }

    final morningTasks = completed.where((t) => t.updatedAt.hour < 12).length;
    final afternoonTasks =
        completed.where((t) => t.updatedAt.hour >= 12 && t.updatedAt.hour < 18).length;
    if (morningTasks > afternoonTasks * 1.3 && morningTasks >= 3) {
      insights.add(
        AnalyticsInsight(
          category: InsightCategory.productivity,
          emoji: '🌅',
          title: 'Ertalabki samaradorlik',
          description:
              'Siz oxirgi vaqtlarda ertalabki vazifalarni yaxshiroq bajaryapsiz. Ertalab rejalashtiring.',
          metric: '$morningTasks ertalab',
          trend: 'up',
          actionRoute: '/reja',
          actionLabel: 'Kun rejasi',
        ),
      );
    }

    return insights;
  }

  List<AnalyticsInsight> _habitInsights(List<HabitEntity> habits) {
    if (habits.isEmpty) return [];

    final now = DateTime.now();
    final last30 = List.generate(30, (i) {
      final day = _normalize(now.subtract(Duration(days: 29 - i)));
      var count = 0;
      for (final habit in habits) {
        if (habit.completedDates.any((d) => _sameDay(d, day))) count++;
      }
      return habits.isEmpty ? 0.0 : count / habits.length;
    });

    final avgRate = last30.isEmpty
        ? 0.0
        : last30.fold<double>(0, (a, b) => a + b) / last30.length;
    final recentRate = last30.length >= 7
        ? last30.skip(last30.length - 7).fold<double>(0, (a, b) => a + b) / 7
        : avgRate;

    final trend = recentRate > avgRate * 1.05
        ? 'up'
        : recentRate < avgRate * 0.95
            ? 'down'
            : 'stable';

    var maxStreak = 0;
    for (final habit in habits) {
      final streak =
          _habitRepo?.calculateStreak(habit) ?? _streakFromDates(habit);
      if (streak > maxStreak) maxStreak = streak;
    }

    return [
      AnalyticsInsight(
        category: InsightCategory.habits,
        emoji: '🔥',
        title: 'Odat bajarilish trendi',
        description: switch (trend) {
          'up' =>
            'Odatlaringizni bajarish oxirgi haftada yaxshilandi. Davom eting!',
          'down' =>
            'Odat bajarish kamaymoqda. Kichik qadam bilan qayta boshlang.',
          _ => 'Odat bajarishingiz barqaror. Shu tempda davom eting.',
        },
        metric: '${(recentRate * 100).round()}%',
        trend: trend,
        dataPoints: last30,
        actionRoute: '/qahramon/odatlar',
        actionLabel: 'Odatlar',
      ),
      if (maxStreak > 0)
        AnalyticsInsight(
          category: InsightCategory.habits,
          emoji: '🏆',
          title: 'Eng uzun ketma-ketlik',
          description:
              'Eng uzun odat ketma-ketligingiz $maxStreak kun. Ajoyib intizom!',
          metric: '$maxStreak kun',
          trend: 'up',
          actionRoute: '/qahramon/odatlar',
          actionLabel: 'Odatlar',
        ),
    ];
  }

  List<AnalyticsInsight> _learningInsights(List<StudySessionEntity> sessions) {
    if (sessions.isEmpty) return [];

    final now = DateTime.now();
    final last14 = List.generate(14, (i) {
      final day = _normalize(now.subtract(Duration(days: 13 - i)));
      return sessions
          .where((s) => _sameDay(s.date, day))
          .fold<int>(0, (sum, s) => sum + s.durationMinutes)
          .toDouble();
    });

    final totalMinutes = sessions.fold<int>(0, (s, e) => s + e.durationMinutes);
    final recentMinutes =
        last14.skip(7).fold<double>(0, (a, b) => a + b);
    final prevMinutes = last14.take(7).fold<double>(0, (a, b) => a + b);

    final trend = recentMinutes > prevMinutes * 1.1
        ? 'up'
        : recentMinutes < prevMinutes * 0.9
            ? 'down'
            : 'stable';

    return [
      AnalyticsInsight(
        category: InsightCategory.learning,
        emoji: '📚',
        title: 'O\'qish trendi',
        description: switch (trend) {
          'up' => 'Ta\'lim vaqtingiz oshmoqda. Ajoyib rivojlanish!',
          'down' => 'O\'qish vaqti kamaymoqda. Kuniga 20 daqiqa ajrating.',
          _ => 'O\'qish vaqtingiz barqaror.',
        },
        metric: '${(totalMinutes / 60).toStringAsFixed(1)} soat',
        trend: trend,
        dataPoints: last14,
        actionRoute: '/hayot/ta\'lim',
        actionLabel: 'Ta\'lim',
      ),
    ];
  }

  List<AnalyticsInsight> _fitnessInsights(List<WorkoutEntity> workouts) {
    if (workouts.isEmpty) return [];

    final now = DateTime.now();
    final last14 = List.generate(14, (i) {
      final day = _normalize(now.subtract(Duration(days: 13 - i)));
      return workouts.where((w) => _sameDay(w.date, day)).length.toDouble();
    });

    final workoutDays = last14.where((d) => d > 0).length;
    final consistency = (workoutDays / 14 * 100).round();

    return [
      AnalyticsInsight(
        category: InsightCategory.fitness,
        emoji: '💪',
        title: 'Mashq barqarorligi',
        description: consistency >= 50
            ? 'Mashq qilishda yaxshi barqarorlik ko\'rsatyapsiz. Shu tempda davom eting!'
            : 'Mashq qilishni ko\'proq muntazam qiling. Haftada 3 kun maqsad qiling.',
        metric: '$consistency%',
        trend: consistency >= 50 ? 'up' : 'down',
        dataPoints: last14,
        actionRoute: '/hayot/mashq',
        actionLabel: 'Mashq',
      ),
    ];
  }

  List<AnalyticsInsight> _financeInsights(
    List<FinanceTransactionEntity> finance,
  ) {
    if (finance.isEmpty) return [];

    final now = DateTime.now();
    final thisMonth = finance.where((t) {
      return t.date.year == now.year && t.date.month == now.month;
    }).toList();
    final lastMonth = finance.where((t) {
      final prev = DateTime(now.year, now.month - 1);
      return t.date.year == prev.year && t.date.month == prev.month;
    }).toList();

    final thisExpense = FinanceRepository.totalExpense(thisMonth);
    final lastExpense = FinanceRepository.totalExpense(lastMonth);

    if (thisExpense == 0 && lastExpense == 0) return [];

    final trend = thisExpense > lastExpense * 1.1
        ? 'up'
        : thisExpense < lastExpense * 0.9
            ? 'down'
            : 'stable';

    final expenseByCat = <String, double>{};
    for (final tx in thisMonth.where((t) => t.type == 1)) {
      expenseByCat[tx.category] = (expenseByCat[tx.category] ?? 0) + tx.amount;
    }

    final insights = <AnalyticsInsight>[
      AnalyticsInsight(
        category: InsightCategory.finance,
        emoji: '💰',
        title: 'Xarajat trendi',
        description: switch (trend) {
          'up' =>
            'Bu oy xarajatlaringiz o\'tgan oyga nisbatan oshdi. Byudjetni ko\'rib chiqing.',
          'down' =>
            'Xarajatlaringiz kamaymoqda. Moliyaviy intizomingiz yaxshilanmoqda!',
          _ => 'Xarajatlaringiz barqaror.',
        },
        metric: formatMoneyCompact(thisExpense),
        trend: trend == 'up' ? 'down' : trend == 'down' ? 'up' : 'stable',
        actionRoute: '/hayot/moliya',
        actionLabel: 'Moliya',
      ),
    ];

    if (expenseByCat.isNotEmpty) {
      final top = expenseByCat.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights.add(
        AnalyticsInsight(
          category: InsightCategory.finance,
          emoji: '📊',
          title: 'Eng ko\'p xarajat',
          description:
              '"${top.key}" kategoriyasida eng ko\'p sarflaysiz. Cheklov qo\'yishni o\'ylab ko\'ring.',
          metric: formatMoneyCompact(top.value),
          actionRoute: '/hayot/moliya',
          actionLabel: 'Moliya',
        ),
      );
    }

    return insights;
  }

  List<AnalyticsInsight> _goalInsights(List<GoalEntity> goals) {
    if (goals.isEmpty) return [];

    final active = goals.where((g) => g.progress < 100).toList();
    if (active.isEmpty) {
      return [
        const AnalyticsInsight(
          category: InsightCategory.productivity,
          emoji: '🎯',
          title: 'Barcha maqsadlar bajarildi',
          description: 'Tabriklaymiz! Yangi maqsadlar qo\'ying.',
          trend: 'up',
          actionRoute: '/hayot/maqsadlar',
          actionLabel: 'Maqsadlar',
        ),
      ];
    }

    active.sort((a, b) => b.progress.compareTo(a.progress));
    final top = active.first;
    return [
      AnalyticsInsight(
        category: InsightCategory.productivity,
        emoji: '🎯',
        title: 'Eng yaqin maqsad',
        description:
            '"${top.title}" ${top.progress.round()}% bajarilgan. Shu yo\'nalishda davom eting!',
        metric: '${top.progress.round()}%',
        trend: top.progress >= 50 ? 'up' : 'stable',
        actionRoute: '/hayot/maqsadlar',
        actionLabel: 'Maqsadlar',
      ),
    ];
  }

  static int _streakFromDates(HabitEntity habit) {
    final dates = habit.completedDates.map(_normalize).toSet();
    if (dates.isEmpty) return 0;
    var current = _normalize(DateTime.now());
    if (!dates.contains(current)) {
      current = current.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (dates.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

String formatMoneyCompact(double amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(1)}M';
  }
  if (amount >= 1000) {
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
  return amount.toStringAsFixed(0);
}
