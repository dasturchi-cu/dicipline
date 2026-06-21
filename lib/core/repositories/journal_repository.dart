import 'package:isar/isar.dart';

import '../database/schemas/journal_entry_entity.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class JournalRepository {
  JournalRepository(this._isar);

  final Isar _isar;

  Stream<List<JournalEntryEntity>> watchAll() {
    return _isar.journalEntryEntitys
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<JournalEntryEntity?> getById(int id) {
    return _isar.journalEntryEntitys.get(id);
  }

  Future<List<JournalEntryEntity>> getAll() {
    return _isar.journalEntryEntitys.where().sortByDateDesc().findAll();
  }

  Future<JournalEntryEntity?> getByDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return _isar.journalEntryEntitys
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  Future<JournalEntryEntity?> getToday() {
    return getByDate(DateTime.now());
  }

  Future<JournalEntryEntity> create({
    required DateTime date,
    String content = '',
    int mood = 3,
  }) async {
    final entry = JournalEntryEntity.create(
      date: _normalizeDate(date),
      content: content,
      mood: mood.clamp(1, 5),
    );
    await _isar.writeTxn(() async {
      await _isar.journalEntryEntitys.put(entry);
    });
    return entry;
  }

  Future<JournalEntryEntity> save(JournalEntryEntity entry) async {
    entry.date = _normalizeDate(entry.date);
    entry.mood = entry.mood.clamp(1, 5);
    await _isar.writeTxn(() async {
      await _isar.journalEntryEntitys.put(entry);
    });
    return entry;
  }

  Future<JournalEntryEntity> update(JournalEntryEntity entry) async {
    entry.date = _normalizeDate(entry.date);
    entry.mood = entry.mood.clamp(1, 5);
    await _isar.writeTxn(() async {
      await _isar.journalEntryEntitys.put(entry);
    });
    return entry;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.journalEntryEntitys.delete(id));
  }
}
