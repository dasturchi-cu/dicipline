import '../../../features/journal/domain/mood_trend_service.dart';
import '../../../features/life_twin/domain/coach_pattern_engine.dart';

/// Bugungi holat — vazifa, odat, inbox.
class TodaySnapshot {
  const TodaySnapshot({
    this.tasksOverdue = 0,
    this.tasksDueToday = 0,
    this.habitsTotal = 0,
    this.habitsCompletedToday = 0,
    this.inboxPending = 0,
    this.journalWrittenToday = false,
  });

  final int tasksOverdue;
  final int tasksDueToday;
  final int habitsTotal;
  final int habitsCompletedToday;
  final int inboxPending;
  final bool journalWrittenToday;
}

/// RPG holati.
class RpgSnapshot {
  const RpgSnapshot({this.level = 1, this.totalXp = 0});

  final int level;
  final int totalXp;
}

/// Maqsad harakatsizligi signali.
class GoalDriftSignal {
  const GoalDriftSignal({
    required this.goalTitle,
    this.goalEmoji = '',
    required this.daysInactive,
    this.progress = 0,
  });

  final String goalTitle;
  final String goalEmoji;
  final int daysInactive;
  final double progress;
}

/// AI murabbiy va dashboard uchun birlashtirilgan kontekst.
class CoachContext {
  const CoachContext({
    required this.asOf,
    required this.moodTrend,
    this.moodProductivity,
    this.dayPerformance,
    this.burnout,
    this.patternInsight,
    this.today = const TodaySnapshot(),
    this.rpg,
    this.goalsAtRisk = const [],
    this.topMemories = const [],
  });

  final DateTime asOf;
  final MoodTrendReport moodTrend;
  final MoodProductivityCorrelation? moodProductivity;
  final DayPerformanceProfile? dayPerformance;
  final BurnoutSignal? burnout;
  final String? patternInsight;
  final TodaySnapshot today;
  final RpgSnapshot? rpg;
  final List<GoalDriftSignal> goalsAtRisk;
  final List<String> topMemories;

  String? get headlineInsight {
    if (burnout != null) return burnout!.message;
    if (goalsAtRisk.isNotEmpty) {
      final g = goalsAtRisk.first;
      return '"${g.goalTitle}" ${g.daysInactive} kundan beri sekin harakatlanmoqda.';
    }
    if (moodTrend.burnoutRisk) return moodTrend.insight;
    if (patternInsight != null && patternInsight!.isNotEmpty) {
      return patternInsight;
    }
    return moodTrend.hasSufficientData ? moodTrend.insight : null;
  }
}
