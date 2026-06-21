import 'package:isar/isar.dart';

import '../database/schemas/quest_entity.dart';

DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

class QuestRepository {
  QuestRepository(this._isar);

  final Isar _isar;

  Stream<List<QuestEntity>> watchActiveForDate(DateTime date) {
    final norm = _normalize(date);
    return _isar.questEntitys
        .filter()
        .startDateLessThan(norm.add(const Duration(days: 1)), include: true)
        .endDateGreaterThan(norm, include: true)
        .watch(fireImmediately: true);
  }

  Future<List<QuestEntity>> getActiveForDate(DateTime date) async {
    final norm = _normalize(date);
    return _isar.questEntitys
        .filter()
        .startDateLessThan(norm.add(const Duration(days: 1)), include: true)
        .endDateGreaterThan(norm, include: true)
        .findAll();
  }

  Future<List<QuestEntity>> getByTypeAndPeriod({
    required String questType,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _isar.questEntitys
        .filter()
        .questTypeEqualTo(questType)
        .startDateEqualTo(_normalize(startDate))
        .findAll();
  }

  Future<QuestEntity?> findQuest({
    required String questType,
    required String questId,
    required DateTime startDate,
  }) {
    return _isar.questEntitys
        .filter()
        .questTypeEqualTo(questType)
        .questIdEqualTo(questId)
        .startDateEqualTo(_normalize(startDate))
        .findFirst();
  }

  Future<QuestEntity> save(QuestEntity quest) async {
    await _isar.writeTxn(() async {
      await _isar.questEntitys.put(quest);
    });
    return quest;
  }

  Future<QuestEntity> complete(QuestEntity quest) async {
    quest.completed = true;
    quest.completedAt = DateTime.now();
    return save(quest);
  }

  Future<void> deleteExpiredBefore(DateTime date) async {
    final norm = _normalize(date);
    await _isar.writeTxn(() async {
      final expired = await _isar.questEntitys
          .filter()
          .endDateLessThan(norm)
          .findAll();
      for (final q in expired) {
        await _isar.questEntitys.delete(q.id);
      }
    });
  }

  Future<int> countCompleted() {
    return _isar.questEntitys.filter().completedEqualTo(true).count();
  }
}
