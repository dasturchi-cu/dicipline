import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/schemas/milestone_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/emoji_picker_field.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../capture/presentation/providers/capture_providers.dart';

class MilestonesScreen extends ConsumerWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestonesAsync = ref.watch(milestonesProvider);

    return ModuleScreen(
      title: AppStrings.achievementTimeline,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: milestonesAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => const Center(child: Text(AppStrings.errorGeneric)),
        data: (milestones) {
          if (milestones.isEmpty) {
            return AppEmptyState(
              icon: Icons.emoji_events_rounded,
              title: AppStrings.milestonesEmpty,
              description: AppStrings.milestonesEmptyDesc,
              actionLabel: AppStrings.addMilestone,
              onAction: () => _showForm(context, ref),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            itemCount: milestones.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final m = milestones[index];
              return FadeIn(
                child: AppCard(
                  child: Row(
                    children: [
                      Text(m.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (m.description != null &&
                                m.description!.isNotEmpty)
                              Text(
                                m.description!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            Text(
                              AppDateFormat.formatDate(m.achievedAt),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _showForm(BuildContext context, WidgetRef ref) {
    return showAppBottomSheet<void>(
      context,
      title: AppStrings.addMilestone,
      child: const _MilestoneForm(),
    );
  }
}

class _MilestoneForm extends ConsumerStatefulWidget {
  const _MilestoneForm();

  @override
  ConsumerState<_MilestoneForm> createState() => _MilestoneFormState();
}

class _MilestoneFormState extends ConsumerState<_MilestoneForm> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _emoji = '🏆';

  @override
  void dispose() {
    deferDispose(_titleCtrl.dispose);
    deferDispose(_descCtrl.dispose);
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    await ref.read(milestoneRepositoryProvider).create(
          title: title,
          emoji: _emoji,
          description:
              _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        );
    ref.invalidate(milestonesProvider);
    ref.invalidate(lifeTimelineProvider);
    if (mounted) {
      Navigator.pop(context);
      showSavedSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmojiPickerField(
            selected: _emoji,
            onSelected: (e) => setState(() => _emoji = e),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(controller: _titleCtrl, label: AppStrings.milestoneTitle),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _descCtrl,
            label: AppStrings.milestoneDesc,
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: AppStrings.save, onPressed: _save),
        ],
      ),
    );
  }
}
