import 'package:isar/isar.dart';

import '../database/schemas/goal_entity.dart';

class GoalRepository {
  GoalRepository(this._isar);

  final Isar _isar;

  Stream<List<GoalEntity>> watchAll() {
    return _isar.goalEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<GoalEntity?> getById(int id) {
    return _isar.goalEntitys.get(id);
  }

  Future<List<GoalEntity>> getAll() {
    return _isar.goalEntitys.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<GoalEntity>> getLowProgress({double threshold = 30}) async {
    final goals = await getAll();
    return goals.where((goal) => goal.progress < threshold).toList();
  }

  Future<GoalEntity> create({
    required String title,
    String? description,
    double progress = 0,
    List<MilestoneEmbedded>? milestones,
    DateTime? targetDate,
  }) async {
    final goal = GoalEntity.create(
      title: title,
      description: description,
      progress: progress.clamp(0, 100),
      milestones: milestones,
      targetDate: targetDate,
    );
    await _isar.writeTxn(() async {
      await _isar.goalEntitys.put(goal);
    });
    return goal;
  }

  Future<GoalEntity> save(GoalEntity goal) => update(goal);

  Future<GoalEntity> update(GoalEntity goal) async {
    goal.progress = goal.progress.clamp(0, 100);
    await _isar.writeTxn(() async {
      await _isar.goalEntitys.put(goal);
    });
    return goal;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.goalEntitys.delete(id));
  }

  Future<GoalEntity?> updateProgress(int id, double progress) async {
    final goal = await getById(id);
    if (goal == null) return null;
    goal.progress = progress.clamp(0, 100);
    return update(goal);
  }

  Future<GoalEntity?> toggleMilestone(int goalId, int milestoneIndex) async {
    final goal = await getById(goalId);
    if (goal == null) return null;
    if (milestoneIndex < 0 || milestoneIndex >= goal.milestones.length) {
      return goal;
    }

    final milestone = goal.milestones[milestoneIndex];
    milestone.isCompleted = !milestone.isCompleted;

    if (goal.milestones.isNotEmpty) {
      final completed =
          goal.milestones.where((m) => m.isCompleted).length;
      goal.progress = (completed / goal.milestones.length) * 100;
    }

    return update(goal);
  }
}
