import 'package:isar/isar.dart';

import '../database/schemas/challenge_entity.dart';

class ChallengeRepository {
  ChallengeRepository(this._isar);

  final Isar _isar;

  Stream<List<ChallengeEntity>> watchActive() {
    return _isar.challengeEntitys
        .filter()
        .isActiveEqualTo(true)
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<ChallengeEntity>> watchAll() {
    return _isar.challengeEntitys
        .where()
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<ChallengeEntity>> getActive() {
    return _isar.challengeEntitys
        .filter()
        .isActiveEqualTo(true)
        .sortByStartedAtDesc()
        .findAll();
  }

  Future<ChallengeEntity?> getByType(String typeId) {
    return _isar.challengeEntitys
        .filter()
        .typeIdEqualTo(typeId)
        .isActiveEqualTo(true)
        .findFirst();
  }

  Future<ChallengeEntity> create(ChallengeEntity challenge) async {
    await _isar.writeTxn(() async {
      await _isar.challengeEntitys.put(challenge);
    });
    return challenge;
  }

  Future<ChallengeEntity> update(ChallengeEntity challenge) async {
    await _isar.writeTxn(() async {
      await _isar.challengeEntitys.put(challenge);
    });
    return challenge;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.challengeEntitys.delete(id));
  }

  Future<ChallengeEntity?> markTodayComplete(int id) async {
    final challenge = await _isar.challengeEntitys.get(id);
    if (challenge == null || !challenge.isActive) return null;

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final alreadyDone = challenge.completedDates.any(
      (d) =>
          d.year == todayNorm.year &&
          d.month == todayNorm.month &&
          d.day == todayNorm.day,
    );
    if (alreadyDone) return challenge;

    challenge.completedDates.add(todayNorm);
    challenge.currentDay = challenge.completedDates.length;

    if (challenge.currentDay >= challenge.targetDays) {
      challenge.completedAt = DateTime.now();
      challenge.isActive = false;
    }

    return update(challenge);
  }
}
