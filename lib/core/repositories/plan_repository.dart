import 'package:isar/isar.dart';

import '../database/schemas/plan_entity.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class PlanRepository {
  PlanRepository(this._isar);

  final Isar _isar;

  Stream<List<PlanEntity>> watchAll() {
    return _isar.planEntitys
        .where()
        .sortByPlanDateDesc()
        .watch(fireImmediately: true);
  }

  Stream<PlanEntity?> watchForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return _isar.planEntitys
        .filter()
        .planDateEqualTo(normalized)
        .watch(fireImmediately: true)
        .map((plans) => plans.isEmpty ? null : plans.first);
  }

  Future<PlanEntity?> getForDate(DateTime date) async {
    final normalized = _normalizeDate(date);
    final plans = await _isar.planEntitys
        .filter()
        .planDateEqualTo(normalized)
        .findAll();
    return plans.isEmpty ? null : plans.first;
  }

  Future<PlanEntity?> getToday() => getForDate(DateTime.now());

  Future<PlanEntity?> getById(int id) => _isar.planEntitys.get(id);

  Future<List<PlanEntity>> getAll() {
    return _isar.planEntitys.where().sortByPlanDateDesc().findAll();
  }

  Future<List<PlanEntity>> getRange(DateTime start, DateTime end) async {
    final from = _normalizeDate(start);
    final to = _normalizeDate(end);
    return _isar.planEntitys
        .filter()
        .planDateBetween(from, to)
        .sortByPlanDate()
        .findAll();
  }

  Future<PlanEntity> save(PlanEntity plan) async {
    plan.planDate = _normalizeDate(plan.planDate);
    plan.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.planEntitys.put(plan);
    });
    return plan;
  }

  Future<PlanEntity> upsertForDate({
    required DateTime planDate,
    required String sourceText,
    required List<PlanItemEmbedded> items,
  }) async {
    final normalized = _normalizeDate(planDate);
    final existing = await getForDate(normalized);
    final plan = existing ??
        PlanEntity.create(planDate: normalized, sourceText: sourceText);
    plan.sourceText = sourceText;
    plan.items = items;
    return save(plan);
  }

  Future<PlanEntity?> toggleItemComplete(int planId, int itemIndex) async {
    final plan = await getById(planId);
    if (plan == null || itemIndex < 0 || itemIndex >= plan.items.length) {
      return null;
    }
    final item = plan.items[itemIndex];
    item.isCompleted = !item.isCompleted;
    if (item.isCompleted) {
      item.isMissed = false;
    }
    return save(plan);
  }

  Future<PlanEntity?> markMissedItems(DateTime asOf) async {
    final plan = await getForDate(asOf);
    if (plan == null) return null;

    var changed = false;
    for (final item in plan.items) {
      if (item.isCompleted) continue;
      if (item.endTime.isBefore(asOf)) {
        if (!item.isMissed) {
          item.isMissed = true;
          changed = true;
        }
      }
    }

    return changed ? save(plan) : plan;
  }

  Future<bool> delete(int id) {
    return _isar.writeTxn(() => _isar.planEntitys.delete(id));
  }
}
