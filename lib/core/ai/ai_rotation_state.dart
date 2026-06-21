import 'package:shared_preferences/shared_preferences.dart';

import 'ai_config.dart';
import 'ai_types.dart';

class AiRotationState {
  AiRotationState({
    required this.providerIndex,
    required this.modelIndices,
    required this.keyIndices,
  });

  int providerIndex;
  final Map<AiProviderId, int> modelIndices;
  final Map<AiProviderId, int> keyIndices;

  static const _providerIndexKey = 'ai_rotation_provider_index';
  static const _modelIndexPrefix = 'ai_rotation_model_';
  static const _keyIndexPrefix = 'ai_rotation_key_';

  static Future<AiRotationState> load(AiConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final chain = config.providerChain;
    final providerIndex = (prefs.getInt(_providerIndexKey) ?? 0)
        .clamp(0, chain.isEmpty ? 0 : chain.length - 1);

    final modelIndices = <AiProviderId, int>{};
    final keyIndices = <AiProviderId, int>{};
    for (final provider in chain) {
      final providerConfig = config.providers[provider];
      final modelMax = (providerConfig?.models.length ?? 1) - 1;
      final keyMax = (providerConfig?.apiKeys.length ?? 1) - 1;
      modelIndices[provider] =
          (prefs.getInt('$_modelIndexPrefix${provider.name}') ?? 0)
              .clamp(0, modelMax < 0 ? 0 : modelMax);
      keyIndices[provider] =
          (prefs.getInt('$_keyIndexPrefix${provider.name}') ?? 0)
              .clamp(0, keyMax < 0 ? 0 : keyMax);
    }

    return AiRotationState(
      providerIndex: providerIndex,
      modelIndices: modelIndices,
      keyIndices: keyIndices,
    );
  }

  Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_providerIndexKey, providerIndex);
    for (final entry in modelIndices.entries) {
      await prefs.setInt(
        '$_modelIndexPrefix${entry.key.name}',
        entry.value,
      );
    }
    for (final entry in keyIndices.entries) {
      await prefs.setInt(
        '$_keyIndexPrefix${entry.key.name}',
        entry.value,
      );
    }
  }

  AiRouteTarget currentTarget(AiConfig config) {
    final chain = config.providerChain;
    if (chain.isEmpty) {
      return const AiRouteTarget(
        provider: AiProviderId.gemini,
        modelIndex: 0,
        keyIndex: 0,
      );
    }

    final provider = chain[providerIndex.clamp(0, chain.length - 1)];
    return AiRouteTarget(
      provider: provider,
      modelIndex: modelIndices[provider] ?? 0,
      keyIndex: keyIndices[provider] ?? 0,
    );
  }

  bool advanceWithinProvider(AiConfig config) {
    final chain = config.providerChain;
    if (chain.isEmpty) return false;

    final provider = chain[providerIndex.clamp(0, chain.length - 1)];
    final providerConfig = config.providers[provider];
    if (providerConfig == null || !providerConfig.isConfigured) {
      return _advanceProvider(config);
    }

    final keyCount = providerConfig.apiKeys.length;
    final modelCount = providerConfig.models.length;
    final currentKey = keyIndices[provider] ?? 0;
    final currentModel = modelIndices[provider] ?? 0;

    if (currentKey + 1 < keyCount) {
      keyIndices[provider] = currentKey + 1;
      return true;
    }

    if (currentModel + 1 < modelCount) {
      modelIndices[provider] = currentModel + 1;
      keyIndices[provider] = 0;
      return true;
    }

    return _advanceProvider(config);
  }

  bool _advanceProvider(AiConfig config) {
    final chain = config.providerChain;
    if (chain.isEmpty) return false;

    final provider = chain[providerIndex.clamp(0, chain.length - 1)];
    modelIndices[provider] = 0;
    keyIndices[provider] = 0;

    if (providerIndex + 1 < chain.length) {
      providerIndex++;
      return true;
    }

    providerIndex = 0;
    return true;
  }

  void resetAll(AiConfig config) {
    providerIndex = 0;
    for (final provider in config.providerChain) {
      modelIndices[provider] = 0;
      keyIndices[provider] = 0;
    }
  }
}
