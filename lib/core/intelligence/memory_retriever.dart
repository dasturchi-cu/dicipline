import '../database/schemas/ai_memory_entity.dart';
import '../repositories/ai_memory_repository.dart';

/// AI xotirasidan olingan bitta xotira.
class RetrievedMemory {
  const RetrievedMemory({
    required this.id,
    required this.category,
    required this.insight,
    required this.confidence,
    required this.relevanceScore,
  });

  final int id;
  final String category;
  final String insight;
  final double confidence;
  final double relevanceScore;
}

/// Murabbiy va LLM uchun xotira konteksti.
class MemoryContext {
  const MemoryContext({
    required this.memories,
    required this.contextBlock,
  });

  final List<RetrievedMemory> memories;
  final String contextBlock;

  bool get isEmpty => memories.isEmpty;
}

/// AI xotirasini qidirish va kontekstga yig'ish.
class MemoryRetriever {
  const MemoryRetriever();

  /// Kalit so'z va kategoriya bo'yicha xotiralarni qaytaradi.
  Future<MemoryContext> retrieve({
    required AiMemoryRepository repository,
    List<String> keywords = const [],
    List<String> categories = const [],
    int limit = 5,
  }) async {
    final all = await repository.getAll();
    if (all.isEmpty) {
      return const MemoryContext(memories: [], contextBlock: '');
    }

    final scored = <RetrievedMemory>[];
    for (final memory in all) {
      if (categories.isNotEmpty && !categories.contains(memory.category)) {
        continue;
      }
      final relevance = _score(memory, keywords);
      if (keywords.isNotEmpty && relevance <= 0) continue;
      scored.add(
        RetrievedMemory(
          id: memory.id,
          category: memory.category,
          insight: memory.insight,
          confidence: memory.confidence,
          relevanceScore: relevance,
        ),
      );
    }

    scored.sort((a, b) {
      final scoreA = a.relevanceScore * 0.6 + a.confidence * 0.4;
      final scoreB = b.relevanceScore * 0.6 + b.confidence * 0.4;
      return scoreB.compareTo(scoreA);
    });

    final top = scored.take(limit).toList();
    if (top.isEmpty && keywords.isEmpty) {
      final fallback = all.take(limit).map((m) {
        return RetrievedMemory(
          id: m.id,
          category: m.category,
          insight: m.insight,
          confidence: m.confidence,
          relevanceScore: m.confidence,
        );
      }).toList();
      return MemoryContext(
        memories: fallback,
        contextBlock: _buildBlock(fallback),
      );
    }

    return MemoryContext(
      memories: top,
      contextBlock: _buildBlock(top),
    );
  }

  /// Foydalanuvchi hayoti bo'yicha yangi xotiralar yaratadi.
  Future<void> enrichFromLifeData({
    required AiMemoryRepository repository,
    required int completedTasks,
    required int longestHabitStreak,
    required int journalDays,
    required int studyMinutes,
    required int workoutCount,
    required double avgGoalProgress,
    required double avgMood7d,
    required String? topGoalTitle,
  }) async {
    if (longestHabitStreak >= 7) {
      await repository.upsert(
        category: 'habits',
        insight:
            'Siz $longestHabitStreak kun ketma-ket odatlarni bajaryapsiz — kuchli intizom.',
        confidence: 0.9,
      );
    }
    if (studyMinutes >= 600) {
      final hours = (studyMinutes / 60).round();
      await repository.upsert(
        category: 'learning',
        insight: 'Siz jami $hours soat o\'qigansiz — bilim doimiy o\'smoqda.',
        confidence: 0.85,
      );
    }
    if (completedTasks >= 50) {
      await repository.upsert(
        category: 'productivity',
        insight:
            '$completedTasks ta vazifa bajarildi — siz barqaror harakat qiluvchisiz.',
        confidence: 0.88,
      );
    }
    if (avgMood7d >= 4.0) {
      await repository.upsert(
        category: 'mood',
        insight: 'So\'nggi haftada kayfiyatingiz yuqori — yaxshi energiya.',
        confidence: 0.8,
      );
    } else if (avgMood7d > 0 && avgMood7d <= 2.5) {
      await repository.upsert(
        category: 'mood',
        insight:
            'Kayfiyat past — dam olish va yengil vazifalar muhim.',
        confidence: 0.85,
      );
    }
    if (topGoalTitle != null && avgGoalProgress > 0) {
      await repository.upsert(
        category: 'goals',
        insight:
            '"$topGoalTitle" maqsadi ${avgGoalProgress.round()}% — davom eting.',
        confidence: 0.82,
      );
    }
    if (workoutCount >= 10) {
      await repository.upsert(
        category: 'fitness',
        insight: '$workoutCount ta mashq — sog\'liq ustuvor.',
        confidence: 0.85,
      );
    }
  }

  Future<void> markUsed(AiMemoryRepository repository, List<int> ids) async {
    for (final id in ids) {
      await repository.markReferenced(id);
    }
  }

  double _score(AiMemoryEntity memory, List<String> keywords) {
    if (keywords.isEmpty) return memory.confidence;
    final text = memory.insight.toLowerCase();
    var hits = 0;
    for (final kw in keywords) {
      if (kw.isNotEmpty && text.contains(kw.toLowerCase())) hits++;
    }
    return hits / keywords.length;
  }

  String _buildBlock(List<RetrievedMemory> memories) {
    if (memories.isEmpty) return '';
    return memories.map((m) => '• ${m.insight}').join('\n');
  }
}
