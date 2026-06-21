import 'package:rejabon_ai/core/database/schemas/achievement_unlock_entity.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/milestone_entity.dart';
import 'package:rejabon_ai/core/database/schemas/xp_event_entity.dart';

/// Life Map nuqtasi.
class LifeMapNode {
  const LifeMapNode({
    required this.id,
    required this.title,
    required this.emoji,
    required this.date,
    required this.type,
    required this.progress,
    this.description,
  });

  final String id;
  final String title;
  final String emoji;
  final DateTime date;
  final String type;
  final double progress;
  final String? description;
}

/// Maqsad yo'l xaritasi segmenti.
class GoalRoadmapSegment {
  const GoalRoadmapSegment({
    required this.goalId,
    required this.title,
    required this.emoji,
    required this.progress,
    required this.milestones,
    required this.targetDate,
  });

  final int goalId;
  final String title;
  final String emoji;
  final double progress;
  final List<LifeMapNode> milestones;
  final DateTime? targetDate;
}

/// Life Map — maqsadlar, yutuqlar va progress xronologiyasi.
class LifeMapData {
  const LifeMapData({
    required this.goalRoadmaps,
    required this.progressTimeline,
    required this.achievementTimeline,
    required this.overallProgress,
  });

  final List<GoalRoadmapSegment> goalRoadmaps;
  final List<LifeMapNode> progressTimeline;
  final List<LifeMapNode> achievementTimeline;
  final double overallProgress;
}

class LifeMapService {
  LifeMapData build({
    required List<GoalEntity> goals,
    required List<MilestoneEntity> milestones,
    required List<AchievementUnlockEntity> achievements,
    required List<XpEventEntity> xpEvents,
  }) {
    final roadmaps = goals.map((goal) {
      final embedded = goal.milestones
          .asMap()
          .entries
          .map(
            (e) => LifeMapNode(
              id: 'goal_${goal.id}_m${e.key}',
              title: e.value.title,
              emoji: goal.emoji.isNotEmpty ? goal.emoji : '🎯',
              date: goal.createdAt.add(Duration(days: e.key * 7)),
              type: e.value.isCompleted ? 'milestone_done' : 'milestone',
              progress: e.value.isCompleted ? 100 : 0,
            ),
          )
          .toList();

      return GoalRoadmapSegment(
        goalId: goal.id,
        title: goal.title,
        emoji: goal.emoji.isNotEmpty ? goal.emoji : '🎯',
        progress: goal.progress,
        milestones: embedded,
        targetDate: goal.targetDate,
      );
    }).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));

    final progressTimeline = <LifeMapNode>[];

    for (final goal in goals) {
      progressTimeline.add(
        LifeMapNode(
          id: 'goal_${goal.id}',
          title: goal.title,
          emoji: goal.emoji.isNotEmpty ? goal.emoji : '🎯',
          date: goal.createdAt,
          type: 'goal',
          progress: goal.progress,
          description: '${goal.progress.round()}% bajarildi',
        ),
      );
    }

    for (final event in xpEvents) {
      progressTimeline.add(
        LifeMapNode(
          id: 'xp_${event.id}',
          title: event.description ?? event.source,
          emoji: '⭐',
          date: event.earnedAt,
          type: 'xp',
          progress: event.amount.toDouble(),
          description: event.description ?? '+${event.amount} XP',
        ),
      );
    }

    progressTimeline.sort((a, b) => b.date.compareTo(a.date));

    final achievementTimeline = <LifeMapNode>[];

    for (final ms in milestones) {
      achievementTimeline.add(
        LifeMapNode(
          id: 'ms_${ms.id}',
          title: ms.title,
          emoji: ms.emoji,
          date: ms.achievedAt,
          type: 'milestone',
          progress: 100,
          description: ms.description,
        ),
      );
    }

    for (final ach in achievements) {
      achievementTimeline.add(
        LifeMapNode(
          id: 'ach_${ach.id}',
          title: ach.achievementId,
          emoji: '🏆',
          date: ach.unlockedAt,
          type: 'achievement',
          progress: 100,
        ),
      );
    }

    achievementTimeline.sort((a, b) => b.date.compareTo(a.date));

    final overallProgress = goals.isEmpty
        ? 0.0
        : goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;

    return LifeMapData(
      goalRoadmaps: roadmaps,
      progressTimeline: progressTimeline.take(50).toList(),
      achievementTimeline: achievementTimeline.take(50).toList(),
      overallProgress: overallProgress,
    );
  }
}
