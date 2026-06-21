import 'package:isar/isar.dart';

import '../constants/app_categories.dart';
import '../database/schemas/document_entity.dart';

class DocumentRepository {
  DocumentRepository(this._isar);

  final Isar _isar;

  Stream<List<DocumentEntity>> watchAll() {
    return _isar.documentEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<DocumentEntity?> getById(int id) {
    return _isar.documentEntitys.get(id);
  }

  Future<List<DocumentEntity>> getAll() {
    return _isar.documentEntitys.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<DocumentEntity>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getAll();
    }

    return _isar.documentEntitys
        .filter()
        .group(
          (q) => q
              .titleContains(trimmed, caseSensitive: false)
              .or()
              .descriptionContains(trimmed, caseSensitive: false),
        )
        .sortByCreatedAtDesc()
        .findAll();
  }

  Stream<List<DocumentEntity>> watchSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return watchAll();
    }

    return _isar.documentEntitys
        .filter()
        .group(
          (q) => q
              .titleContains(trimmed, caseSensitive: false)
              .or()
              .descriptionContains(trimmed, caseSensitive: false),
        )
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<DocumentEntity> create({
    required String title,
    String? description,
    String? type,
  }) async {
    final document = DocumentEntity.create(
      title: title,
      description: description,
      type: type ?? AppCategories.documentOther,
    );
    await _isar.writeTxn(() async {
      await _isar.documentEntitys.put(document);
    });
    return document;
  }

  Future<DocumentEntity> save(DocumentEntity document) async {
    await _isar.writeTxn(() async {
      await _isar.documentEntitys.put(document);
    });
    return document;
  }

  Future<DocumentEntity> update(DocumentEntity document) async {
    await _isar.writeTxn(() async {
      await _isar.documentEntitys.put(document);
    });
    return document;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.documentEntitys.delete(id));
  }
}
