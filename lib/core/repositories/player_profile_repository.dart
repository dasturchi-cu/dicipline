import 'package:isar/isar.dart';

import '../database/schemas/player_profile_entity.dart';

class PlayerProfileRepository {
  PlayerProfileRepository(this._isar);

  final Isar _isar;

  Stream<PlayerProfileEntity?> watchProfile() {
    return _isar.playerProfileEntitys
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<PlayerProfileEntity?> getProfile() async {
    return _isar.playerProfileEntitys.where().findFirst();
  }

  Future<PlayerProfileEntity> getOrCreate() async {
    final existing = await getProfile();
    if (existing != null) return existing;

    final profile = PlayerProfileEntity.create();
    await _isar.writeTxn(() async {
      await _isar.playerProfileEntitys.put(profile);
    });
    return profile;
  }

  Future<PlayerProfileEntity> save(PlayerProfileEntity profile) async {
    profile.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.playerProfileEntitys.put(profile);
    });
    return profile;
  }
}
