import 'package:isar/isar.dart';

import '../database/schemas/note_entity.dart';

class NoteRepository {
  NoteRepository(this._isar);

  final Isar _isar;

  Stream<List<NoteEntity>> watchAll() {
    return _isar.noteEntitys
        .where()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<NoteEntity?> getById(int id) {
    return _isar.noteEntitys.get(id);
  }

  Future<List<NoteEntity>> getAll() {
    return _isar.noteEntitys.where().sortByUpdatedAtDesc().findAll();
  }

  Future<List<NoteEntity>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getAll();
    }

    return _isar.noteEntitys
        .filter()
        .group(
          (q) => q
              .titleContains(trimmed, caseSensitive: false)
              .or()
              .contentContains(trimmed, caseSensitive: false),
        )
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Stream<List<NoteEntity>> watchSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return watchAll();
    }

    return _isar.noteEntitys
        .filter()
        .group(
          (q) => q
              .titleContains(trimmed, caseSensitive: false)
              .or()
              .contentContains(trimmed, caseSensitive: false),
        )
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<NoteEntity> create({
    required String title,
    required String content,
    List<String>? tags,
    String itemType = 'note',
    String? sourceUrl,
    String category = 'umumiy',
  }) async {
    final note = NoteEntity.create(
      title: title,
      content: content,
      tags: tags,
      itemType: itemType,
      sourceUrl: sourceUrl,
      category: category,
    );
    await _isar.writeTxn(() async {
      await _isar.noteEntitys.put(note);
    });
    return note;
  }

  Future<NoteEntity> save(NoteEntity note) async {
    note.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.noteEntitys.put(note);
    });
    return note;
  }

  Future<NoteEntity> update(NoteEntity note) async {
    note.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.noteEntitys.put(note);
    });
    return note;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.noteEntitys.delete(id));
  }
}
