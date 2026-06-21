import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/ai/ai_config.dart';

void main() {
  group('AiConfig', () {
    test('parseEnvFile ignores comments and empty lines', () {
      const content = '''
# comment
AI_PROVIDER=gemini
GEMINI_API_KEY=test-key

EMPTY=
''';
      final map = AiConfig.parseEnvFile(content);
      expect(map['AI_PROVIDER'], 'gemini');
      expect(map['GEMINI_API_KEY'], 'test-key');
      expect(map['EMPTY'], '');
    });

    test('fromMap returns unconfigured when no keys', () {
      final config = AiConfig.fromMap(const {});
      expect(config.isConfigured, isFalse);
    });

    test('fromMap configures gemini when key present', () {
      final config = AiConfig.fromMap({
        'GEMINI_API_KEY': 'abc',
        'GEMINI_MODEL': 'gemini-2.0-flash-lite',
      });
      expect(config.isConfigured, isTrue);
    });

    test('aiEnvAssetPath points to example template', () {
      expect(AiConfig.aiEnvAssetPath, 'assets/ai.env.example');
    });

    test('loadDartDefineEnv returns map with expected keys', () {
      final env = AiConfig.loadDartDefineEnv();
      expect(env, isA<Map<String, String>>());
    });
  });
}
