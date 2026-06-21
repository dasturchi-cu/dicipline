import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rejabon_ai/core/ai/ai_config.dart';
import 'package:rejabon_ai/core/ai/ai_orchestrator.dart';
import 'package:rejabon_ai/core/ai/ai_provider_client.dart';
import 'package:rejabon_ai/core/ai/ai_rotation_state.dart';
import 'package:rejabon_ai/core/ai/ai_types.dart';

class FakeAiClient implements AiProviderClient {
  FakeAiClient({
    required this.id,
    required this.failuresBeforeSuccess,
  });

  @override
  final AiProviderId id;
  final Map<String, int> failuresBeforeSuccess;
  final List<String> calls = [];

  @override
  Future<String> complete({
    required ProviderConfig config,
    required String model,
    required String apiKey,
    required AiCompletionRequest request,
    required Duration timeout,
  }) async {
    final routeKey = '$model|$apiKey';
    calls.add(routeKey);
    final remaining = failuresBeforeSuccess[routeKey] ?? 0;
    if (remaining > 0) {
      failuresBeforeSuccess[routeKey] = remaining - 1;
      throw AiQuotaException('limit', statusCode: 429);
    }
    return 'ok:$routeKey';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiConfig.fromMap', () {
    test('parses provider chain and multiple keys', () {
      final config = AiConfig.fromMap({
        'AI_PROVIDER': 'gemini',
        'AI_FALLBACK_ORDER': 'openai,groq',
        'GEMINI_API_KEY': 'g1',
        'GEMINI_API_KEY_2': 'g2',
        'GEMINI_MODEL': 'gemini-a',
        'GEMINI_MODEL_FALLBACKS': 'gemini-b',
        'OPENAI_API_KEY': 'o1',
        'OPENAI_MODEL': 'gpt-mini',
        'GROQ_API_KEY': 'q1',
        'GROQ_MODEL': 'llama',
      });

      expect(config.providerChain, [
        AiProviderId.gemini,
        AiProviderId.openai,
        AiProviderId.groq,
      ]);
      expect(config.providers[AiProviderId.gemini]!.apiKeys, ['g1', 'g2']);
      expect(config.providers[AiProviderId.gemini]!.models, ['gemini-a', 'gemini-b']);
    });
  });

  group('AiRotationState', () {
    test('advances key, then model, then provider', () {
      final config = AiConfig.fromMap({
        'AI_PROVIDER': 'gemini',
        'AI_FALLBACK_ORDER': 'openai',
        'GEMINI_API_KEY': 'g1',
        'GEMINI_API_KEY_2': 'g2',
        'GEMINI_MODEL': 'm1',
        'GEMINI_MODEL_FALLBACKS': 'm2',
        'OPENAI_API_KEY': 'o1',
        'OPENAI_MODEL': 'gpt',
      });

      final rotation = AiRotationState(
        providerIndex: 0,
        modelIndices: {
          AiProviderId.gemini: 0,
          AiProviderId.openai: 0,
        },
        keyIndices: {
          AiProviderId.gemini: 0,
          AiProviderId.openai: 0,
        },
      );

      expect(rotation.currentTarget(config).keyIndex, 0);
      expect(rotation.advanceWithinProvider(config), isTrue);
      expect(rotation.currentTarget(config).keyIndex, 1);

      expect(rotation.advanceWithinProvider(config), isTrue);
      expect(rotation.currentTarget(config).modelIndex, 1);
      expect(rotation.currentTarget(config).keyIndex, 0);

      expect(rotation.advanceWithinProvider(config), isTrue);
      expect(rotation.currentTarget(config).modelIndex, 1);
      expect(rotation.currentTarget(config).keyIndex, 1);

      expect(rotation.advanceWithinProvider(config), isTrue);
      expect(rotation.currentTarget(config).provider, AiProviderId.openai);
    });
  });

  group('AiOrchestrator', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('switches to next key on quota error', () async {
      final config = AiConfig.fromMap({
        'AI_PROVIDER': 'gemini',
        'AI_FALLBACK_ORDER': '',
        'AI_MAX_RETRIES': '0',
        'GEMINI_API_KEY': 'g1',
        'GEMINI_API_KEY_2': 'g2',
        'GEMINI_MODEL': 'm1',
      });

      final rotation = AiRotationState(
        providerIndex: 0,
        modelIndices: {AiProviderId.gemini: 0},
        keyIndices: {AiProviderId.gemini: 0},
      );

      final client = FakeAiClient(
        id: AiProviderId.gemini,
        failuresBeforeSuccess: {'m1|g1': 1},
      );

      final orchestrator = AiOrchestrator(
        config: config,
        rotation: rotation,
        clients: {AiProviderId.gemini: client},
      );

      final result = await orchestrator.complete(
        const AiCompletionRequest(messages: [AiMessage(role: 'user', content: 'salom')]),
      );

      expect(result.text, 'ok:m1|g2');
      expect(client.calls, ['m1|g1', 'm1|g2']);
    });

    test('falls back to next provider after all gemini routes fail', () async {
      final config = AiConfig.fromMap({
        'AI_PROVIDER': 'gemini',
        'AI_FALLBACK_ORDER': 'openai',
        'AI_MAX_RETRIES': '0',
        'GEMINI_API_KEY': 'g1',
        'GEMINI_MODEL': 'm1',
        'OPENAI_API_KEY': 'o1',
        'OPENAI_MODEL': 'gpt',
      });

      final rotation = AiRotationState(
        providerIndex: 0,
        modelIndices: {
          AiProviderId.gemini: 0,
          AiProviderId.openai: 0,
        },
        keyIndices: {
          AiProviderId.gemini: 0,
          AiProviderId.openai: 0,
        },
      );

      final geminiClient = FakeAiClient(
        id: AiProviderId.gemini,
        failuresBeforeSuccess: {'m1|g1': 99},
      );
      final openAiClient = FakeAiClient(
        id: AiProviderId.openai,
        failuresBeforeSuccess: {},
      );

      final orchestrator = AiOrchestrator(
        config: config,
        rotation: rotation,
        clients: {
          AiProviderId.gemini: geminiClient,
          AiProviderId.openai: openAiClient,
        },
      );

      final result = await orchestrator.complete(
        const AiCompletionRequest(messages: [AiMessage(role: 'user', content: 'test')]),
      );

      expect(result.provider, AiProviderId.openai);
      expect(result.text, 'ok:gpt|o1');
    });
  });
}
