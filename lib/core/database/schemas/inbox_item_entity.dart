import 'package:isar/isar.dart';

part 'inbox_item_entity.g.dart';

@collection
class InboxItemEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash, caseSensitive: false)
  late String title;

  late String body;

  /// note | voice | photo | link | document | idea
  late String captureType;

  /// pending | accepted | processed
  @Index()
  late String status;

  /// task | goal | habit | note | learning | brain
  String? suggestedAction;

  String? sourceUrl;

  late String emoji;

  @Index()
  late DateTime createdAt;

  InboxItemEntity();

  InboxItemEntity.create({
    required this.title,
    this.body = '',
    required this.captureType,
    this.status = 'pending',
    this.suggestedAction,
    this.sourceUrl,
    this.emoji = '📥',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'captureType': captureType,
        'status': status,
        'suggestedAction': suggestedAction,
        'sourceUrl': sourceUrl,
        'emoji': emoji,
        'createdAt': createdAt.toIso8601String(),
      };

  static InboxItemEntity fromJson(Map<String, dynamic> json) {
    final entity = InboxItemEntity.create(
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      captureType: json['captureType'] as String,
      status: json['status'] as String? ?? 'pending',
      suggestedAction: json['suggestedAction'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      emoji: json['emoji'] as String? ?? '📥',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) {
      entity.id = json['id'] as int;
    }
    return entity;
  }
}
