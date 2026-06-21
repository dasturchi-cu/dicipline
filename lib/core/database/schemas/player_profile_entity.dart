import 'package:isar/isar.dart';

part 'player_profile_entity.g.dart';

/// Foydalanuvchi RPG profili — bitta yozuv (singleton).
@collection
class PlayerProfileEntity {
  Id id = Isar.autoIncrement;

  int totalXp = 0;

  int level = 1;

  int disciplineXp = 0;

  int healthXp = 0;

  int knowledgeXp = 0;

  int wealthXp = 0;

  int socialXp = 0;

  int spiritualXp = 0;

  String avatarEmoji = '🧙';

  String title = 'Hayot o\'rganuvchisi';

  DateTime? lastXpEarnedAt;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();

  PlayerProfileEntity();

  PlayerProfileEntity.create({
    this.totalXp = 0,
    this.level = 1,
    this.disciplineXp = 0,
    this.healthXp = 0,
    this.knowledgeXp = 0,
    this.wealthXp = 0,
    this.socialXp = 0,
    this.spiritualXp = 0,
    this.avatarEmoji = '🧙',
    this.title = 'Hayot o\'rganuvchisi',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'totalXp': totalXp,
        'level': level,
        'disciplineXp': disciplineXp,
        'healthXp': healthXp,
        'knowledgeXp': knowledgeXp,
        'wealthXp': wealthXp,
        'socialXp': socialXp,
        'spiritualXp': spiritualXp,
        'avatarEmoji': avatarEmoji,
        'title': title,
        'lastXpEarnedAt': lastXpEarnedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static PlayerProfileEntity fromJson(Map<String, dynamic> json) {
    final entity = PlayerProfileEntity.create(
      totalXp: json['totalXp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      disciplineXp: json['disciplineXp'] as int? ?? 0,
      healthXp: json['healthXp'] as int? ?? 0,
      knowledgeXp: json['knowledgeXp'] as int? ?? 0,
      wealthXp: json['wealthXp'] as int? ?? 0,
      socialXp: json['socialXp'] as int? ?? 0,
      spiritualXp: json['spiritualXp'] as int? ?? 0,
      avatarEmoji: json['avatarEmoji'] as String? ?? '🧙',
      title: json['title'] as String? ?? 'Hayot o\'rganuvchisi',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    if (json['lastXpEarnedAt'] != null) {
      entity.lastXpEarnedAt =
          DateTime.parse(json['lastXpEarnedAt'] as String);
    }
    return entity;
  }
}
