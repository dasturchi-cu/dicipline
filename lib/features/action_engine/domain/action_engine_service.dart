import 'package:rejabon_ai/core/database/schemas/action_plan_entity.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/journal_entry_entity.dart';
import 'package:rejabon_ai/core/database/schemas/plan_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/action_plan_repository.dart';
import 'package:rejabon_ai/core/repositories/plan_repository.dart';
import 'package:rejabon_ai/features/ai_planning/domain/auto_reschedule_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/life_score_service.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/life_twin/domain/coach_pattern_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_service.dart';

/// AI Action Engine — jadval, reja va tiklanish strategiyalari.
class ActionEngineService {
  ActionEngineService({
    required ActionPlanRepository actionPlanRepo,
    required PlanRepository planRepo,
    AutoRescheduleService? rescheduleService,
    CoachPatternEngine? patternEngine,
  })  : _actions = actionPlanRepo,
        _plans = planRepo,
        _reschedule = rescheduleService ?? AutoRescheduleService(planRepo),
        _patterns = patternEngine ?? const CoachPatternEngine();

  final ActionPlanRepository _actions;
  final PlanRepository _plans;
  final AutoRescheduleService _reschedule;
  final CoachPatternEngine _patterns;

  Future<ActionPlanEntity> adjustSchedule({DateTime? asOf}) async {
    final now = asOf ?? DateTime.now();
    final suggestions = await _reschedule.suggestForToday(asOf: now);
    final plan = await _plans.getForDate(now);

    final actions = suggestions
        .map(
          (s) => {
            'title': s.itemTitle,
            'description': s.reason,
            'suggestedStart': s.suggestedStart.toIso8601String(),
            'type': 'reschedule',
          },
        )
        .toList();

    if (actions.isEmpty && plan != null) {
      actions.add({
        'title': 'Jadval barqaror',
        'description': 'Bugun o\'tkazib yuborilgan bandlar yo\'q.',
        'type': 'info',
      });
    }

    final entity = ActionPlanEntity.create(
      planType: 'schedule_adjust',
      title: 'Jadvalni moslashtirish',
      summary: '${actions.length} ta o\'zgarish taklif qilindi.',
      actions: actions,
    );
    return _actions.save(entity);
  }

