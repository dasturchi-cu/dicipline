import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../ai_coach/domain/ai_coach_service.dart';

/// Yutuq — motivatsiya tizimi.
class Achievement {
  const Achievement({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.unlocked,
    this.progress,
  });

  final String id;
  final String emoji;
  final String title;
  final String description;
  final bool unlocked;
  final double? progress;
}

/// Ma'lumotlardan yutuqlarni hisoblaydi (etik, manipulyatsiyasiz).
class AchievementService {
  const AchievementService._();

  static List<Achievement> compute({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    HabitRepository? habitRepo,
  }) {
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final longestStreak = habits.isEmpty
        ? 0
        : habits
            .map((h) =>
                habitRepo?.calculateStreak(h) ??
                AiCoachService.habitStreakFromDates(h))
            .fold(0, (a, b) => a > b ? a : b);
    final goalsAbove50 = goals.where((g) => g.progress >= 50).length;
    final journalDays = journal.where((j) => j.content.trim().isNotEmpty).length;

    return [
      Achievement(
        id: 'first_task',
        emoji: '✅',
        title: 'Birinchi qadam',
        description: 'Birinchi vazifani bajardingiz',
        unlocked: completedTasks >= 1,
        progress: completedTasks >= 1 ? 1 : 0,
      ),
      Achievement(
        id: 'task_master',
        emoji: '📋',
        title: 'Vazifa ustasi',
        description: '10 ta vazifa bajarildi',
        unlocked: completedTasks >= 10,
        progress: (completedTasks / 10).clamp(0, 1),
      ),
      Achievement(
        id: 'streak_7',
        emoji: '🔥',
        title: '7 kunlik olov',
        description: 'Odatda 7 kunlik ketma-ketlik',
        unlocked: longestStreak >= 7,
        progress: (longestStreak / 7).clamp(0, 1),
      ),
      Achievement(
        id: 'goal_setter',
        emoji: '🎯',
        title: 'Maqsad qo\'yuvchi',
        description: 'Birinchi maqsad yaratildi',
        unlocked: goals.isNotEmpty,
        progress: goals.isNotEmpty ? 1 : 0,
      ),
      Achievement(
        id: 'half_way',
        emoji: '🏆',
        title: 'Yarim yo\'l',
        description: 'Maqsadning 50% ga yetildi',
        unlocked: goalsAbove50 >= 1,
        progress: goalsAbove50 >= 1 ? 1 : 0,
      ),
      Achievement(
        id: 'journal_3',
        emoji: '📔',
        title: 'O\'zini tushunish',
        description: '3 ta kundalik yozuv',
        unlocked: journalDays >= 3,
        progress: (journalDays / 3).clamp(0, 1),
      ),
      Achievement(
        id: 'habit_hero',
        emoji: '💪',
        title: 'Odat qahramoni',
        description: '5 ta odat yaratildi',
        unlocked: habits.length >= 5,
        progress: (habits.length / 5).clamp(0, 1),
      ),
    ];
  }

  static int unlockedCount(List<Achievement> achievements) {
    return achievements.where((a) => a.unlocked).length;
  }
}
