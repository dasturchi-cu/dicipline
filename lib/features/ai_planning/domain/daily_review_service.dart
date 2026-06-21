import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/database/schemas/habit_entity.dart';
import '../../../core/database/schemas/plan_entity.dart';
import '../../../core/database/schemas/task_entity.dart';
import '../../../core/repositories/habit_repository.dart';
import 'models/plan_models.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Kunlik hisobot — bajarilgan va o'tkazib yuborilgan bandlar.
class DailyReviewService {
  DailyReviewService({HabitRepository? habitRepository})
      : _habitRepository = habitRepository;

  final HabitRepository? _habitRepository;

  DailyReviewReport generate({
    required DateTime date,
    PlanEntity? plan,
    required List<TaskEntity> tasks,
    required List<HabitEntity> habits,
    required List<GoalEntity> goals,
  }) {
    final day = _normalizeDate(date);
    final planItems = plan?.items ?? [];

    final completedItems = planItems
        .where((item) => item.isCompleted)
        .map((item) => item.title)
        .toList();
    final missedItems = planItems
        .where((item) => item.isMissed && !item.isCompleted)
        .map((item) => item.title)
        .toList();
    final pendingItems = planItems
        .where((item) => !item.isCompleted && !item.isMissed)
        .map((item) => item.title)
        .toList();

    final dayTasks = tasks.where((task) {
      if (task.dueDate == null) return _isSameDay(task.createdAt, day);
      return _isSameDay(task.dueDate!, day);
    }).toList();

    final tasksCompleted = dayTasks.where((t) => t.isCompleted).length;
    final tasksTotal = dayTasks.length;

    final habitsCompleted = habits
        .where((h) => h.completedDates.any((d) => _isSameDay(d, day)))
        .length;
    final habitsTotal = habits.length;

    var longestStreak = 0;
    for (final habit in habits) {
      final streak = _habitRepository?.calculateStreak(habit) ??
          _streakFromDates(habit);
      if (streak > longestStreak) longestStreak = streak;
    }

    final advice = <String>[];
    if (missedItems.isNotEmpty) {
      advice.add(
        '${missedItems.length} ta band o\'tkazib yuborildi — qayta rejalashtirishni ko\'rib chiqing.',
      );
    }
    if (tasksTotal > 0 && tasksCompleted < tasksTotal) {
      advice.add(
        'Bugun ${tasksTotal - tasksCompleted} ta vazifa hali bajarilmagan.',
      );
    }
    if (habitsTotal > 0 && habitsCompleted < habitsTotal) {
      advice.add('Odatlaringizning bir qismi bajarilmagan — ertaga davom eting.');
    }

    final lowGoals = goals.where((g) => g.progress < 40).take(2);
    for (final goal in lowGoals) {
      advice.add(
        '"${goal.title}" maqsadi ${goal.progress.toStringAsFixed(0)}% — kichik qadam qo\'shing.',
      );
    }

    if (advice.isEmpty) {
      advice.add('Ajoyib kun! Ertaga ham shu intizomni saqlang.');
    }

    final summary = _buildSummary(
      completed: completedItems.length,
      missed: missedItems.length,
      tasksCompleted: tasksCompleted,
      tasksTotal: tasksTotal,
      habitsCompleted: habitsCompleted,
      habitsTotal: habitsTotal,
    );

    return DailyReviewReport(
      date: day,
      completedItems: completedItems,
      missedItems: missedItems,
      pendingItems: pendingItems,
      tasksCompleted: tasksCompleted,
      tasksTotal: tasksTotal,
      habitsCompleted: habitsCompleted,
      habitsTotal: habitsTotal,
      longestStreak: longestStreak,
      summary: summary,
      advice: advice,
    );
  }

  String _buildSummary({
    required int completed,
    required int missed,
    required int tasksCompleted,
    required int tasksTotal,
    required int habitsCompleted,
    required int habitsTotal,
  }) {
    final parts = <String>[];
    if (completed > 0) parts.add('$completed ta reja bandi bajarildi');
    if (missed > 0) parts.add('$missed ta band o\'tkazib yuborildi');
    if (tasksTotal > 0) {
      parts.add('$tasksCompleted/$tasksTotal vazifa bajarildi');
    }
    if (habitsTotal > 0) {
      parts.add('$habitsCompleted/$habitsTotal odat bajarildi');
    }
    return parts.isEmpty ? 'Bugun uchun ma\'lumot yetarli emas.' : parts.join('. ');
  }

  static int _streakFromDates(HabitEntity habit) {
    final dates = habit.completedDates.map(_normalizeDate).toSet();
    if (dates.isEmpty) return 0;

    var current = _normalizeDate(DateTime.now());
    if (!dates.contains(current)) {
      current = current.subtract(const Duration(days: 1));
    }

    var streak = 0;
    while (dates.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
