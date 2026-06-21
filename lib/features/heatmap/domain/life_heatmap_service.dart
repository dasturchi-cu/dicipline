import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/utils/date_format.dart';

/// Bitta kun faolligi — heatmap uchun.
class HeatmapDay {
  const HeatmapDay({
    required this.date,
    required this.intensity,
    required this.tasksCompleted,
    required this.habitsCompleted,
    required this.hasJournal,
    required this.hasWorkout,
    required this.studyMinutes,
  });

  final DateTime date;
  /// 0–4 GitHub-style intensity
  final int intensity;
  final int tasksCompleted;
  final int habitsCompleted;
  final bool hasJournal;
  final bool hasWorkout;
  final int studyMinutes;
}

/// 365 kunlik hayot heatmap.
class LifeHeatmapService {
  const LifeHeatmapService();

  static const _days = 365;

  List<HeatmapDay> build({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<JournalEntryEntity> journal,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    DateTime? asOf,
  }) {
    final today = AppDateFormat.dateOnly(asOf ?? DateTime.now());
    final days = <HeatmapDay>[];

    for (var i = _days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));

      final tasksDone = tasks
          .where((t) => t.isCompleted && _sameDay(t.updatedAt, day))
          .length;

      var habitsDone = 0;
      for (final h in habits) {
        if (h.completedDates.any((d) => AppDateFormat.isSameDay(d, day))) {
          habitsDone++;
        }
      }

      final hasJournal = journal.any(
        (j) =>
            AppDateFormat.isSameDay(j.date, day) &&
            j.content.trim().isNotEmpty,
      );

      final hasWorkout =
          workouts.any((w) => AppDateFormat.isSameDay(w.date, day));

      final studyMin = studySessions
          .where((s) => AppDateFormat.isSameDay(s.date, day))
          .fold<int>(0, (sum, s) => sum + s.durationMinutes);

      var score = 0;
      if (tasksDone > 0) score += tasksDone.clamp(0, 2);
      if (habitsDone > 0) score += (habitsDone >= 2 ? 2 : 1);
      if (hasJournal) score++;
      if (hasWorkout) score++;
      if (studyMin >= 20) score++;

      days.add(
        HeatmapDay(
          date: day,
          intensity: score.clamp(0, 4),
          tasksCompleted: tasksDone,
          habitsCompleted: habitsDone,
          hasJournal: hasJournal,
          hasWorkout: hasWorkout,
          studyMinutes: studyMin,
        ),
      );
    }

    return days;
  }

  int totalActiveDays(List<HeatmapDay> days) =>
      days.where((d) => d.intensity > 0).length;

  int currentStreak(List<HeatmapDay> days) {
    var streak = 0;
    for (var i = days.length - 1; i >= 0; i--) {
      if (days[i].intensity > 0) {
        streak++;
      } else if (i < days.length - 1) {
        break;
      }
    }
    return streak;
  }

  bool _sameDay(DateTime a, DateTime b) => AppDateFormat.isSameDay(a, b);
}
