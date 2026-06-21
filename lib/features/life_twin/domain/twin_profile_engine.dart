import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/database/schemas/twin_profile_entity.dart';
import 'package:rejabon_ai/core/repositories/habit_repository.dart';

/// Hisoblangan shaxsiyat profili.
class ComputedTwinProfile {
  const ComputedTwinProfile({
    required this.chronotype,
    required this.productivityStyle,
    required this.goalOrientation,
    required this.habitConsistency,
    required this.moodTrend,
    required this.learnedHabits,
    required this.learnedGoals,
    required this.topCategories,
    required this.avgMood,
    required this.taskCompletionRate,
    required this.activeGoalCount,
  });

  final String chronotype;
  final String productivityStyle;
  final String goalOrientation;
  final String habitConsistency;
  final String moodTrend;
  final List<String> learnedHabits;
  final List<String> learnedGoals;
  final List<String> topCategories;
  final double avgMood;
  final double taskCompletionRate;
  final int activeGoalCount;

  TwinProfileEntity toEntity({required int lifeScore}) {
    return TwinProfileEntity.create(
      chronotype: chronotype,
      productivityStyle: productivityStyle,
      goalOrientation: goalOrientation,
      habitConsistency: habitConsistency,
      moodTrend: moodTrend,
      lifeScoreSnapshot: lifeScore,
      traits: {
        'learnedHabits': learnedHabits,
        'learnedGoals': learnedGoals,
        'topCategories': topCategories,
        'avgMood': avgMood,
        'taskCompletionRate': taskCompletionRate,
        'activeGoalCount': activeGoalCount,
      },
    );
  }
}

/// Foydalanuvchi shaxsiyati, odatlar, maqsadlar va naqshlarni o'rganadi.
class TwinProfileEngine {
  const TwinProfileEngine({HabitRepository? habitRepo})
      : _habitRepo = habitRepo;

  final HabitRepository? _habitRepo;

  ComputedTwinProfile compute({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
  }) {
    final chronotype = _detectChronotype(tasks);
    final productivityStyle = _detectProductivityStyle(tasks);
    final goalOrientation = _detectGoalOrientation(goals);
    final habitConsistency = _detectHabitConsistency(habits);
    final moodTrend = _detectMoodTrend(journal);
    final learnedHabits = _learnTopHabits(habits);
    final learnedGoals = _learnActiveGoals(goals);
    final topCategories = _learnTopCategories(tasks);
    final avgMood = _avgMood(journal);
    final taskRate = _taskCompletionRate(tasks);

    return ComputedTwinProfile(
      chronotype: chronotype,
      productivityStyle: productivityStyle,
      goalOrientation: goalOrientation,
      habitConsistency: habitConsistency,
      moodTrend: moodTrend,
      learnedHabits: learnedHabits,
      learnedGoals: learnedGoals,
      topCategories: topCategories,
      avgMood: avgMood,
      taskCompletionRate: taskRate,
      activeGoalCount: goals.where((g) => g.progress < 100).length,
    );
  }

  String _detectChronotype(List<TaskEntity> tasks) {
    if (tasks.isEmpty) return 'balanced';

    final completed = tasks.where((t) => t.isCompleted).toList();
    if (completed.length < 5) return 'balanced';

    var morning = 0;
    var evening = 0;
    for (final task in completed) {
      final hour = task.updatedAt.hour;
      if (hour < 12) {
        morning++;
      } else if (hour >= 18) {
        evening++;
      }
    }

    if (morning > evening * 1.5) return 'morning_person';
    if (evening > morning * 1.5) return 'night_owl';
    return 'balanced';
  }

  String _detectProductivityStyle(List<TaskEntity> tasks) {
    if (tasks.isEmpty) return 'steady';

    final now = DateTime.now();
    final dailyCounts = <DateTime, int>{};
    for (final task in tasks.where((t) => t.isCompleted)) {
      final day = DateTime(
        task.updatedAt.year,
        task.updatedAt.month,
        task.updatedAt.day,
      );
      if (now.difference(day).inDays <= 14) {
        dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
      }
    }

    if (dailyCounts.length < 3) return 'steady';

    final values = dailyCounts.values.toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    final variance = values
            .map((v) => (v - avg) * (v - avg))
            .reduce((a, b) => a + b) /
        values.length;

    if (variance > avg * 2) return 'burst';
    if (variance < avg * 0.3 && avg < 2) return 'inconsistent';
    return 'steady';
  }

