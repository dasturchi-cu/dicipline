import 'package:rejabon_ai/core/database/schemas/coach_conversation_entity.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/database/schemas/twin_profile_entity.dart';
import 'package:rejabon_ai/core/repositories/coach_conversation_repository.dart';
import 'package:rejabon_ai/features/ai_memory/domain/ai_memory_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/life_score_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/life_twin/domain/coach_pattern_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/digital_twin_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/twin_profile_engine.dart';
import 'package:rejabon_ai/core/ai/ai_orchestrator.dart';

/// Life Twin holati — birlashtirilgan profil.
class LifeTwinProfile {
  const LifeTwinProfile({
    required this.lifeScore,
    required this.patternInsights,
    required this.memoryInsights,
    required this.burnout,
    required this.bestDay,
    required this.twinMessage,
    this.twinProfile,
    this.personalitySummary,
  });

  final int lifeScore;
  final List<String> patternInsights;
  final List<String> memoryInsights;
  final BurnoutSignal? burnout;
  final String bestDay;
  final String twinMessage;
  final TwinProfileEntity? twinProfile;
  final String? personalitySummary;
}

/// AI Life Twin — naqshlar + xotira + coach birlashtirilgan.
class LifeTwinService {
  LifeTwinService({
    required CoachConversationRepository conversationRepo,
    required AiMemoryService memoryService,
    required DigitalTwinEngine twinEngine,
    AiService? aiService,
    CoachPatternEngine? patternEngine,
  })  : _conversations = conversationRepo,
        _memory = memoryService,
        _twinEngine = twinEngine,
        _ai = aiService,
        _patterns = patternEngine ?? const CoachPatternEngine();

  final CoachConversationRepository _conversations;
  final AiMemoryService _memory;
  final DigitalTwinEngine _twinEngine;
  final AiService? _ai;
  final CoachPatternEngine _patterns;

  Future<LifeTwinProfile> buildProfile({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
    required LifeScoreBreakdown lifeScore,
  }) async {
    final twinProfile = await _twinEngine.syncProfile(
      tasks: tasks,
      habits: habits,
      goals: goals,
      journal: journal,
      lifeScore: lifeScore.overall,
    );

    final patternInsights = _patterns.buildPatternInsights(
      journal: journal,
      tasks: tasks,
    );
    final memoryInsights = await _memory.getTopInsights(limit: 5);
    final dayProfile = _patterns.analyzeDayOfWeek(tasks);
    final burnout = _patterns.detectBurnout(journal: journal, tasks: tasks);
    final personalitySummary = _buildPersonalitySummary(twinProfile);

    final twinMessage = await _generateTwinMessage(
      lifeScore: lifeScore.overall,
      patterns: patternInsights,
      memories: memoryInsights,
      bestDay: dayProfile.bestDay,
      personality: personalitySummary,
    );

    return LifeTwinProfile(
      lifeScore: lifeScore.overall,
      patternInsights: patternInsights,
      memoryInsights: memoryInsights,
      burnout: burnout,
      bestDay: dayProfile.bestDay,
      twinMessage: twinMessage,
      twinProfile: twinProfile,
      personalitySummary: personalitySummary,
    );
  }

  String _buildPersonalitySummary(TwinProfileEntity profile) {
    final traits = profile.traits;
    final habits = (traits['learnedHabits'] as List?)?.cast<String>() ?? [];
    final goals = (traits['learnedGoals'] as List?)?.cast<String>() ?? [];
    return 'Xronotip: ${profile.chronotype}, '
        'intizom: ${profile.productivityStyle}, '
        'odat barqarorligi: ${profile.habitConsistency}. '
        '${habits.isNotEmpty ? "Kuchli odatlar: ${habits.join(", ")}. " : ""}'
        '${goals.isNotEmpty ? "Maqsadlar: ${goals.join(", ")}." : ""}';
  }

  Future<String> _generateTwinMessage({
    required int lifeScore,
    required List<String> patterns,
    required List<String> memories,
    required String bestDay,
    required String personality,
  }) async {
    final ai = _ai ?? AiService.instance;
    if (ai == null) {
      if (patterns.isNotEmpty) return patterns.first;
      return 'Hayot ballingiz: $lifeScore/100. Davom eting!';
    }

    try {
      final response = await ai.chat(
        systemPrompt:
            'Sen REJABON AI Life Twin san — foydalanuvchining raqamli o\'ziga. '
            '2-3 jumla, o\'zbek tilida, samimiy va aniq bo\'l.',
        prompt: 'Hayot balli: $lifeScore/100\n'
            'Shaxsiyat: $personality\n'
            'Eng yaxshi kun: $bestDay\n'
            'Naqshlar: ${patterns.join("; ")}\n'
            'Xotira: ${memories.join("; ")}',
        maxOutputTokens: 150,
      );
      return response?.trim().isNotEmpty == true
          ? response!.trim()
          : 'Hayot ballingiz: $lifeScore/100.';
    } catch (_) {
      return patterns.isNotEmpty
          ? patterns.first
          : 'Hayot ballingiz: $lifeScore/100.';
    }
  }

  Future<String> chat({
    required String userMessage,
    required LifeTwinProfile profile,
    String inputType = 'text',
  }) async {
    await _conversations.add(
      CoachConversationEntity.create(
        role: 'user',
        message: userMessage,
        inputType: inputType,
        contextType: 'twin_chat',
      ),
    );

    final ai = _ai ?? AiService.instance;
    String reply;
    if (ai == null) {
      reply = profile.twinMessage;
    } else {
      try {
        reply = await ai.chat(
              systemPrompt:
                  'Sen REJABON AI Life Twin murabbiyisan. O\'zbek tilida, '
                  'qisqa va amaliy javob ber.',
              prompt: 'Foydalanuvchi: $userMessage\n\n'
                  'Kontekst: hayot balli ${profile.lifeScore}, '
                  'shaxsiyat: ${profile.personalitySummary ?? ""}, '
                  'naqshlar: ${profile.patternInsights.join("; ")}',
              maxOutputTokens: 250,
            ) ??
            profile.twinMessage;
      } catch (_) {
        reply = profile.twinMessage;
      }
    }

    await _conversations.add(
      CoachConversationEntity.create(
        role: 'coach',
        message: reply,
        inputType: 'text',
        contextType: 'twin_chat',
      ),
    );

    return reply;
  }
}
