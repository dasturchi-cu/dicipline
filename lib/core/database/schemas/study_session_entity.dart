import 'package:isar/isar.dart';

part 'study_session_entity.g.dart';

@collection
class StudySessionEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late int subjectId;

  late int durationMinutes;

  @Index()
  late DateTime date;

  String? notes;

  StudySessionEntity();

  StudySessionEntity.create({
    required this.subjectId,
    required this.durationMinutes,
    DateTime? date,
    this.notes,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'durationMinutes': durationMinutes,
        'date': date.toIso8601String(),
        'notes': notes,
      };

  static StudySessionEntity fromJson(Map<String, dynamic> json) {
    final entity = StudySessionEntity.create(
      subjectId: json['subjectId'] as int,
      durationMinutes: json['durationMinutes'] as int,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
