import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/future_letter_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/theme/app_typography.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_prediction_engine.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_letter_service.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_simulator_service.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';
import 'package:rejabon_ai/shared/widgets/progress_ring.dart';

/// Kelajak simulyatori + vaqt kapsulasi xatlar.
class FutureSimulatorScreen extends ConsumerStatefulWidget {
  const FutureSimulatorScreen({super.key});

  @override
  ConsumerState<FutureSimulatorScreen> createState() =>
      _FutureSimulatorScreenState();
}

class _FutureSimulatorScreenState extends ConsumerState<FutureSimulatorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.futureSimulator,
      showBackButton: true,
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            labelColor: AppColors.primary,
            tabs: const [
              Tab(text: AppStrings.simulationTab),
              Tab(text: AppStrings.predictionsTab),
              Tab(text: AppStrings.lettersTab),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _SimulationTab(brightness: brightness),
                _PredictionsTab(brightness: brightness),
                _LettersTab(brightness: brightness),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationTab extends ConsumerWidget {
  const _SimulationTab({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(simulationResultsProvider);

    return resultsAsync.when(
      loading: () => const AppLoadingState(),
      error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
      data: (results) => ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          ContentInsets.shellScrollBottom(context),
        ),
        children: [
          Text(
            AppStrings.simulationDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final result in results) ...[
            AppCard(
              variant: result.scenario.id == 'boost'
                  ? AppCardVariant.filled
                  : AppCardVariant.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProgressRing(
                        progress: result.projectedScore / 100,
                        size: 48,
                        strokeWidth: 4,
                        color: result.delta >= 0
                            ? AppColors.success
                            : AppColors.error,
                        child: Text(
                          '${result.projectedScore}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.scenario.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              result.scenario.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${result.delta >= 0 ? '+' : ''}${result.delta}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: result.delta >= 0
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(result.insight,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _PredictionsTab extends ConsumerWidget {
  const _PredictionsTab({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionsAsync = ref.watch(futurePredictionsProvider);

    return predictionsAsync.when(
      loading: () => const AppLoadingState(),
      error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
      data: (predictions) => ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          ContentInsets.shellScrollBottom(context),
        ),
        children: [
          Text(AppStrings.predictionsDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(brightness),
                  )),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.goalPredictions,
              style: AppTypography.sectionLabel(brightness)),
          const SizedBox(height: AppSpacing.sm),
          if (predictions.goalPredictions.isEmpty)
            Text(AppStrings.noGoalsYet)
          else
            ...predictions.goalPredictions.map(
              (g) => AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.goalTitle,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(g.insight),
                    Text(
                      '${g.weeksRemaining} hafta · ${g.confidence * 100}% ishonch',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.streakRisks,
              style: AppTypography.sectionLabel(brightness)),
          const SizedBox(height: AppSpacing.sm),
          ...predictions.streakRisks.take(5).map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    variant: s.riskLevel == 'high'
                        ? AppCardVariant.filled
                        : AppCardVariant.elevated,
                    child: Text(s.insight),
                  ),
                ),
              ),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.trendPredictions,
              style: AppTypography.sectionLabel(brightness)),
          const SizedBox(height: AppSpacing.sm),
          ...predictions.trends.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(child: Text(t.insight)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LettersTab extends ConsumerStatefulWidget {
  const _LettersTab({required this.brightness});

  final Brightness brightness;

  @override
  ConsumerState<_LettersTab> createState() => _LettersTabState();
}

class _LettersTabState extends ConsumerState<_LettersTab> {
  final _contentCtrl = TextEditingController();
  var _horizon = '3m';

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendLetter() async {
    final content = _contentCtrl.text.trim();
    if (content.isEmpty) return;

    final breakdown = await ref.read(lifeScoreProvider.future);
    final profile =
        await ref.read(playerProfileRepositoryProvider).getOrCreate();

    await ref.read(futureLetterServiceProvider).createLetter(
          content: content,
          horizon: _horizon,
          lifeScore: breakdown,
          playerLevel: profile.level,
          goals: await ref.read(goalRepositoryProvider).getAll(),
        );

    _contentCtrl.clear();
    ref.invalidate(futureLettersProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.letterScheduled)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lettersAsync = ref.watch(futureLettersProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        ContentInsets.shellScrollBottom(context),
      ),
      children: [
        Text(AppStrings.lettersDesc,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _contentCtrl,
          label: AppStrings.letterContent,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: _horizon,
          decoration: InputDecoration(labelText: AppStrings.letterHorizon),
          items: FutureLetterService.horizons.keys
              .map((h) => DropdownMenuItem(
                    value: h,
                    child: Text(FutureLetterService.horizonLabel(h)),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _horizon = v ?? '3m'),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: AppStrings.scheduleLetter, onPressed: _sendLetter),
        const SizedBox(height: AppSpacing.lg),
        Text(AppStrings.myLetters,
            style: AppTypography.sectionLabel(widget.brightness)),
        const SizedBox(height: AppSpacing.sm),
        lettersAsync.when(
          loading: () => const AppLoadingState(),
          error: (_, __) => const SizedBox.shrink(),
          data: (letters) {
            if (letters.isEmpty) {
              return Text(AppStrings.noLetters,
                  style: Theme.of(context).textTheme.bodySmall);
            }
            return Column(
              children: letters.map((l) => _LetterTile(letter: l)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({required this.letter});

  final FutureLetterEntity letter;

  @override
  Widget build(BuildContext context) {
    final status = letter.delivered
        ? (letter.read ? AppStrings.letterRead : AppStrings.letterDelivered)
        : AppStrings.letterPending;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: letter.delivered
            ? () => context.push('/hayot/xat/${letter.id}')
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  FutureLetterService.horizonLabel(letter.deliveryHorizon),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                Text(status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                        )),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              letter.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
