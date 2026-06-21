import 'dart:math' as math;

import '../../../../core/database/schemas/player_profile_entity.dart';
import '../../../../core/database/schemas/xp_event_entity.dart';
import '../../../../core/repositories/player_profile_repository.dart';
import '../../../../core/repositories/xp_event_repository.dart';
import 'models/rpg_models.dart';

export 'models/rpg_models.dart';

/// XP qo'shish natijasi.
class XpAwardResult {
  const XpAwardResult({
    required this.amount,
    required this.statType,
    required this.leveledUp,
    this.newLevel,
    this.description,
  });

  final int amount;
  final String statType;
  final bool leveledUp;
  final int? newLevel;
  final String? description;
}

/// RPG XP tizimi.
class XpService {
  XpService({
    required PlayerProfileRepository profileRepo,
    required XpEventRepository eventRepo,
  })  : _profileRepo = profileRepo,
        _eventRepo = eventRepo;

  final PlayerProfileRepository _profileRepo;
  final XpEventRepository _eventRepo;

  Future<XpAwardResult?> award({
    required String statType,
    required int amount,
    required String source,
    String? sourceId,
    String? description,
    bool oncePerDay = false,
  }) async {
    if (amount <= 0) return null;

    if (oncePerDay) {
      final already = await _eventRepo.hasSourceToday(source, sourceId: sourceId);
      if (already) return null;
    }

    final event = XpEventEntity.create(
      statType: statType,
      amount: amount,
      source: source,
      sourceId: sourceId,
      description: description,
    );
    await _eventRepo.create(event);

    final profile = await _profileRepo.getOrCreate();
    final oldLevel = profile.level;

    _addStatXp(profile, statType, amount);
    profile.totalXp += amount;
    profile.lastXpEarnedAt = DateTime.now();
    profile.level = LevelCalculator.levelFromTotalXp(profile.totalXp);
    profile.title = LevelCalculator.titleForLevel(profile.level);

    await _profileRepo.save(profile);

    return XpAwardResult(
      amount: amount,
      statType: statType,
      leveledUp: profile.level > oldLevel,
      newLevel: profile.level > oldLevel ? profile.level : null,
      description: description,
    );
  }

  void _addStatXp(PlayerProfileEntity profile, String statType, int amount) {
    switch (statType) {
      case StatType.discipline:
        profile.disciplineXp += amount;
      case StatType.health:
        profile.healthXp += amount;
      case StatType.knowledge:
        profile.knowledgeXp += amount;
      case StatType.wealth:
        profile.wealthXp += amount;
      case StatType.social:
        profile.socialXp += amount;
      case StatType.spiritual:
        profile.spiritualXp += amount;
    }
  }

  Future<XpAwardResult?> awardTaskComplete(int taskId) => award(
        statType: StatType.discipline,
        amount: XpRewards.taskComplete,
        source: XpSource.taskComplete,
        sourceId: taskId.toString(),
        description: 'Vazifa bajarildi',
      );

  Future<XpAwardResult?> awardHabitComplete(int habitId) => award(
        statType: StatType.discipline,
        amount: XpRewards.habitComplete,
        source: XpSource.habitComplete,
        sourceId: habitId.toString(),
        description: 'Odat bajarildi',
        oncePerDay: true,
      );

  Future<XpAwardResult?> awardWorkout() => award(
        statType: StatType.health,
        amount: XpRewards.workout,
        source: XpSource.workout,
        description: 'Mashq qilindi',
        oncePerDay: false,
      );

  Future<XpAwardResult?> awardJournal() => award(
        statType: StatType.spiritual,
        amount: XpRewards.journal,
        source: XpSource.journal,
        description: 'Kundalik yozildi',
        oncePerDay: true,
      );

  Future<XpAwardResult?> awardStudy(int minutes) => award(
        statType: StatType.knowledge,
        amount: minutes * XpRewards.studyPerMinute,
        source: XpSource.study,
        description: '$minutes daqiqa o\'qildi',
      );

  Future<XpAwardResult?> awardFinanceLog() => award(
        statType: StatType.wealth,
        amount: XpRewards.financeLog,
        source: XpSource.finance,
        description: 'Moliya qayd etildi',
        oncePerDay: true,
      );

  Future<XpAwardResult?> awardQuest(int xp, String statType, String questId) =>
      award(
        statType: statType,
        amount: xp,
        source: XpSource.quest,
        sourceId: questId,
        description: 'Vazifa bajarildi',
      );

  Future<XpAwardResult?> awardFocusSession() => award(
        statType: StatType.discipline,
        amount: XpRewards.pomodoroComplete,
        source: XpSource.focusSession,
        description: 'Pomodoro tugallandi',
        oncePerDay: false,
      );
}

/// Daraja hisoblash.
class LevelCalculator {
  const LevelCalculator._();

  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    return (100 * math.pow(level - 1, 1.5)).round();
  }

  static int xpToNextLevel(int totalXp, int currentLevel) {
    final nextThreshold = xpForLevel(currentLevel + 1);
    return (nextThreshold - totalXp).clamp(0, 999999);
  }

  static double levelProgress(int totalXp, int currentLevel) {
    final currentThreshold = xpForLevel(currentLevel);
    final nextThreshold = xpForLevel(currentLevel + 1);
    if (nextThreshold <= currentThreshold) return 1.0;
    return ((totalXp - currentThreshold) / (nextThreshold - currentThreshold))
        .clamp(0.0, 1.0);
  }

  static int levelFromTotalXp(int totalXp) {
    var level = 1;
    while (xpForLevel(level + 1) <= totalXp && level < 100) {
      level++;
    }
    return level;
  }

  static String titleForLevel(int level) {
    if (level >= 100) return 'Hayot afsonasi';
    if (level >= 76) return 'Hayot strategi';
    if (level >= 51) return 'Ustoz';
    if (level >= 26) return 'Hayot arxitekti';
    if (level >= 11) return 'Intizom quruvchi';
    return 'Hayot o\'rganuvchisi';
  }
}