  Future<ActionPlanEntity> rebuildPlan({
    required LifeTwinProfile profile,
    required List<TaskEntity> pendingTasks,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var plan = await _plans.getForDate(today);
    plan ??= PlanEntity.create(planDate: today);

    var cursor = DateTime(today.year, today.month, today.day, 9);
    final newItems = <PlanItemEmbedded>[];

    final sorted = pendingTasks
        .where((t) => !t.isCompleted)
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    for (final task in sorted.take(8)) {
      newItems.add(
        PlanItemEmbedded.create(
          title: task.title,
          emoji: task.emoji,
          startTime: cursor,
          durationMinutes: 45,
          category: task.category,
        ),
      );
      cursor = cursor.add(const Duration(hours: 1));
    }

    plan.items = newItems;
    plan.sourceText = 'AI Action Engine — ${DateTime.now().toIso8601String()}';
    plan.updatedAt = DateTime.now();
    await _plans.save(plan);

    final entity = ActionPlanEntity.create(
      planType: 'plan_rebuild',
      title: 'Kunlik reja qayta qurildi',
      summary:
          '${newItems.length} ta vazifa rejalashtirildi. Hayot balli: ${profile.lifeScore}.',
      actions: newItems
          .map(
            (i) => {
              'title': i.title,
              'description':
                  '${i.startTime.hour}:${i.startTime.minute.toString().padLeft(2, "0")} — ${i.durationMinutes} daq',
              'type': 'plan_item',
            },
          )
          .toList(),
    );
    return _actions.save(entity);
  }

  Future<ActionPlanEntity> generateRecoveryPlan({
    required LifeTwinProfile profile,
    required List<JournalEntryEntity> journal,
    required List<TaskEntity> tasks,
  }) async {
    final burnout = profile.burnout ??
        _patterns.detectBurnout(journal: journal, tasks: tasks);

    final actions = <Map<String, dynamic>>[
      {
        'title': 'Yengil kun',
        'description': 'Bugun faqat 2-3 muhim vazifani bajaring.',
        'priority': 1,
        'type': 'recovery',
      },
      {
        'title': 'Dam olish',
        'description': '30 daqiqa telefonssiz vaqt ajrating.',
        'priority': 2,
        'type': 'recovery',
      },
      {
        'title': 'Kundalik',
        'description': 'Kayfiyatingizni yozing — bu tiklanishni tezlashtiradi.',
        'priority': 3,
        'type': 'recovery',
      },
    ];

    if (burnout != null) {
      actions.insert(0, {
        'title': 'Burnout signali',
        'description': burnout.message,
        'priority': 0,
        'type': 'recovery',
      });
    }

    final entity = ActionPlanEntity.create(
      planType: 'recovery',
      title: 'Tiklanish rejasi',
      summary: burnout != null
          ? 'Burnout belgilari aniqlandi — yengil rejim tavsiya etiladi.'
          : 'Profilaktik tiklanish — barqarorlik uchun.',
      actions: actions,
    );
    return _actions.save(entity);
  }

  Future<ActionPlanEntity> generateIntervention({
    required LifeScoreBreakdown breakdown,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
  }) async {
    final actions = <Map<String, dynamic>>[];

    if (breakdown.discipline < 50) {
      actions.add({
        'title': 'Intizom',
        'description':
            'Intizom ${breakdown.discipline}/100 — bugun 1 ta odatni bajaring.',
        'priority': 0,
        'type': 'intervention',
      });
    }
    if (breakdown.health < 50) {
      actions.add({
        'title': 'Sog\'liq',
        'description': 'Sog\'liq balli past — 20 daqiqa harakat qo\'shing.',
        'priority': 1,
        'type': 'intervention',
      });
    }
    if (goals.any((g) => g.progress < 20)) {
      actions.add({
        'title': 'Maqsad',
        'description':
            'Ba\'zi maqsadlar cho\'kmoqda — bittasini tanlab kichik qadam qo\'ying.',
        'priority': 2,
        'type': 'intervention',
      });
    }
    if (habits.isEmpty) {
      actions.add({
        'title': 'Odat',
        'description': 'Odatlar yo\'q — birinchi odatni yarating.',
        'priority': 3,
        'type': 'intervention',
      });
    }

    if (actions.isEmpty) {
      actions.add({
        'title': 'Barqaror',
        'description': 'Jiddiy muammo yo\'q — hozirgi ritmni saqlang.',
        'type': 'intervention',
      });
    }

    final entity = ActionPlanEntity.create(
      planType: 'intervention',
      title: 'Intervensiya strategiyasi',
      summary: '${actions.length} ta harakat tavsiya etildi.',
      actions: actions,
    );
    return _actions.save(entity);
  }

  Future<ActionPlanEntity?> applySchedulePlan(ActionPlanEntity plan) async {
    if (plan.planType != 'schedule_adjust') return null;

    final now = DateTime.now();
    final todayPlan = await _plans.getForDate(now);
    if (todayPlan == null) return plan;

    final suggestions = await _reschedule.suggestForToday(asOf: now);
    await _reschedule.applySuggestions(todayPlan, suggestions);
    return _actions.markApplied(plan);
  }

  Future<List<ActionPlanEntity>> runFullAnalysis({
    required LifeTwinProfile profile,
    required LifeScoreBreakdown breakdown,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    required List<JournalEntryEntity> journal,
  }) async {
    final results = <ActionPlanEntity>[];
    results.add(await adjustSchedule());
    results.add(
      await rebuildPlan(
        profile: profile,
        pendingTasks: tasks.where((t) => !t.isCompleted).toList(),
      ),
    );
    results.add(
      await generateRecoveryPlan(
        profile: profile,
        journal: journal,
        tasks: tasks,
      ),
    );
    results.add(
      await generateIntervention(
        breakdown: breakdown,
        habits: habits,
        goals: goals,
      ),
    );
    return results;
  }
}
