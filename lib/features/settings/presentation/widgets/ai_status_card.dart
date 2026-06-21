import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ai/ai_status.dart';
import '../../../../core/ai/ai_types.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/ai_status_provider.dart';

class AiStatusCard extends ConsumerStatefulWidget {
  const AiStatusCard({super.key});

  @override
  ConsumerState<AiStatusCard> createState() => _AiStatusCardState();
}

class _AiStatusCardState extends ConsumerState<AiStatusCard> {
  var _testing = false;

  Future<void> _testConnection() async {
    setState(() => _testing = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final ok = await ref.refresh(aiConnectionTestProvider.future);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            ok ? AppStrings.aiTestSuccess : AppStrings.aiTestFailed,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.aiTestFailed)),
      );
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(aiStatusProvider);
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                color: _statusColor(status),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppStrings.aiStatus,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              _StatusChip(status: status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!status.isActive && status.connectionState == AiConnectionState.notConfigured) ...[
            Text(
              AppStrings.aiRuleBasedFallback,
              style: theme.textTheme.bodySmall,
            ),
          ] else ...[
            if (status.currentProvider != null)
              _InfoRow(
                label: AppStrings.aiCurrentProvider,
                value: _providerName(status.currentProvider!),
              ),
            if (status.currentModel != null)
              _InfoRow(
                label: AppStrings.aiCurrentModel,
                value: status.currentModel!,
              ),
            if (status.currentKeyNumber != null &&
                status.totalKeysForProvider != null)
              _InfoRow(
                label: AppStrings.aiCurrentKey,
                value:
                    '${status.currentKeyNumber} / ${status.totalKeysForProvider}',
              ),
            if (status.fallbackChain.isNotEmpty)
              _InfoRow(
                label: AppStrings.aiFallbackChain,
                value: status.fallbackChain.map(_providerName).join(' → '),
              ),
            if (status.configSource != null)
              _InfoRow(
                label: AppStrings.aiConfigSource,
                value: status.configSource!,
              ),
            if (status.lastSuccessAt != null)
              _InfoRow(
                label: AppStrings.aiLastSuccess,
                value: _formatTime(status.lastSuccessAt!),
              ),
            if (status.providers.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.aiProviders,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              ...status.providers.map(
                (provider) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Icon(
                        provider.isConfigured
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        size: 16,
                        color: provider.isConfigured
                            ? AppColors.success
                            : theme.colorScheme.outline,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          '${provider.displayName}: '
                          '${provider.keyCount} kalit, '
                          '${provider.modelCount} model',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: AppStrings.aiTestConnection,
            icon: Icons.wifi_tethering_rounded,
            size: AppButtonSize.sm,
            isLoading: _testing,
            isExpanded: true,
            variant: AppButtonVariant.secondary,
            onPressed: status.connectionState == AiConnectionState.notConfigured
                ? null
                : _testConnection,
          ),
        ],
      ),
    );
  }

  Color _statusColor(AiStatusInfo status) {
    return switch (status.connectionState) {
      AiConnectionState.active => AppColors.success,
      AiConnectionState.error => AppColors.error,
      AiConnectionState.notConfigured => AppColors.lightTextSecondary,
    };
  }

  String _providerName(AiProviderId id) => switch (id) {
        AiProviderId.gemini => 'Gemini',
        AiProviderId.openai => 'OpenAI',
        AiProviderId.openrouter => 'OpenRouter',
        AiProviderId.groq => 'Groq',
        AiProviderId.cloudflare => 'Cloudflare',
      };

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '${local.day.toString().padLeft(2, '0')}.'
        '${local.month.toString().padLeft(2, '0')} $h:$m';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final AiStatusInfo status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status.connectionState) {
      AiConnectionState.active => (AppStrings.aiStatusActive, AppColors.success),
      AiConnectionState.notConfigured =>
        (AppStrings.aiStatusNotConfigured, AppColors.lightTextSecondary),
      AiConnectionState.error => (AppStrings.aiStatusError, AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
