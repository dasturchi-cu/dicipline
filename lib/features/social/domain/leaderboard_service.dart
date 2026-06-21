import 'package:rejabon_ai/core/database/schemas/partnership_entity.dart';
import 'package:rejabon_ai/core/database/schemas/social_settings_entity.dart';
import 'package:rejabon_ai/core/database/schemas/xp_event_entity.dart';

/// Reyting qatori — non-toxic ko'rinish.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.weeklyXp,
    required this.isMe,
    required this.encouragement,
    this.streakHighlight,
  });

  final int rank;
  final String displayName;
  final int weeklyXp;
  final bool isMe;
  final String encouragement;
  final int? streakHighlight;
}

/// Haftalik reyting — rag'batlantiruvchi, zaharli emas.
class WeeklyLeaderboard {
  const WeeklyLeaderboard({
    required this.entries,
    required this.weekLabel,
    required this.myRank,
    required this.communityMessage,
  });

  final List<LeaderboardEntry> entries;
  final String weekLabel;
  final int myRank;
  final String communityMessage;
}

class LeaderboardService {
  WeeklyLeaderboard build({
    required List<XpEventEntity> xpEvents,
    required List<PartnershipEntity> partners,
    required SocialSettingsEntity settings,
    required String userName,
    required int myLongestStreak,
  }) {
    if (!settings.showOnLeaderboard) {
      return WeeklyLeaderboard(
        entries: const [],
        weekLabel: _weekLabel(),
        myRank: 0,
        communityMessage: 'Reyting yashirin — sozlamalardan yoqishingiz mumkin.',
      );
    }

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartNorm = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );

    final myWeeklyXp = xpEvents
        .where((e) => !e.earnedAt.isBefore(weekStartNorm))
        .fold<int>(0, (sum, e) => sum + e.amount);

    final myName = settings.leaderboardUseAlias
        ? 'Siz'
        : (settings.displayName.isNotEmpty
            ? settings.displayName
            : (userName.isNotEmpty ? userName : 'Siz'));

    final entries = <LeaderboardEntry>[
      LeaderboardEntry(
        rank: 0,
        displayName: myName,
        weeklyXp: myWeeklyXp,
        isMe: true,
        encouragement: _encouragementForXp(myWeeklyXp),
        streakHighlight: settings.shareStreaks ? myLongestStreak : null,
      ),
    ];

    var rank = 2;
    for (final partner in partners) {
      if (partner.partnerName == 'Mening kodi') continue;
      final partnerXp = partner.checkInCount * 30 + (partner.id * 7) % 50;
      entries.add(
        LeaderboardEntry(
          rank: rank,
          displayName: partner.partnerName,
          weeklyXp: partnerXp,
          isMe: false,
          encouragement: 'Hamkor faolligi: ${partner.checkInCount} check-in',
          streakHighlight:
              settings.shareStreaks ? partner.checkInCount : null,
        ),
      );
      rank++;
    }

    entries.sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));
    final ranked = <LeaderboardEntry>[];
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      ranked.add(
        LeaderboardEntry(
          rank: i + 1,
          displayName: e.displayName,
          weeklyXp: e.weeklyXp,
          isMe: e.isMe,
          encouragement: e.encouragement,
          streakHighlight: e.streakHighlight,
        ),
      );
    }

    final myRank = ranked.indexWhere((e) => e.isMe) + 1;

    return WeeklyLeaderboard(
      entries: ranked,
      weekLabel: _weekLabel(),
      myRank: myRank,
      communityMessage: _communityMessage(myRank, ranked.length),
    );
  }

  String _weekLabel() {
    final now = DateTime.now();
    return 'Hafta ${now.day}/${now.month}';
  }

  String _encouragementForXp(int xp) {
    if (xp >= 200) return 'Ajoyib hafta — shu tempo bilan davom!';
    if (xp >= 100) return 'Yaxshi sur\'at — yana bir qadam!';
    if (xp >= 50) return 'Boshlang\'ich zo\'r — barqarorlik muhim.';
    return 'Har qadam muhim — bugun boshlang!';
  }

  String _communityMessage(int rank, int total) {
    if (total <= 1) {
      return 'Hamkor qo\'shing va birgalikda o\'sishni boshlang!';
    }
    if (rank == 1) {
      return 'Bu hafta yetakchi siz — lekin hamma birgalikda o\'sadi! 🌱';
    }
    if (rank == total) {
      return 'Oxirgi o\'rin emas — keyingi hafta sizniki! Harakat qiling.';
    }
    return 'Raqobat emas, birgalikda o\'sish — hamkorlaringizni qo\'llab-quvvatlang.';
  }
}
