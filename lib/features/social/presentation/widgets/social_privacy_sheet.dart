import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/social_settings_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/features/social/presentation/providers/social_providers.dart';

class SocialPrivacySheet extends ConsumerWidget {
  const SocialPrivacySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(socialSettingsProvider);

    return settingsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (settings) {
        final s = settings ??
            SocialSettingsEntity.defaults(
              displayName: ref.watch(settingsProvider).userName,
            );
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.privacySettings,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                title: Text(AppStrings.showOnLeaderboard),
                value: s.showOnLeaderboard,
                onChanged: (v) => _save(ref, s..showOnLeaderboard = v),
              ),
              SwitchListTile(
                title: Text(AppStrings.shareStreaksSetting),
                value: s.shareStreaks,
                onChanged: (v) => _save(ref, s..shareStreaks = v),
              ),
              SwitchListTile(
                title: Text(AppStrings.shareAchievementsSetting),
                value: s.shareAchievements,
                onChanged: (v) => _save(ref, s..shareAchievements = v),
              ),
              SwitchListTile(
                title: Text(AppStrings.allowFriendChallenges),
                value: s.allowFriendChallenges,
                onChanged: (v) => _save(ref, s..allowFriendChallenges = v),
              ),
              SwitchListTile(
                title: Text(AppStrings.allowGroupInvites),
                value: s.allowGroupInvites,
                onChanged: (v) => _save(ref, s..allowGroupInvites = v),
              ),
              SwitchListTile(
                title: Text(AppStrings.leaderboardAnonymous),
                subtitle: const Text('Reytingda faqat "Siz" ko\'rinadi'),
                value: s.leaderboardUseAlias,
                onChanged: (v) => _save(ref, s..leaderboardUseAlias = v),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save(WidgetRef ref, SocialSettingsEntity settings) async {
    await ref.read(socialSettingsRepositoryProvider).save(settings);
    ref.invalidate(socialSettingsProvider);
    ref.invalidate(weeklyLeaderboardProvider);
  }
}
