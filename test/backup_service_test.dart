import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/backup/backup_service.dart';
import 'package:rejabon_ai/core/database/schemas/player_profile_entity.dart';
import 'package:rejabon_ai/core/database/schemas/quest_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/database/schemas/xp_event_entity.dart';
import 'package:rejabon_ai/core/repositories/player_profile_repository.dart';
import 'package:rejabon_ai/core/repositories/quest_repository.dart';
import 'package:rejabon_ai/core/repositories/task_repository.dart';

import 'helpers/isar_test_helper.dart';

void main() {
  late TestIsarHandle handle;
  late BackupService backup;

  setUpAll(() async {
    await ensureIsarCoreInitialized();
  });

  setUp(() async {
    handle = await openTestIsar();
    backup = BackupService(handle.isar);
  });

  tearDown(() async {
    await closeTestIsar(handle);
  });

  test('export includes RPG entities after data created', () async {
    final tasks = TaskRepository(handle.isar);
    await tasks.create(title: 'Backup test');

    final profileRepo = PlayerProfileRepository(handle.isar);
    var profile = await profileRepo.getOrCreate();
    profile.totalXp = 100;
    profile.level = 2;
    await profileRepo.save(profile);

    final now = DateTime.now();
    final questRepo = QuestRepository(handle.isar);
    await questRepo.save(
      QuestEntity.create(
        questType: 'daily',
        questId: 'tasks_3',
        title: 'Test quest',
        description: 'Complete 3 tasks',
        statReward: 'discipline',
        xpReward: 30,
        verificationType: 'auto',
        startDate: now,
        endDate: now.add(const Duration(days: 1)),
      ),
    );

    await handle.isar.writeTxn(() async {
      await handle.isar.xpEventEntitys.put(
        XpEventEntity.create(
          amount: 25,
          source: 'task',
          statType: 'discipline',
        ),
      );
    });

    final data = await backup.exportToMap();
    expect(data['version'], BackupService.currentVersion);
    expect(data['tasks'], isA<List>());
    expect((data['tasks'] as List), isNotEmpty);
    expect(data['playerProfiles'], isA<List>());
    expect((data['playerProfiles'] as List), isNotEmpty);
    expect(data['quests'], isA<List>());
    expect(data['xpEvents'], isA<List>());
  });

  test('restore round-trips tasks and player profile', () async {
    final tasks = TaskRepository(handle.isar);
    await tasks.create(title: 'Round trip');

    final profileRepo = PlayerProfileRepository(handle.isar);
    var profile = await profileRepo.getOrCreate();
    profile.totalXp = 50;
    await profileRepo.save(profile);

    final json = await backup.exportToJson();
    await backup.restoreFromJson(json, clearExisting: true);

    final allTasks = await tasks.getAll();
    expect(allTasks.any((t) => t.title == 'Round trip'), isTrue);

    profile = await profileRepo.getOrCreate();
    expect(profile.totalXp, 50);
  });
}
