import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/inbox_item_entity.dart';
import '../../../core/database/schemas/milestone_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/time_log_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../ai_coach/domain/ai_coach_service.dart';
import '../../gamification/domain/achievement_service.dart';

enum TimelineEventType {
  milestone,
  goal,
  achievement,
  streak,
  task,
  study,
  workout,
  timeLog,
  inbox,
}

class TimelineEvent {
  const TimelineEvent({
    required this.date,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.route,
  });

  final DateTime date;
  final TimelineEventType type;
  final String title;
  final String subtitle;
  final String emoji;
  final String? route;
}

class LifeTimelineService {
  const LifeTimelineService();

  List<TimelineEvent> build({
    required List<MilestoneEntity> milestones,
    required List<GoalEntity> goals,
    required List<Achievement> achievements,
    required List<HabitEntity> habits,
    required List<TaskEntity> tasks,
    required List<StudySessionEntity> studySessions,
    required List<WorkoutEntity> workouts,
    required List<TimeLogEntity> timeLogs,
    required List<InboxItemEntity> inboxItems,
    int limit = 50,
  }) {
    final events = <TimelineEvent>[];

    for (final m in milestones) {
      events.add(
        TimelineEvent(
          date: m.achievedAt,
          type: TimelineEventType.milestone,
          title: m.title,
          subtitle: m.description ?? m.category,
          emoji: m.emoji,
          route: '/hayot/timeline',
        ),
      );
    }

    for (final g in goals.where((g) => g.progress >= 100)) {
      events.add(
        TimelineEvent(
          date: g.targetDate ?? g.createdAt,
          type: TimelineEventType.goal,
          title: g.title,
          subtitle: 'Maqsad bajarildi — ${g.progress.round()}%',
          emoji: g.emoji.isNotEmpty ? g.emoji : '🎯',
          route: '/hayot/maqsadlar',
        ),
      );
    }

    for (final a in achievements.where((a) => a.unlocked)) {
      events.add(
        TimelineEvent(
          date: DateTime.now(),
          type: TimelineEventType.achievement,
          title: a.title,
          subtitle: a.description,
          emoji: a.emoji,
        ),
      );
    }

    for (final h in habits) {
      final streak = AiCoachService.habitStreakFromDates(h);
      if (streak >= 7) {
        events.add(
          TimelineEvent(
            date: DateTime.now(),
            type: TimelineEventType.streak,
            title: h.name,
            subtitle: '$streak kunlik ketma-ketlik',
            emoji: h.emoji.isNotEmpty ? h.emoji : '🔥',
            route: '/hayot/odatlar',
          ),
        );
      }
    }

    for (final t in tasks.where((t) => t.isCompleted)) {
      events.add(
        TimelineEvent(
          date: t.updatedAt,
          type: TimelineEventType.task,
          title: t.title,
          subtitle: 'Vazifa bajarildi',
          emoji: t.emoji.isNotEmpty ? t.emoji : '✅',
          route: '/vazifalar/${t.id}',
        ),
      );
    }

    for (final s in studySessions) {
      events.add(
        TimelineEvent(
          date: s.date,
          type: TimelineEventType.study,
          title: 'Ta\'lim sessiyasi',
          subtitle: '${s.durationMinutes} daqiqa',
          emoji: '📚',
          route: '/hayot/ta\'lim',
        ),
      );
    }

    for (final w in workouts) {
      events.add(
        TimelineEvent(
          date: w.date,
          type: TimelineEventType.workout,
          title: w.exerciseName,
          subtitle: '${w.durationMinutes} daqiqa mashq',
          emoji: '💪',
          route: '/hayot/mashq',
        ),
      );
    }

    for (final log in timeLogs) {
      events.add(
        TimelineEvent(
          date: log.endedAt,
          type: TimelineEventType.timeLog,
          title: log.label ?? _timeLabel(log.sessionType),
          subtitle: '${(log.durationSeconds / 60).round()} daqiqa',
          emoji: _timeEmoji(log.sessionType),
          route: '/hayot/vaqt',
        ),
      );
    }

    for (final item in inboxItems.where((i) => i.status == 'processed')) {
      events.add(
        TimelineEvent(
          date: item.createdAt,
          type: TimelineEventType.inbox,
          title: item.title,
          subtitle: 'Inboxdan tartibga solindi',
          emoji: item.emoji,
          route: '/boshqa/inbox',
        ),
      );
    }

    events.sort((a, b) => b.date.compareTo(a.date));
    return events.take(limit).toList();
  }

  static String _timeLabel(String type) => switch (type) {
        'study' => 'Ta\'lim sessiyasi',
        'programming' => 'Dasturlash sessiyasi',
        'workout' => 'Mashq sessiyasi',
        'focus' => 'Fokus sessiyasi',
        'reading' => 'O\'qish sessiyasi',
        _ => 'Vaqt sessiyasi',
      };

  static String _timeEmoji(String type) => switch (type) {
        'study' => '📚',
        'programming' => '💻',
        'workout' => '💪',
        'focus' => '🎯',
        'reading' => '📖',
        _ => '⏱️',
      };
}
