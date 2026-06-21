import 'package:isar/isar.dart';

import '../database/schemas/future_letter_entity.dart';

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

class FutureLetterRepository {
  FutureLetterRepository(this._isar);

  final Isar _isar;

  Stream<List<FutureLetterEntity>> watchAll() {
    return _isar.futureLetterEntitys
        .where()
        .sortByDeliverAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<FutureLetterEntity>> watchPending() {
    return _isar.futureLetterEntitys
        .filter()
        .deliveredEqualTo(false)
        .sortByDeliverAt()
        .watch(fireImmediately: true);
  }

  Future<List<FutureLetterEntity>> getAll() {
    return _isar.futureLetterEntitys.where().sortByDeliverAtDesc().findAll();
  }

  Future<List<FutureLetterEntity>> getDueForDelivery() async {
    final now = DateTime.now();
    return _isar.futureLetterEntitys
        .filter()
        .deliveredEqualTo(false)
        .deliverAtLessThan(now.add(const Duration(days: 1)))
        .findAll();
  }

  Future<FutureLetterEntity> save(FutureLetterEntity letter) async {
    await _isar.writeTxn(() async {
      await _isar.futureLetterEntitys.put(letter);
    });
    return letter;
  }

  Future<FutureLetterEntity> markDelivered(FutureLetterEntity letter) async {
    letter.delivered = true;
    letter.deliveredAt = DateTime.now();
    return save(letter);
  }

  Future<FutureLetterEntity> markRead(FutureLetterEntity letter) async {
    letter.read = true;
    return save(letter);
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.futureLetterEntitys.delete(id));
  }

  Future<int> countActive() {
    return _isar.futureLetterEntitys.filter().deliveredEqualTo(false).count();
  }
}
