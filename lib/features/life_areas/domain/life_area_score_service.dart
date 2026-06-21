import '../../../core/constants/life_areas.dart';
import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/time_log_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/finance_repository.dart';
import '../../../core/repositories/habit_repository.dart';

/// Bitta hayot sohasi uchun haqiqiy ball.
class LifeAreaScore {
  const LifeAreaScore({
    required this.area,
    required this.score,
    required this.health,
    required this.tasksCompleted,
    required this.tasksTotal,
    required this.habitsCompleted,
    required this.habitsTotal,
    required this.goalProgress,
    required this.timeInvestedMinutes,
    required this.trend,
  });

  final LifeArea area;
  final int score;
  final AreaHealth health;
  final int tasksCompleted;
  final int tasksTotal;
  final int habitsCompleted;
  final int habitsTotal;
  final double goalProgress;
  final int timeInvestedMinutes;
  final String trend; // up | down | stable
}

/// Hayot muvozanati — faqat haqiqiy ma'lumotlardan.
class LifeBalanceReport {
  const LifeBalanceReport({
    required this.overallScore,
    required this.areaScores,
    required this.neglectedAreas,
    required this.thrivingAreas,
    required this.hasSufficientData,
  });

  final int overallScore;
  final List<LifeAreaScore> areaScores;
  final List<LifeArea> neglectedAreas;
  final List<LifeArea> thrivingAreas;
  final bool hasSufficientData;
}

DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class LifeAreaScoreService {
  LifeAreaScoreService({HabitRepository? habitRepository})
      : _habitRepo = habitRepository;

  final HabitRepository? _habitRepo;

  static const _windowDays = 14;
  static const _minDataPoints = 3;

  LifeBalanceReport compute({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<PlanEntity> plans,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    required List<FinanceTransactionEntity> finance,
    List<TimeLogEntity> timeLogs = const [],
    DateTime? asOf,
  }) {
    final today = _norm(asOf ?? DateTime.now());
    final windowStart = today.subtract(const Duration(days: _windowDays - 1));

    var dataPoints = 0;
    final areaScores = <LifeAreaScore>[];

    for (final area in LifeArea.all) {
      final score = _scoreForArea(
        area: area,
        tasks: tasks,
        habits: habits,
        goals: goals,
        plans: plans,
        workouts: workouts,
        studySessions: studySessions,
        finance: finance,
        timeLogs: timeLogs,
        windowStart: windowStart,
        today: today,
      );
      dataPoints += score.tasksTotal +
          score.habitsTotal +
          (score.goalProgress > 0 ? 1 : 0) +
          (score.timeInvestedMinutes > 0 ? 1 : 0);
      areaScores.add(score);
    }

    final hasData = dataPoints >= _minDataPoints;
    final overall = hasData
        ? (areaScores.fold<int>(0, (s, a) => s + a.score) / areaScores.length)
            .round()
        : 0;

    final neglected = areaScores
        .where((s) => s.health == AreaHealth.neglected)
        .map((s) => s.area)
        .toList();
    final thriving = areaScores
        .where((s) => s.health == AreaHealth.thriving)
        .map((s) => s.area)
        .toList();

    return LifeBalanceReport(
      overallScore: overall,
      areaScores: areaScores,
      neglectedAreas: neglected,
      thrivingAreas: thriving,
      hasSufficientData: hasData,
    );
  }

  LifeAreaScore _scoreForArea({
    required LifeArea area,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<PlanEntity> plans,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    required List<FinanceTransactionEntity> finance,
    List<TimeLogEntity> timeLogs = const [],
    required DateTime windowStart,
    required DateTime today,
  }) {
    final areaTasks = tasks.where((t) {
      return LifeArea.resolveForTask(t).contains(area.id);
    }).toList();

    final windowTasks = areaTasks.where((t) {
      final d = _norm(t.updatedAt);
      return !d.isBefore(windowStart) && !d.isAfter(today);
    }).toList();

    final tasksCompleted = windowTasks.where((t) => t.isCompleted).length;
    final tasksTotal = windowTasks.length;

    final areaHabits =
        habits.where((h) => LifeArea.resolveForHabit(h).contains(area.id));
    var habitCompletions = 0;
    var habitOpportunities = 0;
    for (final habit in areaHabits) {
      for (var i = 0; i < _windowDays; i++) {
        final day = windowStart.add(Duration(days: i));
        habitOpportunities++;
        if (habit.completedDates.any((d) => _sameDay(d, day))) {
          habitCompletions++;
        }
      }
    }

    final areaGoals =
        goals.where((g) => LifeArea.resolveForGoal(g).contains(area.id));
    final goalProgress = areaGoals.isEmpty
        ? 0.0
        : areaGoals.fold<double>(0, (s, g) => s + g.progress) /
            areaGoals.length;

    var timeMinutes = 0;
    if (area.id == LifeArea.health.id) {
      timeMinutes = workouts
          .where((w) {
            final d = _norm(w.date);
            return !d.isBefore(windowStart) && !d.isAfter(today);
          })
          .fold<int>(0, (s, w) => s + w.durationMinutes);
    } else if (area.id == LifeArea.learning.id) {
      timeMinutes = studySessions
          .where((s) {
            final d = _norm(s.date);
            return !d.isBefore(windowStart) && !d.isAfter(today);
          })
          .fold<int>(0, (s, e) => s + e.durationMinutes);
    } else if (area.id == LifeArea.finance.id) {
      timeMinutes = finance
          .where((f) {
            final d = _norm(f.date);
            return !d.isBefore(windowStart) && !d.isAfter(today);
          })
          .length *
          5; // har tranzaksiya ~5 daq deb hisob
    } else {
      final areaPlans = plans.where((p) {
        return LifeArea.resolveForPlan(p).contains(area.id);
      });
      for (final plan in areaPlans) {
        final d = _norm(plan.planDate);
        if (d.isBefore(windowStart) || d.isAfter(today)) continue;
        timeMinutes += plan.items
            .where((i) => i.isCompleted)
            .fold<int>(0, (s, i) => s + i.durationMinutes);
      }
    }

    timeMinutes += _timeLogMinutesForArea(
      area: area,
      timeLogs: timeLogs,
      windowStart: windowStart,
      today: today,
    );

    final taskRate = tasksTotal > 0 ? tasksCompleted / tasksTotal : 0.0;
    final habitRate =
        habitOpportunities > 0 ? habitCompletions / habitOpportunities : 0.0;
    final goalFactor = goalProgress / 100;

    var score = 0;
    if (tasksTotal > 0) score += (taskRate * 35).round();
    if (habitOpportunities > 0) score += (habitRate * 35).round();
    if (areaGoals.isNotEmpty) score += (goalFactor * 20).round();
    if (timeMinutes > 0) {
      score += (timeMinutes.clamp(0, 300) / 300 * 10).round();
    }

    final health = score >= 60
        ? AreaHealth.thriving
        : score >= 30
            ? AreaHealth.balanced
            : AreaHealth.neglected;

    final prevWindowStart =
        windowStart.subtract(const Duration(days: _windowDays));
    final prevTasks = areaTasks.where((t) {
      final d = _norm(t.updatedAt);
      return !d.isBefore(prevWindowStart) &&
          d.isBefore(windowStart) &&
          t.isCompleted;
    }).length;
    final trend = tasksCompleted > prevTasks
        ? 'up'
        : tasksCompleted < prevTasks
            ? 'down'
            : 'stable';

    return LifeAreaScore(
      area: area,
      score: score.clamp(0, 100),
      health: health,
      tasksCompleted: tasksCompleted,
      tasksTotal: tasksTotal,
      habitsCompleted: habitCompletions,
      habitsTotal: habitOpportunities,
      goalProgress: goalProgress,
      timeInvestedMinutes: timeMinutes,
      trend: trend,
    );
  }

  int _timeLogMinutesForArea({
    required LifeArea area,
    required List<TimeLogEntity> timeLogs,
    required DateTime windowStart,
    required DateTime today,
  }) {
    var minutes = 0;
    for (final log in timeLogs) {
      final day = _norm(log.startedAt);
      if (day.isBefore(windowStart) || day.isAfter(today)) continue;
      if (!LifeArea.resolveForTimeLog(log).contains(area.id)) continue;
      minutes += (log.durationSeconds / 60).round();
    }
    return minutes;
  }
}
