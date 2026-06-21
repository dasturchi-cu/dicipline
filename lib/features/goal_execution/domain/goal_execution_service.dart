import 'package:rejabon_ai/core/constants/app_categories.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/plan_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/repositories/goal_repository.dart';
import 'package:rejabon_ai/core/repositories/plan_repository.dart';
import 'package:rejabon_ai/core/repositories/task_repository.dart';
import 'package:rejabon_ai/features/life_twin/domain/life_twin_engine.dart';
import 'package:rejabon_ai/features/life_twin/domain/models/twin_models.dart';

/// Maqsad bajarish natijasi.
class GoalExecutionPlan {
  const GoalExecutionPlan({
    required this.goalId,
    required this.goalTitle,
    required this.milestonesCreated,
    required this.tasksCreated,
    required this.weeklyTasks,
    required this.dailyTasks,
    required this.summary,
  });

  final int goalId;
  final String goalTitle;
  final int milestonesCreated;
  final int tasksCreated;
  final List<String> weeklyTasks;
  final List<String> dailyTasks;
  final String summary;
}

/// Maqsadni avtomatik bajariladigan rejaga aylantiradi.
class GoalExecutionService {
  GoalExecutionService({
    required GoalRepository goalRepo,
    required TaskRepository taskRepo,
    required PlanRepository planRepo,
    LifeTwinEngine? twinEngine,
  })  : _goals = goalRepo,
        _tasks = taskRepo,
        _plans = planRepo,
        _twin = twinEngine ?? LifeTwinEngine();

  final GoalRepository _goals;
  final TaskRepository _tasks;
  final PlanRepository _plans;
  final LifeTwinEngine _twin;

  Future<GoalExecutionPlan> executeGoal({
    required GoalEntity goal,
    LifeTwinAnalysis? twinAnalysis,
  }) async {
    final titleLower = goal.title.toLowerCase();
    final isExam = titleLower.contains('ielts') ||
        titleLower.contains('toefl') ||
        titleLower.contains('sat');
    final isLanguage = titleLower.contains('ingliz') ||
        titleLower.contains('english') ||
        isExam;
    final isTech = titleLower.contains('flutter') ||
        titleLower.contains('dart') ||
        titleLower.contains('dasturlash');

    final milestoneTemplates = _milestoneTemplates(
      goal: goal,
      isExam: isExam,
      isLanguage: isLanguage,
      isTech: isTech,
    );

    var milestonesAdded = 0;
    if (goal.milestones.isEmpty) {
      for (final m in milestoneTemplates) {
        goal.milestones.add(MilestoneEmbedded.create(title: m));
        milestonesAdded++;
      }
    }

    final weeklyTasks = _weeklyTasks(goal, isExam, isLanguage, isTech);
    final dailyTasks = _dailyTasks(goal, isExam, isLanguage, isTech);

    final now = DateTime.now();
    var taskCount = 0;
    var dayOffset = 0;

    for (final daily in dailyTasks) {
      final due = now.add(Duration(days: dayOffset));
      await _createLinkedTask(
        title: daily,
        goalId: goal.id,
        dueDate: due,
        category: isLanguage
            ? AppCategories.taskStudy
            : isTech
                ? AppCategories.taskWork
                : AppCategories.taskGeneral,
        priority: dayOffset == 0 ? 2 : 1,
      );
      taskCount++;
      dayOffset++;
    }

    for (var w = 0; w < weeklyTasks.length; w++) {
      await _createLinkedTask(
        title: weeklyTasks[w],
        goalId: goal.id,
        dueDate: now.add(Duration(days: 7 * (w + 1))),
        category: AppCategories.taskStudy,
        priority: 1,
      );
      taskCount++;
    }

    await _injectTodayPlan(dailyTasks, goal);

    if (goal.progress < 5) goal.progress = 5;
    await _goals.save(goal);

    final styleHint = twinAnalysis?.learningStyle == 'daily_sessions'
        ? ' Kunlik sessiyalar sizga mos.'
        : '';

    return GoalExecutionPlan(
      goalId: goal.id,
      goalTitle: goal.title,
      milestonesCreated: milestonesAdded,
      tasksCreated: taskCount,
      weeklyTasks: weeklyTasks,
      dailyTasks: dailyTasks,
      summary:
          '${goal.title}: $milestonesAdded bosqich, $taskCount vazifa yaratildi.$styleHint',
    );
  }

