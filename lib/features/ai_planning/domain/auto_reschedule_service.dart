import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/repositories/plan_repository.dart';
import 'models/plan_models.dart';
import 'schedule_optimizer.dart';

/// O'tkazib yuborilgan bandlar uchun qayta rejalashtirish takliflari.
class AutoRescheduleService {
  AutoRescheduleService(this._planRepository);

  final PlanRepository _planRepository;

  Future<List<RescheduleSuggestion>> suggestForToday({
    DateTime? asOf,
  }) async {
    final now = asOf ?? DateTime.now();
    final plan = await _planRepository.getForDate(now);
    if (plan == null) return [];

    await _planRepository.markMissedItems(now);
    final updated = await _planRepository.getForDate(now);
    if (updated == null) return [];

    final missed = updated.items
        .where((item) => item.isMissed && !item.isCompleted)
        .toList();
    if (missed.isEmpty) return [];

    return _buildSuggestions(missed, now, updated);
  }

  Future<PlanEntity?> applySuggestions(
    PlanEntity plan,
    List<RescheduleSuggestion> suggestions,
  ) async {
    if (suggestions.isEmpty) return plan;

    for (final suggestion in suggestions) {
      final index = plan.items.indexWhere(
        (item) =>
            item.title == suggestion.itemTitle &&
            item.startTime == suggestion.originalStart,
      );
      if (index >= 0) {
        plan.items[index].startTime = suggestion.suggestedStart;
        plan.items[index].isMissed = false;
      }
    }

    final optimized = ScheduleOptimizer.resolveOverlaps(
      plan.items
          .map(
            (item) => PlanItemDraft(
              title: item.title,
              emoji: item.emoji,
              startTime: item.startTime,
              durationMinutes: item.durationMinutes,
              category: item.category,
            ),
          )
          .toList(),
    );

    for (var i = 0; i < plan.items.length && i < optimized.length; i++) {
      final draft = optimized[i];
      if (draft.startTime != null) {
        plan.items[i].startTime = draft.startTime!;
      }
    }

    return _planRepository.save(plan);
  }

  List<RescheduleSuggestion> _buildSuggestions(
    List<PlanItemEmbedded> missed,
    DateTime now,
    PlanEntity plan,
  ) {
    final suggestions = <RescheduleSuggestion>[];
    var cursor = now.add(const Duration(minutes: 15));

    final upcomingEnd = plan.items
        .where((item) => !item.isMissed && item.startTime.isAfter(now))
        .fold<DateTime?>(null, (latest, item) {
      final end = item.endTime;
      if (latest == null || end.isAfter(latest)) return end;
      return latest;
    });

    if (upcomingEnd != null && upcomingEnd.isAfter(cursor)) {
      cursor = upcomingEnd.add(const Duration(minutes: 10));
    }

    for (final item in missed) {
      suggestions.add(
        RescheduleSuggestion(
          itemTitle: item.title,
          originalStart: item.startTime,
          suggestedStart: cursor,
          reason: '"${item.title}" o\'tkazib yuborildi — $cursor vaqtiga ko\'chirish mumkin.',
        ),
      );
      cursor = cursor.add(
        Duration(minutes: item.durationMinutes + ScheduleOptimizer.minGapMinutes),
      );
    }

    return suggestions;
  }

  Future<PlanEntity?> moveMissedToTomorrow(DateTime fromDate) async {
    final plan = await _planRepository.getForDate(fromDate);
    if (plan == null) return null;

    final missed = plan.items
        .where((item) => item.isMissed && !item.isCompleted)
        .toList();
    if (missed.isEmpty) return plan;

    final tomorrow = DateTime(
      fromDate.year,
      fromDate.month,
      fromDate.day,
    ).add(const Duration(days: 1));

    var existingTomorrow = await _planRepository.getForDate(tomorrow);
    existingTomorrow ??= PlanEntity.create(planDate: tomorrow);

    var cursor = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      8,
    );

    if (existingTomorrow.items.isNotEmpty) {
      final last = existingTomorrow.items
          .map((item) => item.endTime)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      cursor = last.add(const Duration(minutes: 15));
    }

    for (final item in missed) {
      existingTomorrow.items.add(
        PlanItemEmbedded.create(
          title: item.title,
          emoji: item.emoji,
          startTime: cursor,
          durationMinutes: item.durationMinutes,
          category: item.category,
        ),
      );
      cursor = cursor.add(
        Duration(minutes: item.durationMinutes + 10),
      );
      item.isMissed = false;
      item.isCompleted = true;
    }

    await _planRepository.save(plan);
    return _planRepository.save(existingTomorrow);
  }
}
