import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../core/emoji/emoji_catalog.dart';
import '../../core/providers/core_providers.dart';
import '../../core/theme/app_colors.dart';
import 'glass_panel.dart';

/// Emoji tanlash maydoni — so'nggi va kategoriyalar.
class EmojiPickerField extends ConsumerStatefulWidget {
  const EmojiPickerField({
    super.key,
    required this.selected,
    required this.onSelected,
    this.label = AppStrings.emojiOptional,
  });

  final String selected;
  final ValueChanged<String> onSelected;
  final String label;

  @override
  ConsumerState<EmojiPickerField> createState() => _EmojiPickerFieldState();
}

class _EmojiPickerFieldState extends ConsumerState<EmojiPickerField> {
  Future<void> _openPicker() async {
    final emojiService = await ref.read(emojiServiceProvider.future);
    if (!mounted) return;

    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EmojiPickerSheet(
        recent: emojiService.getRecent(),
        selected: widget.selected,
      ),
    );

    if (picked != null && mounted) {
      widget.onSelected(picked);
      await emojiService.remember(picked);
      ref.invalidate(emojiServiceProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = widget.selected.isNotEmpty ? widget.selected : null;

    return InkWell(
      onTap: _openPicker,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Row(
          children: [
            if (display != null)
              Text(display, style: const TextStyle(fontSize: 24))
            else
              Text(
                AppStrings.selectEmoji,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const Spacer(),
            const Icon(Icons.add_reaction_outlined, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _EmojiPickerSheet extends StatelessWidget {
  const _EmojiPickerSheet({
    required this.recent,
    required this.selected,
  });

  final List<String> recent;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, bottom),
      child: GlassPanel(
        opacity: 0.94,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                AppStrings.selectEmoji,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView(
                  children: [
                    if (recent.isNotEmpty) ...[
                      Text(
                        AppStrings.recentEmojis,
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _EmojiGrid(
                        emojis: recent,
                        selected: selected,
                        onPick: (e) => Navigator.pop(context, e),
                      ),
                    ],
                    ...EmojiCatalog.categories.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.md),
                          Text(entry.key, style: theme.textTheme.labelLarge),
                          const SizedBox(height: AppSpacing.sm),
                          _EmojiGrid(
                            emojis: entry.value,
                            selected: selected,
                            onPick: (e) => Navigator.pop(context, e),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid({
    required this.emojis,
    required this.selected,
    required this.onPick,
  });

  final List<String> emojis;
  final String selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: emojis.map((emoji) {
        final isSelected = emoji == selected;
        return GestureDetector(
          onTap: () => onPick(emoji),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: isSelected
                  ? Border.all(color: AppColors.primary)
                  : null,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        );
      }).toList(),
    );
  }
}
