import 'package:rejabon_ai/core/database/schemas/friend_challenge_entity.dart';
import 'package:rejabon_ai/core/database/schemas/partnership_entity.dart';
import 'package:rejabon_ai/core/repositories/friend_challenge_repository.dart';

/// Do'st musobaqasi shabloni.
class FriendChallengeTemplate {
  const FriendChallengeTemplate({
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

class FriendChallengeService {
  FriendChallengeService(this._repo);

  final FriendChallengeRepository _repo;

  static const templates = [
    FriendChallengeTemplate(
      typeId: 'streak_duel',
      title: 'Streak jang',
      emoji: '🔥',
      targetScore: 7,
      description: '7 kun davomida eng uzoq odat streak',
    ),
    FriendChallengeTemplate(
      typeId: 'task_sprint',
      title: 'Vazifa sprint',
      emoji: '⚡',
      targetScore: 10,
      description: '7 kun ichida 10 ta vazifa bajarish',
    ),
    FriendChallengeTemplate(
      typeId: 'habit_race',
      title: 'Odat poygasi',
      emoji: '🏃',
      targetScore: 5,
      description: '5 marta odat bajarish',
    ),
  ];

  Future<FriendChallengeEntity> startChallenge({
    required FriendChallengeTemplate template,
    required PartnershipEntity partner,
  }) async {
    final challenge = FriendChallengeEntity.create(
      typeId: template.typeId,
      title: template.title,
      emoji: template.emoji,
      partnershipId: partner.id,
      partnerName: partner.partnerName,
      targetScore: template.targetScore,
    );
    return _repo.save(challenge);
  }

  Future<FriendChallengeEntity?> incrementMyScore(int challengeId) async {
    final active = await _repo.getActive();
    final challenge = active.cast<FriendChallengeEntity?>().firstWhere(
          (c) => c?.id == challengeId,
          orElse: () => null,
        );
    if (challenge == null) return null;

    challenge.myScore++;
    if (challenge.myScore >= challenge.targetScore) {
      challenge.status = 'completed';
      challenge.winnerLabel = 'Siz';
    }
    return _repo.save(challenge);
  }

  Future<void> syncPartnerProgress({
    required PartnershipEntity partner,
    int bonusPerCheckIn = 1,
  }) async {
    final active = await _repo.getActive();
    for (final challenge in active) {
      if (challenge.partnershipId != partner.id) continue;
      challenge.partnerScore = (partner.checkInCount * bonusPerCheckIn)
          .clamp(0, challenge.targetScore);
      if (challenge.partnerScore >= challenge.targetScore &&
          challenge.myScore < challenge.targetScore) {
        challenge.status = 'completed';
        challenge.winnerLabel = partner.partnerName;
      }
      await _repo.save(challenge);
    }
  }

  Future<void> autoSyncFromActivity({
    required String typeId,
    required int amount,
  }) async {
    final active = await _repo.getActive();
    for (final challenge in active) {
      if (challenge.typeId != typeId) continue;
      challenge.myScore = (challenge.myScore + amount).clamp(0, 999);
      if (challenge.myScore >= challenge.targetScore) {
        challenge.status = 'completed';
        challenge.winnerLabel = 'Siz';
      }
      await _repo.save(challenge);
    }
  }
}
