import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/intelligence/models/coach_context.dart';
import 'package:rejabon_ai/features/action_engine/domain/action_engine_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/goal_execution/domain/goal_execution_service.dart';
import 'package:rejabon_ai/features/journal/domain/mood_trend_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';
import 'package:rejabon_ai/features/retention/domain/daily_retention_engine.dart';

/// Life OS tsikli holati.
class LifeOsState {
  const LifeOsState({
    required this.moodMultiplier,
    required this.productivityScore,
    required this.goalMomentum,
    required this.rewardReadiness,
    required this.twinAnalysis,
    required this.dailyBundle,
    required this.proactiveActionsTaken,
    required this.loopInsight,
  });

  /// 0.5–1.2 — kayfiyat samaradorlikka ta'siri
  final double moodMultiplier;
  final int productivityScore;
  final double goalMomentum;
  final bool rewardReadiness;
  final LifeTwinAnalysis twinAnalysis;
  final DailyRetentionBundle dailyBundle;
  final int proactiveActionsTaken;
  final String loopInsight;
}

/// Life OS — barcha modullarni birlashtiruvchi markaziy dvigatel.
class LifeOsEngine {
  LifeOsEngine({
    LifeTwinEngine? twinEngine,
    ActionEngineService? actionEngine,
    GoalExecutionService? goalExecution,
    DailyRetentionEngine? retention,
    FuturePredictionEngine? predictions,
    MoodTrendService? moodTrend,
  })  : _twinEngine = twinEngine ?? LifeTwinEngine(),
        _actionEngine = actionEngine,
        _goalExecution = goalExecution,
        _retention = retention ?? DailyRetentionEngine(),
        _predictions = predictions ?? FuturePredictionEngine(),
        _moodTrend = moodTrend ?? const MoodTrendService();

  final LifeTwinEngine _twinEngine;
  final ActionEngineService? _actionEngine;
  final GoalExecutionService? _goalExecution;
  final DailyRetentionEngine _retention;
  final FuturePredictionEngine _predictions;
  final MoodTrendService _moodTrend;

  LifeOsState compute({
    required CoachContext coachContext,
    required LifeTwinProfile twinProfile,
    required LifeScoreBreakdown breakdown,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    required int playerLevel,
    required int dailyXpEarned,
    int proactiveActionsTaken = 0,
  }) {
    final twinAnalysis = _twinEngine.analyze(
      profile: twinProfile,
      tasks: tasks,
      habits: habits,
      goals: goals,
      journal: journal,
      storedProfile: twinProfile.twinProfile,
    );

    final moodReport = coachContext.moodTrend;
    final moodMultiplier = _moodMultiplier(moodReport);
    final productivityScore =
        (breakdown.discipline * moodMultiplier).round().clamp(0, 100);

    final goalMomentum = goals.isEmpty
        ? 0.0
        : goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;

    final predictions = _predictions.predict(
      goals: goals,
      habits: habits,
      tasks: tasks,
      journal: journal,
    );

    final dailyBundle = _retention.buildDailyBundle(
      twinAnalysis: twinAnalysis,
      predictions: predictions,
      breakdown: breakdown,
      playerLevel: playerLevel,
      dailyXpEarned: dailyXpEarned,
      coachContext: coachContext,
    );

    final loopInsight = _loopInsight(
      moodMultiplier: moodMultiplier,
      productivityScore: productivityScore,
      goalMomentum: goalMomentum,
      burnout: twinProfile.burnout != null,
    );

    return LifeOsState(
      moodMultiplier: moodMultiplier,
      productivityScore: productivityScore,
      goalMomentum: goalMomentum,
      rewardReadiness: dailyXpEarned >= 25 || playerLevel > 1,
      twinAnalysis: twinAnalysis,
      dailyBundle: dailyBundle,
      proactiveActionsTaken: proactiveActionsTaken,
      loopInsight: loopInsight,
    );
  }

  /// Signallar asosida proaktiv harakatlar (jadval, tiklanish, maqsad).
  Future<int> runProactiveActions({
    required LifeOsState state,
    required LifeTwinProfile profile,
    required LifeScoreBreakdown breakdown,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
  }) async {
    if (_actionEngine == null) return 0;
    var count = 0;

    final overdue = tasks.where((t) {
      if (t.isCompleted || t.dueDate == null) return false;
      return t.dueDate!.isBefore(DateTime.now());
    }).length;

    if (overdue >= 2) {
      await _actionEngine.adjustSchedule();
      count++;
    }

    if (profile.burnout != null || state.moodMultiplier < 0.75) {
      await _actionEngine.generateRecoveryPlan(
        profile: profile,
        journal: journal,
        tasks: tasks,
      );
      count++;
    }

    if (state.productivityScore < 50) {
      await _actionEngine.rebuildPlan(
        profile: profile,
        pendingTasks: tasks.where((t) => !t.isCompleted).toList(),
      );
      count++;
    }

    final stalledGoal = goals
        .where((g) => g.progress < 20 && g.milestones.isEmpty)
        .toList();
    if (stalledGoal.isNotEmpty && _goalExecution != null) {
      await _goalExecution.executeGoal(goal: stalledGoal.first);
      count++;
    }

    if (count == 0 && breakdown.discipline < 55) {
      await _actionEngine.generateIntervention(
        breakdown: breakdown,
        habits: habits,
        goals: goals,
      );
      count++;
    }

    return count;
  }

  double _moodMultiplier(MoodTrendReport mood) {
    if (!mood.hasSufficientData) return 1.0;
    if (mood.burnoutRisk) return 0.65;
    if (mood.average7d >= 4.0) return 1.15;
    if (mood.average7d <= 2.5) return 0.75;
    return 1.0;
  }

  String _loopInsight({
    required double moodMultiplier,
    required int productivityScore,
    required double goalMomentum,
    required bool burnout,
  }) {
    if (burnout) {
      return 'Kayfiyat past → samaradorlik $productivityScore. Tiklanish rejimi faollashtirildi.';
    }
    if (moodMultiplier > 1.05) {
      return 'Yuqori kayfiyat → +${((moodMultiplier - 1) * 100).round()}% samaradorlik kuchaytmasi.';
    }
    if (goalMomentum >= 50) {
      return 'Maqsadlar ${goalMomentum.round()}% — mukofotlar motivatsiyani oshiradi.';
    }
    return 'Life Loop: Capture → Act → Reward → Reflect → Plan.';
  }
}
