import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/database/schemas/partnership_entity.dart';
import 'package:rejabon_ai/core/database/schemas/social_settings_entity.dart';
import 'package:rejabon_ai/core/database/schemas/xp_event_entity.dart';
import 'package:rejabon_ai/features/social/domain/leaderboard_service.dart';

void main() {
  group('LeaderboardService', () {
    final service = LeaderboardService();

    test('builds non-toxic leaderboard with me first entry', () {
      final settings = SocialSettingsEntity.defaults(displayName: 'Test');
      final board = service.build(
        xpEvents: [
          XpEventEntity.create(
            statType: 'social',
            amount: 80,
            source: 'quest',
          ),
        ],
        partners: [
          PartnershipEntity.create(
            inviteCode: 'ABC123',
            partnerName: 'Ali',
          )..checkInCount = 2,
        ],
        settings: settings,
        userName: 'Test',
        myLongestStreak: 5,
      );

      expect(board.entries, isNotEmpty);
      expect(board.entries.any((e) => e.isMe), isTrue);
      expect(board.communityMessage, isNotEmpty);
    });

    test('respects privacy hide leaderboard', () {
      final settings = SocialSettingsEntity.defaults()
        ..showOnLeaderboard = false;

      final board = service.build(
        xpEvents: const [],
        partners: const [],
        settings: settings,
        userName: 'Test',
        myLongestStreak: 0,
      );

      expect(board.entries, isEmpty);
    });
  });
}
