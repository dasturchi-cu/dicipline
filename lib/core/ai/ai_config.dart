import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ai_types.dart';

class ProviderConfig {
  const ProviderConfig({
    required this.apiKeys,
    required this.models,
    this.maxOutputTokens,
    this.accountId,
    this.httpReferer,
    this.xTitle,
  });

  final List<String> apiKeys;
  final List<String> models;
  final int? maxOutputTokens;
  final String? accountId;
  final String? httpReferer;
  final String? xTitle;

  bool get isConfigured => apiKeys.isNotEmpty && models.isNotEmpty;
}

class AiConfig {
  const AiConfig({
    required this.primaryProvider,
    required this.fallbackOrder,
    required this.providers,
    this.requestTimeoutMs = 90000,
    this.maxRetries = 2,
    this.retryDelayMs = 1500,
    this.debugLogs = false,
  });

  final AiProviderId primaryProvider;
  final List<AiProviderId> fallbackOrder;
  final Map<AiProviderId, ProviderConfig> providers;
  final int requestTimeoutMs;
  final int maxRetries;
  final int retryDelayMs;
  final bool debugLogs;

  bool get isConfigured =>
      providerChain.any((id) => providers[id]?.isConfigured ?? false);

  List<AiProviderId> get providerChain {
    final chain = <AiProviderId>[primaryProvider];
    for (final id in fallbackOrder) {
      if (!chain.contains(id)) chain.add(id);
    }
    return chain;
  }

  static AiProviderId? parseProviderId(String? value) {
    if (value == null || value.isEmpty) return null;
    return switch (value.toLowerCase()) {
      'gemini' => AiProviderId.gemini,
      'openai' => AiProviderId.openai,
      'openrouter' => AiProviderId.openrouter,
      'groq' => AiProviderId.groq,
      'cloudflare' => AiProviderId.cloudflare,
      _ => null,
    };
  }

  static List<String> _collectKeys(Map<String, String> env, String prefix) {
    final keys = <String>[];
    final primary = env['${prefix}_API_KEY']?.trim();
    if (primary != null && primary.isNotEmpty) keys.add(primary);

    final token = env['${prefix}_API_TOKEN']?.trim();
    if (token != null && token.isNotEmpty && !keys.contains(token)) {
      keys.add(token);
    }

    for (var i = 2; i <= 20; i++) {
      final value = env['${prefix}_API_KEY_$i']?.trim();
      if (value == null || value.isEmpty) break;
      if (!keys.contains(value)) keys.add(value);
    }
    return keys;
  }

  static List<String> _splitList(String? value) {
    if (value == null || value.trim().isEmpty) return [];
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static List<String> _modelsFromEnv(
    Map<String, String> env,
    String prefix,
  ) {
    final primary = env['${prefix}_MODEL']?.trim() ??
        env['${prefix}_AI_MODEL']?.trim();
    final fallbacks = [
      ..._splitList(env['${prefix}_MODEL_FALLBACKS']),
      ..._splitList(env['${prefix}_AI_MODEL_FALLBACKS']),
    ];
    final models = <String>[];
    if (primary != null && primary.isNotEmpty) models.add(primary);
    for (final model in fallbacks) {
      if (!models.contains(model)) models.add(model);
    }
    return models;
  }

  static AiConfig fromMap(Map<String, String> env) {
    final primary = parseProviderId(env['AI_PROVIDER']) ?? AiProviderId.gemini;
    final fallbackOrder = _splitList(env['AI_FALLBACK_ORDER'])
        .map(parseProviderId)
        .whereType<AiProviderId>()
        .toList();

    int parseInt(String? value, int fallback) =>
        int.tryParse(value ?? '') ?? fallback;

    bool parseBool(String? value, {bool fallback = false}) {
      if (value == null) return fallback;
      return value.toLowerCase() == 'true' || value == '1';
    }

    return AiConfig(
      primaryProvider: primary,
      fallbackOrder: fallbackOrder,
      requestTimeoutMs: parseInt(env['AI_REQUEST_TIMEOUT_MS'], 90000),
      maxRetries: parseInt(env['AI_MAX_RETRIES'], 2),
      retryDelayMs: parseInt(env['AI_RETRY_DELAY_MS'], 1500),
      debugLogs: parseBool(env['BOT_DEBUG_LOGS']),
      providers: {
        AiProviderId.gemini: ProviderConfig(
          apiKeys: _collectKeys(env, 'GEMINI'),
          models: _modelsFromEnv(env, 'GEMINI'),
          maxOutputTokens: parseInt(env['GEMINI_MAX_OUTPUT_TOKENS'], 8192),
        ),
        AiProviderId.openai: ProviderConfig(
          apiKeys: _collectKeys(env, 'OPENAI'),
          models: _modelsFromEnv(env, 'OPENAI'),
        ),
        AiProviderId.openrouter: ProviderConfig(
          apiKeys: _collectKeys(env, 'OPENROUTER'),
          models: _modelsFromEnv(env, 'OPENROUTER'),
          httpReferer: env['OPENROUTER_HTTP_REFERER'],
          xTitle: env['OPENROUTER_X_TITLE'],
        ),
        AiProviderId.groq: ProviderConfig(
          apiKeys: _collectKeys(env, 'GROQ'),
          models: _modelsFromEnv(env, 'GROQ'),
        ),
        AiProviderId.cloudflare: ProviderConfig(
          apiKeys: _collectKeys(env, 'CLOUDFLARE'),
          models: _modelsFromEnv(env, 'CLOUDFLARE'),
          accountId: env['CLOUDFLARE_ACCOUNT_ID'],
        ),
      },
    );
  }

  static Map<String, String> parseEnvFile(String content) {
    final result = <String, String>{};
    for (final rawLine in content.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final separator = line.indexOf('=');
      if (separator <= 0) continue;
      final key = line.substring(0, separator).trim();
      var value = line.substring(separator + 1).trim();
      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }
      result[key] = value;
    }
    return result;
  }

