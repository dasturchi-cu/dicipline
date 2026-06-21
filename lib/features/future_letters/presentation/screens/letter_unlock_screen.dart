import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/future_letter_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/future_simulator/domain/future_letter_service.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// Kelajak xati ochilish marosimi.
class LetterUnlockScreen extends ConsumerWidget {
  const LetterUnlockScreen({super.key, required this.letterId});

  final int letterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lettersAsync = ref.watch(futureLettersProvider);

    return ModuleScreen(
      title: AppStrings.letterUnlockTitle,
      showBackButton: true,
      body: lettersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
        data: (letters) {
          FutureLetterEntity? letter;
          for (final l in letters) {
            if (l.id == letterId) {
              letter = l;
              break;
            }
          }
          if (letter == null) {
            return Center(child: Text(AppStrings.noLetters));
          }
          return _UnlockBody(letter: letter);
        },
      ),
    );
  }
}

class _UnlockBody extends ConsumerStatefulWidget {
  const _UnlockBody({required this.letter});

  final FutureLetterEntity letter;

  @override
  ConsumerState<_UnlockBody> createState() => _UnlockBodyState();
}

class _UnlockBodyState extends ConsumerState<_UnlockBody> {
  @override
  void initState() {
    super.initState();
    if (!widget.letter.read) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(futureLetterRepositoryProvider).markRead(widget.letter);
        ref.invalidate(futureLettersProvider);
      });
    }
  }

  Map<String, dynamic>? get _snapshot {
    final json = widget.letter.snapshotJson;
    if (json == null || json.isEmpty) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final snap = _snapshot;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        ContentInsets.shellScrollBottom(context),
      ),
      child: Column(
        children: [
          const Text('📬', style: TextStyle(fontSize: 72)),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.letterUnlockTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            FutureLetterService.horizonLabel(widget.letter.deliveryHorizon),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                ),
          ),
          if (snap != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.letterThenVsNow,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (snap['level'] != null)
              Text('${AppStrings.levelLabel}: ${snap['level']}'),
            if (snap['lifeScore'] != null)
              Text('${AppStrings.lifeScore}: ${snap['lifeScore']}'),
          ],
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                widget.letter.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          AppButton(
            label: AppStrings.continueLabel,
            onPressed: () => context.go('/hayot/simulyator'),
          ),
        ],
      ),
    );
  }
}
