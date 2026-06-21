import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/friend_challenge_entity.dart';
import 'package:rejabon_ai/core/database/schemas/group_challenge_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/gamification/domain/models/rpg_models.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/social/domain/friend_challenge_service.dart';
import 'package:rejabon_ai/features/social/domain/group_challenge_service.dart';
import 'package:rejabon_ai/features/social/domain/leaderboard_service.dart';
import 'package:rejabon_ai/features/social/domain/referral_service.dart';
import 'package:rejabon_ai/features/social/domain/share_card_service.dart';
import 'package:rejabon_ai/features/social/domain/social_service.dart';
import 'package:rejabon_ai/features/social/presentation/providers/social_providers.dart';
import 'package:rejabon_ai/features/social/presentation/widgets/social_privacy_sheet.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/calm_ui.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// Premium ijtimoiy markaz — hamkorlar, musobaqalar, reyting, takliflar.
class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _groupMembersCtrl = TextEditingController();
  final _shareKey = GlobalKey();
  var _connecting = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => runSocialBootstrap(ref));
  }

  @override
  void dispose() {
    _tabs.dispose();
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _groupMembersCtrl.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    if (code.length < 4 || name.isEmpty) return;

    setState(() => _connecting = true);
    try {
      final service = await ref.read(socialServiceProvider.future);
      await service.connectPartner(inviteCode: code, partnerName: name);
      ref.invalidate(partnershipsProvider);
      ref.invalidate(partnerSummariesProvider);
      ref.invalidate(referralStatsProvider);
      _codeCtrl.clear();
      _nameCtrl.clear();
      if (mounted) {
        await awardXpAndRefresh(
          ref,
          statType: StatType.social,
          amount: 50,
          source: 'partner_connect',
          description: 'Hamkor ulandi',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.partnerConnected)),
        );
      }
    } on SocialException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  Future<void> _checkIn(int id) async {
    final service = await ref.read(socialServiceProvider.future);
    await service.checkIn(id);
    ref.invalidate(partnershipsProvider);
    ref.invalidate(partnerSummariesProvider);
    ref.invalidate(friendChallengesProvider);
    if (mounted) {
      await awardXpAndRefresh(
        ref,
        statType: StatType.social,
        amount: 30,
        source: 'partner_checkin',
        sourceId: id.toString(),
        description: 'Hamkor check-in',
        oncePerDay: true,
      );
    }
  }

  Future<void> _removePartner(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.removePartner),
        content: Text('$name — ${AppStrings.removePartner}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Bekor'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppStrings.removePartner),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final service = await ref.read(socialServiceProvider.future);
    await service.removePartner(id);
    ref.invalidate(partnershipsProvider);
    ref.invalidate(partnerSummariesProvider);
    ref.invalidate(friendChallengesProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.partnerRemoved)),
      );
    }
  }

  void _openPrivacy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SocialPrivacySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final premiumAsync = ref.watch(isPremiumProvider);

    return ModuleScreen(
      title: AppStrings.socialHub,
      showBackButton: true,
      actions: [
        premiumAsync.when(
          data: (isPremium) => isPremium
              ? Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Chip(
                    label: Text(AppStrings.premiumActive,
                        style: const TextStyle(fontSize: 11)),
                    backgroundColor:
                        AppColors.gold.withValues(alpha: 0.2),
                  ),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        IconButton(
          icon: const Icon(Icons.privacy_tip_outlined),
          tooltip: AppStrings.privacySettings,
          onPressed: _openPrivacy,
        ),
      ],
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            isScrollable: true,
            labelColor: AppColors.primary,
            tabs: const [
              Tab(text: AppStrings.socialTabPartners),
              Tab(text: AppStrings.socialTabChallenges),
              Tab(text: AppStrings.socialTabLeaderboard),
              Tab(text: AppStrings.socialTabReferrals),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _PartnersTab(
                  codeCtrl: _codeCtrl,
                  nameCtrl: _nameCtrl,
                  connecting: _connecting,
                  onConnect: _connect,
                  onCheckIn: _checkIn,
                  onRemove: _removePartner,
                  shareKey: _shareKey,
                ),
                _ChallengesTab(groupMembersCtrl: _groupMembersCtrl),
                const _LeaderboardTab(),
                _ReferralsTab(shareKey: _shareKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnersTab extends ConsumerWidget {
  const _PartnersTab({
    required this.codeCtrl,
    required this.nameCtrl,
    required this.connecting,
    required this.onConnect,
    required this.onCheckIn,
    required this.onRemove,
    required this.shareKey,
  });

  final TextEditingController codeCtrl;
  final TextEditingController nameCtrl;
  final bool connecting;
  final VoidCallback onConnect;
  final ValueChanged<int> onCheckIn;
  final void Function(int id, String name) onRemove;
  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inviteAsync = ref.watch(myInviteCodeProvider);
    final summariesAsync = ref.watch(partnerSummariesProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        ContentInsets.shellScrollBottom(context),
      ),
      children: [
        CalmPageHeader(
          title: AppStrings.socialHeroTitle,
          subtitle: AppStrings.socialHeroSubtitle,
        ),
        const CalmSectionTitle(title: AppStrings.myInviteCode),
        const SizedBox(height: AppSpacing.sm),
        inviteAsync.when(
          loading: () => const AppLoadingState(),
          error: (_, __) => Text(AppStrings.errorGeneric),
          data: (code) => _InviteCodeCard(code: code, shareKey: shareKey),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          variant: AppCardVariant.outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.connectPartner,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: codeCtrl, label: AppStrings.partnerCode),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: nameCtrl, label: AppStrings.partnerName),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: AppStrings.connectPartner,
                isExpanded: true,
                onPressed: connecting ? null : onConnect,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const CalmSectionTitle(title: AppStrings.myPartners),
        const SizedBox(height: AppSpacing.sm),
        summariesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (summaries) {
            if (summaries.isEmpty) {
              return Text(AppStrings.noPartners);
            }
            return Column(
              children: summaries.map((s) {
                final p = s.partner;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    variant: AppCardVariant.outlined,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.15),
                          child: Text(
                            p.partnerName.isNotEmpty
                                ? p.partnerName[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.partnerName,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              Text(
                                '${AppStrings.partnerSince}: ${s.daysConnected} kun · '
                                '${AppStrings.checkIns}: ${p.checkInCount}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: s.canCheckInToday
                              ? () => onCheckIn(p.id)
                              : null,
                          child: Text(AppStrings.checkIn),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'remove') {
                              onRemove(p.id, p.partnerName);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'remove',
                              child: Text(AppStrings.removePartner),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _InviteCodeCard extends ConsumerWidget {
  const _InviteCodeCard({required this.code, required this.shareKey});

  final String code;
  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumAsync = ref.watch(isPremiumProvider);
    final isPremium = premiumAsync.valueOrNull ?? false;
    final userName = ref.watch(settingsProvider).userName;

    return Column(
      children: [
        RepaintBoundary(
          key: shareKey,
          child: ShareCardService.buildCard(
            ShareCardData(
              type: ShareCardType.referral,
              title: AppStrings.shareInvite,
              subtitle: AppStrings.socialDesc,
              emoji: '🤝',
              inviteCode: code,
              isPremium: isPremium,
            ),
            brightness: Theme.of(context).brightness,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          variant: AppCardVariant.outlined,
          child: Row(
            children: [
              Text(code,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        letterSpacing: 4,
                        fontWeight: FontWeight.w800,
                      )),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy_rounded),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppStrings.copied)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () async {
                  final referral = await ref.read(referralServiceProvider.future);
                  await Share.share(
                    referral.buildShareMessage(code, userName: userName),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.image_rounded),
                tooltip: AppStrings.shareCard,
                onPressed: () async {
                  final data = ShareCardData(
                    type: ShareCardType.referral,
                    title: AppStrings.shareInvite,
                    subtitle: AppStrings.socialDesc,
                    emoji: '🤝',
                    inviteCode: code,
                    isPremium: isPremium,
                  );
                  await ShareCardService.shareImage(shareKey, data);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChallengesTab extends ConsumerWidget {
  const _ChallengesTab({required this.groupMembersCtrl});

  final TextEditingController groupMembersCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendAsync = ref.watch(friendChallengesProvider);
    final groupAsync = ref.watch(groupChallengesProvider);
    final summariesAsync = ref.watch(partnerSummariesProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        ContentInsets.shellScrollBottom(context),
      ),
      children: [
        const CalmSectionTitle(title: AppStrings.friendChallenges),
        const SizedBox(height: AppSpacing.sm),
        friendAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (challenges) {
            if (challenges.isEmpty) {
              return Text(AppStrings.noFriendChallenges);
            }
            return Column(
              children: challenges
                  .map((c) => _FriendChallengeCard(challenge: c))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        summariesAsync.when(
          data: (summaries) {
            if (summaries.isEmpty) return const SizedBox.shrink();
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: FriendChallengeService.templates.map((t) {
                return ActionChip(
                  label: Text('${t.emoji} ${t.title}'),
                  onPressed: () async {
                    final svc = ref.read(friendChallengeServiceProvider);
                    await svc.startChallenge(
                      template: t,
                      partner: summaries.first.partner,
                    );
                    ref.invalidate(friendChallengesProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.challengeStarted)),
                      );
                    }
                  },
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.lg),
        const CalmSectionTitle(title: AppStrings.groupChallenges),
        const SizedBox(height: AppSpacing.sm),
        groupAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (groups) {
            if (groups.isEmpty) {
              return Text(AppStrings.noGroupChallenges);
            }
            return Column(
              children:
                  groups.map((g) => _GroupChallengeCard(challenge: g)).toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: groupMembersCtrl,
          label: AppStrings.groupMemberNames,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: AppStrings.startGroupChallenge,
          isExpanded: true,
          onPressed: () async {
            final svc = await ref.read(groupChallengeServiceProvider.future);
            final names = groupMembersCtrl.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
            final template = GroupChallengeService.templates.first;
            await svc.createGroup(
              template: template,
              myName: ref.read(settingsProvider).userName,
              memberNames: names,
            );
            groupMembersCtrl.clear();
            ref.invalidate(groupChallengesProvider);
          },
        ),
      ],
    );
  }
}

class _FriendChallengeCard extends StatelessWidget {
  const _FriendChallengeCard({required this.challenge});

  final FriendChallengeEntity challenge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        variant: AppCardVariant.outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${challenge.emoji} ${challenge.title}',
                style: Theme.of(context).textTheme.titleSmall),
            Text('vs ${challenge.partnerName}'),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: challenge.myProgress,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('${challenge.myScore}/${challenge.targetScore}'),
              ],
            ),
            if (challenge.status == 'completed' && challenge.winnerLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text('🏆 ${challenge.winnerLabel}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _GroupChallengeCard extends ConsumerWidget {
  const _GroupChallengeCard({required this.challenge});

  final GroupChallengeEntity challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = challenge.members.fold<int>(0, (s, m) => s + m.score);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        variant: AppCardVariant.outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${challenge.emoji} ${challenge.title}',
                style: Theme.of(context).textTheme.titleSmall),
            Text('Jamoa: $total/${challenge.targetScore}'),
            ...challenge.members.map(
              (m) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(m.isMe ? '${m.name} (siz)' : m.name)),
                    Text('${m.score}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardAsync = ref.watch(weeklyLeaderboardProvider);

    return boardAsync.when(
      loading: () => const AppLoadingState(),
      error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
      data: (board) => ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          ContentInsets.shellScrollBottom(context),
        ),
        children: [
          AppCard(
            variant: AppCardVariant.outlined,
            child: Text(
              board.communityMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CalmSectionTitle(
            title: '${AppStrings.weeklyLeaderboard} · ${board.weekLabel}',
          ),
          if (board.myRank > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('${AppStrings.yourRank}: #${board.myRank}'),
          ],
          const SizedBox(height: AppSpacing.md),
          ...board.entries.map((e) => _LeaderboardTile(entry: e)),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends ConsumerWidget {
  const _LeaderboardTile({required this.entry});

  final LeaderboardEntry entry;

  Future<void> _shareStreak(WidgetRef ref) async {
    final streak = entry.streakHighlight;
    if (streak == null) return;
    final isPremium = ref.read(isPremiumProvider).valueOrNull ?? false;
    await ShareCardService.shareText(
      ShareCardData(
        type: ShareCardType.streak,
        title: AppStrings.shareStreak,
        subtitle: 'Haftalik ketma-ketlik — REJABON AI bilan',
        emoji: '🔥',
        statLine: '$streak kun streak',
        isPremium: isPremium,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        variant: entry.isMe ? AppCardVariant.filled : AppCardVariant.outlined,
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '#${entry.rank}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: entry.rank <= 3 ? AppColors.gold : null,
                    ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.displayName,
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    entry.encouragement,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${entry.weeklyXp} XP'),
                if (entry.streakHighlight != null)
                  Text('🔥 ${entry.streakHighlight}'),
                if (entry.isMe && entry.streakHighlight != null)
                  IconButton(
                    icon: const Icon(Icons.ios_share_rounded, size: 20),
                    tooltip: AppStrings.shareStreak,
                    onPressed: () => _shareStreak(ref),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferralsTab extends ConsumerWidget {
  const _ReferralsTab({required this.shareKey});

  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(referralStatsProvider);
    final premiumAsync = ref.watch(isPremiumProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        ContentInsets.shellScrollBottom(context),
      ),
      children: [
        premiumAsync.when(
          data: (isPremium) => AppCard(
            variant: AppCardVariant.outlined,
            child: Row(
              children: [
                if (isPremium)
                  Icon(Icons.workspace_premium_rounded,
                      color: AppColors.gold, size: 28)
                else
                  Icon(Icons.star_outline_rounded,
                      color: AppColors.primary, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPremium
                            ? AppStrings.premiumActive
                            : AppStrings.premiumSocial,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(AppStrings.premiumSocialDesc),
                    ],
                  ),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.lg),
        const CalmSectionTitle(title: AppStrings.referralRewards),
        const SizedBox(height: AppSpacing.sm),
        statsAsync.when(
          loading: () => const AppLoadingState(),
          error: (_, __) => Text(AppStrings.errorGeneric),
          data: (stats) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      variant: AppCardVariant.outlined,
                      child: Column(
                        children: [
                          Text('${stats.total}',
                              style: Theme.of(context).textTheme.headlineMedium),
                          Text(AppStrings.totalReferrals),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppCard(
                      variant: AppCardVariant.outlined,
                      child: Column(
                        children: [
                          Text('${stats.totalXp}',
                              style: Theme.of(context).textTheme.headlineMedium),
                          Text(AppStrings.referralXpEarned),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                variant: AppCardVariant.outlined,
                child: Text(stats.nextMilestone),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...ReferralService.rewardTiers.map(
                (tier) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    variant: AppCardVariant.outlined,
                    child: Row(
                      children: [
                        ProgressRing(
                          progress: (stats.total / tier.count).clamp(0.0, 1.0),
                          size: 40,
                          strokeWidth: 3,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tier.label,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              Text('${tier.count} taklif · +${tier.xp} XP'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
