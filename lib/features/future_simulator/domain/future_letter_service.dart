import 'dart:convert';

import '../../../core/database/schemas/future_letter_entity.dart';
import '../../../core/database/schemas/goal_entity.dart';
import '../../../core/repositories/future_letter_repository.dart';
import '../../ai_planning/domain/models/plan_models.dart';

/// Kelajak xatlari xizmati.
class FutureLetterService {
  FutureLetterService(this._repo);

  final FutureLetterRepository _repo;

  static const horizons = {
    '1m': Duration(days: 30),
    '3m': Duration(days: 90),
    '6m': Duration(days: 180),
    '1y': Duration(days: 365),
    '5y': Duration(days: 365 * 5),
  };

  static String horizonLabel(String id) => switch (id) {
        '1m' => '1 oy',
        '3m' => '3 oy',
        '6m' => '6 oy',
        '1y' => '1 yil',
        '5y' => '5 yil',
        _ => id,
      };

  Future<FutureLetterEntity> createLetter({
    required String content,
    required String horizon,
    int mood = 3,
    LifeScoreBreakdown? lifeScore,
    List<GoalEntity>? goals,
    int? playerLevel,
  }) async {
    final duration = horizons[horizon] ?? const Duration(days: 30);
    final deliverAt = DateTime.now().add(duration);

    final snapshot = <String, dynamic>{
      if (lifeScore != null) 'lifeScore': lifeScore.overall,
      if (playerLevel != null) 'level': playerLevel,
      if (goals != null)
        'goals': goals.take(5).map((g) => {'title': g.title, 'progress': g.progress}).toList(),
      'writtenAt': DateTime.now().toIso8601String(),
    };

    return _repo.save(
      FutureLetterEntity.create(
        content: content,
        deliveryHorizon: horizon,
        deliverAt: deliverAt,
        moodAtWriting: mood,
        snapshotJson: jsonEncode(snapshot),
      ),
    );
  }

  /// Yetib kelgan xatlarni yetkazish.
  Future<List<FutureLetterEntity>> processDeliveries() async {
    final due = await _repo.getDueForDelivery();
    final delivered = <FutureLetterEntity>[];
    for (final letter in due) {
      if (!letter.delivered && letter.deliverAt.isBefore(DateTime.now())) {
        delivered.add(await _repo.markDelivered(letter));
      }
    }
    return delivered;
  }
}
