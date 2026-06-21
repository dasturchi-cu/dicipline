import 'package:isar/isar.dart';

part 'plan_entity.g.dart';

@embedded
class PlanItemEmbedded {
  late String title;

  late String emoji;

  late DateTime startTime;

  /// Davomiylik daqiqalarda.
  late int durationMinutes;

  late bool isCompleted;

  late bool isMissed;

  late String category;

  PlanItemEmbedded();

  PlanItemEmbedded.create({
    required this.title,
    this.emoji = '',
    required this.startTime,
    this.durationMinutes = 30,
    this.isCompleted = false,
    this.isMissed = false,
    this.category = 'general',
  });

  DateTime get endTime =>
      startTime.add(Duration(minutes: durationMinutes));

  Map<String, dynamic> toJson() => {
        'title': title,
        'emoji': emoji,
        'startTime': startTime.toIso8601String(),
        'durationMinutes': durationMinutes,
        'isCompleted': isCompleted,
        'isMissed': isMissed,
        'category': category,
      };

  static PlanItemEmbedded fromJson(Map<String, dynamic> json) {
    return PlanItemEmbedded.create(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '',
      startTime: DateTime.parse(json['startTime'] as String),
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isMissed: json['isMissed'] as bool? ?? false,
      category: json['category'] as String? ?? 'general',
    );
  }
}

@collection
class PlanEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime planDate;

  late String sourceText;

  List<PlanItemEmbedded> items = [];

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  PlanEntity();

  PlanEntity.create({
    required this.planDate,
    this.sourceText = '',
    List<PlanItemEmbedded>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : items = items ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'planDate': planDate.toIso8601String(),
        'sourceText': sourceText,
        'items': items.map((item) => item.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static PlanEntity fromJson(Map<String, dynamic> json) {
    final entity = PlanEntity.create(
      planDate: DateTime.parse(json['planDate'] as String),
      sourceText: json['sourceText'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PlanItemEmbedded.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
