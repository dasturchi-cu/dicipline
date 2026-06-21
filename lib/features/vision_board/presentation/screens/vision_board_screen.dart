import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/vision_board_item_entity.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// Kelajak vizualizatsiyasi — maqsadlar taxtasi.
class VisionBoardScreen extends ConsumerWidget {
  const VisionBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(visionBoardItemsProvider);

    return ModuleScreen(
      title: AppStrings.visionBoard,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: () => _showAddSheet(context, ref),
        ),
      ],
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('✨', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.visionBoardEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: AppStrings.visionBoardAdd,
                      onPressed: () => _showAddSheet(context, ref),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.85,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return FadeIn(
                index: index,
                child: _VisionTile(
                  item: item,
                  onTap: () {
                    if (item.linkedGoalId != null) {
                      context.push('/hayot/maqsadlar');
                    }
                  },
                  onDelete: () async {
                    await ref
                        .read(visionBoardRepositoryProvider)
                        .delete(item.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    var emoji = '✨';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            MediaQuery.viewInsetsOf(ctx).bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.visionBoardAdd,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: AppStrings.taskTitle,
                  prefixText: '$emoji ',
                ),
                onChanged: (_) {},
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: InputDecoration(labelText: AppStrings.description),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: AppStrings.save,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final repo = ref.read(visionBoardRepositoryProvider);
                  final existing = await repo.getAll();
                  await repo.save(
                    VisionBoardItemEntity.create(
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      emoji: emoji,
                      sortOrder: existing.length,
                    ),
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
    titleCtrl.dispose();
    descCtrl.dispose();
  }
}

class _VisionTile extends StatelessWidget {
  const _VisionTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final VisionBoardItemEntity item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (item.description != null && item.description!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary(
                          Theme.of(context).brightness,
                        ),
                      ),
                ),
              ],
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}
