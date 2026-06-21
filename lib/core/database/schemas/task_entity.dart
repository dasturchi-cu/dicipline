import 'package:isar/isar.dart';

part 'task_entity.g.dart';

@collection
class TaskEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  /// Emoji belgisi (masalan: 💻, 📚)
  late String emoji;

  String? description;

  @Index()
  late bool isCompleted;

  /// 0 = low, 1 = medium, 2 = high
  @Index()
  late int priority;

  @Index()
  late String category;

  @Index()
  DateTime? dueDate;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  TaskEntity();

  TaskEntity.create({
    required this.title,
    this.emoji = '',
    this.description,
    this.isCompleted = false,
    this.priority = 1,
    this.category = 'general',
    this.dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'emoji': emoji,
        'description': description,
        'isCompleted': isCompleted,
        'priority': priority,
        'category': category,
        'dueDate': dueDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static TaskEntity fromJson(Map<String, dynamic> json) {
    final entity = TaskEntity.create(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '',
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: json['priority'] as int? ?? 1,
      category: json['category'] as String? ?? 'general',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
