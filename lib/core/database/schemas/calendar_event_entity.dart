import 'package:isar/isar.dart';

part 'calendar_event_entity.g.dart';

@collection
class CalendarEventEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  String? description;

  @Index()
  late DateTime startTime;

  late DateTime endTime;

  late bool hasReminder;

  late int reminderMinutes;

  CalendarEventEntity();

  CalendarEventEntity.create({
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.hasReminder = false,
    this.reminderMinutes = 15,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'hasReminder': hasReminder,
        'reminderMinutes': reminderMinutes,
      };

  static CalendarEventEntity fromJson(Map<String, dynamic> json) {
    final entity = CalendarEventEntity.create(
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      hasReminder: json['hasReminder'] as bool? ?? false,
      reminderMinutes: json['reminderMinutes'] as int? ?? 15,
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
