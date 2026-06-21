import 'package:isar/isar.dart';

part 'study_subject_entity.g.dart';

@collection
class StudySubjectEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String name;

  late int color;

  late int totalMinutes;

  late int targetMinutes;

  StudySubjectEntity();

  StudySubjectEntity.create({
    required this.name,
    this.color = 0xFF6366F1,
    this.totalMinutes = 0,
    this.targetMinutes = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'totalMinutes': totalMinutes,
        'targetMinutes': targetMinutes,
      };

  static StudySubjectEntity fromJson(Map<String, dynamic> json) {
    final entity = StudySubjectEntity.create(
      name: json['name'] as String,
      color: json['color'] as int? ?? 0xFF6366F1,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      targetMinutes: json['targetMinutes'] as int? ?? 0,
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
