import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/constants/app_strings.dart';
import '../../core/integration/provider_sync.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/capture/domain/capture_processing_service.dart';
import '../../features/capture/presentation/providers/capture_providers.dart';
import '../../features/platform/presentation/providers/platform_providers.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';
import 'app_feedback.dart';
import 'app_text_field.dart';
import 'quick_add_sheet.dart';

enum CaptureType { note, voice, photo, link, document, idea }

/// Universal capture — 2 bosishda.
class CaptureSheet extends ConsumerStatefulWidget {
  const CaptureSheet({super.key, this.initialType});

  final CaptureType? initialType;

  static Future<void> show(BuildContext context, {CaptureType? type}) {
    return showAppBottomSheet<void>(
      context,
      title: AppStrings.capture,
      child: CaptureSheet(initialType: type),
    );
  }

  @override
  ConsumerState<CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends ConsumerState<CaptureSheet> {
  CaptureType? _selected;
  final _textCtrl = TextEditingController();
  final _speech = SpeechToText();
  bool _listening = false;
  bool _speechReady = false;
  bool _saving = false;
  String? _pickedPath;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialType;
    _initSpeech();
    if (_selected == CaptureType.voice) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _toggleVoice());
    }
    if (_selected == CaptureType.photo || _selected == CaptureType.document) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickFile());
    }
  }

  Future<void> _initSpeech() async {
    final ok = await _speech.initialize();
    if (mounted) setState(() => _speechReady = ok);
  }

  @override
  void dispose() {
    deferDispose(_textCtrl.dispose);
    _speech.stop();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final type = _selected;
    if (type == null) return;
    final result = await FilePicker.platform.pickFiles(
      type: type == CaptureType.photo ? FileType.image : FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _pickedPath = file.path;
        if (_textCtrl.text.isEmpty) {
          _textCtrl.text = file.name;
        }
      });
    }
  }

  Future<void> _toggleVoice() async {
    if (!_speechReady) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.voiceNotAvailable)),
        );
      }
      return;
    }
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (r) => _textCtrl.text = r.recognizedWords,
      localeId: 'uz_UZ',
      listenMode: ListenMode.dictation,
    );
  }

  Future<void> _capture() async {
    final type = _selected;
    if (type == null) return;

    final text = _textCtrl.text.trim();
    if (text.isEmpty && _pickedPath == null) return;

    setState(() => _saving = true);
    try {
      final captureType = _captureTypeId(type);
      final processor = ref.read(captureProcessingServiceProvider);
      final suggestion = processor.analyze(
        text: text.isNotEmpty ? text : _pickedPath ?? '',
        captureType: captureType,
      );

      final title = text.isNotEmpty
          ? (text.length > 80 ? '${text.substring(0, 80)}...' : text)
          : (_pickedPath?.split(RegExp(r'[/\\]')).last ?? 'Capture');

      await ref.read(inboxRepositoryProvider).create(
            title: title,
            body: text,
            captureType: captureType,
            suggestedAction: suggestion.action,
            sourceUrl: _pickedPath ?? (type == CaptureType.link ? text : null),
            emoji: CaptureProcessingService.emojiForType(captureType),
          );

      invalidateDerivedProviders(ref);
      ref.invalidate(inboxProvider);
      await refreshWidgetData(ref);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(AppStrings.capturedToInbox),
            action: SnackBarAction(
              label: AppStrings.openInbox,
              onPressed: () => context.pushOnce('/boshqa/inbox'),
            ),
          ),
        );
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

  static String _captureTypeId(CaptureType type) => switch (type) {
        CaptureType.note => 'note',
        CaptureType.voice => 'voice',
        CaptureType.photo => 'photo',
        CaptureType.link => 'link',
        CaptureType.document => 'document',
        CaptureType.idea => 'idea',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selected == null) ...[
            Text(
              AppStrings.captureHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _CaptureGrid(onSelect: (t) => setState(() => _selected = t)),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                QuickAddSheet.show(context);
              },
              child: Text(AppStrings.quickAdd),
            ),
          ] else ...[
            _CaptureInput(
              type: _selected!,
              controller: _textCtrl,
              listening: _listening,
              pickedPath: _pickedPath,
              onVoice: _toggleVoice,
              onPick: _pickFile,
              onBack: () => setState(() {
                _selected = null;
                _textCtrl.clear();
                _pickedPath = null;
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AppStrings.captureSave,
              onPressed: _saving ? null : _capture,
              isLoading: _saving,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _CaptureGrid extends StatelessWidget {
  const _CaptureGrid({required this.onSelect});

  final ValueChanged<CaptureType> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      (CaptureType.note, '📝', AppStrings.captureNote),
      (CaptureType.voice, '🎙️', AppStrings.captureVoice),
      (CaptureType.photo, '📸', AppStrings.capturePhoto),
      (CaptureType.link, '🔗', AppStrings.captureLink),
      (CaptureType.document, '📄', AppStrings.captureDocument),
      (CaptureType.idea, '💡', AppStrings.captureIdea),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.1,
      children: items.map((item) {
        return InkWell(
          onTap: () => onSelect(item.$1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.$2, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  item.$3,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CaptureInput extends StatelessWidget {
  const _CaptureInput({
    required this.type,
    required this.controller,
    required this.listening,
    required this.pickedPath,
    required this.onVoice,
    required this.onPick,
    required this.onBack,
  });

  final CaptureType type;
  final TextEditingController controller;
  final bool listening;
  final String? pickedPath;
  final VoidCallback onVoice;
  final VoidCallback onPick;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
            Expanded(
              child: Text(
                switch (type) {
                  CaptureType.note => AppStrings.captureNote,
                  CaptureType.voice => AppStrings.captureVoice,
                  CaptureType.photo => AppStrings.capturePhoto,
                  CaptureType.link => AppStrings.captureLink,
                  CaptureType.document => AppStrings.captureDocument,
                  CaptureType.idea => AppStrings.captureIdea,
                },
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        if (type == CaptureType.voice)
          AppButton(
            label: listening ? AppStrings.voiceStop : AppStrings.voiceRecord,
            variant: AppButtonVariant.secondary,
            onPressed: onVoice,
          ),
        if (type == CaptureType.photo || type == CaptureType.document) ...[
          AppButton(
            label: AppStrings.capturePickFile,
            variant: AppButtonVariant.secondary,
            onPressed: onPick,
          ),
          if (pickedPath != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(pickedPath!, style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: controller,
          label: type == CaptureType.link
              ? AppStrings.captureLink
              : AppStrings.captureContent,
          autofocus: type != CaptureType.voice,
          maxLines: type == CaptureType.idea ? 4 : 2,
          onSubmitted: (_) {},
        ),
      ],
    );
  }
}

/// Global capture FAB.
class CaptureFab extends StatelessWidget {
  const CaptureFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => CaptureSheet.show(context),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.bolt_rounded),
      label: Text(AppStrings.capture),
    );
  }
}

void showCapture(BuildContext context) => CaptureSheet.show(context);
