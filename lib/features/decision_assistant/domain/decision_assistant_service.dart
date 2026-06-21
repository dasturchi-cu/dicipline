import 'package:rejabon_ai/core/ai/ai_orchestrator.dart';
import 'package:rejabon_ai/core/database/schemas/coach_conversation_entity.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/coach_conversation_repository.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';

/// Shaxsiylashtirilgan tavsiya.
class DecisionRecommendation {
  const DecisionRecommendation({
    required this.title,
    required this.description,
    required this.category,
    this.actionRoute,
    this.priority = 1,
  });

  final String title;
  final String description;
  final String category;
  final String? actionRoute;
  final int priority;
}

/// AI Decision Assistant — Life Twin bilan quvvatlangan tavsiyalar.
class DecisionAssistantService {
  DecisionAssistantService({
    required CoachConversationRepository conversationRepo,
    AiService? aiService,
  })  : _conversations = conversationRepo,
        _ai = aiService;

  final CoachConversationRepository _conversations;
  final AiService? _ai;

  List<DecisionRecommendation> generateRecommendations({
    required LifeTwinProfile profile,
    required List<GoalEntity> goals,
    required List<TaskEntity> tasks,
    required List<String> memoryInsights,
    LifeTwinAnalysis? twinAnalysis,
  }) {
    final recs = <DecisionRecommendation>[];

    if (profile.burnout != null) {
      recs.add(
        DecisionRecommendation(
          title: 'Burnout signali',
          description: profile.burnout!.message,
          category: 'wellbeing',
          actionRoute: '/hayot/kundalik',
          priority: 0,
        ),
      );
    }

    final overdue = tasks.where((t) {
      if (t.isCompleted || t.dueDate == null) return false;
      return t.dueDate!.isBefore(DateTime.now());
    }).toList();

    if (overdue.isNotEmpty) {
      recs.add(
        DecisionRecommendation(
          title: 'Muddat o\'tgan vazifalar',
          description:
              '${overdue.length} ta vazifa kechikdi. Bugun eng muhimini tanlang.',
          category: 'tasks',
          actionRoute: '/vazifalar',
          priority: 1,
        ),
      );
    }

    for (final goal in goals.where((g) => g.progress < 50).take(2)) {
      recs.add(
        DecisionRecommendation(
          title: 'Maqsad: ${goal.title}',
          description:
              'Progress ${goal.progress.round()}% — kichik qadam qo\'ying.',
          category: 'goals',
          actionRoute: '/hayot/maqsadlar',
          priority: 2,
        ),
      );
    }

    for (final insight in profile.patternInsights.take(2)) {
      recs.add(
        DecisionRecommendation(
          title: 'Naqsh',
          description: insight,
          category: 'patterns',
          priority: 3,
        ),
      );
    }

    for (final memory in memoryInsights.take(2)) {
      recs.add(
        DecisionRecommendation(
          title: 'Xotira',
          description: memory,
          category: 'memory',
          priority: 4,
        ),
      );
    }

    if (profile.twinProfile != null) {
      final tp = profile.twinProfile!;
      if (tp.chronotype == 'morning_person') {
        recs.add(
          const DecisionRecommendation(
            title: 'Tong rejimi',
            description:
                'Eng samarali vaqtingiz tong — muhim vazifalarni ertalab rejalashtiring.',
            category: 'schedule',
            actionRoute: '/reja',
            priority: 2,
          ),
        );
      }
    }

    if (twinAnalysis != null) {
      for (final insight in twinAnalysis.insights.take(2)) {
        recs.add(
          DecisionRecommendation(
            title: insight.headline,
            description: insight.body,
            category: 'twin',
            priority: 2,
          ),
        );
      }
      for (final rec in twinAnalysis.recommendations.take(2)) {
        recs.add(
          DecisionRecommendation(
            title: rec.title,
            description: rec.description,
            category: 'twin_action',
            actionRoute: rec.actionRoute,
            priority: 3,
          ),
        );
      }
      if (twinAnalysis.weaknesses.isNotEmpty) {
        recs.add(
          DecisionRecommendation(
            title: 'Zaif tomon',
            description: twinAnalysis.weaknesses.first,
            category: 'weakness',
            priority: 4,
          ),
        );
      }
    }

    recs.sort((a, b) => a.priority.compareTo(b.priority));
    return recs;
  }

