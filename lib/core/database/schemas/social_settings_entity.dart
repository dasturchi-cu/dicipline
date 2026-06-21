import 'package:isar/isar.dart';

part 'social_settings_entity.g.dart';

/// Ijtimoiy maxfiylik va ko'rinish sozlamalari (bitta yozuv).
@collection
class SocialSettingsEntity {
  Id id = Isar.autoIncrement;

  late String displayName;

  bool showOnLeaderboard = true;

  bool shareStreaks = true;

  bool shareAchievements = true;

  bool allowFriendChallenges = true;

  bool allowGroupInvites = true;

  /// Reytingda faqat o'z ismingiz ko'rinadi (boshqalar anonim)
  bool leaderboardUseAlias = false;

  late DateTime updatedAt;

  SocialSettingsEntity();

  SocialSettingsEntity.defaults({String displayName = ''})
      : displayName = displayName,
        updatedAt = DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'showOnLeaderboard': showOnLeaderboard,
        'shareStreaks': shareStreaks,
        'shareAchievements': shareAchievements,
        'allowFriendChallenges': allowFriendChallenges,
        'allowGroupInvites': allowGroupInvites,
        'leaderboardUseAlias': leaderboardUseAlias,
        'updatedAt': updatedAt.toIso8601String(),
      };

  static SocialSettingsEntity fromJson(Map<String, dynamic> json) {
    final entity = SocialSettingsEntity.defaults(
      displayName: json['displayName'] as String? ?? '',
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    entity.showOnLeaderboard = json['showOnLeaderboard'] as bool? ?? true;
    entity.shareStreaks = json['shareStreaks'] as bool? ?? true;
    entity.shareAchievements = json['shareAchievements'] as bool? ?? true;
    entity.allowFriendChallenges =
        json['allowFriendChallenges'] as bool? ?? true;
    entity.allowGroupInvites = json['allowGroupInvites'] as bool? ?? true;
    entity.leaderboardUseAlias =
        json['leaderboardUseAlias'] as bool? ?? false;
    entity.updatedAt = DateTime.parse(json['updatedAt'] as String);
    return entity;
  }
}
