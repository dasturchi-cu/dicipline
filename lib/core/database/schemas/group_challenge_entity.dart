import 'dart:convert';

import 'package:isar/isar.dart';

part 'group_challenge_entity.g.dart';

/// Guruh musobaqasi a'zosi (JSON ichida).
class GroupMember {
  const GroupMember({
    required this.name,
    required this.score,
    this.isMe = false,
  });

  final String name;
  final int score;
  final bool isMe;

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'isMe': isMe,
      };

  static GroupMember fromJson(Map<String, dynamic> json) => GroupMember(
        name: json['name'] as String,
        score: json['score'] as int? ?? 0,
        isMe: json['isMe'] as bool? ?? false,
      );
}

/// Guruh musobaqasi.
@collection
class GroupChallengeEntity {
  Id id = Isar.autoIncrement;

  late String title;

  late String emoji;

  /// team_streak | group_tasks | wellness_week
  @Index()
  late String typeId;

  late int targetScore;

  /// JSON array of GroupMember
  late String membersJson;

  /// active | completed
  @Index()
  late String status;

  late DateTime startedAt;

  late DateTime endsAt;

  int maxMembers = 5;

  GroupChallengeEntity();

  GroupChallengeEntity.create({
    required this.title,
    this.emoji = '👥',
    required this.typeId,
    required this.targetScore,
    required List<GroupMember> members,
    this.status = 'active',
    DateTime? startedAt,
    DateTime? endsAt,
    this.maxMembers = 5,
  })  : membersJson = jsonEncode(members.map((m) => m.toJson()).toList()),
        startedAt = startedAt ?? DateTime.now(),
        endsAt = endsAt ??
            DateTime.now().add(const Duration(days: 7));

  @ignore
  List<GroupMember> get members {
    final decoded = jsonDecode(membersJson);
    if (decoded is! List) return [];
    return decoded
        .cast<Map<String, dynamic>>()
        .map(GroupMember.fromJson)
        .toList();
  }

  void setMembers(List<GroupMember> members) {
    membersJson = jsonEncode(members.map((m) => m.toJson()).toList());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'emoji': emoji,
        'typeId': typeId,
        'targetScore': targetScore,
        'membersJson': membersJson,
        'status': status,
        'startedAt': startedAt.toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
        'maxMembers': maxMembers,
      };

  static GroupChallengeEntity fromJson(Map<String, dynamic> json) {
    final membersRaw = json['membersJson'] is String
        ? jsonDecode(json['membersJson'] as String) as List
        : json['members'] as List? ?? [];
    final entity = GroupChallengeEntity.create(
      title: json['title'] as String,
      emoji: json['emoji'] as String? ?? '👥',
      typeId: json['typeId'] as String,
      targetScore: json['targetScore'] as int,
      members: membersRaw
          .cast<Map<String, dynamic>>()
          .map(GroupMember.fromJson)
          .toList(),
      status: json['status'] as String? ?? 'active',
      startedAt: DateTime.parse(json['startedAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      maxMembers: json['maxMembers'] as int? ?? 5,
    );
    if (json['id'] != null) entity.id = json['id'] as int;
    return entity;
  }
}
