import 'package:isar/isar.dart';

import '../database/schemas/workout_entity.dart';

DateTime _normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class WorkoutStatistics {
  const WorkoutStatistics({
    required this.totalSessions,
    required this.totalMinutes,
    required this.totalCalories,
    required this.thisWeekSessions,
    required this.thisWeekMinutes,
    required this.thisWeekCalories,
  });

  final int totalSessions;
  final int totalMinutes;
  final int totalCalories;
  final int thisWeekSessions;
  final int thisWeekMinutes;
  final int thisWeekCalories;
}

class WorkoutRepository {
  WorkoutRepository(this._isar);

  final Isar _isar;

  Stream<List<WorkoutEntity>> watchAll() {
    return _isar.workoutEntitys
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<WorkoutEntity?> getById(int id) {
    return _isar.workoutEntitys.get(id);
  }

  Future<List<WorkoutEntity>> getAll() {
    return _isar.workoutEntitys.where().sortByDateDesc().findAll();
  }

  Future<WorkoutStatistics> getStatistics() async {
    final workouts = await getAll();
    final weekStart = _normalizeDate(
      DateTime.now().subtract(const Duration(days: 6)),
    );

    var thisWeekSessions = 0;
    var thisWeekMinutes = 0;
    var thisWeekCalories = 0;

    for (final workout in workouts) {
      final date = _normalizeDate(workout.date);
      if (!date.isBefore(weekStart)) {
        thisWeekSessions++;
        thisWeekMinutes += workout.durationMinutes;
        thisWeekCalories += workout.caloriesBurned;
      }
    }

    return WorkoutStatistics(
      totalSessions: workouts.length,
      totalMinutes: workouts.fold(0, (sum, w) => sum + w.durationMinutes),
      totalCalories: workouts.fold(0, (sum, w) => sum + w.caloriesBurned),
      thisWeekSessions: thisWeekSessions,
      thisWeekMinutes: thisWeekMinutes,
      thisWeekCalories: thisWeekCalories,
    );
  }

  Future<WorkoutEntity> create({
    required String exerciseName,
    required int durationMinutes,
    int caloriesBurned = 0,
    DateTime? date,
    String? notes,
  }) async {
    final workout = WorkoutEntity.create(
      exerciseName: exerciseName,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      date: date,
      notes: notes,
    );
    await _isar.writeTxn(() async {
      await _isar.workoutEntitys.put(workout);
    });
    return workout;
  }

  Future<WorkoutEntity> save(WorkoutEntity workout) async {
    await _isar.writeTxn(() async {
      await _isar.workoutEntitys.put(workout);
    });
    return workout;
  }

  Future<WorkoutEntity> update(WorkoutEntity workout) async {
    await _isar.writeTxn(() async {
      await _isar.workoutEntitys.put(workout);
    });
    return workout;
  }

  Future<bool> delete(int id) async {
    return _isar.writeTxn(() => _isar.workoutEntitys.delete(id));
  }
}
