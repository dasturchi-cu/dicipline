import 'ai_config.dart';
import 'ai_types.dart';

enum AiConnectionState {
  active,
  notConfigured,
  error,
}

class AiProviderSummary {
  const AiProviderSummary({
    required this.id,
    required this.keyCount,
    required this.modelCount,
    required this.isConfigured,
  });

  final AiProviderId id;
  final int keyCount;
  final int modelCount;
  final bool isConfigured;

  String get displayName => switch (id) {
        AiProviderId.gemini => 'Gemini',
        AiProviderId.openai => 'OpenAI',
        AiProviderId.openrouter => 'OpenRouter',
        AiProviderId.groq => 'Groq',
        AiProviderId.cloudflare => 'Cloudflare',
      };
}

class AiStatusInfo {
  const AiStatusInfo({
    required this.connectionState,
    required this.currentProvider,
    required this.currentModel,
    required this.currentKeyNumber,
    required this.totalKeysForProvider,
    required this.fallbackChain,
    required this.providers,
    this.lastSuccessAt,
    this.lastError,
    this.configSource,
  });

  final AiConnectionState connectionState;
  final AiProviderId? currentProvider;
  final String? currentModel;
  final int? currentKeyNumber;
  final int? totalKeysForProvider;
  final List<AiProviderId> fallbackChain;
  final List<AiProviderSummary> providers;
  final DateTime? lastSuccessAt;
  final String? lastError;
  final String? configSource;

  bool get isActive => connectionState == AiConnectionState.active;

  String get statusLabel => switch (connectionState) {
        AiConnectionState.active => 'Faol',
        AiConnectionState.notConfigured => 'Sozlanmagan',
        AiConnectionState.error => 'Xato',
      };

  factory AiStatusInfo.notConfigured() {
    return const AiStatusInfo(
      connectionState: AiConnectionState.notConfigured,
      currentProvider: null,
      currentModel: null,
      currentKeyNumber: null,
      totalKeysForProvider: null,
      fallbackChain: [],
      providers: [],
      configSource: null,
    );
  }

  static AiStatusInfo fromService({
    required AiConfig config,
    required AiRouteTarget target,
    required String? configSource,
    DateTime? lastSuccessAt,
    String? lastError,
  }) {
    final providerConfig = config.providers[target.provider];
    final model = providerConfig?.models.isNotEmpty == true
        ? providerConfig!.models[
            target.modelIndex.clamp(0, providerConfig.models.length - 1)]
        : null;

    final summaries = config.providerChain.map((id) {
      final cfg = config.providers[id];
      return AiProviderSummary(
        id: id,
        keyCount: cfg?.apiKeys.length ?? 0,
        modelCount: cfg?.models.length ?? 0,
        isConfigured: cfg?.isConfigured ?? false,
      );
    }).toList();

    final connectionState = !config.isConfigured
        ? AiConnectionState.notConfigured
        : lastError != null && lastSuccessAt == null
            ? AiConnectionState.error
            : AiConnectionState.active;

    return AiStatusInfo(
      connectionState: connectionState,
      currentProvider: target.provider,
      currentModel: model,
      currentKeyNumber: (providerConfig?.apiKeys.isNotEmpty ?? false)
          ? target.keyIndex + 1
          : null,
      totalKeysForProvider: providerConfig?.apiKeys.length,
      fallbackChain: config.providerChain,
      providers: summaries,
      lastSuccessAt: lastSuccessAt,
      lastError: lastError,
      configSource: configSource,
    );
  }
}
