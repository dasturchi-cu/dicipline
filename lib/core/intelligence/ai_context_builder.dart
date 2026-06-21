import '../repositories/ai_memory_repository.dart';
import 'memory_retriever.dart';
import 'models/coach_context.dart';

/// LLM va murabbiy uchun to'liq kontekst bloki.
class AiContextBundle {
  const AiContextBundle({
    required this.systemBlock,
    required this.userBlock,
    required this.memories,
    required this.memoryScore,
  });

  final String systemBlock;
  final String userBlock;
  final List<RetrievedMemory> memories;
  final double memoryScore;
}

/// AI chaqiruvlari uchun kontekst yig'uvchi.
class AiContextBuilder {
  const AiContextBuilder({MemoryRetriever? retriever})
      : _retriever = retriever ?? const MemoryRetriever();

  final MemoryRetriever _retriever;

  Future<AiContextBundle> build({
    required CoachContext coachContext,
    required AiMemoryRepository memoryRepo,
    List<String> keywords = const [],
    String surface = 'coach',
    int memoryLimit = 5,
  }) async {
    final memoryContext = await _retriever.retrieve(
      repository: memoryRepo,
      keywords: keywords,
      limit: memoryLimit,
    );

    final memoryScore = memoryContext.memories.isEmpty
        ? 0.0
        : memoryContext.memories
                .map((m) => m.relevanceScore * 0.6 + m.confidence * 0.4)
                .reduce((a, b) => a + b) /
            memoryContext.memories.length;

    final today = coachContext.today;
    final mood = coachContext.moodTrend;

    final userLines = <String>[
      'Bugun: ${today.tasksDueToday} vazifa, ${today.tasksOverdue} kechikkan, '
          '${today.habitsCompletedToday}/${today.habitsTotal} odat',
      'Inbox: ${today.inboxPending} ta kutmoqda',
      'Kayfiyat 7 kun: ${mood.average7d.toStringAsFixed(1)}/5',
      if (mood.insight.isNotEmpty) mood.insight,
      if (coachContext.patternInsight != null)
        'Naqsh: ${coachContext.patternInsight}',
      if (memoryContext.contextBlock.isNotEmpty)
        'Xotira:\n${memoryContext.contextBlock}',
    ];

    final systemBlock = 'REJABON AI Life OS konteksti (surface: $surface). '
        'Faqat o\'zbek tilida, qisqa va amaliy javob ber. '
        'Quyidagi ma\'lumotlarga tayangan holda tavsiya qil.';

    if (memoryContext.memories.isNotEmpty) {
      await _retriever.markUsed(
        memoryRepo,
        memoryContext.memories.map((m) => m.id).toList(),
      );
    }

    return AiContextBundle(
      systemBlock: systemBlock,
      userBlock: userLines.join('\n'),
      memories: memoryContext.memories,
      memoryScore: memoryScore,
    );
  }

  /// Kalit so'zlarni matndan ajratib oladi.
  List<String> keywordsFromQuery(String query) {
    return query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 3)
        .take(8)
        .toList();
  }
}
