import 'package:isar/isar.dart';

import '../database/schemas/milestone_entity.dart';

class MilestoneRepository {
  MilestoneRepository(this._isar);

  final Isar _isar;

  Stream<List<MilestoneEntity>> watchAll() {
    return _isar.milestoneEntitys
        .where()
        .sortByAchievedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<MilestoneEntity>> getAll() {
    return _isar.milestoneEntitys.where().sortByAchievedAtDesc().findAll();
  }

  Future<MilestoneEntity?> getById(int id) => _isar.milestoneEntitys.get(id);

  Future<MilestoneEntity> create({
    required String title,
    String emoji = '🏆',
    String? description,
    String category = 'achievement',
    DateTime? achievedAt,
  }) async {
    final milestone = MilestoneEntity.create(
      title: title,
      emoji: emoji,
      description: description,
      category: category,
      achievedAt: achievedAt,
    );
    await save(milestone);
    return milestone;
  }

  Future<void> save(MilestoneEntity milestone) async {
    await _isar.writeTxn(() async {
      await _isar.milestoneEntitys.put(milestone);
    });
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.milestoneEntitys.delete(id);
    });
  }
}
