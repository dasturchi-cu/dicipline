import 'package:isar/isar.dart';

import '../database/schemas/time_log_entity.dart';

class TimeLogRepository {
  TimeLogRepository(this._isar);

  final Isar _isar;

  Stream<List<TimeLogEntity>> watchAll() {
    return _isar.timeLogEntitys
        .where()
        .sortByStartedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<TimeLogEntity>> getAll() {
    return _isar.timeLogEntitys.where().sortByStartedAtDesc().findAll();
  }

  Future<List<TimeLogEntity>> getInRange(DateTime start, DateTime end) {
    return _isar.timeLogEntitys
        .filter()
        .startedAtGreaterThan(start.subtract(const Duration(seconds: 1)))
        .startedAtLessThan(end.add(const Duration(days: 1)))
        .findAll();
  }

  Future<TimeLogEntity> create(TimeLogEntity log) async {
    await _isar.writeTxn(() async {
      await _isar.timeLogEntitys.put(log);
    });
    return log;
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.timeLogEntitys.delete(id);
    });
  }
}
