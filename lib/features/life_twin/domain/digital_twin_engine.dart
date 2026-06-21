import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/database/schemas/twin_profile_entity.dart';
import 'package:rejabon_ai/core/repositories/ai_memory_repository.dart';
import 'package:rejabon_ai/core/repositories/habit_repository.dart';
import 'package:rejabon_ai/core/repositories/twin_profile_repository.dart';
import 'package:rejabon_ai/features/life_twin/domain/coach_pattern_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/twin_profile_engine.dart';

/// Raqamli ikki — profil, xotira va naqshlarni sinxronlashtiradi.
class DigitalTwinEngine {
  DigitalTwinEngine({
    required TwinProfileRepository profileRepo,
    required AiMemoryRepository memoryRepo,
    HabitRepository? habitRepo,
    CoachPatternEngine? patternEngine,
    TwinProfileEngine? profileEngine,
  })  : _profiles = profileRepo,
        _memory = memoryRepo,
        _patterns = patternEngine ?? const CoachPatternEngine(),
        _profileEngine = profileEngine ??
            TwinProfileEngine(habitRepo: habitRepo);

  final TwinProfileRepository _profiles;
  final AiMemoryRepository _memory;
  final CoachPatternEngine _patterns;
  final TwinProfileEngine _profileEngine;

  Future<TwinProfileEntity> syncProfile({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    required int lifeScore,
  }) async {
    final computed = _profileEngine.compute(
      tasks: tasks,
      habits: habits,
      goals: goals,
      journal: journal,
    );

    final entity = computed.toEntity(lifeScore: lifeScore);
    await _profiles.save(entity);
    await _storeLongTermMemories(
      computed: computed,
      tasks: tasks,
      journal: journal,
    );
    return entity;
  }

  Future<void> _storeLongTermMemories({
    required ComputedTwinProfile computed,
    required List<TaskEntity> tasks,
    required List<JournalEntryEntity> journal,
  }) async {
    await _memory.upsert(
      category: 'personality',
      insight: _chronotypeLabel(computed.chronotype),
      confidence: 0.9,
    );
    await _memory.upsert(
      category: 'habits',
      insight: _habitInsight(computed),
      confidence: 0.85,
    );
    await _memory.upsert(
      category: 'goals',
      insight: _goalInsight(computed),
      confidence: 0.85,
    );

    final patterns = _patterns.buildPatternInsights(
      journal: journal,
      tasks: tasks,
    );
    for (final pattern in patterns.take(2)) {
      await _memory.upsert(
        category: 'productivity',
        insight: pattern,
        confidence: 0.8,
      );
    }

    if (journal.isNotEmpty) {
      await _memory.upsert(
        category: 'mood',
        insight: _moodInsight(computed),
        confidence: 0.82,
      );
    }
  }

  String _chronotypeLabel(String chronotype) => switch (chronotype) {
        'morning_person' => 'Siz ertalabki odamsiz — eng samarali vaqtingiz tong.',
        'night_owl' => 'Siz kechki odamsiz — kechqurun faollik yuqori.',
        _ => 'Siz kun bo\'ylab barqaror faollikka egasiz.',
      };

  String _habitInsight(ComputedTwinProfile computed) {
    if (computed.learnedHabits.isEmpty) {
      return 'Hali odatlar shakllanmagan — kichik odatdan boshlang.';
    }
    return 'Eng kuchli odatlar: ${computed.learnedHabits.join(", ")} '
        '(${computed.habitConsistency} barqarorlik).';
  }

  String _goalInsight(ComputedTwinProfile computed) {
    if (computed.learnedGoals.isEmpty) {
      return 'Faol maqsadlar yo\'q — birinchi maqsadni belgilang.';
    }
    return 'Asosiy maqsadlar: ${computed.learnedGoals.join(", ")} '
        '(${computed.goalOrientation} yo\'nalish).';
  }

  String _moodInsight(ComputedTwinProfile computed) {
    final trend = switch (computed.moodTrend) {
      'improving' => 'yaxshilanmoqda',
      'declining' => 'pasaymoqda',
      'volatile' => 'o\'zgaruvchan',
      _ => 'barqaror',
    };
    return 'Kayfiyat $trend (o\'rtacha ${computed.avgMood.toStringAsFixed(1)}/5).';
  }
}
