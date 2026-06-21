import 'package:isar/isar.dart';

import '../database/schemas/habit_entity.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class HabitStatistics {
  const HabitStatistics({
    required this.totalHabits,
    required this.completedToday,
    required this.longestStreak,
    required this.weeklyCompletionRate,
    required this.monthlyCompletionRate,
  });

  final int totalHabits;
  final int completedToday;
  final int longestStreak;
  final double weeklyCompletionRate;
  final double monthlyCompletionRate;
}

class HabitRepository {
  HabitRepository(this._isar);

  final Isar _isar;

  Stream<List<HabitEntity>> watchAll() {
    return _isar.habitEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<HabitEntity?> getById(int id) {
    return _isar.habitEntitys.get(id);
  }

  Future<List<HabitEntity>> getAll() {
    return _isar.habitEntitys.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<HabitEntity>> getIncompleteToday() async {
    final habits = await getAll();
    return habits.where((habit) => !isCompletedToday(habit)).toList();
  }

  bool isCompletedToday(HabitEntity habit) {
    final today = _normalizeDate(DateTime.now());
    return habit.completedDates.any((date) => _isSameDay(date, today));
  }

  int calculateStreak(HabitEntity habit) {
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

  Future<HabitStatistics> getStatistics() async {
    final habits = await getAll();
    if (habits.isEmpty) {
      return const HabitStatistics(
        totalHabits: 0,
        completedToday: 0,
        longestStreak: 0,
        weeklyCompletionRate: 0,
        monthlyCompletionRate: 0,
      );
    }

    final completedToday =
        habits.where((habit) => isCompletedToday(habit)).length;
    final longestStreak = habits
        .map(calculateStreak)
        .fold<int>(0, (max, streak) => streak > max ? streak : max);

    final weekStart = _normalizeDate(
      DateTime.now().subtract(const Duration(days: 6)),
    );
    var expected = 0;
    var completed = 0;
    for (final habit in habits) {
      for (var i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        if (!day.isAfter(DateTime.now())) {
          expected++;
          if (habit.completedDates.any((d) => _isSameDay(d, day))) {
            completed++;
          }
        }
      }
    }

    final weeklyCompletionRate =
        expected == 0 ? 0.0 : (completed / expected) * 100;

    final monthStart = _normalizeDate(
      DateTime.now().subtract(const Duration(days: 29)),
    );
    var monthlyExpected = 0;
    var monthlyCompleted = 0;
    for (final habit in habits) {
      for (var i = 0; i < 30; i++) {
        final day = monthStart.add(Duration(days: i));
        if (!day.isAfter(DateTime.now())) {
          monthlyExpected++;
          if (habit.completedDates.any((d) => _isSameDay(d, day))) {
            monthlyCompleted++;
          }
        }
      }
    }

    final monthlyCompletionRate = monthlyExpected == 0
        ? 0.0
        : (monthlyCompleted / monthlyExpected) * 100;

    return HabitStatistics(
      totalHabits: habits.length,
      completedToday: completedToday,
      longestStreak: longestStreak,
      weeklyCompletionRate: weeklyCompletionRate,
      monthlyCompletionRate: monthlyCompletionRate,
    );
  }

  Future<HabitEntity> create({
    required String name,
    String emoji = '',
    String icon = 'check_circle',
    int color = 0xFF6366F1,
  }) async {
    final habit = HabitEntity.create(
      name: name,
      emoji: emoji,
      icon: icon,
      color: color,
    );
    await _isar.writeTxn(() async {
      await _isar.habitEntitys.put(habit);
    });
    return habit;
  }

  Future<HabitEntity> update(HabitEntity habit) async {
    await _isar.writeTxn(() async {
      await _isar.habitEntitys.put(habit);
    });
    return habit;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.habitEntitys.delete(id));
  }

  Future<HabitEntity> save(HabitEntity habit) => update(habit);

  Future<HabitEntity?> toggleToday(Object habitOrId) async {
    final id = habitOrId is HabitEntity ? habitOrId.id : habitOrId as int;
    final habit = await getById(id);
    if (habit == null) return null;

    final today = _normalizeDate(DateTime.now());
    final hasToday =
        habit.completedDates.any((date) => _isSameDay(date, today));

    if (hasToday) {
      habit.completedDates
          .removeWhere((date) => _isSameDay(date, today));
    } else {
      habit.completedDates.add(today);
    }

    return update(habit);
  }
}
