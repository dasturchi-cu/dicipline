import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/achievement_unlock_repository.dart';
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
    this.unlockedAt,
  });

  final String id;
  final String emoji;
  final String title;
  final String description;
  final bool unlocked;
  final double? progress;
  final DateTime? unlockedAt;
}

/// Barcha yutuq shablonlari.
abstract final class AchievementDefinitions {
  static const all = [
    ('first_task', '✅', 'Birinchi qadam', 'Birinchi vazifani bajardingiz'),
    ('task_master', '📋', 'Vazifa ustasi', '10 ta vazifa bajarildi'),
    ('streak_7', '🔥', '7 kunlik olov', 'Odatda 7 kunlik ketma-ketlik'),
    ('goal_setter', '🎯', 'Maqsad qo\'yuvchi', 'Birinchi maqsad yaratildi'),
    ('half_way', '🏆', 'Yarim yo\'l', 'Maqsadning 50% ga yetildi'),
    ('journal_3', '📔', 'O\'zini tushunish', '3 ta kundalik yozuv'),
    ('habit_hero', '💪', 'Odat qahramoni', '5 ta odat yaratildi'),
    ('level_10', '⭐', '10-daraja', '10-darajaga yetdingiz'),
    ('level_25', '🌟', '25-daraja', '25-darajaga yetdingiz'),
    ('quest_master', '📜', 'Vazifa ustasi', '10 ta quest bajarildi'),
    ('streak_30', '🏅', '30 kunlik olov', 'Odatda 30 kunlik ketma-ketlik'),
    ('task_100', '💯', '100 vazifa', '100 ta vazifa bajarildi'),
    ('early_riser', '🌅', 'Ertalabchi', 'Ertalab vazifa bajarildi'),
    ('first_goal_done', '🎖️', 'Birinchi g\'alaba', 'Birinchi maqsad 100% bajarildi'),
    ('english_warrior', '📚', 'Ingliz jangchisi', 'Ta\'limda 10 soat'),
  ];
}

/// Ma'lumotlardan yutuqlarni hisoblaydi va doimiy saqlaydi.
class AchievementService {
  AchievementService({
    required AchievementUnlockRepository unlockRepo,
    HabitRepository? habitRepo,
  })  : _unlockRepo = unlockRepo,
        _habitRepo = habitRepo;

  final AchievementUnlockRepository _unlockRepo;
  final HabitRepository? _habitRepo;

  Future<List<Achievement>> computeAndSync({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    int playerLevel = 1,
    int completedQuests = 0,
    int totalStudyMinutes = 0,
  }) async {
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final longestStreak = habits.isEmpty
        ? 0
        : habits
            .map((h) =>
                _habitRepo?.calculateStreak(h) ??
                AiCoachService.habitStreakFromDates(h))
            .fold(0, (a, b) => a > b ? a : b);
    final goalsAbove50 = goals.where((g) => g.progress >= 50).length;
    final goalsCompleted = goals.where((g) => g.progress >= 100).length;
    final journalDays =
        journal.where((j) => j.content.trim().isNotEmpty).length;
    final earlyMorningTasks = tasks
        .where((t) => t.isCompleted && t.updatedAt.hour < 8)
        .length;

    final unlocks = await _unlockRepo.getAll();
    final unlockMap = {for (final u in unlocks) u.achievementId: u};

    final achievements = <Achievement>[];
    final pendingUnlocks = <Future<void>>[];

    void queueUnlock(
      String id,
      String emoji,
      String title,
      String desc,
      bool shouldUnlock,
      double progress,
    ) {
      final existing = unlockMap[id];
      final unlocked = existing != null || shouldUnlock;
      achievements.add(
        Achievement(
          id: id,
          emoji: emoji,
          title: title,
          description: desc,
          unlocked: unlocked,
          progress: progress,
          unlockedAt: existing?.unlockedAt,
        ),
      );
      if (shouldUnlock && existing == null) {
        pendingUnlocks.add(_unlockRepo.unlock(id));
      }
    }

    queueUnlock(
      'first_task',
      '✅',
      'Birinchi qadam',
      'Birinchi vazifani bajardingiz',
      completedTasks >= 1,
      (completedTasks / 1).clamp(0, 1),
    );
    queueUnlock(
      'task_master',
      '📋',
      'Vazifa ustasi',
      '10 ta vazifa bajarildi',
      completedTasks >= 10,
      (completedTasks / 10).clamp(0, 1),
    );
    queueUnlock(
      'streak_7',
      '🔥',
      '7 kunlik olov',
      'Odatda 7 kunlik ketma-ketlik',
      longestStreak >= 7,
      (longestStreak / 7).clamp(0, 1),
    );
    queueUnlock(
      'goal_setter',
      '🎯',
      'Maqsad qo\'yuvchi',
      'Birinchi maqsad yaratildi',
      goals.isNotEmpty,
      goals.isNotEmpty ? 1 : 0,
    );
    queueUnlock(
      'half_way',
      '🏆',
      'Yarim yo\'l',
      'Maqsadning 50% ga yetildi',
      goalsAbove50 >= 1,
      goalsAbove50 >= 1 ? 1 : 0,
    );
    queueUnlock(
      'journal_3',
      '📔',
      'O\'zini tushunish',
      '3 ta kundalik yozuv',
      journalDays >= 3,
      (journalDays / 3).clamp(0, 1),
    );
    queueUnlock(
      'habit_hero',
      '💪',
      'Odat qahramoni',
      '5 ta odat yaratildi',
      habits.length >= 5,
      (habits.length / 5).clamp(0, 1),
    );
    queueUnlock(
      'level_10',
      '⭐',
      '10-daraja',
      '10-darajaga yetdingiz',
      playerLevel >= 10,
      (playerLevel / 10).clamp(0, 1),
    );
    queueUnlock(
      'level_25',
      '🌟',
      '25-daraja',
      '25-darajaga yetdingiz',
      playerLevel >= 25,
      (playerLevel / 25).clamp(0, 1),
    );
    queueUnlock(
      'quest_master',
      '📜',
      'Quest ustasi',
      '10 ta quest bajarildi',
      completedQuests >= 10,
      (completedQuests / 10).clamp(0, 1),
    );
    queueUnlock(
      'streak_30',
      '🏅',
      '30 kunlik olov',
      'Odatda 30 kunlik ketma-ketlik',
      longestStreak >= 30,
      (longestStreak / 30).clamp(0, 1),
    );
    queueUnlock(
      'task_100',
      '💯',
      '100 vazifa',
      '100 ta vazifa bajarildi',
      completedTasks >= 100,
      (completedTasks / 100).clamp(0, 1),
    );
    queueUnlock(
      'early_riser',
      '🌅',
      'Ertalabchi',
      'Ertalab vazifa bajarildi',
      earlyMorningTasks >= 1,
      earlyMorningTasks >= 1 ? 1 : 0,
    );
    queueUnlock(
      'first_goal_done',
      '🎖️',
      'Birinchi g\'alaba',
      'Birinchi maqsad 100% bajarildi',
      goalsCompleted >= 1,
      goalsCompleted >= 1 ? 1 : 0,
    );
    queueUnlock(
      'english_warrior',
      '📚',
      'Ingliz jangchisi',
      'Ta\'limda 10 soat',
      totalStudyMinutes >= 600,
      (totalStudyMinutes / 600).clamp(0, 1),
    );

    await Future.wait(pendingUnlocks);

    return achievements;
  }

  static int unlockedCount(List<Achievement> achievements) {
    return achievements.where((a) => a.unlocked).length;
  }
}
