import 'package:isar/isar.dart';

import '../database/schemas/vision_board_item_entity.dart';

class VisionBoardRepository {
  VisionBoardRepository(this._isar);

  final Isar _isar;

  Stream<List<VisionBoardItemEntity>> watchAll() {
    return _isar.visionBoardItemEntitys
        .where()
        .sortBySortOrder()
        .watch(fireImmediately: true);
  }

  Future<List<VisionBoardItemEntity>> getAll() {
    return _isar.visionBoardItemEntitys.where().sortBySortOrder().findAll();
  }

  Future<VisionBoardItemEntity> save(VisionBoardItemEntity item) async {
    item.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.visionBoardItemEntitys.put(item);
    });
    return item;
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.visionBoardItemEntitys.delete(id);
    });
  }

  Future<void> reorder(List<VisionBoardItemEntity> items) async {
    await _isar.writeTxn(() async {
      for (var i = 0; i < items.length; i++) {
        items[i].sortOrder = i;
        items[i].updatedAt = DateTime.now();
      }
      await _isar.visionBoardItemEntitys.putAll(items);
    });
  }
}
