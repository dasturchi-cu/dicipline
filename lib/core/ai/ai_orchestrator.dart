import 'dart:async';

import 'ai_config.dart';
import 'ai_provider_client.dart';
import 'ai_rotation_state.dart';
import 'ai_status.dart';
import 'ai_types.dart';

class AiOrchestrator {
  AiOrchestrator({
    required AiConfig config,
    required AiRotationState rotation,
    Map<AiProviderId, AiProviderClient>? clients,
  })  : _config = config,
        _rotation = rotation,
        _clients = clients ?? createDefaultAiClients(config);

  final AiConfig _config;
  final AiRotationState _rotation;
  final Map<AiProviderId, AiProviderClient> _clients;

  AiConfig get config => _config;

  Future<AiCompletionResult> complete(AiCompletionRequest request) async {
    if (!_config.isConfigured) {
      throw StateError('AI konfiguratsiyasi topilmadi');
    }

    final timeout = Duration(milliseconds: _config.requestTimeoutMs);
    final startTarget = _rotation.currentTarget(_config);
    var attempts = 0;
    final maxAttempts = _totalRoutes();

    while (attempts < maxAttempts) {
      final target = _rotation.currentTarget(_config);
      attempts++;

      final providerConfig = _config.providers[target.provider];
      if (providerConfig == null || !providerConfig.isConfigured) {
        if (!_rotation.advanceWithinProvider(_config)) break;
        continue;
      }

      final model = providerConfig.models[
          target.modelIndex.clamp(0, providerConfig.models.length - 1)];
      final apiKey = providerConfig.apiKeys[
          target.keyIndex.clamp(0, providerConfig.apiKeys.length - 1)];
      final client = _clients[target.provider];

      if (client == null) {
        if (!_rotation.advanceWithinProvider(_config)) break;
        continue;
      }

      try {
        final text = await _callWithRetries(
          client: client,
          providerConfig: providerConfig,
          model: model,
          apiKey: apiKey,
          request: request,
          timeout: timeout,
        );

        await _rotation.persist();
        return AiCompletionResult(
          text: text,
          provider: target.provider,
          model: model,
          keyIndex: target.keyIndex,
        );
      } on AiQuotaException catch (error) {
        _log(
          'Limit: ${target.provider.name}/$model key#${target.keyIndex + 1} '
          '→ keyingi',
        );
        if (!_rotation.advanceWithinProvider(_config)) {
          _rotation.resetAll(_config);
        }
        await _rotation.persist();
        if (_sameTarget(startTarget, _rotation.currentTarget(_config)) &&
            attempts > 1) {
          throw error;
        }
      } on AiRequestException catch (error) {
        _log(
          'Xato: ${target.provider.name}/$model '
          '(${error.statusCode}) → keyingi',
        );
        if (error.statusCode != null &&
            isQuotaOrRateLimitError(error.statusCode!, error.message)) {
          if (!_rotation.advanceWithinProvider(_config)) {
            _rotation.resetAll(_config);
          }
        } else if (!_rotation.advanceWithinProvider(_config)) {
          _rotation.resetAll(_config);
        }
        await _rotation.persist();
        if (_sameTarget(startTarget, _rotation.currentTarget(_config)) &&
            attempts > 1) {
          throw error;
        }
      } on TimeoutException {
        _log('Timeout: ${target.provider.name}/$model → keyingi');
        if (!_rotation.advanceWithinProvider(_config)) {
          _rotation.resetAll(_config);
        }
        await _rotation.persist();
      }
    }

    throw StateError('Barcha AI provayderlar va kalitlar band yoki limit tugagan');
  }

