import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/player_profile_entity.dart';
import 'package:rejabon_ai/core/database/schemas/quest_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';
import 'package:rejabon_ai/features/gamification/domain/models/rpg_models.dart';
import 'package:rejabon_ai/features/gamification/domain/xp_service.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/social/domain/share_card_service.dart';
import 'package:rejabon_ai/shared/widgets/calm_ui.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_empty_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// RPG qahramon ekrani — daraja, statlar, questlar, yutuqlar.
class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(playerProfileProvider);
    final questsAsync = ref.watch(dailyQuestsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: profileAsync.when(
          loading: () => const AppLoadingState(),
          error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
          data: (profile) {
            if (profile == null) {
              return const AppEmptyState(
                icon: Icons.person_outline_rounded,
                title: AppStrings.characterEmpty,
                description: AppStrings.characterEmptyDesc,
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await runDailyBootstrap(ref);
              },
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        CalmPageHeader(
                          title: AppStrings.navCharacter,
                          subtitle: profile.title,
                        ),
                        _ProfileHeader(profile: profile, brightness: brightness),
                        const SizedBox(height: AppSpacing.lg),
                        _StatsRow(profile: profile, brightness: brightness),
                        const SizedBox(height: AppSpacing.lg),
                        questsAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (quests) => _QuestsSection(
                            quests: quests,
                            brightness: brightness,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        achievementsAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (achievements) => _AchievementsSection(
                            achievements: achievements,
                            brightness: brightness,
                          ),
                        ),
                        SizedBox(
                          height: ContentInsets.shellScrollBottom(context),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.brightness,
  });

  final PlayerProfileEntity profile;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = LevelCalculator.levelProgress(profile.totalXp, profile.level);
    final xpToNext = LevelCalculator.xpToNextLevel(profile.totalXp, profile.level);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(profile.avatarEmoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${AppStrings.level} ${profile.level}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.border(brightness, subtle: true),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${profile.totalXp} XP · $xpToNext ${AppStrings.xpToNext}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary(brightness),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.profile,
    required this.brightness,
  });

  final PlayerProfileEntity profile;
  final Brightness brightness;

  int _statValue(String type) => switch (type) {
        StatType.discipline => profile.disciplineXp,
        StatType.health => profile.healthXp,
        StatType.knowledge => profile.knowledgeXp,
        StatType.wealth => profile.wealthXp,
        StatType.social => profile.socialXp,
        StatType.spiritual => profile.spiritualXp,
        _ => 0,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalmSectionTitle(title: AppStrings.characterStats),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: StatType.all.map((type) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface(brightness, elevated: true),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: AppColors.border(brightness, subtle: true),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(StatType.emoji(type)),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${_statValue(type)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        StatType.label(type),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary(brightness),
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _QuestsSection extends StatelessWidget {
  const _QuestsSection({
    required this.quests,
    required this.brightness,
  });

  final List<QuestEntity> quests;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) return const SizedBox.shrink();

    final daily = quests.where((q) => q.questType == 'daily').take(3).toList();
    final weekly = quests.where((q) => q.questType == 'weekly').take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalmSectionTitle(title: AppStrings.dailyQuests),
        ...daily.map((q) => _QuestTile(quest: q, brightness: brightness)),
        if (weekly.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          CalmSectionTitle(title: AppStrings.weeklyQuests),
          ...weekly.map((q) => _QuestTile(quest: q, brightness: brightness)),
        ],
      ],
    );
  }
}

class _QuestTile extends StatelessWidget {
  const _QuestTile({
    required this.quest,
    required this.brightness,
  });

  final QuestEntity quest;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        variant: AppCardVariant.filled,
        child: Row(
          children: [
            ProgressRing(
              progress: quest.completed ? 1 : 0,
              size: 40,
              strokeWidth: 3,
              color: quest.completed ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration:
                              quest.completed ? TextDecoration.lineThrough : null,
                        ),
                  ),
                  Text(
                    quest.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary(brightness),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              '+${quest.xpReward}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementsSection extends ConsumerWidget {
  const _AchievementsSection({
    required this.achievements,
    required this.brightness,
  });

  final List<Achievement> achievements;
  final Brightness brightness;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = achievements.where((a) => a.unlocked).length;

    final shown = achievements.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalmSectionTitle(
          title: AppStrings.achievements,
          trailing: '$unlocked/${achievements.length}',
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: shown.map((a) {
            return GestureDetector(
              onTap: a.unlocked
                  ? () => ShareCardService.shareText(
                        ShareCardData(
                          type: ShareCardType.achievement,
                          title: a.title,
                          subtitle: a.description,
                          emoji: a.emoji,
                          statLine: AppStrings.shareAchievement,
                        ),
                      )
                  : null,
              child: Opacity(
                opacity: a.unlocked ? 1 : 0.35,
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                    horizontal: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface(brightness, elevated: true),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: a.unlocked
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border(brightness, subtle: true),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(a.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        a.title,
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
