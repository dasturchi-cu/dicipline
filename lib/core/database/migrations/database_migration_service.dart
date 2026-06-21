import 'package:isar/isar.dart';

import 'package:rejabon_ai/core/database/schemas/app_meta.dart';
import 'package:rejabon_ai/core/repositories/player_profile_repository.dart';

/// Ma'lumotlar bazasi versiyasi.
abstract final class DatabaseSchemaVersion {
  static const int current = 6;
  static const String versionKey = 'schema_version';
}

/// Migratsiya natijasi.
class MigrationResult {
  const MigrationResult({
    required this.fromVersion,
    required this.toVersion,
    required this.stepsExecuted,
  });

  final int fromVersion;
  final int toVersion;
  final List<String> stepsExecuted;

  bool get migrated => stepsExecuted.isNotEmpty;
}

/// Isar ochilgandan keyin migratsiyalarni bajaradi.
class DatabaseMigrationService {
  DatabaseMigrationService(this._isar);

  final Isar _isar;

  Future<MigrationResult> migrate() async {
    final fromVersion = await _readVersion();
    final steps = <String>[];

    if (fromVersion < 2) {
      await _migrateToV2(steps);
      await _writeVersion(2);
    }

    if (fromVersion < 3) {
      steps.add('phase2_collections_ready');
      await _writeVersion(3);
    }

    if (fromVersion < 4) {
      steps.add('phase2_twin_profile_action_plan_ready');
      await _writeVersion(4);
    }

    if (fromVersion < 5) {
      steps.add('social_viral_system_ready');
      await _writeVersion(5);
    }

    if (fromVersion < 6) {
      steps.add('vision_board_and_task_goal_link_ready');
      await _writeVersion(6);
    }

    return MigrationResult(
      fromVersion: fromVersion,
      toVersion: DatabaseSchemaVersion.current,
      stepsExecuted: steps,
    );
  }

  Future<int> _readVersion() async {
    final meta = await _isar.appMetas
        .filter()
        .keyEqualTo(DatabaseSchemaVersion.versionKey)
        .findFirst();
    if (meta == null) return 1;
    return int.tryParse(meta.value) ?? 1;
  }

  Future<void> _writeVersion(int version) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.appMetas
          .filter()
          .keyEqualTo(DatabaseSchemaVersion.versionKey)
          .findFirst();
      if (existing != null) {
        existing.value = version.toString();
        await _isar.appMetas.put(existing);
      } else {
        final meta = AppMeta()
          ..key = DatabaseSchemaVersion.versionKey
          ..value = version.toString();
        await _isar.appMetas.put(meta);
      }
    });
  }

  Future<void> _migrateToV2(List<String> steps) async {
    final profileRepo = PlayerProfileRepository(_isar);
    await profileRepo.getOrCreate();
    steps.add('player_profile_initialized');
    steps.add('schema_v2_collections_ready');
  }
}
