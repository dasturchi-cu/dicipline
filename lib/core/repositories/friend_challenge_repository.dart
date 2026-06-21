import 'package:isar/isar.dart';

import '../database/schemas/friend_challenge_entity.dart';

class FriendChallengeRepository {
  FriendChallengeRepository(this._isar);

  final Isar _isar;

  Stream<List<FriendChallengeEntity>> watchActive() {
    return _isar.friendChallengeEntitys
        .filter()
        .statusEqualTo('active')
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<FriendChallengeEntity>> watchAll() {
    return _isar.friendChallengeEntitys
        .where()
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<FriendChallengeEntity>> getActive() {
    return _isar.friendChallengeEntitys
        .filter()
        .statusEqualTo('active')
        .findAll();
  }

  Future<FriendChallengeEntity> save(FriendChallengeEntity challenge) async {
    await _isar.writeTxn(() async {
      await _isar.friendChallengeEntitys.put(challenge);
    });
    return challenge;
  }
}
