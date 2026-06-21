import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/schemas/goal_entity.dart';
import '../../../../core/integration/provider_sync.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/content_insets.dart';
import '../../../../core/utils/display_with_emoji.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_feedback.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/fade_in.dart';
import '../../../../shared/widgets/life_area_picker.dart';
import '../../../../shared/widgets/module_screen.dart';
import '../../../../shared/widgets/progress_ring.dart';

class FuturePlanningScreen extends ConsumerWidget {
  const FuturePlanningScreen({super.key});

  static const _horizons = [
    ('5y', '5 yil', '🏔️'),
    ('1y', '1 yil', '🎯'),
    ('3m', '3 oy', '📅'),
    ('1m', '1 oy', '📆'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.futurePlanning,
      showBackButton: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGoalSheet(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(AppStrings.addHorizonGoal),
      ),
      body: goalsAsync.when(
        loading: () => const AppLoadingState(),
        error: (_, __) => AppErrorState(
          onRetry: () => ref.invalidate(goalsProvider),
        ),
        data: (goals) {
          final horizonGoals =
              goals.where((g) => g.horizon != null && g.horizon!.isNotEmpty);

          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            children: [
              Text(
                AppStrings.futurePlanningDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () => context.push('/hayot/simulyator'),
                icon: const Icon(Icons.science_outlined),
                label: Text(AppStrings.futureSimulator),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final (id, label, emoji) in _horizons) ...[
                Text(
                  '$emoji $label'.toUpperCase(),
                  style: AppTypography.sectionLabel(brightness),
                ),
                const SizedBox(height: AppSpacing.sm),
                ..._goalsForHorizon(horizonGoals, id).map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: FadeIn(
                      child: _HorizonGoalCard(
                        goal: goal,
                        childGoals: goals
                            .where((g) => g.parentGoalId == goal.id)
                            .toList(),
                        onTap: () => context.push('/hayot/maqsadlar'),
                      ),
                    ),
                  ),
                ),
                if (_goalsForHorizon(horizonGoals, id).isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppCard(
                      variant: AppCardVariant.filled,
                      onTap: () => _showGoalSheet(context, ref, horizon: id),
                      child: Text(
                        AppStrings.addHorizonGoal,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }

  List<GoalEntity> _goalsForHorizon(
    Iterable<GoalEntity> goals,
    String horizon,
  ) {
    return goals
        .where((g) => g.horizon == horizon && g.parentGoalId == null)
        .toList();
  }

  static Future<void> _showGoalSheet(
    BuildContext context,
    WidgetRef ref, {
    String? horizon,
  }) {
    return showAppBottomSheet<void>(
      context,
      title: AppStrings.addHorizonGoal,
      child: _HorizonGoalForm(horizon: horizon),
    );
  }
}

class _HorizonGoalCard extends StatelessWidget {
  const _HorizonGoalCard({
    required this.goal,
    required this.childGoals,
    required this.onTap,
  });

  final GoalEntity goal;
  final List<GoalEntity> childGoals;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          ProgressRing(
            progress: goal.progress / 100,
            size: 52,
            strokeWidth: 4,
            color: AppColors.secondary,
            child: Text(
              '${goal.progress.round()}%',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayWithEmoji(title: goal.title, emoji: goal.emoji),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (childGoals.isNotEmpty)
                  Text(
                    '${childGoals.length} bog\'langan maqsad',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizonGoalForm extends ConsumerStatefulWidget {
  const _HorizonGoalForm({this.horizon});

  final String? horizon;

  @override
  ConsumerState<_HorizonGoalForm> createState() => _HorizonGoalFormState();
}

class _HorizonGoalFormState extends ConsumerState<_HorizonGoalForm> {
  final _titleCtrl = TextEditingController();
  String _horizon = '1y';
  List<String> _areas = [];
  int? _parentId;

  @override
  void initState() {
    super.initState();
    _horizon = widget.horizon ?? '1y';
  }

  @override
  void dispose() {
    deferDispose(_titleCtrl.dispose);
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    await ref.read(goalRepositoryProvider).create(
          title: title,
          lifeAreaIds: _areas,
          horizon: _horizon,
          parentGoalId: _parentId,
        );
    invalidateDerivedProviders(ref);
    ref.invalidate(goalsProvider);
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(controller: _titleCtrl, label: AppStrings.goalTitle),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: _horizon,
            decoration: InputDecoration(labelText: AppStrings.planHorizon),
            items: const [
              DropdownMenuItem(value: '5y', child: Text('5 yil')),
              DropdownMenuItem(value: '1y', child: Text('1 yil')),
              DropdownMenuItem(value: '3m', child: Text('3 oy')),
              DropdownMenuItem(value: '1m', child: Text('1 oy')),
            ],
            onChanged: (v) => setState(() => _horizon = v ?? '1y'),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.lifeAreas, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          LifeAreaPicker(
            selected: _areas,
            onChanged: (v) => setState(() => _areas = v),
            compact: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: AppStrings.save, onPressed: _save),
        ],
      ),
    );
  }
}
