import 'package:isar/isar.dart';

import '../database/schemas/twin_profile_entity.dart';

class TwinProfileRepository {
  TwinProfileRepository(this._isar);

  final Isar _isar;

  Future<TwinProfileEntity?> getLatest() {
    return _isar.twinProfileEntitys
        .where()
        .sortByUpdatedAtDesc()
        .findFirst();
  }

  Stream<TwinProfileEntity?> watchLatest() {
    return _isar.twinProfileEntitys
        .where()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<TwinProfileEntity> save(TwinProfileEntity profile) async {
    await _isar.writeTxn(() async {
      await _isar.twinProfileEntitys.put(profile);
    });
    return profile;
  }
}
