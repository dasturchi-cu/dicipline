import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Ovozli javob — TTS qatlami.
class TextToSpeechService {
  TextToSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  var _initialized = false;

  Future<void> initialize({String language = 'uz-UZ'}) async {
    if (_initialized) return;
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    if (kIsWeb) return;
    await initialize();
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();

  Future<void> dispose() async {
    await _tts.stop();
  }
}
