import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/habit_repository.dart';

/// Maqsad tugash sanasi bashorati.
class GoalCompletionPrediction {
  const GoalCompletionPrediction({
    required this.goalTitle,
    required this.currentProgress,
    required this.predictedDate,
    required this.weeksRemaining,
    required this.confidence,
    required this.insight,
  });

  final String goalTitle;
  final double currentProgress;
  final DateTime predictedDate;
  final int weeksRemaining;
  final double confidence;
  final String insight;
}

/// Streak uzilish xavfi.
class StreakRiskPrediction {
  const StreakRiskPrediction({
    required this.habitName,
    required this.currentStreak,
    required this.riskLevel,
    required this.riskScore,
    required this.insight,
  });

  final String habitName;
  final int currentStreak;
  final String riskLevel;
  final double riskScore;
  final String insight;
}

/// Trend bashorati (productivity yoki mood).
class TrendPrediction {
  const TrendPrediction({
    required this.metric,
    required this.direction,
    required this.currentValue,
    required this.projectedValue,
    required this.insight,
  });

  final String metric;
  final String direction;
  final double currentValue;
  final double projectedValue;
  final String insight;
}

/// Kelajak bashoratlari to'plami.
class FuturePredictions {
  const FuturePredictions({
    required this.goalPredictions,
    required this.streakRisks,
    required this.trends,
  });

  final List<GoalCompletionPrediction> goalPredictions;
  final List<StreakRiskPrediction> streakRisks;
  final List<TrendPrediction> trends;
}

/// Kelajak simulyatori — maqsad, streak va trend bashoratlari.
class FuturePredictionEngine {
  FuturePredictionEngine({HabitRepository? habitRepo})
      : _habitRepo = habitRepo;

  final HabitRepository? _habitRepo;

  FuturePredictions predict({
    required List<GoalEntity> goals,
    required List<HabitEntity> habits,
    required List<TaskEntity> tasks,
    required List<JournalEntryEntity> journal,
  }) {
    return FuturePredictions(
      goalPredictions: _predictGoalCompletions(goals, tasks),
      streakRisks: _predictStreakRisks(habits),
      trends: [
        _predictProductivityTrend(tasks),
        _predictMoodTrend(journal),
      ],
    );
  }

  List<GoalCompletionPrediction> _predictGoalCompletions(
    List<GoalEntity> goals,
    List<TaskEntity> tasks,
  ) {
    final weeklyProgressRate = _weeklyProgressRate(tasks);

    return goals
        .where((g) => g.progress < 100)
        .map((goal) {
          final remaining = 100 - goal.progress;
          final rate = weeklyProgressRate.clamp(0.5, 15.0);
          final weeks = (remaining / rate).ceil().clamp(1, 104);
          final predicted = DateTime.now().add(Duration(days: weeks * 7));

          if (goal.targetDate != null && predicted.isAfter(goal.targetDate!)) {
            return GoalCompletionPrediction(
              goalTitle: goal.title,
              currentProgress: goal.progress,
              predictedDate: predicted,
              weeksRemaining: weeks,
              confidence: 0.7,
              insight:
                  '${goal.title}: joriy sur\'atda maqsad muddatidan kech tugashi mumkin.',
            );
          }

          return GoalCompletionPrediction(
            goalTitle: goal.title,
            currentProgress: goal.progress,
            predictedDate: predicted,
            weeksRemaining: weeks,
            confidence: rate >= 2 ? 0.85 : 0.65,
            insight:
                '${goal.title}: taxminan $weeks haftada tugashi mumkin '
                '(${goal.progress.round()}% → 100%).',
          );
        })
        .toList();
  }

  double _weeklyProgressRate(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentCompleted =
        tasks.where((t) => t.isCompleted && t.updatedAt.isAfter(weekAgo)).length;
    return recentCompleted * 2.5;
  }

