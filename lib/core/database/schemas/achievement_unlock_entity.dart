import 'package:isar/isar.dart';

part 'achievement_unlock_entity.g.dart';

/// Yutuq ochilishi — doimiy saqlanadi.
@collection
class AchievementUnlockEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String achievementId;

  late DateTime unlockedAt;

  bool celebrated = false;

  AchievementUnlockEntity();

  AchievementUnlockEntity.create({
    required this.achievementId,
    DateTime? unlockedAt,
    this.celebrated = false,
  }) : unlockedAt = unlockedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'achievementId': achievementId,
        'unlockedAt': unlockedAt.toIso8601String(),
        'celebrated': celebrated,
      };

  static AchievementUnlockEntity fromJson(Map<String, dynamic> json) {
    final entity = AchievementUnlockEntity.create(
      achievementId: json['achievementId'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      celebrated: json['celebrated'] as bool? ?? false,
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