  String _detectGoalOrientation(List<GoalEntity> goals) {
    if (goals.isEmpty) return 'realistic';

    final avgProgress =
        goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;
    final withTarget = goals.where((g) => g.targetDate != null).length;
    final targetRatio = goals.isEmpty ? 0.0 : withTarget / goals.length;

    if (avgProgress >= 60 && targetRatio >= 0.5) return 'optimistic';
    if (avgProgress < 25) return 'cautious';
    return 'realistic';
  }

  String _detectHabitConsistency(List<HabitEntity> habits) {
    if (habits.isEmpty) return 'low';

    var totalStreak = 0;
    var activeCount = 0;
    for (final habit in habits) {
      final streak = _habitRepo?.calculateStreak(habit) ??
          _localStreak(habit);
      if (streak > 0) {
        totalStreak += streak;
        activeCount++;
      }
    }

    if (activeCount == 0) return 'low';
    final avgStreak = totalStreak / activeCount;
    if (avgStreak >= 7) return 'high';
    if (avgStreak >= 3) return 'medium';
    return 'low';
  }

  int _localStreak(HabitEntity habit) {
    if (habit.completedDates.isEmpty) return 0;
    final sorted = habit.completedDates.toList()
      ..sort((a, b) => b.compareTo(a));
    var streak = 0;
    var cursor = DateTime.now();
    for (final date in sorted) {
      final day = DateTime(date.year, date.month, date.day);
      final expected = DateTime(cursor.year, cursor.month, cursor.day);
      if (day == expected || day == expected.subtract(const Duration(days: 1))) {
        streak++;
        cursor = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  String _detectMoodTrend(List<JournalEntryEntity> journal) {
    if (journal.length < 5) return 'stable';

    final sorted = journal.toList()..sort((a, b) => a.date.compareTo(b.date));
    final recent = sorted.length >= 7
        ? sorted.sublist(sorted.length - 7)
        : sorted;
    final older = sorted.length >= 14
        ? sorted.sublist(sorted.length - 14, sorted.length - 7)
        : sorted.sublist(0, sorted.length ~/ 2);

    if (older.isEmpty) return 'stable';

    final recentAvg =
        recent.map((e) => e.mood).reduce((a, b) => a + b) / recent.length;
    final olderAvg =
        older.map((e) => e.mood).reduce((a, b) => a + b) / older.length;
    final delta = recentAvg - olderAvg;

    if (delta >= 0.5) return 'improving';
    if (delta <= -0.5) return 'declining';
    if ((recent.map((e) => e.mood).toSet().length) >= 4) return 'volatile';
    return 'stable';
  }

  List<String> _learnTopHabits(List<HabitEntity> habits) {
    final ranked = habits.toList()
      ..sort((a, b) {
        final sa = _habitRepo?.calculateStreak(a) ?? _localStreak(a);
        final sb = _habitRepo?.calculateStreak(b) ?? _localStreak(b);
        return sb.compareTo(sa);
      });
    return ranked.take(3).map((h) => h.name).toList();
  }

  List<String> _learnActiveGoals(List<GoalEntity> goals) {
    final active = goals.where((g) => g.progress < 100).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
    return active.take(3).map((g) => g.title).toList();
  }

  List<String> _learnTopCategories(List<TaskEntity> tasks) {
    final counts = <String, int>{};
    for (final task in tasks.where((t) => t.isCompleted)) {
      counts[task.category] = (counts[task.category] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => e.key).toList();
  }

  double _avgMood(List<JournalEntryEntity> journal) {
    if (journal.isEmpty) return 3.0;
    return journal.map((e) => e.mood).reduce((a, b) => a + b) / journal.length;
  }

  double _taskCompletionRate(List<TaskEntity> tasks) {
    if (tasks.isEmpty) return 0;
    return tasks.where((t) => t.isCompleted).length / tasks.length;
  }
}
