import 'package:isar/isar.dart';

part 'friend_challenge_entity.g.dart';

/// Do'st bilan 1v1 musobaqa.
@collection
class FriendChallengeEntity {
  Id id = Isar.autoIncrement;

  /// streak_duel | task_sprint | habit_race
  @Index()
  late String typeId;

  late String title;

  late String emoji;

  int partnershipId = 0;

  late String partnerName;

  int myScore = 0;

  int partnerScore = 0;

  late int targetScore;

  /// active | completed | cancelled
  @Index()
  late String status;

  late DateTime startedAt;

  late DateTime endsAt;

  String? winnerLabel;

  FriendChallengeEntity();

  FriendChallengeEntity.create({
    required this.typeId,
    required this.title,
    this.emoji = '⚔️',
    required this.partnershipId,
    required this.partnerName,
    required this.targetScore,
    this.status = 'active',
    DateTime? startedAt,
    DateTime? endsAt,
  })  : startedAt = startedAt ?? DateTime.now(),
        endsAt = endsAt ??
            DateTime.now().add(const Duration(days: 7));

  double get myProgress =>
      targetScore > 0 ? (myScore / targetScore).clamp(0.0, 1.0) : 0;

  double get partnerProgress =>
      targetScore > 0 ? (partnerScore / targetScore).clamp(0.0, 1.0) : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'typeId': typeId,
        'title': title,
        'emoji': emoji,
        'partnershipId': partnershipId,
        'partnerName': partnerName,
        'myScore': myScore,
        'partnerScore': partnerScore,
        'targetScore': targetScore,
        'status': status,
        'startedAt': startedAt.toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
        'winnerLabel': winnerLabel,
      };

  static FriendChallengeEntity fromJson(Map<String, dynamic> json) {
    final entity = FriendChallengeEntity.create(
      typeId: json['typeId'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '⚔️',
      partnershipId: json['partnershipId'] as int? ?? 0,
      partnerName: json['partnerName'] as String,
      targetScore: json['targetScore'] as int,
      status: json['status'] as String? ?? 'active',
      startedAt: DateTime.parse(json['startedAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    entity.myScore = json['myScore'] as int? ?? 0;
    entity.partnerScore = json['partnerScore'] as int? ?? 0;
    entity.winnerLabel = json['winnerLabel'] as String?;
    return entity;
  }
}
