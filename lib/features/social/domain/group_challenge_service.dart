import 'package:rejabon_ai/core/database/schemas/group_challenge_entity.dart';
import 'package:rejabon_ai/core/repositories/group_challenge_repository.dart';
import 'package:rejabon_ai/features/social/domain/premium_service.dart';

class GroupChallengeTemplate {
  const GroupChallengeTemplate({
    required this.typeId,
    required this.title,
    required this.emoji,
    required this.targetScore,
    required this.description,
  });

  final String typeId;
  final String title;
  final String emoji;
  final int targetScore;
  final String description;
}

class GroupChallengeService {
  GroupChallengeService({
    required GroupChallengeRepository repo,
    required PremiumService premium,
  })  : _repo = repo,
        _premium = premium;

  final GroupChallengeRepository _repo;
  final PremiumService _premium;

  static const templates = [
    GroupChallengeTemplate(
      typeId: 'team_streak',
      title: 'Jamoa streak',
      emoji: '🔥',
      targetScore: 21,
      description: 'Jamoa sifatida 21 kunlik odat',
    ),
    GroupChallengeTemplate(
      typeId: 'group_tasks',
      title: 'Guruh vazifalari',
      emoji: '📋',
      targetScore: 30,
      description: '30 ta vazifa jamoaviy',
    ),
    GroupChallengeTemplate(
      typeId: 'wellness_week',
      title: 'Salomatlik haftasi',
      emoji: '💚',
      targetScore: 14,
      description: '7 kun sog\'lom odatlar',
    ),
  ];

  Future<GroupChallengeEntity> createGroup({
    required GroupChallengeTemplate template,
    required String myName,
    required List<String> memberNames,
  }) async {
    final maxMembers = _premium.maxGroupMembers;
    final names = memberNames.take(maxMembers - 1).toList();

    final members = [
      GroupMember(name: myName.isEmpty ? 'Siz' : myName, score: 0, isMe: true),
      ...names.map((n) => GroupMember(name: n, score: 0)),
    ];

    final challenge = GroupChallengeEntity.create(
      title: template.title,
      emoji: template.emoji,
      typeId: template.typeId,
      targetScore: template.targetScore,
      members: members,
      maxMembers: maxMembers,
    );
    return _repo.save(challenge);
  }

  Future<GroupChallengeEntity?> incrementMyScore(int challengeId) async {
    final all = await _repo.watchAll().first;
    final challenge = all.cast<GroupChallengeEntity?>().firstWhere(
          (c) => c?.id == challengeId,
          orElse: () => null,
        );
    if (challenge == null || challenge.status != 'active') return null;

    final members = challenge.members.map((m) {
      if (m.isMe) {
        return GroupMember(name: m.name, score: m.score + 1, isMe: true);
      }
      return m;
    }).toList();

    challenge.setMembers(members);
    final myScore = members.firstWhere((m) => m.isMe).score;
    if (myScore >= challenge.targetScore) {
      challenge.status = 'completed';
    }
    return _repo.save(challenge);
  }

  int getTeamTotalScore(GroupChallengeEntity challenge) {
    return challenge.members.fold<int>(0, (sum, m) => sum + m.score);
  }
}
