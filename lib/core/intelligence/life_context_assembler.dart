import '../../core/database/schemas/goal_entity.dart';
import '../../core/database/schemas/habit_entity.dart';
import '../../core/database/schemas/inbox_item_entity.dart';
import '../../core/database/schemas/journal_entry_entity.dart';
import '../../core/database/schemas/task_entity.dart';
import '../../core/utils/date_format.dart';
import '../../features/journal/domain/mood_trend_service.dart';
import '../../features/life_twin/domain/coach_pattern_engine.dart';
import 'models/coach_context.dart';

/// Hayot ma'lumotlarini AI murabbiy kontekstiga yig'adi.
class LifeContextAssembler {
  LifeContextAssembler({
    MoodTrendService? moodTrendService,
    CoachPatternEngine? patternEngine,
  })  : _moodTrend = moodTrendService ?? const MoodTrendService(),
        _patterns = patternEngine ?? const CoachPatternEngine();

  final MoodTrendService _moodTrend;
  final CoachPatternEngine _patterns;

  CoachContext assemble({
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
    List<HabitEntity> habits = const [],
    List<GoalEntity> goals = const [],
    List<InboxItemEntity> inbox = const [],
    int rpgLevel = 1,
    int rpgTotalXp = 0,
    List<String> topMemories = const [],
    DateTime? asOf,
  }) {
    final now = asOf ?? DateTime.now();
    final today = AppDateFormat.dateOnly(now);
    final moodTrend = _moodTrend.compute(journal, asOf: now);

    MoodProductivityCorrelation? moodProductivity;
    DayPerformanceProfile? dayPerformance;
    BurnoutSignal? burnout;
    String? patternInsight;

    if (journal.isNotEmpty && tasks.isNotEmpty) {
      moodProductivity = _patterns.analyzeMoodProductivity(
        journal: journal,
        tasks: tasks,
      );
      dayPerformance = _patterns.analyzeDayOfWeek(tasks);
      burnout = _patterns.detectBurnout(journal: journal, tasks: tasks);
      final insights = _patterns.buildPatternInsights(
        journal: journal,
        tasks: tasks,
      );
      patternInsight = insights.isNotEmpty ? insights.first : null;
    }

    final activeTasks = tasks.where((t) => !t.isCompleted);
    final overdue = activeTasks.where((t) {
      if (t.dueDate == null) return false;
      return AppDateFormat.dateOnly(t.dueDate!).isBefore(today);
    }).length;
    final dueToday = activeTasks.where((t) {
      if (t.dueDate == null) return false;
      return AppDateFormat.isSameDay(t.dueDate!, today);
    }).length;

    final habitsDone = habits
        .where((h) => h.completedDates.any((d) => AppDateFormat.isSameDay(d, today)))
        .length;
    final inboxPending =
        inbox.where((i) => i.status == 'pending').length;
    final journalToday = journal.any(
      (j) =>
          AppDateFormat.isSameDay(j.date, today) &&
          j.content.trim().isNotEmpty,
    );

    return CoachContext(
      asOf: now,
      moodTrend: moodTrend,
      moodProductivity: moodProductivity,
      dayPerformance: dayPerformance,
      burnout: burnout,
      patternInsight: patternInsight,
      today: TodaySnapshot(
        tasksOverdue: overdue,
        tasksDueToday: dueToday,
        habitsTotal: habits.length,
        habitsCompletedToday: habitsDone,
        inboxPending: inboxPending,
        journalWrittenToday: journalToday,
      ),
      rpg: RpgSnapshot(level: rpgLevel, totalXp: rpgTotalXp),
      goalsAtRisk: _detectGoalDrift(goals, today),
      topMemories: topMemories,
    );
  }

  List<GoalDriftSignal> _detectGoalDrift(
    List<GoalEntity> goals,
    DateTime today,
  ) {
    final signals = <GoalDriftSignal>[];
    for (final goal in goals) {
      if (goal.progress >= 100) continue;
      final age = today.difference(AppDateFormat.dateOnly(goal.createdAt)).inDays;

      if (age >= 7 && goal.progress < 25) {
        signals.add(
          GoalDriftSignal(
            goalTitle: goal.title,
            goalEmoji: goal.emoji,
            daysInactive: age,
            progress: goal.progress,
          ),
        );
        continue;
      }

      if (goal.targetDate != null) {
        final daysLeft =
            AppDateFormat.dateOnly(goal.targetDate!).difference(today).inDays;
        if (daysLeft <= 14 && daysLeft >= 0 && goal.progress < 50) {
          signals.add(
            GoalDriftSignal(
              goalTitle: goal.title,
              goalEmoji: goal.emoji,
              daysInactive: age,
              progress: goal.progress,
            ),
          );
        }
      }
    }
    signals.sort((a, b) => b.daysInactive.compareTo(a.daysInactive));
    return signals.take(3).toList();
  }
}