  Future<String> _callWithRetries({
    required AiProviderClient client,
    required ProviderConfig providerConfig,
    required String model,
    required String apiKey,
    required AiCompletionRequest request,
    required Duration timeout,
  }) async {
    Object? lastError;
    final retries = _config.maxRetries.clamp(0, 5);

    for (var attempt = 0; attempt <= retries; attempt++) {
      try {
        return await client.complete(
          config: providerConfig,
          model: model,
          apiKey: apiKey,
          request: request,
          timeout: timeout,
        );
      } catch (error) {
        lastError = error;
        if (error is AiQuotaException) rethrow;
        if (attempt < retries) {
          await Future<void>.delayed(
            Duration(milliseconds: _config.retryDelayMs),
          );
        }
      }
    }

    throw lastError ?? StateError('AI so\'rov muvaffaqiyatsiz');
  }

  int _totalRoutes() {
    var total = 0;
    for (final provider in _config.providerChain) {
      final providerConfig = _config.providers[provider];
      if (providerConfig == null || !providerConfig.isConfigured) continue;
      total += providerConfig.apiKeys.length * providerConfig.models.length;
    }
    return total == 0 ? 1 : total;
  }

  bool _sameTarget(AiRouteTarget a, AiRouteTarget b) {
    return a.provider == b.provider &&
        a.modelIndex == b.modelIndex &&
        a.keyIndex == b.keyIndex;
  }

  void _log(String message) {
    if (_config.debugLogs) {
      // ignore: avoid_print
      print('[AI] $message');
    }
  }
}

class AiService {
  AiService._({
    required this.config,
    required this.orchestrator,
    required this.rotation,
    this.configSource,
  });

  final AiConfig config;
  final AiOrchestrator orchestrator;
  final AiRotationState rotation;
  final String? configSource;

  AiCompletionResult? lastSuccess;
  String? lastError;
  DateTime? lastSuccessAt;

  static AiService? _instance;

  static AiService? get instance => _instance;

  static Future<AiService?> initialize({String? envPath}) async {
    final env = await AiConfig.loadEnvMap(envPath: envPath);
    return _createFromEnv(env, _detectConfigSource(env));
  }

  static Future<AiService?> initializeFromMap(Map<String, String> env) async {
    return _createFromEnv(env, 'qo\'lda');
  }

  static Future<AiService?> _createFromEnv(
    Map<String, String> env,
    String? configSource,
  ) async {
    final config = AiConfig.fromMap(env);
    if (!config.isConfigured) {
      _instance = null;
      return null;
    }

    final rotation = await AiRotationState.load(config);
    _instance = AiService._(
      config: config,
      orchestrator: AiOrchestrator(config: config, rotation: rotation),
      rotation: rotation,
      configSource: configSource,
    );
    return _instance;
  }

  static String? _detectConfigSource(Map<String, String> env) {
    if (!_hasAnyKey(env)) return null;
    return env.containsKey('GEMINI_API_KEY') ? 'dart-define/.env' : null;
  }

  static bool _hasAnyKey(Map<String, String> env) {
    return AiConfig.fromMap(env).isConfigured;
  }

  AiStatusInfo buildStatus() {
    return AiStatusInfo.fromService(
      config: config,
      target: rotation.currentTarget(config),
      configSource: configSource,
      lastSuccessAt: lastSuccessAt,
      lastError: lastError,
    );
  }

  Future<bool> testConnection() async {
    try {
      final result = await orchestrator.complete(
        const AiCompletionRequest(
          messages: [AiMessage(role: 'user', content: 'Salom')],
          maxOutputTokens: 16,
        ),
      );
      lastSuccess = result;
      lastError = null;
      lastSuccessAt = DateTime.now();
      return true;
    } catch (error) {
      lastError = error.toString();
      return false;
    }
  }

  Future<String?> chat({
    required String prompt,
    String? systemPrompt,
    int? maxOutputTokens,
  }) async {
    try {
      final result = await orchestrator.complete(
        AiCompletionRequest(
          messages: [AiMessage(role: 'user', content: prompt)],
          systemPrompt: systemPrompt,
          maxOutputTokens: maxOutputTokens,
        ),
      );
      lastSuccess = result;
      lastError = null;
      lastSuccessAt = DateTime.now();
      return result.text;
    } catch (error) {
      lastError = error.toString();
      rethrow;
    }
  }
}
