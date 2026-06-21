import 'dart:math';

import 'package:isar/isar.dart';

import '../database/schemas/partnership_entity.dart';

class PartnershipRepository {
  PartnershipRepository(this._isar);

  final Isar _isar;

  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  Stream<List<PartnershipEntity>> watchAll() {
    return _isar.partnershipEntitys
        .where()
        .sortByConnectedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<PartnershipEntity>> getAll() {
    return _isar.partnershipEntitys.where().sortByConnectedAtDesc().findAll();
  }

  Future<PartnershipEntity?> getByCode(String code) {
    return _isar.partnershipEntitys
        .filter()
        .inviteCodeEqualTo(code.toUpperCase())
        .findFirst();
  }

  Future<String> generateUniqueCode() async {
    final random = Random();
    for (var attempt = 0; attempt < 20; attempt++) {
      final code = List.generate(
        6,
        (_) => _chars[random.nextInt(_chars.length)],
      ).join();
      final existing = await getByCode(code);
      if (existing == null) return code;
    }
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  Future<PartnershipEntity> create(PartnershipEntity partnership) async {
    await _isar.writeTxn(() async {
      await _isar.partnershipEntitys.put(partnership);
    });
    return partnership;
  }

  Future<PartnershipEntity> checkIn(PartnershipEntity partnership) async {
    partnership.lastCheckInAt = DateTime.now();
    partnership.checkInCount++;
    return create(partnership);
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.partnershipEntitys.delete(id));
  }
}
