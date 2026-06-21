import 'package:isar/isar.dart';

part 'future_letter_entity.g.dart';

/// Kelajak o'ziga xat — vaqt kapsulasi.
@collection
class FutureLetterEntity {
  Id id = Isar.autoIncrement;

  late String content;

  /// 1m | 3m | 6m | 1y | 5y
  @Index()
  late String deliveryHorizon;

  late DateTime createdAt;

  @Index()
  late DateTime deliverAt;

  bool delivered = false;

  DateTime? deliveredAt;

  bool read = false;

  int moodAtWriting = 3;

  /// JSON snapshot: goals, lifeScore, level
  String? snapshotJson;

  FutureLetterEntity();

  FutureLetterEntity.create({
    required this.content,
    required this.deliveryHorizon,
    required this.deliverAt,
    this.moodAtWriting = 3,
    this.snapshotJson,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'deliveryHorizon': deliveryHorizon,
        'createdAt': createdAt.toIso8601String(),
        'deliverAt': deliverAt.toIso8601String(),
        'delivered': delivered,
        'deliveredAt': deliveredAt?.toIso8601String(),
        'read': read,
        'moodAtWriting': moodAtWriting,
        'snapshotJson': snapshotJson,
      };

  static FutureLetterEntity fromJson(Map<String, dynamic> json) {
    final entity = FutureLetterEntity.create(
      content: json['content'] as String,
      deliveryHorizon: json['deliveryHorizon'] as String,
      deliverAt: DateTime.parse(json['deliverAt'] as String),
      moodAtWriting: json['moodAtWriting'] as int? ?? 3,
      snapshotJson: json['snapshotJson'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    entity.delivered = json['delivered'] as bool? ?? false;
    entity.read = json['read'] as bool? ?? false;
    if (json['deliveredAt'] != null) {
      entity.deliveredAt = DateTime.parse(json['deliveredAt'] as String);
    }
    return entity;
  }
}
