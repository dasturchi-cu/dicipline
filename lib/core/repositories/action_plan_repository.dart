import 'package:isar/isar.dart';

import '../database/schemas/action_plan_entity.dart';

class ActionPlanRepository {
  ActionPlanRepository(this._isar);

  final Isar _isar;

  Stream<List<ActionPlanEntity>> watchAll() {
    return _isar.actionPlanEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<ActionPlanEntity>> watchPending() {
    return _isar.actionPlanEntitys
        .filter()
        .statusEqualTo('pending')
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<ActionPlanEntity>> getPending() {
    return _isar.actionPlanEntitys
        .filter()
        .statusEqualTo('pending')
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<ActionPlanEntity> save(ActionPlanEntity plan) async {
    await _isar.writeTxn(() async {
      await _isar.actionPlanEntitys.put(plan);
    });
    return plan;
  }

  Future<ActionPlanEntity> markApplied(ActionPlanEntity plan) async {
    plan.status = 'applied';
    plan.appliedAt = DateTime.now();
    return save(plan);
  }

  Future<ActionPlanEntity> markDismissed(ActionPlanEntity plan) async {
    plan.status = 'dismissed';
    return save(plan);
  }

  Future<bool> delete(int id) {
    return _isar.writeTxn(() => _isar.actionPlanEntitys.delete(id));
  }
}