  Future<String> askQuestion({
    required String question,
    required LifeTwinProfile profile,
    required List<GoalEntity> goals,
    required List<CoachConversationEntity> history,
    LifeTwinAnalysis? twinAnalysis,
  }) async {
    await _conversations.add(
      CoachConversationEntity.create(
        role: 'user',
        message: question,
        inputType: 'text',
        contextType: 'decision',
      ),
    );

    final goalContext = goals
        .where((g) => g.progress < 100)
        .map((g) => '${g.title} (${g.progress.round()}%)')
        .join(', ');

    final historyContext = history
        .take(6)
        .map((m) => '${m.role}: ${m.message}')
        .join('\n');

    final ai = _ai ?? AiService.instance;
    String reply;

    if (ai == null) {
      reply = _fallbackAnswer(question, profile, twinAnalysis);
    } else {
      try {
        final twinBlock = twinAnalysis == null
            ? ''
            : '\nPeak vaqt: ${twinAnalysis.peakHoursLabel}\n'
                'O\'rganish uslubi: ${twinAnalysis.learningStyle}\n'
                'Kuchli: ${twinAnalysis.strengths.join(", ")}\n'
                'Zaif: ${twinAnalysis.weaknesses.join(", ")}\n'
                'Twin insight: ${twinAnalysis.insights.isNotEmpty ? twinAnalysis.insights.first.body : ""}';

        reply = await ai.chat(
              systemPrompt:
                  'Sen REJABON AI qaror yordamchisisan. Life Twin ma\'lumotlariga '
                  'asoslanib, o\'zbek tilida aniq va amaliy javob ber. '
                  'Maqsadlarni hisobga ol. Umumiy maslahat berma — shaxsiy ma\'lumotga tayan.',
              prompt: 'Savol: $question\n\n'
                  'Hayot balli: ${profile.lifeScore}\n'
                  'Shaxsiyat: ${profile.personalitySummary ?? ""}\n'
                  'Faol maqsadlar: ${goalContext.isEmpty ? "yo\'q" : goalContext}\n'
                  'Naqshlar: ${profile.patternInsights.join("; ")}\n'
                  '$twinBlock\n'
                  'Tarix:\n$historyContext',
              maxOutputTokens: 300,
            ) ??
            _fallbackAnswer(question, profile, twinAnalysis);
      } catch (_) {
        reply = _fallbackAnswer(question, profile, twinAnalysis);
      }
    }

    await _conversations.add(
      CoachConversationEntity.create(
        role: 'coach',
        message: reply,
        inputType: 'text',
        contextType: 'decision',
      ),
    );

    return reply;
  }

  String _fallbackAnswer(
    String question,
    LifeTwinProfile profile,
    LifeTwinAnalysis? twinAnalysis,
  ) {
    final lower = question.toLowerCase();
    if ((lower.contains('flutter') &&
            (lower.contains('english') || lower.contains('ingliz'))) ||
        (lower.contains('yoki') &&
            (lower.contains('flutter') || lower.contains('ingliz')))) {
      final goals = profile.patternInsights.join(' ').toLowerCase();
      if (twinAnalysis != null && twinAnalysis.learningStyle == 'daily_sessions') {
        return 'Life Twin ma\'lumotlariga ko\'ra, kunlik sessiyalar sizga mos. '
            'Agar maqsadingiz IELTS bo\'lsa, ertalab ${twinAnalysis.peakHoursLabel} '
            'oralig\'ida ingliz tiliga e\'tibor bering; Flutter kechqurun amaliyot uchun.';
      }
      if (goals.contains('ielts') || goals.contains('ingliz')) {
        return 'Maqsadlaringizda til ko\'rinadi — bugun ingliz tiliga 45 daqiqa, '
            'Flutterga 30 daqiqa ajrating.';
      }
      return 'Hayot ballingiz ${profile.lifeScore}/100. '
          'Eng past progressdagi maqsadga e\'tibor bering — u hozir eng muhim.';
    }
    if (lower.contains('maqsad') || lower.contains('goal')) {
      return 'Maqsadlaringizga e\'tibor bering. '
          'Hayot ballingiz ${profile.lifeScore}/100 — kichik qadamlar eng samarali.';
    }
    if (lower.contains('vaqt') || lower.contains('reja')) {
      final peak = twinAnalysis?.peakHoursLabel ?? profile.bestDay;
      return 'Eng yaxshi vaqtingiz $peak. '
          'Muhim vazifalarni shu oralikka rejalashtiring.';
    }
    return profile.twinMessage;
  }
}
