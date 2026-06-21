import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rejabon_ai/core/ai/ai_orchestrator.dart';
import 'package:rejabon_ai/core/ai/ai_status.dart';

final aiStatusRefreshProvider = StateProvider<int>((ref) => 0);

final aiStatusProvider = Provider<AiStatusInfo>((ref) {
  ref.watch(aiStatusRefreshProvider);
  return AiService.instance?.buildStatus() ?? AiStatusInfo.notConfigured();
});

final aiConnectionTestProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final ai = AiService.instance;
  if (ai == null) return false;
  final ok = await ai.testConnection();
  ref.read(aiStatusRefreshProvider.notifier).state++;
  return ok;
});
