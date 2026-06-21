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

  /// Hayot sohalari: health, learning, finance, family, personal_growth, career
  List<String> lifeAreaIds = [];

  @Index()
  DateTime? dueDate;

  /// none | daily | weekly | monthly
  @Index()
  String recurrenceType = 'none';

  /// Shablon vazifa ID (takroriy nusxalar uchun)
  int? recurrenceTemplateId;

  /// Takroriy shablon bo'lsa — keyingi muddat
  DateTime? nextRecurrenceDate;

  /// Haftalik: 1=Dush..7=Yak (bo'sh = har kuni)
  List<int> recurrenceDays = [];

  /// Bog'langan maqsad (Life Loop — vazifa → maqsad).
  @Index()
  int? goalId;

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
    this.lifeAreaIds = const [],
    this.dueDate,
    this.recurrenceType = 'none',
    this.recurrenceTemplateId,
    this.nextRecurrenceDate,
    this.recurrenceDays = const [],
    this.goalId,
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
        'lifeAreaIds': lifeAreaIds,
        'dueDate': dueDate?.toIso8601String(),
        'recurrenceType': recurrenceType,
        'recurrenceTemplateId': recurrenceTemplateId,
        'nextRecurrenceDate': nextRecurrenceDate?.toIso8601String(),
        'recurrenceDays': recurrenceDays,
        'goalId': goalId,
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
      lifeAreaIds:
          (json['lifeAreaIds'] as List<dynamic>?)?.cast<String>() ?? [],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      recurrenceType: json['recurrenceType'] as String? ?? 'none',
      recurrenceTemplateId: json['recurrenceTemplateId'] as int?,
      nextRecurrenceDate: json['nextRecurrenceDate'] != null
          ? DateTime.parse(json['nextRecurrenceDate'] as String)
          : null,
      recurrenceDays:
          (json['recurrenceDays'] as List<dynamic>?)?.cast<int>() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    entity.goalId = json['goalId'] as int?;
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
