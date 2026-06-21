import '../../../core/ai/ai_orchestrator.dart';
import '../../../core/database/schemas/finance_transaction_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/journal_entry_entity.dart';
import '../../../core/database/schemas/study_session_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/database/schemas/workout_entity.dart';
import '../../../core/repositories/ai_memory_repository.dart';
import '../../../core/repositories/habit_repository.dart';
import '../../analytics/domain/analytics_insight_service.dart';

/// AI xotirasi — foydalanuvchi naqshlarini o'rganadi va saqlaydi.
class AiMemoryService {
  AiMemoryService({
    required AiMemoryRepository memoryRepository,
    HabitRepository? habitRepository,
    AiService? aiService,
  })  : _memory = memoryRepository,
        _habitRepo = habitRepository,
        _aiService = aiService;

  final AiMemoryRepository _memory;
  final HabitRepository? _habitRepo;
  final AiService? _aiService;

  Future<List<String>> getTopInsights({int limit = 3}) async {
    final memories = await _memory.getTop(limit: limit);
    return memories.map((m) => m.insight).toList();
  }

  Future<void> analyzeAndStore({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
    required List<WorkoutEntity> workouts,
    required List<StudySessionEntity> studySessions,
    List<JournalEntryEntity> journal = const [],
  }) async {
    final analytics = AnalyticsInsightService(habitRepository: _habitRepo);
    final insights = analytics.generate(
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
      workouts: workouts,
      studySessions: studySessions,
      journal: journal,
    );

    for (final insight in insights) {
      final category = _categoryName(insight.category);
      await _memory.upsert(
        category: category,
        insight: insight.description,
        confidence: insight.trend == 'up' ? 0.9 : 0.75,
      );
    }

    await _generateLlmMemories(
      tasks: tasks,
      habits: habits,
      goals: goals,
      finance: finance,
    );

    await _memory.deleteOld(keepMax: 40);
  }

  Future<void> _generateLlmMemories({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<FinanceTransactionEntity> finance,
  }) async {
    final ai = _aiService ?? AiService.instance;
    if (ai == null) return;

    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final activeHabits = habits.length;
    final avgGoalProgress = goals.isEmpty
        ? 0.0
        : goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;

    try {
      final response = await ai.chat(
        systemPrompt:
            'Sen REJABON AI xotira tizimisan. Foydalanuvchi haqida 2-3 qisqa '
            'kuzatuv yoz (o\'zbek tilida). Har biri alohida qator. '
            'Masalan: "Siz ertalabki vazifalarni yaxshiroq bajaryapsiz." '
            'Faqat kuzatuvlar, boshqa matn yo\'q.',
        prompt:
            'Vazifalar bajarilgan: $completedTasks\n'
            'Odatlar: $activeHabits\n'
            'O\'rtacha maqsad progress: ${avgGoalProgress.toStringAsFixed(0)}%\n'
            'Moliya tranzaksiyalar: ${finance.length}',
        maxOutputTokens: 200,
      );

      if (response == null || response.trim().isEmpty) return;

      final lines = response
          .split('\n')
          .map((l) => l.trim().replaceAll(RegExp(r'^[-•*]\s*'), ''))
          .where((l) => l.length > 10)
          .take(3);

      for (final line in lines) {
        await _memory.upsert(
          category: 'productivity',
          insight: line,
          confidence: 0.85,
        );
      }
    } catch (_) {
      // Offline — qoidaviy xotira yetarli
    }
  }

  static String _categoryName(InsightCategory category) => switch (category) {
        InsightCategory.productivity => 'productivity',
        InsightCategory.learning => 'learning',
        InsightCategory.fitness => 'fitness',
        InsightCategory.finance => 'finance',
        InsightCategory.habits => 'habits',
        InsightCategory.mood => 'mood',
      };
}
