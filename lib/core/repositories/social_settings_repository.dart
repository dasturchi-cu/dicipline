import 'package:isar/isar.dart';

import '../database/schemas/social_settings_entity.dart';

class SocialSettingsRepository {
  SocialSettingsRepository(this._isar);

  final Isar _isar;

  Future<SocialSettingsEntity> getOrCreate({String displayName = ''}) async {
    final existing = await _isar.socialSettingsEntitys.where().findFirst();
    if (existing != null) return existing;

    final defaults = SocialSettingsEntity.defaults(displayName: displayName);
    await _isar.writeTxn(() async {
      await _isar.socialSettingsEntitys.put(defaults);
    });
    return defaults;
  }

  Stream<SocialSettingsEntity?> watch() {
    return _isar.socialSettingsEntitys
        .where()
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<SocialSettingsEntity> save(SocialSettingsEntity settings) async {
    settings.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.socialSettingsEntitys.put(settings);
    });
    return settings;
  }
}
