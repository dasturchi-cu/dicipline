import 'package:isar/isar.dart';

part 'vision_board_item_entity.g.dart';

/// Vizual maqsadlar taxtasi elementi.
@collection
class VisionBoardItemEntity {
  Id id = Isar.autoIncrement;

  late String title;

  String? description;

  late String emoji;

  /// image | text | goal_link
  @Index()
  late String itemType;

  /// goal_link bo'lsa
  int? linkedGoalId;

  /// image bo'lsa — local path
  String? imagePath;

  @Index()
  late int sortOrder;

  late DateTime createdAt;

  late DateTime updatedAt;

  VisionBoardItemEntity();

  VisionBoardItemEntity.create({
    required this.title,
    this.description,
    this.emoji = '✨',
    this.itemType = 'text',
    this.linkedGoalId,
    this.imagePath,
    this.sortOrder = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'emoji': emoji,
        'itemType': itemType,
        'linkedGoalId': linkedGoalId,
        'imagePath': imagePath,
        'sortOrder': sortOrder,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static VisionBoardItemEntity fromJson(Map<String, dynamic> json) {
    final entity = VisionBoardItemEntity.create(
      title: json['title'] as String,
      description: json['description'] as String?,
      emoji: json['emoji'] as String? ?? '✨',
      itemType: json['itemType'] as String? ?? 'text',
      linkedGoalId: json['linkedGoalId'] as int?,
      imagePath: json['imagePath'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
