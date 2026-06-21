import 'package:isar/isar.dart';

import '../database/schemas/inbox_item_entity.dart';

class InboxRepository {
  InboxRepository(this._isar);

  final Isar _isar;

  Stream<List<InboxItemEntity>> watchPending() {
    return _isar.inboxItemEntitys
        .filter()
        .statusEqualTo('pending')
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<InboxItemEntity>> watchAll() {
    return _isar.inboxItemEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<InboxItemEntity>> getPending() {
    return _isar.inboxItemEntitys
        .filter()
        .statusEqualTo('pending')
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<InboxItemEntity>> getAll() {
    return _isar.inboxItemEntitys.where().sortByCreatedAtDesc().findAll();
  }

  Future<InboxItemEntity?> getById(int id) => _isar.inboxItemEntitys.get(id);

  Future<InboxItemEntity> create({
    required String title,
    String body = '',
    required String captureType,
    String? suggestedAction,
    String? sourceUrl,
    String emoji = '📥',
  }) async {
    final item = InboxItemEntity.create(
      title: title,
      body: body,
      captureType: captureType,
      suggestedAction: suggestedAction,
      sourceUrl: sourceUrl,
      emoji: emoji,
    );
    await save(item);
    return item;
  }

  Future<void> save(InboxItemEntity item) async {
    await _isar.writeTxn(() async {
      await _isar.inboxItemEntitys.put(item);
    });
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.inboxItemEntitys.delete(id);
    });
  }

  Future<int> pendingCount() {
    return _isar.inboxItemEntitys.filter().statusEqualTo('pending').count();
  }
}