  Future<void> _createLinkedTask({
    required String title,
    required int goalId,
    required DateTime dueDate,
    required String category,
    required int priority,
  }) async {
    final task = TaskEntity.create(
      title: title,
      category: category,
      priority: priority,
      dueDate: dueDate,
      goalId: goalId,
    );
    await _tasks.save(task);
  }

  Future<void> _injectTodayPlan(List<String> dailyTasks, GoalEntity goal) async {
    if (dailyTasks.isEmpty) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var plan = await _plans.getForDate(today);
    plan ??= PlanEntity.create(planDate: today);

    var cursor = DateTime(today.year, today.month, today.day, 9);
    for (final item in dailyTasks.take(4)) {
      if (plan.items.any((i) => i.title == item)) continue;
      plan.items.add(
        PlanItemEmbedded.create(
          title: item,
          emoji: goal.emoji,
          startTime: cursor,
          durationMinutes: 45,
          category: AppCategories.taskStudy,
        ),
      );
      cursor = cursor.add(const Duration(hours: 1));
    }
    plan.sourceText = 'Goal Execution: ${goal.title}';
    plan.updatedAt = DateTime.now();
    await _plans.save(plan);
  }

  List<String> _milestoneTemplates({
    required GoalEntity goal,
    required bool isExam,
    required bool isLanguage,
    required bool isTech,
  }) {
    if (isExam) {
      return [
        'Boshlang\'ich test (diagnostika)',
        'Listening 6.5+',
        'Reading 6.5+',
        'Writing 6.5+',
        'Speaking 6.5+',
        'Mock exam',
        'IELTS 7.0',
      ];
    }
    if (isLanguage) {
      return [
        'So\'z boyligi 500',
        'Grammatika asoslari',
        'Kundalik suhbat',
        'Tinglab tushunish',
        'Erkin nutq',
      ];
    }
    if (isTech) {
      return [
        'Asosiy tushunchalar',
        'Amaliy loyiha 1',
        'Amaliy loyiha 2',
        'Portfolio tayyor',
      ];
    }
    if (goal.horizon == '1y' || goal.horizon == '5y') {
      return [
        'Reja va resurslar',
        '1-chorak natijasi',
        'Yarim yo\'l tekshiruvi',
        'Yakuniy natija',
      ];
    }
    return [
      'Boshlash',
      '25% progress',
      '50% progress',
      '75% progress',
      'Yakunlash',
    ];
  }

  List<String> _weeklyTasks(
    GoalEntity goal,
    bool isExam,
    bool isLanguage,
    bool isTech,
  ) {
    if (isExam) {
      return [
        'Haftalik mock test',
        'Writing feedback tahlili',
        'Speaking amaliyot (partner)',
      ];
    }
    if (isLanguage) {
      return [
        'Yangi so\'zlar ro\'yxati (50 ta)',
        'Podcast tinglash sessiyasi',
      ];
    }
    if (isTech) {
      return [
        'Haftalik kod review',
        'Yangi feature amaliyot',
      ];
    }
    return [
      '${goal.title} — haftalik tekshiruv',
      'Progress yangilash',
    ];
  }

  List<String> _dailyTasks(
    GoalEntity goal,
    bool isExam,
    bool isLanguage,
    bool isTech,
  ) {
    if (isExam) {
      return [
        'Listening 30 daqiqa',
        'Reading 1 maqola',
        'Writing Task 1',
        'Speaking 15 daqiqa',
      ];
    }
    if (isLanguage) {
      return [
        'So\'z o\'rganish 20 daqiqa',
        'Grammatika mashqi',
        'Tinglash 15 daqiqa',
      ];
    }
    if (isTech) {
      return [
        'Tutorial 45 daqiqa',
        'Kod yozish amaliyot',
      ];
    }
    return [
      '${goal.title} — bugungi qadam',
      'Progress yozuvi',
    ];
  }

  /// Vazifa bajarilganda maqsad progressini yangilaydi.
  Future<void> syncProgressFromTasks({
    required GoalEntity goal,
    required List<TaskEntity> linkedTasks,
  }) async {
    if (linkedTasks.isEmpty) return;
    final done = linkedTasks.where((t) => t.isCompleted).length;
    final rate = (done / linkedTasks.length * 100).clamp(0.0, 100.0);

    for (var i = 0; i < goal.milestones.length; i++) {
      final threshold = ((i + 1) / goal.milestones.length) * 100;
      if (rate >= threshold) {
        goal.milestones[i].isCompleted = true;
      }
    }

    if (rate > goal.progress) {
      goal.progress = rate;
      await _goals.save(goal);
    }
  }
}
