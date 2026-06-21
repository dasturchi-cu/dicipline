import 'package:isar/isar.dart';

import '../database/schemas/group_challenge_entity.dart';

class GroupChallengeRepository {
  GroupChallengeRepository(this._isar);

  final Isar _isar;

  Stream<List<GroupChallengeEntity>> watchActive() {
    return _isar.groupChallengeEntitys
        .filter()
        .statusEqualTo('active')
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<GroupChallengeEntity>> watchAll() {
    return _isar.groupChallengeEntitys
        .where()
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<GroupChallengeEntity> save(GroupChallengeEntity challenge) async {
    await _isar.writeTxn(() async {
      await _isar.groupChallengeEntitys.put(challenge);
    });
    return challenge;
  }
}
