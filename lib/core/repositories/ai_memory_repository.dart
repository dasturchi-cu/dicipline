import 'package:isar/isar.dart';

import '../database/schemas/ai_memory_entity.dart';

class AiMemoryRepository {
  AiMemoryRepository(this._isar);

  final Isar _isar;

  Stream<List<AiMemoryEntity>> watchAll() {
    return _isar.aiMemoryEntitys
        .where()
        .sortByLastReferencedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<AiMemoryEntity>> getAll() {
    return _isar.aiMemoryEntitys
        .where()
        .sortByLastReferencedAtDesc()
        .findAll();
  }

  Future<List<AiMemoryEntity>> getByCategory(String category) {
    return _isar.aiMemoryEntitys
        .filter()
        .categoryEqualTo(category)
        .sortByConfidenceDesc()
        .findAll();
  }

  Future<List<AiMemoryEntity>> getTop({int limit = 5}) {
    return _isar.aiMemoryEntitys
        .where()
        .sortByConfidenceDesc()
        .limit(limit)
        .findAll();
  }

  Future<AiMemoryEntity?> findSimilar(String category, String insight) async {
    final existing = await _isar.aiMemoryEntitys
        .filter()
        .categoryEqualTo(category)
        .findAll();
    for (final memory in existing) {
      if (memory.insight == insight) return memory;
    }
    return null;
  }

  Future<AiMemoryEntity> upsert({
    required String category,
    required String insight,
    double confidence = 0.8,
  }) async {
    final existing = await findSimilar(category, insight);
    if (existing != null) {
      existing.confidence =
          ((existing.confidence + confidence) / 2).clamp(0.0, 1.0);
      existing.lastReferencedAt = DateTime.now();
      existing.referenceCount++;
      await _isar.writeTxn(() async {
        await _isar.aiMemoryEntitys.put(existing);
      });
      return existing;
    }

    final memory = AiMemoryEntity.create(
      category: category,
      insight: insight,
      confidence: confidence,
    );
    await _isar.writeTxn(() async {
      await _isar.aiMemoryEntitys.put(memory);
    });
    return memory;
  }

  Future<void> markReferenced(int id) async {
    final memory = await _isar.aiMemoryEntitys.get(id);
    if (memory == null) return;
    memory.lastReferencedAt = DateTime.now();
    memory.referenceCount++;
    await _isar.writeTxn(() async {
      await _isar.aiMemoryEntitys.put(memory);
    });
  }

  Future<void> deleteOld({int keepMax = 50}) async {
    final all = await getAll();
    if (all.length <= keepMax) return;
    final toDelete = all.skip(keepMax).map((m) => m.id).toList();
    await _isar.writeTxn(() async {
      await _isar.aiMemoryEntitys.deleteAll(toDelete);
    });
  }
}
