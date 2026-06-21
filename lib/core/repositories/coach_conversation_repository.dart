import 'package:isar/isar.dart';

import '../database/schemas/coach_conversation_entity.dart';

class CoachConversationRepository {
  CoachConversationRepository(this._isar);

  final Isar _isar;

  Stream<List<CoachConversationEntity>> watchRecent({int limit = 50}) {
    return _isar.coachConversationEntitys
        .where()
        .sortByTimestampDesc()
        .limit(limit)
        .watch(fireImmediately: true);
  }

  Future<List<CoachConversationEntity>> getRecent({int limit = 50}) {
    return _isar.coachConversationEntitys
        .where()
        .sortByTimestampDesc()
        .limit(limit)
        .findAll();
  }

  Stream<List<CoachConversationEntity>> watchByContext(
    String contextType, {
    int limit = 50,
  }) {
    return _isar.coachConversationEntitys
        .filter()
        .contextTypeEqualTo(contextType)
        .sortByTimestampDesc()
        .limit(limit)
        .watch(fireImmediately: true);
  }

  Future<List<CoachConversationEntity>> getByContext(
    String contextType, {
    int limit = 50,
  }) {
    return _isar.coachConversationEntitys
        .filter()
        .contextTypeEqualTo(contextType)
        .sortByTimestampDesc()
        .limit(limit)
        .findAll();
  }

  Future<CoachConversationEntity> add(CoachConversationEntity message) async {
    await _isar.writeTxn(() async {
      await _isar.coachConversationEntitys.put(message);
    });
    return message;
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.coachConversationEntitys.clear();
    });
  }
}