  List<StreakRiskPrediction> _predictStreakRisks(List<HabitEntity> habits) {
    final today = DateTime.now();
    return habits.map((habit) {
      final streak = _habitRepo?.calculateStreak(habit) ?? _localStreak(habit);
      final doneToday = habit.completedDates.any((d) {
        final day = DateTime(d.year, d.month, d.day);
        final t = DateTime(today.year, today.month, today.day);
        return day == t;
      });

      var riskScore = 0.0;
      if (!doneToday && streak > 0) riskScore += 0.5;
      if (streak >= 7 && !doneToday) riskScore += 0.3;
      if (habit.completedDates.length >= 3) {
        final recent = habit.completedDates.toList()
          ..sort((a, b) => b.compareTo(a));
        final gaps = <int>[];
        for (var i = 0; i < recent.length - 1 && i < 5; i++) {
          gaps.add(recent[i].difference(recent[i + 1]).inDays);
        }
        if (gaps.isNotEmpty) {
          final avgGap = gaps.reduce((a, b) => a + b) / gaps.length;
          if (avgGap > 2) riskScore += 0.2;
        }
      }

      final level = riskScore >= 0.7
          ? 'high'
          : riskScore >= 0.4
              ? 'medium'
              : 'low';

      return StreakRiskPrediction(
        habitName: habit.name,
        currentStreak: streak,
        riskLevel: level,
        riskScore: riskScore.clamp(0, 1),
        insight: switch (level) {
          'high' =>
            '${habit.name}: streak ($streak kun) bugun uzilishi xavfi yuqori!',
          'medium' =>
            '${habit.name}: bugun bajarsangiz streak saqlanadi ($streak kun).',
          _ => '${habit.name}: streak barqaror ($streak kun).',
        },
      );
    }).toList()
      ..sort((a, b) => b.riskScore.compareTo(a.riskScore));
  }

  int _localStreak(HabitEntity habit) {
    if (habit.completedDates.isEmpty) return 0;
    final dates = habit.completedDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
    var current = DateTime.now();
    current = DateTime(current.year, current.month, current.day);
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

  TrendPrediction _predictProductivityTrend(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final thisWeek = tasks.where((t) {
      return t.isCompleted &&
          t.updatedAt.isAfter(now.subtract(const Duration(days: 7)));
    }).length;
    final lastWeek = tasks.where((t) {
      return t.isCompleted &&
          t.updatedAt.isAfter(now.subtract(const Duration(days: 14))) &&
          t.updatedAt.isBefore(now.subtract(const Duration(days: 7)));
    }).length;

    final direction = thisWeek > lastWeek
        ? 'up'
        : thisWeek < lastWeek
            ? 'down'
            : 'stable';
    final projected = direction == 'up'
        ? thisWeek * 1.1
        : direction == 'down'
            ? thisWeek * 0.85
            : thisWeek.toDouble();

    return TrendPrediction(
      metric: 'productivity',
      direction: direction,
      currentValue: thisWeek.toDouble(),
      projectedValue: projected,
      insight: switch (direction) {
        'up' =>
          'Samaradorlik oshmoqda: bu hafta $thisWeek vazifa (o\'tgan hafta $lastWeek).',
        'down' =>
          'Samaradorlik tushmoqda: bu hafta $thisWeek vazifa (o\'tgan hafta $lastWeek).',
        _ => 'Samaradorlik barqaror: haftalik $thisWeek vazifa.',
      },
    );
  }

  TrendPrediction _predictMoodTrend(List<JournalEntryEntity> journal) {
    if (journal.length < 3) {
      return const TrendPrediction(
        metric: 'mood',
        direction: 'stable',
        currentValue: 3,
        projectedValue: 3,
        insight: 'Kayfiyat tahlili uchun ko\'proq kundalik yozuv kerak.',
      );
    }

    final sorted = journal.toList()..sort((a, b) => a.date.compareTo(b.date));
    final recent = sorted.length >= 7
        ? sorted.sublist(sorted.length - 7)
        : sorted;
    final current =
        recent.map((e) => e.mood).reduce((a, b) => a + b) / recent.length;

    final direction = current >= 3.5
        ? 'up'
        : current <= 2.5
            ? 'down'
            : 'stable';
    final projected = (direction == 'up'
        ? current + 0.2
        : direction == 'down'
            ? current - 0.2
            : current)
        .toDouble()
        .clamp(1.0, 5.0);

    return TrendPrediction(
      metric: 'mood',
      direction: direction,
      currentValue: current,
      projectedValue: projected,
      insight: switch (direction) {
        'up' => 'Kayfiyat yaxshi (${current.toStringAsFixed(1)}/5) — davom eting.',
        'down' =>
          'Kayfiyat past (${current.toStringAsFixed(1)}/5) — dam olish va yengil maqsadlar.',
        _ =>
          'Kayfiyat barqaror (${current.toStringAsFixed(1)}/5).',
      },
    );
  }
}
