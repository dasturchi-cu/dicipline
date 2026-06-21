import 'package:isar/isar.dart';

import '../database/schemas/achievement_unlock_entity.dart';

class AchievementUnlockRepository {
  AchievementUnlockRepository(this._isar);

  final Isar _isar;

  Stream<List<AchievementUnlockEntity>> watchAll() {
    return _isar.achievementUnlockEntitys
        .where()
        .sortByUnlockedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<AchievementUnlockEntity>> getAll() {
    return _isar.achievementUnlockEntitys
        .where()
        .sortByUnlockedAtDesc()
        .findAll();
  }

  Future<AchievementUnlockEntity?> getByAchievementId(String id) {
    return _isar.achievementUnlockEntitys
        .filter()
        .achievementIdEqualTo(id)
        .findFirst();
  }

  Future<AchievementUnlockEntity> unlock(String achievementId) async {
    final existing = await getByAchievementId(achievementId);
    if (existing != null) return existing;

    final unlock = AchievementUnlockEntity.create(
      achievementId: achievementId,
    );
    await _isar.writeTxn(() async {
      await _isar.achievementUnlockEntitys.put(unlock);
    });
    return unlock;
  }

  Future<void> markCelebrated(String achievementId) async {
    final existing = await getByAchievementId(achievementId);
    if (existing == null) return;
    existing.celebrated = true;
    await _isar.writeTxn(() async {
      await _isar.achievementUnlockEntitys.put(existing);
    });
  }

  Future<List<AchievementUnlockEntity>> getUncelebrated() {
    return _isar.achievementUnlockEntitys
        .filter()
        .celebratedEqualTo(false)
        .findAll();
  }
}
