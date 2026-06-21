import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/providers/core_providers.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/repositories/friend_challenge_repository.dart';
import 'package:rejabon_ai/core/repositories/group_challenge_repository.dart';
import 'package:rejabon_ai/core/repositories/partnership_repository.dart';
import 'package:rejabon_ai/core/repositories/referral_repository.dart';
import 'package:rejabon_ai/core/repositories/social_settings_repository.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/features/social/domain/friend_challenge_service.dart';
import 'package:rejabon_ai/features/social/domain/group_challenge_service.dart';
import 'package:rejabon_ai/features/social/domain/leaderboard_service.dart';
import 'package:rejabon_ai/features/social/domain/premium_service.dart';
import 'package:rejabon_ai/features/social/domain/referral_service.dart';
import 'package:rejabon_ai/features/social/domain/social_service.dart';

final partnershipRepositoryProvider = Provider<PartnershipRepository>((ref) {
  return PartnershipRepository(ref.watch(isarServiceProvider).isar);
});

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  return ReferralRepository(ref.watch(isarServiceProvider).isar);
});

final friendChallengeRepositoryProvider =
    Provider<FriendChallengeRepository>((ref) {
  return FriendChallengeRepository(ref.watch(isarServiceProvider).isar);
});

final groupChallengeRepositoryProvider = Provider<GroupChallengeRepository>((ref) {
  return GroupChallengeRepository(ref.watch(isarServiceProvider).isar);
});

final socialSettingsRepositoryProvider =
    Provider<SocialSettingsRepository>((ref) {
  return SocialSettingsRepository(ref.watch(isarServiceProvider).isar);
});

final premiumServiceProvider = FutureProvider<PremiumService>((ref) async {
  return PremiumService.create();
});

final socialServiceProvider = FutureProvider<SocialService>((ref) async {
  final premium = await ref.watch(premiumServiceProvider.future);
  return SocialService(
    repo: PartnershipRepository(ref.watch(isarServiceProvider).isar),
    settingsRepo: ref.watch(socialSettingsRepositoryProvider),
    referralService: ReferralService(
      referralRepo: ref.watch(referralRepositoryProvider),
      premiumService: premium,
    ),
    friendChallengeService:
        FriendChallengeService(ref.watch(friendChallengeRepositoryProvider)),
  );
});

final friendChallengeServiceProvider = Provider<FriendChallengeService>((ref) {
  return FriendChallengeService(ref.watch(friendChallengeRepositoryProvider));
});

final groupChallengeServiceProvider = FutureProvider<GroupChallengeService>((ref) async {
  final premium = await ref.watch(premiumServiceProvider.future);
  return GroupChallengeService(
    repo: ref.watch(groupChallengeRepositoryProvider),
    premium: premium,
  );
});

final referralServiceProvider = FutureProvider<ReferralService>((ref) async {
  final premium = await ref.watch(premiumServiceProvider.future);
  return ReferralService(
    referralRepo: ref.watch(referralRepositoryProvider),
    premiumService: premium,
  );
});

final leaderboardServiceProvider = Provider<LeaderboardService>((ref) {
  return LeaderboardService();
});

final partnershipsProvider = StreamProvider((ref) {
  return ref.watch(partnershipRepositoryProvider).watchAll();
});

final partnerSummariesProvider = FutureProvider((ref) async {
  final service = await ref.watch(socialServiceProvider.future);
  return service.getPartnerSummaries();
});

final myInviteCodeProvider = FutureProvider<String>((ref) async {
  final service = await ref.watch(socialServiceProvider.future);
  return service.getMyInviteCode();
});

final socialSettingsProvider = StreamProvider((ref) {
  return ref.watch(socialSettingsRepositoryProvider).watch();
});

final friendChallengesProvider = StreamProvider((ref) {
  return ref.watch(friendChallengeRepositoryProvider).watchActive();
});

final groupChallengesProvider = StreamProvider((ref) {
  return ref.watch(groupChallengeRepositoryProvider).watchActive();
});

final weeklyLeaderboardProvider = FutureProvider((ref) async {
  final settings = await ref
      .watch(socialSettingsRepositoryProvider)
      .getOrCreate(displayName: ref.watch(settingsProvider).userName);
  final xpEvents = await ref.watch(xpEventRepositoryProvider).getAll();
  final partners = await ref.watch(partnershipRepositoryProvider).getAll();
  final habits = await ref.watch(habitRepositoryProvider).getAll();
  final habitRepo = ref.watch(habitRepositoryProvider);

  var longestStreak = 0;
  for (final h in habits) {
    final s = habitRepo.calculateStreak(h);
    if (s > longestStreak) longestStreak = s;
  }

  return ref.watch(leaderboardServiceProvider).build(
        xpEvents: xpEvents,
        partners: partners,
        settings: settings,
        userName: ref.watch(settingsProvider).userName,
        myLongestStreak: longestStreak,
      );
});

final referralStatsProvider = FutureProvider((ref) async {
  final referral = await ref.watch(referralServiceProvider.future);
  return (
    total: await referral.getTotalReferrals(),
    totalXp: await referral.getTotalReferralXp(),
    nextMilestone: await referral.nextMilestoneMessage(),
  );
});

final isPremiumProvider = FutureProvider<bool>((ref) async {
  final premium = await ref.watch(premiumServiceProvider.future);
  return premium.isPremium;
});

Future<void> runSocialBootstrap(WidgetRef ref) async {
  await ref.read(socialSettingsRepositoryProvider).getOrCreate(
        displayName: ref.read(settingsProvider).userName,
      );
  ref.invalidate(partnerSummariesProvider);
  ref.invalidate(weeklyLeaderboardProvider);
  ref.invalidate(referralStatsProvider);
}
