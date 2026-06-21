import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/finance_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import 'models/plan_models.dart';
import 'life_score_service.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Haftalik hisobot va ballar.
class WeeklyReviewService {
  WeeklyReviewService({
    LifeScoreService? lifeScoreService,
    HabitRepository? habitRepository,
  })  : _lifeScoreService = lifeScoreService ?? LifeScoreService(),
        _habitRepository = habitRepository;

  final LifeScoreService _lifeScoreService;
  final HabitRepository? _habitRepository;

  WeeklyReviewReport generate({
    DateTime? asOf,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    required List<PlanEntity> plans,
  }) {
    final today = _normalizeDate(asOf ?? DateTime.now());
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final weekTasks = tasks.where((task) {
      final date = task.dueDate ?? task.createdAt;
      final d = _normalizeDate(date);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).toList();

    final productivityScore = _productivityScore(weekTasks, plans, weekStart, weekEnd);
    final studyScore = _studyScore(studySessions, weekStart, weekEnd);
    final healthScore = _healthScore(workouts, habits, weekStart, weekEnd);
    final financeScore = _financeScore(finance, weekStart, weekEnd);
    final goalScore = _goalScore(goals);

    final overallScore = _clamp(
      ((productivityScore +
                  studyScore +
                  healthScore +
                  financeScore +
                  goalScore) /
              5)
          .round(),
    );

    final highlights = _buildHighlights(
      weekTasks: weekTasks,
      habits: habits,
      workouts: workouts,
      studySessions: studySessions,
      weekStart: weekStart,
      weekEnd: weekEnd,
    );

    final advice = _buildAdvice(
      productivityScore: productivityScore,
      studyScore: studyScore,
      healthScore: healthScore,
      financeScore: financeScore,
      goalScore: goalScore,
    );

    return WeeklyReviewReport(
      weekStart: weekStart,
      weekEnd: weekEnd,
      productivityScore: productivityScore,
      studyScore: studyScore,
      healthScore: healthScore,
      financeScore: financeScore,
      goalScore: goalScore,
      overallScore: overallScore,
      highlights: highlights,
      advice: advice,
    );
  }

  LifeScoreBreakdown lifeScore({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    PlanEntity? todayPlan,
  }) {
    return _lifeScoreService.compute(
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
      workouts: workouts,
      studySessions: studySessions,
      todayPlan: todayPlan,
    );
  }

  int _productivityScore(
    List<TaskEntity> weekTasks,
    List<PlanEntity> plans,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    var score = 40;

    if (weekTasks.isNotEmpty) {
      final done = weekTasks.where((t) => t.isCompleted).length / weekTasks.length;
      score += (done * 40).round();
    }

    final weekPlans = plans.where((plan) {
      final d = _normalizeDate(plan.planDate);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    });

    if (weekPlans.isNotEmpty) {
      var totalItems = 0;
      var completedItems = 0;
      for (final plan in weekPlans) {
        totalItems += plan.items.length;
        completedItems += plan.items.where((item) => item.isCompleted).length;
      }
      if (totalItems > 0) {
        score += ((completedItems / totalItems) * 20).round();
      }
    }

    return _clamp(score);
  }

  int _studyScore(
    List<StudySessionEntity> sessions,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    final minutes = sessions.where((s) {
      final d = _normalizeDate(s.date);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).fold<int>(0, (sum, s) => sum + s.durationMinutes);

    if (minutes >= 600) return 95;
    if (minutes >= 300) return 80;
    if (minutes >= 120) return 65;
    if (minutes >= 30) return 50;
    return 35;
  }

  int _healthScore(
    List<WorkoutEntity> workouts,
    List<HabitEntity> habits,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    var score = 35;

    final weekWorkouts = workouts.where((w) {
      final d = _normalizeDate(w.date);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).length;
    score += (weekWorkouts * 12).clamp(0, 40);

    if (habits.isNotEmpty) {
      var completionDays = 0;
      for (var i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        final done = habits.where(
          (h) => h.completedDates.any(
            (d) =>
                d.year == day.year &&
                d.month == day.month &&
                d.day == day.day,
          ),
        ).length;
        completionDays += done;
      }
      final rate = completionDays / (habits.length * 7);
      score += (rate * 25).round();
    }

    return _clamp(score);
  }

  int _financeScore(
    List<FinanceTransactionEntity> finance,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    final weekFinance = finance.where((tx) {
      final d = _normalizeDate(tx.date);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).toList();

    if (weekFinance.isEmpty) return 45;

    final income = weekFinance
        .where((tx) => tx.type == FinanceRepository.typeIncome)
        .fold<double>(0, (sum, tx) => sum + tx.amount);
    final expense = weekFinance
        .where((tx) => tx.type == FinanceRepository.typeExpense)
        .fold<double>(0, (sum, tx) => sum + tx.amount);

    if (income == 0 && expense > 0) return 30;
    if (income > 0 && expense <= income * 0.8) return 85;
    if (income > 0 && expense <= income) return 70;
    return 40;
  }

  int _goalScore(List<GoalEntity> goals) {
    if (goals.isEmpty) return 40;
    final avg = goals.fold<double>(0, (sum, g) => sum + g.progress) / goals.length;
    return _clamp(25 + (avg * 0.75).round());
  }

  List<String> _buildHighlights({
    required List<TaskEntity> weekTasks,
    required List<HabitEntity> habits,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    required DateTime weekStart,
    required DateTime weekEnd,
  }) {
    final highlights = <String>[];

    final doneTasks = weekTasks.where((t) => t.isCompleted).length;
    if (doneTasks > 0) {
      highlights.add('$doneTasks ta vazifa bajarildi');
    }

    var maxStreak = 0;
    for (final habit in habits) {
      final streak = _habitRepository?.calculateStreak(habit) ?? 0;
      if (streak > maxStreak) maxStreak = streak;
    }
    if (maxStreak >= 3) {
      highlights.add('Eng uzun odat ketma-ketligi: $maxStreak kun');
    }

    final weekWorkouts = workouts.where((w) {
      final d = _normalizeDate(w.date);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).length;
    if (weekWorkouts > 0) {
      highlights.add('$weekWorkouts ta mashq sessiyasi');
    }

    final studyMinutes = studySessions.where((s) {
      final d = _normalizeDate(s.date);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).fold<int>(0, (sum, s) => sum + s.durationMinutes);
    if (studyMinutes >= 60) {
      highlights.add('${(studyMinutes / 60).toStringAsFixed(1)} soat o\'qish');
    }

    if (highlights.isEmpty) {
      highlights.add('Hafta boshlandi — birinchi yutug\'ingizni qo\'shing!');
    }

    return highlights;
  }

  List<String> _buildAdvice({
    required int productivityScore,
    required int studyScore,
    required int healthScore,
    required int financeScore,
    required int goalScore,
  }) {
    final advice = <String>[];

    if (productivityScore < 60) {
      advice.add('Vazifalarni kichik qismlarga bo\'ling va kunlik reja tuzing.');
    }
    if (studyScore < 60) {
      advice.add('Har kuni kamida 30 daqiqa o\'qish vaqti ajrating.');
    }
    if (healthScore < 60) {
      advice.add('Haftada 3 marta jismoniy mashq qilishni maqsad qiling.');
    }
    if (financeScore < 60) {
      advice.add('Xarajatlarni kuzatib, byudjet rejasini yangilang.');
    }
    if (goalScore < 60) {
      advice.add('Maqsadlaringizga kichik, o\'lchanadigan bosqichlar qo\'shing.');
    }

    if (advice.isEmpty) {
      advice.add('Ajoyib hafta! Keyingi haftada ham shu sur\'atni saqlang.');
    }

    return advice;
  }

  int _clamp(int value) => value.clamp(0, 100);
}
