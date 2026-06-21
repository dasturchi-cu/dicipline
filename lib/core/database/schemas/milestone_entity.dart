import 'package:isar/isar.dart';

part 'milestone_entity.g.dart';

@collection
class MilestoneEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  late String emoji;

  String? description;

  /// achievement | goal | learning | finance | health | career | streak
  @Index()
  late String category;

  @Index()
  late DateTime achievedAt;

  late DateTime createdAt;

  MilestoneEntity();

  MilestoneEntity.create({
    required this.title,
    this.emoji = '🏆',
    this.description,
    this.category = 'achievement',
    DateTime? achievedAt,
    DateTime? createdAt,
  })  : achievedAt = achievedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'emoji': emoji,
        'description': description,
        'category': category,
        'achievedAt': achievedAt.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  static MilestoneEntity fromJson(Map<String, dynamic> json) {
    final entity = MilestoneEntity.create(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '🏆',
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'achievement',
      achievedAt: DateTime.parse(json['achievedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
