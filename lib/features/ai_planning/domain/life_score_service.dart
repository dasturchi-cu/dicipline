import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/finance_repository.dart';
import 'models/plan_models.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Shaxsiy hayot balli (0–100) — moliya type: 0=daromad, 1=xarajat.
class LifeScoreService {
  LifeScoreBreakdown compute({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    PlanEntity? todayPlan,
    DateTime? asOf,
  }) {
    final now = asOf ?? DateTime.now();
    final today = _normalizeDate(now);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    final health = _healthScore(workouts, habits, todayPlan, weekStart, today);
    final learning = _learningScore(studySessions, todayPlan, weekStart, today);
    final financeScore = _financeScore(finance);
    final discipline = _disciplineScore(tasks, habits, todayPlan, today);
    final sleep = _sleepScore(todayPlan);
    final goalsScore = _goalsScore(goals);

    final overall = _clamp(
      ((health + learning + financeScore + discipline + sleep + goalsScore) / 6)
          .round(),
    );

    return LifeScoreBreakdown(
      health: health,
      learning: learning,
      finance: financeScore,
      discipline: discipline,
      sleep: sleep,
      goals: goalsScore,
      overall: overall,
    );
  }

  int _healthScore(
    List<WorkoutEntity> workouts,
    List<HabitEntity> habits,
    PlanEntity? plan,
    DateTime weekStart,
    DateTime today,
  ) {
    var score = 40;

    final weekWorkouts = workouts.where((w) {
      final d = _normalizeDate(w.date);
      return !d.isBefore(weekStart) && !d.isAfter(today);
    }).length;
    score += (weekWorkouts * 10).clamp(0, 30);

    final healthHabits = habits.where((h) {
      final name = h.name.toLowerCase();
      return name.contains('yugur') ||
          name.contains('mashq') ||
          name.contains('suv') ||
          name.contains('sport');
    });
    if (healthHabits.isNotEmpty) {
      final completed = healthHabits
          .where((h) => h.completedDates.any((d) => _isSameDay(d, today)))
          .length;
      score += ((completed / healthHabits.length) * 20).round();
    }

    if (plan != null) {
      final healthItems = plan.items.where(
        (item) =>
            item.category == 'health' ||
            item.title.toLowerCase().contains('yugur') ||
            item.title.toLowerCase().contains('mashq'),
      );
      if (healthItems.isNotEmpty) {
        final done =
            healthItems.where((item) => item.isCompleted).length / healthItems.length;
        score += (done * 10).round();
      }
    }

    return _clamp(score);
  }

  int _learningScore(
    List<StudySessionEntity> sessions,
    PlanEntity? plan,
    DateTime weekStart,
    DateTime today,
  ) {
    var score = 30;

    final weekMinutes = sessions.where((s) {
      final d = _normalizeDate(s.date);
      return !d.isBefore(weekStart) && !d.isAfter(today);
    }).fold<int>(0, (sum, s) => sum + s.durationMinutes);

    if (weekMinutes >= 300) {
      score += 40;
    } else if (weekMinutes >= 120) {
      score += 25;
    } else if (weekMinutes >= 30) {
      score += 10;
    }

    if (plan != null) {
      final learningItems = plan.items.where(
        (item) => item.category == 'learning',
      );
      if (learningItems.isNotEmpty) {
        final done = learningItems.where((item) => item.isCompleted).length /
            learningItems.length;
        score += (done * 30).round();
      }
    }

    return _clamp(score);
  }

  int _financeScore(List<FinanceTransactionEntity> finance) {
    final income = finance
        .where((tx) => tx.type == FinanceRepository.typeIncome)
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final expense = finance
        .where((tx) => tx.type == FinanceRepository.typeExpense)
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final balance = income - expense;

    if (finance.isEmpty) return 35;

    var score = 50;
    if (balance >= 0) {
      score += 25;
      if (income > 0 && expense / income <= 0.7) {
        score += 15;
      } else if (income > 0 && expense / income <= 0.9) {
        score += 5;
      }
    } else {
      score -= 20;
    }

    return _clamp(score);
  }

  int _disciplineScore(
    List<TaskEntity> tasks,
    List<HabitEntity> habits,
    PlanEntity? plan,
    DateTime today,
  ) {
    var score = 30;

    final todayTasks = tasks.where((t) {
      if (t.dueDate == null) return true;
      return _isSameDay(t.dueDate!, today);
    }).toList();

    if (todayTasks.isNotEmpty) {
      final done = todayTasks.where((t) => t.isCompleted).length / todayTasks.length;
      score += (done * 35).round();
    }

    if (habits.isNotEmpty) {
      final done = habits
              .where((h) => h.completedDates.any((d) => _isSameDay(d, today)))
              .length /
          habits.length;
      score += (done * 25).round();
    }

    if (plan != null && plan.items.isNotEmpty) {
      final done =
          plan.items.where((item) => item.isCompleted).length / plan.items.length;
      score += (done * 10).round();
    }

    return _clamp(score);
  }

  int _sleepScore(PlanEntity? plan) {
    if (plan == null) return 50;

    final sleepItems = plan.items.where(
      (item) =>
          item.category == 'sleep' ||
          item.title.toLowerCase().contains('uyqu'),
    );

    if (sleepItems.isEmpty) return 55;

    final completed = sleepItems.where((item) => item.isCompleted).length;
    if (completed > 0) return 75;

    final hasSleepScheduled = sleepItems.any(
      (item) => item.startTime.hour >= 21 || item.startTime.hour <= 6,
    );
    return hasSleepScheduled ? 65 : 45;
  }

  int _goalsScore(List<GoalEntity> goals) {
    if (goals.isEmpty) return 40;

    final avgProgress =
        goals.fold<double>(0, (sum, g) => sum + g.progress) / goals.length;
    return _clamp(30 + (avgProgress * 0.7).round());
  }

  int _clamp(int value) => value.clamp(0, 100);
}
