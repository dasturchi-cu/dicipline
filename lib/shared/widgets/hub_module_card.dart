import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'app_card.dart';
import 'fade_in.dart';

class HubModuleCard extends StatelessWidget {
  const HubModuleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.index = 0,
    this.accentColor = AppColors.primary,
    this.gradient,
    this.trailing,
    this.badge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final int index;
  final Color accentColor;
  final List<Color>? gradient;
  final Widget? trailing;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isGradient = gradient != null;

    return FadeIn(
      index: index,
      child: AppCard(
        variant: isGradient ? AppCardVariant.gradient : AppCardVariant.elevated,
        gradientColors: gradient,
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isGradient
                    ? Colors.white.withValues(alpha: 0.2)
                    : accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: isGradient ? Colors.white : accentColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isGradient ? Colors.white : null,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isGradient
                              ? Colors.white.withValues(alpha: 0.88)
                              : AppColors.textSecondary(brightness),
                        ),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isGradient
                      ? Colors.white.withValues(alpha: 0.2)
                      : accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  badge!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isGradient ? Colors.white : accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            trailing ??
                Icon(
                  Icons.arrow_forward_rounded,
                  color: isGradient
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppColors.textSecondary(brightness),
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
    this.action,
    this.onAction,
  });

  final String label;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.sectionLabel(Theme.of(context).brightness),
          ),
          const Spacer(),
          if (action != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}
