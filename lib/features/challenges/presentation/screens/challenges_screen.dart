import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/schemas/challenge_entity.dart';
import '../../../../core/integration/provider_sync.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/calm_ui.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../../shared/widgets/progress_ring.dart';
import '../../../platform/presentation/providers/platform_providers.dart';
import '../../domain/challenge_service.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(activeChallengesProvider);
    final service = ref.watch(challengeServiceProvider);

    return ModuleScreen(
      title: AppStrings.challenges,
      showBackButton: true,
      body: challengesAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(activeChallengesProvider),
        ),
        data: (active) {
          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            children: [
              if (active.isNotEmpty) ...[
                CalmSectionTitle(title: AppStrings.activeChallenges),
                for (final challenge in active)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _ActiveChallengeCard(
                      challenge: challenge,
                      service: service,
                      onMarkToday: () async {
                        await service.markToday(challenge.id);
                        ref.invalidate(activeChallengesProvider);
                        invalidateDerivedProviders(ref);
                        if (context.mounted) {
                          showSavedSnackBar(
                            context,
                            message: AppStrings.challengeMarked,
                          );
                        }
                      },
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],
              CalmSectionTitle(title: AppStrings.availableChallenges),
              for (final template in ChallengeService.templates)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: FadeIn(
                    child: _TemplateCard(
                      template: template,
                      isActive: active.any((c) => c.typeId == template.typeId),
                      onStart: () async {
                        await service.startChallenge(template);
                        ref.invalidate(activeChallengesProvider);
                        if (context.mounted) {
                          showSavedSnackBar(
                            context,
                            message: AppStrings.challengeStarted,
                          );
                        }
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ActiveChallengeCard extends StatelessWidget {
  const _ActiveChallengeCard({
    required this.challenge,
    required this.service,
    required this.onMarkToday,
  });

  final ChallengeEntity challenge;
  final ChallengeService service;
  final VoidCallback onMarkToday;

  @override
  Widget build(BuildContext context) {
    final badge = service.achievementBadge(challenge);

    return AppCard(
      variant: AppCardVariant.outlined,
      child: Row(
        children: [
          ProgressRing(
            progress: challenge.progress,
            size: 52,
            strokeWidth: 4,
            color: AppColors.primary,
            child: Text(
              '${challenge.currentDay}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${challenge.emoji} ${challenge.title}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  badge,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (!challenge.isCompleted)
            IconButton(
              onPressed: onMarkToday,
              icon: const Icon(Icons.check_circle_outline_rounded),
              color: AppColors.primary,
              tooltip: AppStrings.markToday,
            ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.isActive,
    required this.onStart,
  });

  final ChallengeTemplate template;
  final bool isActive;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(template.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${template.targetDays} ${AppStrings.days}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            template.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: isActive ? AppStrings.challengeActive : AppStrings.startChallenge,
            onPressed: isActive ? null : onStart,
            variant: isActive ? AppButtonVariant.secondary : AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
