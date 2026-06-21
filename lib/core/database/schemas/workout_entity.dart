import 'package:isar/isar.dart';

part 'workout_entity.g.dart';

@collection
class WorkoutEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String exerciseName;

  late int durationMinutes;

  late int caloriesBurned;

  @Index()
  late DateTime date;

  String? notes;

  WorkoutEntity();

  WorkoutEntity.create({
    required this.exerciseName,
    required this.durationMinutes,
    this.caloriesBurned = 0,
    DateTime? date,
    this.notes,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseName': exerciseName,
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  static WorkoutEntity fromJson(Map<String, dynamic> json) {
    final entity = WorkoutEntity.create(
      exerciseName: json['exerciseName'] as String,
      durationMinutes: json['durationMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
