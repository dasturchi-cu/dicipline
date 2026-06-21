import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/integration/provider_sync.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/capture_sheet.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../../core/database/schemas/inbox_item_entity.dart';
import '../../domain/inbox_triage_service.dart';
import '../providers/capture_providers.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);

    return ModuleScreen(
      title: AppStrings.smartInbox,
      showBackButton: true,
      showGlobalCapture: false,
      body: inboxAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(inboxProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              icon: Icons.inbox_rounded,
              title: AppStrings.inboxEmpty,
              description: AppStrings.inboxEmptyDesc,
              actionLabel: AppStrings.capture,
              onAction: () => showCapture(context),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return FadeIn(
                child: _InboxCard(
                  item: item,
                  onAction: (action) =>
                      _handleAction(context, ref, item, action),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    InboxItemEntity item,
    _InboxAction action,
  ) async {
    final triage = ref.read(inboxTriageServiceProvider);
    switch (action) {
      case _InboxAction.accept:
        await triage.acceptToBrain(item);
      case _InboxAction.task:
        await triage.convertToTask(item);
      case _InboxAction.goal:
        await triage.convertToGoal(item);
      case _InboxAction.habit:
        await triage.convertToHabit(item);
      case _InboxAction.learning:
        await triage.convertToLearning(item);
      case _InboxAction.dismiss:
        await triage.dismiss(item);
    }
    invalidateDerivedProviders(ref);
    ref.invalidate(inboxProvider);
  }
}

enum _InboxAction { accept, task, goal, habit, learning, dismiss }

class _InboxCard extends StatelessWidget {
  const _InboxCard({required this.item, required this.onAction});

  final InboxItemEntity item;
  final void Function(_InboxAction action) onAction;

  @override
  Widget build(BuildContext context) {
    final suggestion = item.suggestedAction;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          if (item.body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (suggestion != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${AppStrings.suggestedAction}: $suggestion',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _ActionChip(
                label: AppStrings.inboxAccept,
                onTap: () => onAction(_InboxAction.accept),
              ),
              _ActionChip(
                label: AppStrings.tasks,
                onTap: () => onAction(_InboxAction.task),
              ),
              _ActionChip(
                label: AppStrings.goals,
                onTap: () => onAction(_InboxAction.goal),
              ),
              _ActionChip(
                label: AppStrings.habits,
                onTap: () => onAction(_InboxAction.habit),
              ),
              _ActionChip(
                label: AppStrings.study,
                onTap: () => onAction(_InboxAction.learning),
              ),
              _ActionChip(
                label: AppStrings.delete,
                onTap: () => onAction(_InboxAction.dismiss),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}
