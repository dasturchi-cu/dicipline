import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/decision_assistant/domain/decision_assistant_service.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// AI Decision Assistant — Life Twin bilan quvvatlangan tavsiyalar.
class DecisionAssistantScreen extends ConsumerStatefulWidget {
  const DecisionAssistantScreen({super.key});

  @override
  ConsumerState<DecisionAssistantScreen> createState() =>
      _DecisionAssistantScreenState();
}

class _DecisionAssistantScreenState
    extends ConsumerState<DecisionAssistantScreen> {
  final _questionCtrl = TextEditingController();
  var _asking = false;
  String? _lastAnswer;

  @override
  void dispose() {
    _questionCtrl.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final q = _questionCtrl.text.trim();
    if (q.isEmpty || _asking) return;
    setState(() => _asking = true);

    try {
      final profile = await ref.read(lifeTwinProfileProvider.future);
      final goals = await ref.read(goalRepositoryProvider).getAll();
      final history =
          await ref.read(coachConversationRepositoryProvider).getByContext(
                'decision',
              );
      final answer = await ref.read(decisionAssistantServiceProvider).askQuestion(
            question: q,
            profile: profile,
            goals: goals,
            history: history,
            twinAnalysis: await ref.read(lifeTwinAnalysisProvider.future),
          );
      ref.invalidate(decisionConversationProvider);
      ref.invalidate(decisionRecommendationsProvider);
      if (mounted) {
        setState(() {
          _lastAnswer = answer;
          _questionCtrl.clear();
        });
      }
    } finally {
      if (mounted) setState(() => _asking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recsAsync = ref.watch(decisionRecommendationsProvider);
    final historyAsync = ref.watch(decisionConversationProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.decisionAssistant,
      showBackButton: true,
      body: Column(
        children: [
          Expanded(
            child: recsAsync.when(
              loading: () => const AppLoadingState(),
              error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
              data: (recs) => ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                children: [
                  Text(
                    AppStrings.decisionDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary(brightness),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  historyAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (history) {
                      if (history.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.conversationHistory,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: AppSpacing.sm),
                          ...history.reversed.take(6).map(
                                (m) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: AppSpacing.sm),
                                  child: AppCard(
                                    variant: m.role == 'user'
                                        ? AppCardVariant.filled
                                        : AppCardVariant.elevated,
                                    child: Text(m.message),
                                  ),
                                ),
                              ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      );
                    },
                  ),
                  if (_lastAnswer != null) ...[
                    AppCard(
                      variant: AppCardVariant.filled,
                      child: Text(_lastAnswer!),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Text(AppStrings.recommendations,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  if (recs.isEmpty)
                    Text(AppStrings.noRecommendations)
                  else
                    ...recs.map((r) => _RecCard(rec: r)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              ContentInsets.shellScrollBottom(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _questionCtrl,
                    label: AppStrings.askDecision,
                    onSubmitted: (_) => _ask(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: _asking ? null : _ask,
                  icon: _asking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecCard extends StatelessWidget {
  const _RecCard({required this.rec});

  final DecisionRecommendation rec;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: rec.actionRoute != null
            ? () => context.push(rec.actionRoute!)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rec.title,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(rec.description),
          ],
        ),
      ),
    );
  }
}
