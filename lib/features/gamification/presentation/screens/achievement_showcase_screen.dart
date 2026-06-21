import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/gamification/domain/achievement_service.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/social/domain/share_card_service.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// Yutuqlar vitrini — trophy showcase.
class AchievementShowcaseScreen extends ConsumerWidget {
  const AchievementShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.achievementShowcase,
      showBackButton: true,
      body: achievementsAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(achievementsProvider),
        ),
        data: (achievements) {
          final unlocked =
              achievements.where((a) => a.unlocked).toList();
          final locked = achievements.where((a) => !a.unlocked).toList();
          final count = AchievementService.unlockedCount(achievements);

          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            children: [
              FadeIn(
                child: AppCard(
                  child: Row(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 36)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$count / ${achievements.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              AppStrings.showcaseUnlockedCount,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (unlocked.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.publicShowcase.toUpperCase(),
                  style: AppTypography.sectionLabel(brightness),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...unlocked.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: FadeIn(
                          index: e.key,
                          child: _TrophyTile(
                            achievement: e.value,
                            onShare: () {
                              final text = ShareCardService.buildShareText(
                                ShareCardData(
                                  type: ShareCardType.achievement,
                                  title: e.value.title,
                                  subtitle: e.value.description,
                                  emoji: e.value.emoji,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(text)),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
              ],
              if (locked.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.privateLocked.toUpperCase(),
                  style: AppTypography.sectionLabel(brightness),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...locked.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _TrophyTile(
                          achievement: e.value,
                          locked: true,
                        ),
                      ),
                    ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TrophyTile extends StatelessWidget {
  const _TrophyTile({
    required this.achievement,
    this.locked = false,
    this.onShare,
  });

  final Achievement achievement;
  final bool locked;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Text(
            locked ? '🔒' : achievement.emoji,
            style: TextStyle(
              fontSize: 28,
              color: locked ? Colors.grey : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: locked ? Colors.grey : null,
                      ),
                ),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (!locked && achievement.progress != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: LinearProgressIndicator(
                      value: achievement.progress,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
          if (!locked && onShare != null)
            IconButton(
              onPressed: onShare,
              icon: const Icon(Icons.share_rounded, size: 20),
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}
