import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Umumiy ovoz yozish xizmati (STT).
class SpeechCaptureService {
  SpeechCaptureService._();

  static final SpeechCaptureService instance = SpeechCaptureService._();

  final SpeechToText _speech = SpeechToText();
  bool _initialized = false;
  bool _listening = false;

  bool get isListening => _listening;
  bool get isAvailable => _initialized;

  Future<bool> initialize() async {
    if (_initialized) return true;
    _initialized = await _speech.initialize(
      onError: (e) => debugPrint('STT error: $e'),
      onStatus: (s) {
        if (s == 'done' || s == 'notListening') _listening = false;
      },
    );
    return _initialized;
  }

  Future<void> startListening({
    required void Function(String partial) onPartial,
    required void Function(String finalText) onFinal,
    String localeId = 'uz_UZ',
  }) async {
    if (!await initialize()) return;
    if (_listening) await stopListening();

    _listening = true;
    var buffer = '';

    await _speech.listen(
      localeId: localeId,
      listenMode: ListenMode.dictation,
      onResult: (result) {
        buffer = result.recognizedWords;
        if (result.finalResult) {
          _listening = false;
          onFinal(buffer.trim());
        } else {
          onPartial(buffer.trim());
        }
      },
    );
  }

  Future<void> stopListening() async {
    if (_listening) {
      await _speech.stop();
      _listening = false;
    }
  }

  Future<void> dispose() async {
    await stopListening();
    _initialized = false;
  }
}
