import '../../../core/database/schemas/challenge_entity.dart';
import '../../../core/repositories/challenge_repository.dart';

/// Tayyor musobaqa shabloni.
class ChallengeTemplate {
  const ChallengeTemplate({
    required this.typeId,
    required this.title,
    required this.emoji,
    required this.targetDays,
    required this.description,
  });

  final String typeId;
  final String title;
  final String emoji;
  final int targetDays;
  final String description;
}

/// Musobaqa tizimi — streak, progress, yutuqlar.
class ChallengeService {
  ChallengeService(this._repository);

  final ChallengeRepository _repository;

  static const templates = [
    ChallengeTemplate(
      typeId: 'early_wake_7',
      title: '7 kun erta turish',
      emoji: '🌅',
      targetDays: 7,
      description: 'Har kuni ertalab erta turing va kunni energiya bilan boshlang.',
    ),
    ChallengeTemplate(
      typeId: 'english_30',
      title: '30 kun ingliz tili',
      emoji: '📚',
      targetDays: 30,
      description: 'Har kuni kamida 20 daqiqa ingliz tili o\'rganing.',
    ),
    ChallengeTemplate(
      typeId: 'workout_14',
      title: '14 kun sport',
      emoji: '💪',
      targetDays: 14,
      description: 'Har kuni jismoniy mashq qiling — sog\'lom tan, kuchli ruh.',
    ),
    ChallengeTemplate(
      typeId: 'spending_30',
      title: '30 kun xarajat nazorati',
      emoji: '💰',
      targetDays: 30,
      description: 'Har kuni xarajatlaringizni qayd eting va byudjetga rioya qiling.',
    ),
  ];

  Future<ChallengeEntity> startChallenge(ChallengeTemplate template) async {
    final existing = await _repository.getByType(template.typeId);
    if (existing != null) return existing;

    return _repository.create(
      ChallengeEntity.create(
        typeId: template.typeId,
        title: template.title,
        emoji: template.emoji,
        targetDays: template.targetDays,
      ),
    );
  }

  Future<ChallengeEntity?> markToday(int challengeId) {
    return _repository.markTodayComplete(challengeId);
  }

  Future<List<ChallengeEntity>> getActive() => _repository.getActive();

  ChallengeTemplate? templateFor(ChallengeEntity challenge) {
    for (final t in templates) {
      if (t.typeId == challenge.typeId) return t;
    }
    return null;
  }

  String achievementBadge(ChallengeEntity challenge) {
    if (!challenge.isCompleted) {
      final remaining = challenge.targetDays - challenge.currentDay;
      return '🔥 $remaining kun qoldi';
    }
    return switch (challenge.typeId) {
      'early_wake_7' => '🏅 Erta turuvchi',
      'english_30' => '🎖️ Til ustasi',
      'workout_14' => '🏆 Sport chempioni',
      'spending_30' => '💎 Moliya nazoratchisi',
      _ => '🏆 Musobaqa g\'olibi',
    };
  }
}
