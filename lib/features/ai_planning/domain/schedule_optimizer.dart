import 'models/plan_models.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Kunlik jadvalni optimallashtiradi va muammolarni aniqlaydi.
class ScheduleOptimizer {
  static const int maxRecommendedTasks = 12;
  static const int minGapMinutes = 5;
  static const int maxDailyMinutes = 16 * 60;

  static GeneratedPlan optimize(GeneratedPlan plan) {
    if (plan.items.isEmpty) return plan;

    final sorted = List<PlanItemDraft>.from(plan.items);
    sorted.sort((a, b) {
      final aTime = a.startTime;
      final bTime = b.startTime;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return aTime.compareTo(bTime);
    });

    final filled = _fillMissingTimes(sorted, plan.planDate);
    final warnings = <PlanWarning>[
      ...plan.warnings,
      ...detectIssues(filled),
    ];

    return plan.copyWith(items: filled, warnings: warnings);
  }

  static List<PlanWarning> detectIssues(List<PlanItemDraft> items) {
    final warnings = <PlanWarning>[];
    final scheduled = items.where((item) => item.startTime != null).toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

    if (items.length > maxRecommendedTasks) {
      warnings.add(
        PlanWarning(
          type: PlanWarningType.tooManyTasks,
          message:
              '${items.length} ta band — bu juda ko\'p. Muhimlarini tanlang.',
          suggestion: 'Kamroq vazifa bilan boshlang yoki ba\'zilarini boshqa kunga qoldiring.',
        ),
      );
    }

    final missingTime = items.where((item) => item.startTime == null).length;
    if (missingTime > 0) {
      warnings.add(
        PlanWarning(
          type: PlanWarningType.missingTime,
          message: '$missingTime ta band uchun vaqt aniqlanmagan.',
          suggestion: 'Vaqt ko\'rsatilgan bandlardan keyin avtomatik joylashtirildi.',
        ),
      );
    }

    for (var i = 0; i < scheduled.length; i++) {
      final item = scheduled[i];
      if (item.durationMinutes > 180) {
        warnings.add(
          PlanWarning(
            type: PlanWarningType.unrealisticDuration,
            message:
                '"${item.title}" uchun ${item.durationMinutes} daqiqa — juda uzoq.',
            suggestion: 'Kichik qismlarga bo\'ling yoki tanaffus qo\'shing.',
          ),
        );
      }

      if (i > 0) {
        final prev = scheduled[i - 1];
        final prevEnd = prev.startTime!
            .add(Duration(minutes: prev.durationMinutes));
        final gap = item.startTime!.difference(prevEnd).inMinutes;
        if (gap < 0) {
          warnings.add(
            PlanWarning(
              type: PlanWarningType.overlap,
              message:
                  '"${prev.title}" va "${item.title}" vaqtlari ustma-ust tushmoqda.',
              suggestion: 'Optimallashtirish tugmasini bosing — bandlar qayta joylashtiriladi.',
            ),
          );
        } else if (gap < minGapMinutes) {
          warnings.add(
            PlanWarning(
              type: PlanWarningType.tightSchedule,
              message:
                  '"${item.title}" oldidan faqat $gap daqiqa tanaffus bor.',
              suggestion: 'Bandlar orasiga 10–15 daqiqa tanaffus qoldiring.',
            ),
          );
        }
      }
    }

    final totalMinutes =
        scheduled.fold<int>(0, (sum, item) => sum + item.durationMinutes);
    if (totalMinutes > maxDailyMinutes) {
      warnings.add(
        PlanWarning(
          type: PlanWarningType.unrealisticDuration,
          message:
              'Kunlik reja ${(totalMinutes / 60).toStringAsFixed(1)} soat — juda yuklangan.',
          suggestion: 'Ba\'zi bandlarni ertaga yoki keyingi kunga ko\'chiring.',
        ),
      );
    }

    return warnings;
  }

  static List<PlanItemDraft> resolveOverlaps(List<PlanItemDraft> items) {
    final scheduled = items.where((item) => item.startTime != null).toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));
    final unscheduled =
        items.where((item) => item.startTime == null).toList();

    if (scheduled.isEmpty) return items;

    final resolved = <PlanItemDraft>[scheduled.first];
    for (var i = 1; i < scheduled.length; i++) {
      final prev = resolved.last;
      final current = scheduled[i];
      final prevEnd =
          prev.startTime!.add(Duration(minutes: prev.durationMinutes));
      if (current.startTime!.isBefore(prevEnd.add(const Duration(minutes: minGapMinutes)))) {
        resolved.add(
          current.copyWith(
            startTime: prevEnd.add(const Duration(minutes: minGapMinutes)),
          ),
        );
      } else {
        resolved.add(current);
      }
    }

    return [...resolved, ...unscheduled];
  }

  static List<PlanItemDraft> _fillMissingTimes(
    List<PlanItemDraft> items,
    DateTime planDate,
  ) {
    final day = _normalizeDate(planDate);
    var cursor = DateTime(day.year, day.month, day.day, 7);

    final result = <PlanItemDraft>[];
    for (final item in items) {
      if (item.startTime != null) {
        result.add(item);
        final end = item.startTime!.add(Duration(minutes: item.durationMinutes));
        if (end.isAfter(cursor)) {
          cursor = end.add(const Duration(minutes: minGapMinutes));
        }
      } else {
        result.add(item.copyWith(startTime: cursor));
        cursor = cursor.add(
          Duration(minutes: item.durationMinutes + minGapMinutes),
        );
      }
    }
    return result;
  }
}
