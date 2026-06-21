import 'dart:convert';

import '../../../core/ai/ai_orchestrator.dart';
import '../../../core/utils/date_format.dart';
import 'models/plan_models.dart';
import 'schedule_optimizer.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Tabiiy o'zbek tilidagi matndan kunlik reja yaratadi (LLM + qoida asosida).
class AiPlanningService {
  AiPlanningService({AiService? aiService}) : _aiService = aiService;

  final AiService? _aiService;

  Future<GeneratedPlan> generatePlan({
    required String input,
    DateTime? targetDate,
  }) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return GeneratedPlan(
        planDate: targetDate ?? _normalizeDate(DateTime.now()),
        items: const [],
        warnings: const [
          PlanWarning(
            type: PlanWarningType.missingTime,
            message: 'Reja matni bo\'sh.',
            suggestion: 'Nima qilmoqchi ekanligingizni yozing yoki gapiring.',
          ),
        ],
      );
    }

    final planDate = targetDate ?? _detectPlanDate(trimmed);
    final llmPlan = await _generateWithLlm(trimmed, planDate);
    if (llmPlan != null && llmPlan.items.isNotEmpty) {
      return ScheduleOptimizer.optimize(
        llmPlan.copyWith(sourceText: trimmed),
      );
    }

    final ruleBased = _generateRuleBased(trimmed, planDate);
    return ScheduleOptimizer.optimize(
      ruleBased.copyWith(sourceText: trimmed),
    );
  }

  Future<GeneratedPlan?> _generateWithLlm(String input, DateTime planDate) async {
    final ai = _aiService ?? AiService.instance;
    if (ai == null) return null;

    final dateStr = AppDateFormat.formatDate(planDate);
    try {
      final response = await ai.chat(
        systemPrompt:
            'Sen REJABON AI rejalashtirish yordamchisisan. Faqat JSON qaytaring. '
            'O\'zbek tilida band nomlari. Format: '
            '{"items":[{"title":"...","emoji":"...","hour":7,"minute":0,'
            '"durationMinutes":30,"category":"health|learning|general|meal"}]}',
        prompt:
            'Reja sanasi: $dateStr\nFoydalanuvchi matni: $input\n'
            'Vaqt va davomiylikni taxmin qiling. Emoji qo\'shing.',
        maxOutputTokens: 800,
      );

      if (response == null || response.trim().isEmpty) return null;
      return _parseLlmResponse(response, planDate);
    } catch (_) {
      return null;
    }
  }

  GeneratedPlan? _parseLlmResponse(String response, DateTime planDate) {
    final jsonStart = response.indexOf('{');
    final jsonEnd = response.lastIndexOf('}');
    if (jsonStart < 0 || jsonEnd <= jsonStart) return null;

    try {
      final decoded =
          jsonDecode(response.substring(jsonStart, jsonEnd + 1)) as Map<String, dynamic>;
      final itemsJson = decoded['items'] as List<dynamic>? ?? [];
      final day = _normalizeDate(planDate);
      final items = <PlanItemDraft>[];

      for (final raw in itemsJson) {
        if (raw is! Map) continue;
        final map = Map<String, dynamic>.from(raw);
        final title = map['title'] as String?;
        if (title == null || title.isEmpty) continue;

        final hour = (map['hour'] as num?)?.toInt() ?? 7;
        final minute = (map['minute'] as num?)?.toInt() ?? 0;
        items.add(
          PlanItemDraft(
            title: title,
            emoji: map['emoji'] as String? ?? _emojiForTitle(title),
            startTime: DateTime(day.year, day.month, day.day, hour, minute),
            durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 30,
            category: map['category'] as String? ?? 'general',
          ),
        );
      }

      if (items.isEmpty) return null;
      return GeneratedPlan(planDate: day, items: items);
    } catch (_) {
      return null;
    }
  }

  static GeneratedPlan _generateRuleBased(String input, DateTime planDate) {
    final day = _normalizeDate(planDate);
    final lower = input.toLowerCase();
    final segments = _splitSegments(input);
    final items = <PlanItemDraft>[];
    var cursor = DateTime(day.year, day.month, day.day, 7);

    for (final segment in segments) {
      final parsed = _parseSegment(segment.trim(), day, cursor);
      if (parsed == null) continue;
      items.add(parsed);
      cursor = (parsed.startTime ?? cursor)
          .add(Duration(minutes: parsed.durationMinutes + 5));
    }

    if (items.isEmpty) {
      for (final keyword in _activityKeywords.entries) {
        if (lower.contains(keyword.key)) {
          items.add(
            PlanItemDraft(
              title: keyword.value.$1,
              emoji: keyword.value.$2,
              startTime: cursor,
              durationMinutes: keyword.value.$3,
              category: keyword.value.$4,
            ),
          );
          cursor = cursor.add(Duration(minutes: keyword.value.$3 + 10));
        }
      }
    }

    return GeneratedPlan(planDate: day, items: items);
  }

  static List<String> _splitSegments(String input) {
    final normalized = input
        .replaceAll(RegExp(r'\s+va\s+', caseSensitive: false), ',')
        .replaceAll(RegExp(r'\s+keyin\s+', caseSensitive: false), ',')
        .replaceAll(RegExp(r"\s+so'ng\s+", caseSensitive: false), ',');
    return normalized
        .split(RegExp(r'[,;.]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static PlanItemDraft? _parseSegment(
    String segment,
    DateTime day,
    DateTime fallbackCursor,
  ) {
    if (segment.isEmpty) return null;

    final lower = segment.toLowerCase();
    String? activityKey;
    for (final key in _activityKeywords.keys) {
      if (lower.contains(key)) {
        activityKey = key;
        break;
      }
    }

    final activity = activityKey != null
        ? _activityKeywords[activityKey]!
        : (segment, '📌', 30, 'general');

    final time = _extractTime(segment, day) ?? fallbackCursor;
    return PlanItemDraft(
      title: activity.$1,
      emoji: activity.$2,
      startTime: time,
      durationMinutes: activity.$3,
      category: activity.$4,
    );
  }

  static DateTime? _extractTime(String text, DateTime day) {
    final clockMatch = RegExp(r'(\d{1,2})[:\.](\d{2})').firstMatch(text);
    if (clockMatch != null) {
      final hour = int.parse(clockMatch.group(1)!);
      final minute = int.parse(clockMatch.group(2)!);
      return DateTime(day.year, day.month, day.day, hour, minute);
    }

    final daMatch = RegExp(r'(\d{1,2})\s*da\b').firstMatch(text.toLowerCase());
    if (daMatch != null) {
      final hour = int.parse(daMatch.group(1)!);
      return DateTime(day.year, day.month, day.day, hour);
    }

    final gachaMatch =
        RegExp(r'(\d{1,2})\s*gacha').firstMatch(text.toLowerCase());
    if (gachaMatch != null) {
      final hour = int.parse(gachaMatch.group(1)!);
      return DateTime(day.year, day.month, day.day, hour - 1);
    }

    return null;
  }

  static DateTime _detectPlanDate(String input) {
    final lower = input.toLowerCase();
    final today = _normalizeDate(DateTime.now());
    if (lower.contains('ertaga')) {
      return today.add(const Duration(days: 1));
    }
    if (lower.contains('kecha')) {
      return today.subtract(const Duration(days: 1));
    }
    return today;
  }

  static String _emojiForTitle(String title) {
    final lower = title.toLowerCase();
    for (final entry in _activityKeywords.entries) {
      if (lower.contains(entry.key)) return entry.value.$2;
    }
    return '📌';
  }

  /// (title, emoji, durationMinutes, category)
  static const Map<String, (String, String, int, String)> _activityKeywords = {
    'uyg\'on': ('Uyg\'onish', '⏰', 10, 'general'),
    'tur': ('Uyg\'onish', '⏰', 10, 'general'),
    'yugur': ('Yugurish', '🏃', 40, 'health'),
    'dush': ('Dush', '🚿', 20, 'health'),
    'nonushta': ('Nonushta', '🍳', 25, 'meal'),
    'tushlik': ('Tushlik', '🍽️', 30, 'meal'),
    'kechki ovqat': ('Kechki ovqat', '🍽️', 30, 'meal'),
    'kitob': ('Kitob o\'qish', '📚', 60, 'learning'),
    'o\'qi': ('O\'qish', '📚', 60, 'learning'),
    'flutter': ('Flutter o\'rganish', '💻', 90, 'learning'),
    'dasturlash': ('Dasturlash', '💻', 90, 'learning'),
    'mashq': ('Jismoniy mashq', '💪', 45, 'health'),
    'meditatsiya': ('Meditatsiya', '🧘', 15, 'health'),
    'uyqu': ('Uyqu', '😴', 480, 'sleep'),
    'ish': ('Ish', '💼', 120, 'general'),
    'dam olish': ('Dam olish', '☕', 20, 'general'),
    'xarid': ('Xarid', '🛒', 60, 'general'),
  };
}
