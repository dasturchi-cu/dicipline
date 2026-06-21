import 'package:isar/isar.dart';

import '../database/schemas/calendar_event_entity.dart';

class CalendarRepository {
  CalendarRepository(this._isar);

  final Isar _isar;

  Stream<List<CalendarEventEntity>> watchAll() {
    return _isar.calendarEventEntitys
        .where()
        .sortByStartTime()
        .watch(fireImmediately: true);
  }

  Future<CalendarEventEntity?> getById(int id) {
    return _isar.calendarEventEntitys.get(id);
  }

  Future<List<CalendarEventEntity>> getAll() {
    return _isar.calendarEventEntitys.where().sortByStartTime().findAll();
  }

  Future<List<CalendarEventEntity>> getUpcomingEvents({int limit = 10}) async {
    final now = DateTime.now();
    final events = await _isar.calendarEventEntitys
        .filter()
        .startTimeGreaterThan(now, include: true)
        .sortByStartTime()
        .findAll();
    if (events.length <= limit) return events;
    return events.sublist(0, limit);
  }

  Stream<List<CalendarEventEntity>> watchUpcomingEvents({int limit = 10}) {
    final now = DateTime.now();
    return _isar.calendarEventEntitys
        .filter()
        .startTimeGreaterThan(now, include: true)
        .sortByStartTime()
        .watch(fireImmediately: true)
        .map(
          (events) =>
              events.length <= limit ? events : events.sublist(0, limit),
        );
  }

  Future<CalendarEventEntity> create({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    bool hasReminder = false,
    int reminderMinutes = 15,
  }) async {
    final event = CalendarEventEntity.create(
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      hasReminder: hasReminder,
      reminderMinutes: reminderMinutes,
    );
    await _isar.writeTxn(() async {
      await _isar.calendarEventEntitys.put(event);
    });
    return event;
  }

  Future<CalendarEventEntity> save(CalendarEventEntity event) async {
    await _isar.writeTxn(() async {
      await _isar.calendarEventEntitys.put(event);
    });
    return event;
  }

  Future<CalendarEventEntity> update(CalendarEventEntity event) async {
    await _isar.writeTxn(() async {
      await _isar.calendarEventEntitys.put(event);
    });
    return event;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.calendarEventEntitys.delete(id));
  }
}
