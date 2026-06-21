import 'package:isar/isar.dart';

part 'partnership_entity.g.dart';

/// Mahalliy hisob-kitob hamkori (offline-first).
@collection
class PartnershipEntity {
  Id id = Isar.autoIncrement;

  /// 6 belgili taklif kodi
  @Index(unique: true)
  late String inviteCode;

  late String partnerName;

  DateTime connectedAt = DateTime.now();

  bool shareStreaks = true;

  bool shareGoals = true;

  bool shareAchievements = true;

  /// Oxirgi "salom" yuborilgan vaqt
  DateTime? lastCheckInAt;

  int checkInCount = 0;

  PartnershipEntity();

  PartnershipEntity.create({
    required this.inviteCode,
    required this.partnerName,
    DateTime? connectedAt,
    this.shareStreaks = true,
    this.shareGoals = true,
    this.shareAchievements = true,
  }) : connectedAt = connectedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'inviteCode': inviteCode,
        'partnerName': partnerName,
        'connectedAt': connectedAt.toIso8601String(),
        'shareStreaks': shareStreaks,
        'shareGoals': shareGoals,
        'shareAchievements': shareAchievements,
        'lastCheckInAt': lastCheckInAt?.toIso8601String(),
        'checkInCount': checkInCount,
      };

  static PartnershipEntity fromJson(Map<String, dynamic> json) {
    final entity = PartnershipEntity.create(
      inviteCode: json['inviteCode'] as String,
      partnerName: json['partnerName'] as String,
      connectedAt: DateTime.parse(json['connectedAt'] as String),
      shareStreaks: json['shareStreaks'] as bool? ?? true,
      shareGoals: json['shareGoals'] as bool? ?? true,
      shareAchievements: json['shareAchievements'] as bool? ?? true,
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    entity.checkInCount = json['checkInCount'] as int? ?? 0;
    if (json['lastCheckInAt'] != null) {
      entity.lastCheckInAt = DateTime.parse(json['lastCheckInAt'] as String);
    }
    return entity;
  }
}
