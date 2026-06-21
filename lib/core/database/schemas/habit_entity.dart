import 'package:isar/isar.dart';

part 'habit_entity.g.dart';

@collection
class HabitEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String name;

  /// Emoji belgisi
  late String emoji;

  late String icon;

  late int color;

  List<DateTime> completedDates = [];

  @Index()
  late DateTime createdAt;

  HabitEntity();

  HabitEntity.create({
    required this.name,
    this.emoji = '',
    this.icon = 'check_circle',
    this.color = 0xFF6366F1,
    List<DateTime>? completedDates,
    DateTime? createdAt,
  })  : completedDates = completedDates ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'icon': icon,
        'color': color,
        'completedDates':
            completedDates.map((date) => date.toIso8601String()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  static HabitEntity fromJson(Map<String, dynamic> json) {
    final entity = HabitEntity.create(
      name: json['name'] as String,
      emoji: json['emoji'] as String? ?? '',
      icon: json['icon'] as String? ?? 'check_circle',
      color: json['color'] as int? ?? 0xFF6366F1,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
