import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/features/ai_planning/domain/ai_planning_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/ai_planning/domain/schedule_optimizer.dart';

void main() {
  group('AiPlanningService rule-based', () {
    final service = AiPlanningService();

    test('parses Uzbek morning routine text', () async {
      final plan = await service.generatePlan(
        input:
            'ertaga 7 da turaman, yuguraman, keyin dush qilaman, nonushta qilaman, 9 gacha kitob o\'qiyman, keyin Flutter o\'rganaman',
      );

      expect(plan.items, isNotEmpty);
      expect(
        plan.items.any((item) => item.title.toLowerCase().contains('yugur')),
        isTrue,
      );
      expect(
        plan.items.any((item) => item.title.toLowerCase().contains('flutter')),
        isTrue,
      );
    });

    test('detects tomorrow from ertaga keyword', () async {
      final plan = await service.generatePlan(
        input: 'ertaga 8 da ish',
      );
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(plan.planDate.year, tomorrow.year);
      expect(plan.planDate.month, tomorrow.month);
      expect(plan.planDate.day, tomorrow.day);
    });

    test('returns warning for empty input', () async {
      final plan = await service.generatePlan(input: '   ');
      expect(plan.items, isEmpty);
      expect(plan.warnings, isNotEmpty);
      expect(plan.warnings.first.type, PlanWarningType.missingTime);
    });
  });

  group('ScheduleOptimizer', () {
    test('detects overlapping items', () {
      final day = DateTime(2026, 6, 21);
      final items = [
        PlanItemDraft(
          title: 'Yugurish',
          startTime: DateTime(day.year, day.month, day.day, 7),
          durationMinutes: 60,
        ),
        PlanItemDraft(
          title: 'Dush',
          startTime: DateTime(day.year, day.month, day.day, 7, 30),
          durationMinutes: 20,
        ),
      ];

      final warnings = ScheduleOptimizer.detectIssues(items);
      expect(
        warnings.any((w) => w.type == PlanWarningType.overlap),
        isTrue,
      );
    });

    test('resolveOverlaps shifts later items', () {
      final day = DateTime(2026, 6, 21);
      final items = [
        PlanItemDraft(
          title: 'Yugurish',
          startTime: DateTime(day.year, day.month, day.day, 7),
          durationMinutes: 60,
        ),
        PlanItemDraft(
          title: 'Dush',
          startTime: DateTime(day.year, day.month, day.day, 7, 30),
          durationMinutes: 20,
        ),
      ];

      final resolved = ScheduleOptimizer.resolveOverlaps(items);
      expect(resolved[1].startTime!.isAfter(resolved[0].startTime!), isTrue);
    });

    test('optimize fills missing times', () {
      final day = DateTime(2026, 6, 21);
      final plan = GeneratedPlan(
        planDate: day,
        items: [
          const PlanItemDraft(title: 'Kitob o\'qish', durationMinutes: 45),
          PlanItemDraft(
            title: 'Mashq',
            startTime: DateTime(day.year, day.month, day.day, 10),
            durationMinutes: 30,
          ),
        ],
      );

      final optimized = ScheduleOptimizer.optimize(plan);
      expect(
        optimized.items.every((item) => item.startTime != null),
        isTrue,
      );
    });
  });
}