  static Future<AiConfig> load({String? envPath}) async {
    final env = await loadEnvMap(envPath: envPath);
    return fromMap(env);
  }

  static const aiEnvAssetPath = 'assets/ai.env.example';

  static Future<Map<String, String>> loadEnvMap({String? envPath}) async {
    // Release + debug: compile-time --dart-define keys (production path).
    final dartDefine = _loadDartDefineEnv();
    if (_hasAiKeys(dartDefine)) return dartDefine;

    if (!kReleaseMode) {
      if (!kIsWeb) {
        try {
          final path = envPath ?? '.env';
          final file = File(path);
          if (await file.exists()) {
            final parsed = parseEnvFile(await file.readAsString());
            if (_hasAiKeys(parsed)) return parsed;
          }
        } catch (_) {}
      }

      try {
        final content = await rootBundle.loadString(aiEnvAssetPath);
        final parsed = parseEnvFile(content);
        if (_hasAiKeys(parsed)) return parsed;
      } catch (_) {}
    }

    if (!kIsWeb) {
      final platformEnv = Map<String, String>.from(Platform.environment);
      if (_hasAiKeys(platformEnv)) return platformEnv;
    }

    return dartDefine;
  }

  /// Reads `--dart-define=KEY=value` compile-time constants.
  @visibleForTesting
  static Map<String, String> loadDartDefineEnv() => _loadDartDefineEnv();

  static Map<String, String> _loadDartDefineEnv() {
    const scalarKeys = [
      'AI_PROVIDER',
      'AI_FALLBACK_ORDER',
      'AI_REQUEST_TIMEOUT_MS',
      'AI_MAX_RETRIES',
      'AI_RETRY_DELAY_MS',
      'BOT_DEBUG_LOGS',
      'GEMINI_API_KEY',
      'GEMINI_MODEL',
      'GEMINI_MODEL_FALLBACKS',
      'GEMINI_MAX_OUTPUT_TOKENS',
      'OPENAI_API_KEY',
      'OPENAI_MODEL',
      'OPENROUTER_API_KEY',
      'OPENROUTER_MODEL',
      'OPENROUTER_HTTP_REFERER',
      'OPENROUTER_X_TITLE',
      'GROQ_API_KEY',
      'GROQ_MODEL',
      'CLOUDFLARE_API_KEY',
      'CLOUDFLARE_API_TOKEN',
      'CLOUDFLARE_ACCOUNT_ID',
      'CLOUDFLARE_MODEL',
    ];

    final env = <String, String>{};
    for (final key in scalarKeys) {
      final value = String.fromEnvironment(key, defaultValue: '');
      if (value.isNotEmpty) env[key] = value;
    }

    for (final prefix in ['GEMINI', 'OPENAI', 'OPENROUTER', 'GROQ', 'CLOUDFLARE']) {
      for (var i = 2; i <= 20; i++) {
        final key = '${prefix}_API_KEY_$i';
        final value = String.fromEnvironment(key, defaultValue: '');
        if (value.isEmpty) break;
        env[key] = value;
      }
    }

    return env;
  }

  static bool _hasAiKeys(Map<String, String> env) {
    return env['GEMINI_API_KEY']?.isNotEmpty == true ||
        env['OPENAI_API_KEY']?.isNotEmpty == true ||
        env['OPENROUTER_API_KEY']?.isNotEmpty == true ||
        env['GROQ_API_KEY']?.isNotEmpty == true ||
        env['CLOUDFLARE_API_KEY']?.isNotEmpty == true ||
        env['CLOUDFLARE_API_TOKEN']?.isNotEmpty == true;
  }
}
