import '../../../core/ai/ai_orchestrator.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/monthly_focus_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/plan_repository.dart';
import '../../ai_planning/domain/ai_planning_service.dart';
import '../../ai_planning/domain/models/plan_models.dart';
import '../../ai_planning/domain/schedule_optimizer.dart';

/// "Ertangi kunni yarat" — AI asosida ertangi kun rejasini tuzadi.
class DayBuilderService {
  DayBuilderService({
    required PlanRepository planRepository,
    AiPlanningService? planningService,
    AiService? aiService,
  })  : _plans = planRepository,
        _planning = planningService ?? AiPlanningService(aiService: aiService),
        _aiService = aiService;

  final PlanRepository _plans;
  final AiPlanningService _planning;
  final AiService? _aiService;

  Future<GeneratedPlan> buildTomorrow({
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    MonthlyFocusEntity? monthlyFocus,
    PlanEntity? todayPlan,
  }) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowNorm = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    final ruleBased = _buildRuleBased(
      tomorrow: tomorrowNorm,
      tasks: tasks,
      habits: habits,
      goals: goals,
      monthlyFocus: monthlyFocus,
    );

    final ai = _aiService ?? AiService.instance;
    if (ai == null) {
      return ScheduleOptimizer.optimize(ruleBased);
    }

    try {
      final llmPlan = await _buildWithLlm(
        tomorrow: tomorrowNorm,
        tasks: tasks,
        habits: habits,
        goals: goals,
        monthlyFocus: monthlyFocus,
        todayPlan: todayPlan,
      );
      if (llmPlan != null && llmPlan.items.isNotEmpty) {
        return ScheduleOptimizer.optimize(llmPlan);
      }
    } catch (_) {
      // Qoidaviy rejaga qaytamiz
    }

    return ScheduleOptimizer.optimize(ruleBased);
  }

  Future<GeneratedPlan?> _buildWithLlm({
    required DateTime tomorrow,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    MonthlyFocusEntity? monthlyFocus,
    PlanEntity? todayPlan,
  }) async {
    final ai = _aiService ?? AiService.instance;
    if (ai == null) return null;

    final pendingTasks = tasks
        .where((t) => !t.isCompleted)
        .take(5)
        .map((t) => t.title)
        .join(', ');

    final habitNames = habits.map((h) => h.name).join(', ');
    final focusTitle = monthlyFocus?.focusTitle ?? 'yo\'q';

    final missedToday = todayPlan?.items
            .where((i) => i.isMissed && !i.isCompleted)
            .map((i) => i.title)
            .join(', ') ??
        '';

    final input = StringBuffer()
      ..writeln('Ertangi kun uchun reja yarating.')
      ..writeln('Oylik fokus: $focusTitle')
      ..writeln('Kutilayotgan vazifalar: $pendingTasks')
      ..writeln('Odatlar: $habitNames');
    if (missedToday.isNotEmpty) {
      input.writeln('Bugun o\'tkazilgan: $missedToday');
    }

    return _planning.generatePlan(
      input: input.toString(),
      targetDate: tomorrow,
    );
  }

  GeneratedPlan _buildRuleBased({
    required DateTime tomorrow,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
    MonthlyFocusEntity? monthlyFocus,
  }) {
    final items = <PlanItemDraft>[];
    var cursor = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);

    items.add(
      PlanItemDraft(
        title: 'Ertalab rejasi',
        emoji: '🌅',
        startTime: cursor,
        durationMinutes: 15,
        category: 'general',
      ),
    );
    cursor = cursor.add(const Duration(minutes: 15));

    for (final habit in habits.take(3)) {
      items.add(
        PlanItemDraft(
          title: habit.name,
          emoji: habit.emoji.isNotEmpty ? habit.emoji : '🔥',
          startTime: cursor,
          durationMinutes: 20,
          category: 'health',
        ),
      );
      cursor = cursor.add(const Duration(minutes: 25));
    }

    final pendingTasks = tasks.where((t) => !t.isCompleted).take(3);
    for (final task in pendingTasks) {
      items.add(
        PlanItemDraft(
          title: task.title,
          emoji: task.emoji.isNotEmpty ? task.emoji : '📋',
          startTime: cursor,
          durationMinutes: 45,
          category: 'general',
        ),
      );
      cursor = cursor.add(const Duration(minutes: 50));
    }

    if (monthlyFocus != null) {
      items.add(
        PlanItemDraft(
          title: 'Fokus: ${monthlyFocus.focusTitle}',
          emoji: monthlyFocus.emoji,
          startTime: cursor,
          durationMinutes: 60,
          category: 'learning',
        ),
      );
    } else if (goals.isNotEmpty) {
      final topGoal = goals.reduce((a, b) => a.progress > b.progress ? a : b);
      items.add(
        PlanItemDraft(
          title: 'Maqsad: ${topGoal.title}',
          emoji: topGoal.emoji.isNotEmpty ? topGoal.emoji : '🎯',
          startTime: cursor,
          durationMinutes: 60,
          category: 'learning',
        ),
      );
    }

    items.add(
      PlanItemDraft(
        title: 'Kunlik xulosa',
        emoji: '📝',
        startTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 21),
        durationMinutes: 15,
        category: 'general',
      ),
    );

    return GeneratedPlan(planDate: tomorrow, items: items);
  }

  Future<PlanEntity> savePlan(GeneratedPlan plan) async {
    final entity = plan.toEntity();
    return _plans.upsertForDate(
      planDate: entity.planDate,
      sourceText: entity.sourceText,
      items: entity.items,
    );
  }
}
