import 'package:flutter/material.dart';

import '../../../core/constants/life_areas.dart';
import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../ai_planning/domain/weekly_review_service.dart';
import '../../ai_planning/domain/models/plan_models.dart';

/// CEO hisoboti uchun amalga oshirish tugmasi.
class CeoAction {
  const CeoAction({
    required this.label,
    required this.route,
    this.icon = Icons.arrow_forward_rounded,
  });

  final String label;
  final String route;
  final IconData icon;
}

/// Haftalik CEO hisoboti — faqat haqiqiy statistika.
class CeoWeeklyReport {
  const CeoWeeklyReport({
    required this.weekStart,
    required this.weekEnd,
    required this.wins,
    required this.failures,
    required this.progressNotes,
    required this.weaknesses,
    required this.habitNotes,
    required this.goalNotes,
    required this.learningNotes,
    required this.healthNotes,
    required this.recommendations,
    required this.actions,
    required this.focusAreas,
    required this.overallScore,
    required this.hasSufficientData,
    required this.weeklyReview,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final List<String> wins;
  final List<String> failures;
  final List<String> progressNotes;
  final List<String> weaknesses;
  final List<String> habitNotes;
  final List<String> goalNotes;
  final List<String> learningNotes;
  final List<String> healthNotes;
  final List<String> recommendations;
  final List<CeoAction> actions;
  final List<LifeArea> focusAreas;
  final int overallScore;
  final bool hasSufficientData;
  final WeeklyReviewReport weeklyReview;
}

DateTime _norm(DateTime d) => DateTime(d.year, d.month, d.day);

class CeoWeeklyReviewService {
  CeoWeeklyReviewService({
    WeeklyReviewService? weeklyReviewService,
    HabitRepository? habitRepository,
  })  : _weekly = weeklyReviewService ?? WeeklyReviewService(),
        _habitRepo = habitRepository;

  final WeeklyReviewService _weekly;
  final HabitRepository? _habitRepo;

  CeoWeeklyReport generate({
    DateTime? asOf,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    required List<PlanEntity> plans,
  }) {
    final weekly = _weekly.generate(
      asOf: asOf,
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
      workouts: workouts,
      studySessions: studySessions,
      plans: plans,
    );

    final weekStart = weekly.weekStart;
    final weekEnd = weekly.weekEnd;

    final weekTasks = tasks.where((t) {
      final d = _norm(t.dueDate ?? t.updatedAt);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).toList();

    final completed = weekTasks.where((t) => t.isCompleted).toList();
    final missed = weekTasks.where((t) => !t.isCompleted).toList();

    final wins = <String>[];
    final failures = <String>[];
    final progressNotes = <String>[];
    final weaknesses = <String>[];
    final habitNotes = <String>[];
    final goalNotes = <String>[];
    final learningNotes = <String>[];
    final healthNotes = <String>[];
    final recommendations = <String>[];
    final actions = <CeoAction>[];
    final focusAreas = <LifeArea>[];

    if (completed.isNotEmpty) {
      wins.add('✅ ${completed.length} ta vazifa bajarildi');
    }
    if (weekly.highlights.isNotEmpty) {
      wins.addAll(weekly.highlights.take(3).map((h) => '🏆 $h'));
    }

    if (missed.isNotEmpty) {
      failures.add('❌ ${missed.length} ta vazifa bajarilmadi');
      for (final task in missed.take(2)) {
        failures.add('• ${task.title}');
      }
    }

  final missedPlanItems = plans
        .where((p) {
          final d = _norm(p.planDate);
          return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
        })
        .expand((p) => p.items)
        .where((i) => i.isMissed && !i.isCompleted)
        .length;
    if (missedPlanItems > 0) {
      failures.add('❌ $missedPlanItems ta reja bandi o\'tkazildi');
    }

    progressNotes.add(
      '📈 Samaradorlik: ${weekly.productivityScore}% · '
      'Maqsadlar: ${weekly.goalScore}%',
    );

    if (weekly.productivityScore < 55) {
      weaknesses.add('Vazifa bajarish past');
      focusAreas.add(LifeArea.career);
      actions.add(
        const CeoAction(
          label: 'Vazifalarni ko\'rish',
          route: '/vazifalar',
          icon: Icons.task_alt_rounded,
        ),
      );
    }
    if (weekly.studyScore < 55) {
      weaknesses.add('Ta\'lim vaqti yetarli emas');
      focusAreas.add(LifeArea.learning);
      actions.add(
        const CeoAction(
          label: 'O\'qishni boshlash',
          route: '/hayot/ta\'lim',
          icon: Icons.menu_book_rounded,
        ),
      );
    }
    if (weekly.healthScore < 55) {
      weaknesses.add('Sog\'liq va odatlar zaif');
      focusAreas.add(LifeArea.health);
      actions.add(
        const CeoAction(
          label: 'Odatlar',
          route: '/qahramon/odatlar',
          icon: Icons.fitness_center_rounded,
        ),
      );
    }
    if (weekly.financeScore < 55) {
      weaknesses.add('Moliyaviy intizom past');
      focusAreas.add(LifeArea.finance);
      actions.add(
        const CeoAction(
          label: 'Moliya',
          route: '/hayot/moliya',
          icon: Icons.account_balance_wallet_rounded,
        ),
      );
    }

    for (final habit in habits) {
      final streak = _habitRepo?.calculateStreak(habit) ?? 0;
      final weekDone = habit.completedDates
          .where((d) => !d.isBefore(weekStart) && !d.isAfter(weekEnd))
          .length;
      if (weekDone > 0) {
        habitNotes.add(
          '🔥 ${habit.name}: $weekDone kun (streak: $streak)',
        );
      }
    }
    if (habitNotes.isEmpty && habits.isNotEmpty) {
      habitNotes.add('Odatlar bu hafta kam bajarildi');
    }

    for (final goal in goals.take(3)) {
      goalNotes.add(
        '🎯 ${goal.title}: ${goal.progress.round()}%',
      );
    }

    final studyMin = studySessions
        .where((s) {
          final d = _norm(s.date);
          return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
        })
        .fold<int>(0, (s, e) => s + e.durationMinutes);
    if (studyMin > 0) {
      learningNotes.add(
        '📚 ${(studyMin / 60).toStringAsFixed(1)} soat o\'qildi',
      );
    } else {
      learningNotes.add('📚 O\'qish sessiyasi qayd etilmagan');
    }

    final workoutCount = workouts
        .where((w) {
          final d = _norm(w.date);
          return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
        })
        .length;
    if (workoutCount > 0) {
      healthNotes.add('💪 $workoutCount ta mashq');
    } else {
      healthNotes.add('💪 Mashq qayd etilmagan');
    }

    recommendations.addAll(weekly.advice);

    if (focusAreas.isEmpty && weekly.overallScore >= 70) {
      recommendations.add('Keyingi hafta ham shu sur\'atni saqlang.');
    } else if (focusAreas.isNotEmpty) {
      final labels = focusAreas.map((a) => a.label).join(', ');
      recommendations.insert(
        0,
        'Keyingi hafta fokus: $labels',
      );
    }

    if (actions.isEmpty && missed.isNotEmpty) {
      actions.add(
        const CeoAction(
          label: 'Fokus rejimi',
          route: '/boshqa/fokus',
          icon: Icons.timer_rounded,
        ),
      );
    }
    if (actions.isEmpty) {
      actions.add(
        const CeoAction(
          label: 'Analitika',
          route: '/boshqa/analitika',
          icon: Icons.insights_rounded,
        ),
      );
    }

    final hasData = completed.isNotEmpty ||
        missed.isNotEmpty ||
        habitNotes.length > 1 ||
        goals.isNotEmpty ||
        studyMin > 0 ||
        workoutCount > 0;

    return CeoWeeklyReport(
      weekStart: weekStart,
      weekEnd: weekEnd,
      wins: wins,
      failures: failures,
      progressNotes: progressNotes,
      weaknesses: weaknesses,
      habitNotes: habitNotes,
      goalNotes: goalNotes,
      learningNotes: learningNotes,
      healthNotes: healthNotes,
      recommendations: recommendations,
      actions: actions,
      focusAreas: focusAreas,
      overallScore: weekly.overallScore,
      hasSufficientData: hasData,
      weeklyReview: weekly,
    );
  }
}
