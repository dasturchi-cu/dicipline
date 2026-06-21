import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/coach_conversation_entity.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

/// Ovozli AI murabbiy — STT + Life Twin javob.
class VoiceCoachScreen extends ConsumerStatefulWidget {
  const VoiceCoachScreen({super.key});

  @override
  ConsumerState<VoiceCoachScreen> createState() => _VoiceCoachScreenState();
}

class _VoiceCoachScreenState extends ConsumerState<VoiceCoachScreen> {
  final _textCtrl = TextEditingController();
  var _listening = false;
  var _processing = false;
  String _partial = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceAiServiceProvider).initialize();
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleVoice() async {
    final voice = ref.read(voiceAiServiceProvider);
    if (_listening) {
      await voice.stopVoiceInput();
      setState(() => _listening = false);
      return;
    }

    setState(() {
      _listening = true;
      _partial = '';
    });

    await voice.startVoiceInput(
      onPartial: (text) {
        if (mounted) {
          setState(() {
            _partial = text;
            _textCtrl.text = text;
          });
        }
      },
      onResult: (text) async {
        if (!mounted) return;
        setState(() => _listening = false);
        if (text.isNotEmpty) await _send(text, inputType: 'voice');
      },
    );
  }

  Future<void> _send(String message, {String inputType = 'text'}) async {
    if (message.trim().isEmpty || _processing) return;
    setState(() => _processing = true);

    try {
      final profile = await ref.read(lifeTwinProfileProvider.future);
      final voice = ref.read(voiceAiServiceProvider);
      final result = await voice.processVoiceInput(
        transcript: message,
        profile: profile,
      );
      ref.invalidate(coachConversationProvider);
      ref.invalidate(tasksProvider);
      ref.invalidate(habitsProvider);
      ref.invalidate(plansProvider);
      _textCtrl.clear();
      _partial = '';
      if (mounted && result.isAction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final convAsync = ref.watch(coachConversationProvider);
    final brightness = Theme.of(context).brightness;

    return ModuleScreen(
      title: AppStrings.voiceCoach,
      showBackButton: true,
      body: Column(
        children: [
          Expanded(
            child: convAsync.when(
              loading: () => const AppLoadingState(),
              error: (_, __) => Center(child: Text(AppStrings.errorGeneric)),
              data: (messages) {
                final sorted = [...messages]
                  ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                if (sorted.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Text(
                        AppStrings.voiceCoachEmpty,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary(brightness),
                            ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: sorted.length,
                  itemBuilder: (context, i) {
                    final msg = sorted[i];
                    final isUser = msg.role == 'user';
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : AppColors.surface(brightness, elevated: true),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg.inputType == 'voice')
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Icon(Icons.mic, size: 14),
                              ),
                            Text(msg.message),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_partial.isNotEmpty && _listening)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('$_partial…',
                  style: Theme.of(context).textTheme.bodySmall),
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
                  child: TextField(
                    controller: _textCtrl,
                    decoration: InputDecoration(
                      hintText: AppStrings.voiceCoachHint,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (v) => _send(v),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FloatingActionButton(
                  heroTag: 'voice_coach_mic',
                  onPressed: _processing ? null : _toggleVoice,
                  backgroundColor:
                      _listening ? AppColors.error : AppColors.primary,
                  child: Icon(_listening ? Icons.stop_rounded : Icons.mic_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
