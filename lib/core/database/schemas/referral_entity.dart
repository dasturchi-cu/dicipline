import 'package:isar/isar.dart';

part 'referral_entity.g.dart';

/// Taklif/referral qaydi — mukofotlar uchun.
@collection
class ReferralEntity {
  Id id = Isar.autoIncrement;

  /// Foydalanuvchi kiritgan taklif kodi
  @Index()
  late String usedInviteCode;

  late String referredLabel;

  /// partner_connect | share_link | manual
  @Index()
  late String source;

  late int rewardXp;

  bool rewardClaimed = false;

  @Index()
  late DateTime createdAt;

  ReferralEntity();

  ReferralEntity.create({
    required this.usedInviteCode,
    required this.referredLabel,
    this.source = 'partner_connect',
    this.rewardXp = 100,
    this.rewardClaimed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'usedInviteCode': usedInviteCode,
        'referredLabel': referredLabel,
        'source': source,
        'rewardXp': rewardXp,
        'rewardClaimed': rewardClaimed,
        'createdAt': createdAt.toIso8601String(),
      };

  static ReferralEntity fromJson(Map<String, dynamic> json) {
    final entity = ReferralEntity.create(
      usedInviteCode: json['usedInviteCode'] as String,
      referredLabel: json['referredLabel'] as String,
      source: json['source'] as String? ?? 'partner_connect',
      rewardXp: json['rewardXp'] as int? ?? 100,
      rewardClaimed: json['rewardClaimed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
