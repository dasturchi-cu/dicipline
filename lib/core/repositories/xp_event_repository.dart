import 'package:isar/isar.dart';

import '../database/schemas/xp_event_entity.dart';

class XpEventRepository {
  XpEventRepository(this._isar);

  final Isar _isar;

  Stream<List<XpEventEntity>> watchRecent({int limit = 50}) {
    return _isar.xpEventEntitys
        .where()
        .sortByEarnedAtDesc()
        .limit(limit)
        .watch(fireImmediately: true);
  }

  Future<List<XpEventEntity>> getRecent({int limit = 50}) {
    return _isar.xpEventEntitys
        .where()
        .sortByEarnedAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<XpEventEntity>> getToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return _isar.xpEventEntitys
        .filter()
        .earnedAtGreaterThan(start, include: true)
        .earnedAtLessThan(end)
        .findAll();
  }

  Future<bool> hasSourceToday(String source, {String? sourceId}) async {
    final today = await getToday();
    return today.any((e) {
      if (e.source != source) return false;
      if (sourceId != null && e.sourceId != sourceId) return false;
      return true;
    });
  }

  Future<List<XpEventEntity>> getAll() {
    return _isar.xpEventEntitys.where().sortByEarnedAtDesc().findAll();
  }

  Future<XpEventEntity> create(XpEventEntity event) async {
    await _isar.writeTxn(() async {
      await _isar.xpEventEntitys.put(event);
    });
    return event;
  }

  Future<int> getTodayXpTotal() async {
    final events = await getToday();
    return events.fold<int>(0, (sum, e) => sum + e.amount);
  }
}
