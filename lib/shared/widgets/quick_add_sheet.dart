import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../core/integration/provider_sync.dart';
import '../../core/providers/repository_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../features/platform/presentation/providers/platform_providers.dart';
import '../../shared/widgets/app_bottom_sheet.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_feedback.dart';
import '../../shared/widgets/app_text_field.dart';

enum QuickAddType { task, habit, goal, note }

/// Global tez qo'shish — 2 bosishda yaratish.
class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key, this.initialType});

  final QuickAddType? initialType;

  static Future<void> show(BuildContext context, {QuickAddType? type}) {
    return showAppBottomSheet<void>(
      context,
      title: AppStrings.quickAdd,
      child: QuickAddSheet(initialType: type),
    );
  }

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  QuickAddType? _selected;
  final _titleController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialType;
  }

  @override
  void dispose() {
    deferDispose(_titleController.dispose);
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selected == null) return;

    setState(() => _saving = true);
    try {
      switch (_selected!) {
        case QuickAddType.task:
          await ref.read(taskRepositoryProvider).create(title: title);
        case QuickAddType.habit:
          await ref.read(habitRepositoryProvider).create(name: title);
        case QuickAddType.goal:
          await ref.read(goalRepositoryProvider).create(title: title);
        case QuickAddType.note:
          await ref.read(noteRepositoryProvider).create(
                title: title,
                content: '',
              );
      }
      invalidateDerivedProviders(ref);
      await refreshWidgetData(ref);
      if (mounted) {
        Navigator.pop(context);
        showSavedSnackBar(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selected == null) ...[
            Text(
              AppStrings.quickAddHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _TypeGrid(
              onSelect: (type) => setState(() => _selected = type),
            ),
          ] else ...[
            Row(
              children: [
                Text(
                  _typeEmoji(_selected!),
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _typeLabel(_selected!),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _selected = null;
                    _titleController.clear();
                  }),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textSecondary(brightness),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _titleController,
              label: _fieldLabel(_selected!),
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AppStrings.save,
              onPressed: _saving ? null : _save,
              isLoading: _saving,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  static String _typeEmoji(QuickAddType type) => switch (type) {
        QuickAddType.task => '📋',
        QuickAddType.habit => '🔥',
        QuickAddType.goal => '🎯',
        QuickAddType.note => '📝',
      };

  static String _typeLabel(QuickAddType type) => switch (type) {
        QuickAddType.task => AppStrings.addTask,
        QuickAddType.habit => AppStrings.addHabit,
        QuickAddType.goal => AppStrings.newGoal,
        QuickAddType.note => AppStrings.newNote,
      };

  static String _fieldLabel(QuickAddType type) => switch (type) {
        QuickAddType.task => AppStrings.taskTitle,
        QuickAddType.habit => AppStrings.habitName,
        QuickAddType.goal => AppStrings.goalTitle,
        QuickAddType.note => AppStrings.noteTitle,
      };
}

class _TypeGrid extends StatelessWidget {
  const _TypeGrid({required this.onSelect});

  final ValueChanged<QuickAddType> onSelect;

  @override
  Widget build(BuildContext context) {
    const types = QuickAddType.values;
    final brightness = Theme.of(context).brightness;

    return Column(
      children: types.map((type) {
        final (icon, label) = switch (type) {
          QuickAddType.task => (
              Icons.check_circle_outline_rounded,
              AppStrings.tasks,
            ),
          QuickAddType.habit => (Icons.repeat_rounded, AppStrings.habits),
          QuickAddType.goal => (Icons.flag_outlined, AppStrings.goals),
          QuickAddType.note => (
              Icons.sticky_note_2_outlined,
              AppStrings.notes,
            ),
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: () => onSelect(type),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: AppColors.border(brightness, subtle: true),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.primary, size: 22),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary(brightness),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Global FAB — har joyda tez qo'shish.
class QuickAddFab extends StatelessWidget {
  const QuickAddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => QuickAddSheet.show(context),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.add_rounded, size: 28),
    );
  }
}
