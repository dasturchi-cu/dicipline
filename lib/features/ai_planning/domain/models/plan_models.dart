import '../../../../core/database/schemas/plan_entity.dart';

/// Reja bandi (AI yoki foydalanuvchi kiritgan).
class PlanItemDraft {
  const PlanItemDraft({
    required this.title,
    this.emoji = '',
    this.startTime,
    this.durationMinutes = 30,
    this.category = 'general',
  });

  final String title;
  final String emoji;
  final DateTime? startTime;
  final int durationMinutes;
  final String category;

  PlanItemDraft copyWith({
    String? title,
    String? emoji,
    DateTime? startTime,
    int? durationMinutes,
    String? category,
  }) {
    return PlanItemDraft(
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
    );
  }

  PlanItemEmbedded toEmbedded() {
    return PlanItemEmbedded.create(
      title: title,
      emoji: emoji,
      startTime: startTime ?? DateTime.now(),
      durationMinutes: durationMinutes,
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'emoji': emoji,
        'startTime': startTime?.toIso8601String(),
        'durationMinutes': durationMinutes,
        'category': category,
      };

  static PlanItemDraft fromJson(Map<String, dynamic> json) {
    return PlanItemDraft(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      category: json['category'] as String? ?? 'general',
    );
  }
}

enum PlanWarningType {
  overlap,
  missingTime,
  unrealisticDuration,
  tooManyTasks,
  tightSchedule,
}

class PlanWarning {
  const PlanWarning({
    required this.type,
    required this.message,
    this.suggestion,
  });

  final PlanWarningType type;
  final String message;
  final String? suggestion;
}

class GeneratedPlan {
  const GeneratedPlan({
    required this.planDate,
    required this.items,
    this.warnings = const [],
    this.sourceText = '',
  });

  final DateTime planDate;
  final List<PlanItemDraft> items;
  final List<PlanWarning> warnings;
  final String sourceText;

  GeneratedPlan copyWith({
    DateTime? planDate,
    List<PlanItemDraft>? items,
    List<PlanWarning>? warnings,
    String? sourceText,
  }) {
    return GeneratedPlan(
      planDate: planDate ?? this.planDate,
      items: items ?? this.items,
      warnings: warnings ?? this.warnings,
      sourceText: sourceText ?? this.sourceText,
    );
  }

  PlanEntity toEntity() {
    return PlanEntity.create(
      planDate: planDate,
      sourceText: sourceText,
      items: items
          .where((item) => item.startTime != null)
          .map((item) => item.toEmbedded())
          .toList(),
    );
  }
}

class RescheduleSuggestion {
  const RescheduleSuggestion({
    required this.itemTitle,
    required this.originalStart,
    required this.suggestedStart,
    required this.reason,
  });

  final String itemTitle;
  final DateTime originalStart;
  final DateTime suggestedStart;
  final String reason;
}

class LifeScoreBreakdown {
  const LifeScoreBreakdown({
    required this.health,
    required this.learning,
    required this.finance,
    required this.discipline,
    required this.sleep,
    required this.goals,
    required this.overall,
  });

  final int health;
  final int learning;
  final int finance;
  final int discipline;
  final int sleep;
  final int goals;
  final int overall;
}

class DailyReviewReport {
  const DailyReviewReport({
    required this.date,
    required this.completedItems,
    required this.missedItems,
    required this.pendingItems,
    required this.tasksCompleted,
    required this.tasksTotal,
    required this.habitsCompleted,
    required this.habitsTotal,
    required this.longestStreak,
    required this.summary,
    required this.advice,
  });

  final DateTime date;
  final List<String> completedItems;
  final List<String> missedItems;
  final List<String> pendingItems;
  final int tasksCompleted;
  final int tasksTotal;
  final int habitsCompleted;
  final int habitsTotal;
  final int longestStreak;
  final String summary;
  final List<String> advice;
}

class WeeklyReviewReport {
  const WeeklyReviewReport({
    required this.weekStart,
    required this.weekEnd,
    required this.productivityScore,
    required this.studyScore,
    required this.healthScore,
    required this.financeScore,
    required this.goalScore,
    required this.overallScore,
    required this.highlights,
    required this.advice,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final int productivityScore;
  final int studyScore;
  final int healthScore;
  final int financeScore;
  final int goalScore;
  final int overallScore;
  final List<String> highlights;
  final List<String> advice;
}
