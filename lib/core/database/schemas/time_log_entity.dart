import 'package:isar/isar.dart';

part 'time_log_entity.g.dart';

@collection
class TimeLogEntity {
  Id id = Isar.autoIncrement;

  /// study | programming | workout | focus | reading
  @Index()
  late String sessionType;

  late int durationSeconds;

  @Index()
  late DateTime startedAt;

  late DateTime endedAt;

  String? label;

  String? notes;

  late bool fromTimer;

  TimeLogEntity();

  TimeLogEntity.create({
    required this.sessionType,
    required this.durationSeconds,
    required this.startedAt,
    required this.endedAt,
    this.label,
    this.notes,
    this.fromTimer = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionType': sessionType,
        'durationSeconds': durationSeconds,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt.toIso8601String(),
        'label': label,
        'notes': notes,
        'fromTimer': fromTimer,
      };

  static TimeLogEntity fromJson(Map<String, dynamic> json) {
    final entity = TimeLogEntity.create(
      sessionType: json['sessionType'] as String,
      durationSeconds: json['durationSeconds'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      label: json['label'] as String?,
      notes: json['notes'] as String?,
      fromTimer: json['fromTimer'] as bool? ?? true,
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
