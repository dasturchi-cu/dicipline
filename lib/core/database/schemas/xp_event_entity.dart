import 'package:isar/isar.dart';

part 'xp_event_entity.g.dart';

/// XP olish voqeasi — audit va tarix.
@collection
class XpEventEntity {
  Id id = Isar.autoIncrement;

  /// discipline | health | knowledge | wealth | social | spiritual
  @Index()
  late String statType;

  late int amount;

  /// task_complete | habit_streak | workout | journal | quest | goal | study | finance
  @Index()
  late String source;

  String? sourceId;

  String? description;

  @Index()
  late DateTime earnedAt;

  XpEventEntity();

  XpEventEntity.create({
    required this.statType,
    required this.amount,
    required this.source,
    this.sourceId,
    this.description,
    DateTime? earnedAt,
  }) : earnedAt = earnedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'statType': statType,
        'amount': amount,
        'source': source,
        'sourceId': sourceId,
        'description': description,
        'earnedAt': earnedAt.toIso8601String(),
      };

  static XpEventEntity fromJson(Map<String, dynamic> json) {
    final entity = XpEventEntity.create(
      statType: json['statType'] as String,
      amount: json['amount'] as int,
      source: json['source'] as String,
      sourceId: json['sourceId'] as String?,
      description: json['description'] as String?,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
