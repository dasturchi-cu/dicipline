import 'package:isar/isar.dart';

import '../database/schemas/app_meta.dart';

class AppMetaRepository {
  AppMetaRepository(this._isar);

  final Isar _isar;

  Future<String?> get(String key) async {
    final meta = await _isar.appMetas.filter().keyEqualTo(key).findFirst();
    return meta?.value;
  }

  Future<void> set(String key, String value) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.appMetas.filter().keyEqualTo(key).findFirst();
      if (existing != null) {
        existing.value = value;
        await _isar.appMetas.put(existing);
      } else {
        final meta = AppMeta()
          ..key = key
          ..value = value;
        await _isar.appMetas.put(meta);
      }
    });
  }
}
