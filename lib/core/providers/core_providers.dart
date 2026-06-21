import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../backup/backup_service.dart';
import '../database/isar_service.dart';
import '../emoji/emoji_service.dart';
import '../notifications/notification_service.dart';
import '../ai/ai_orchestrator.dart';

final aiServiceProvider = Provider<AiService?>((ref) {
  return AiService.instance;
});

final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService.instance;
});

final isarProvider = FutureProvider<Isar>((ref) async {
  final service = ref.watch(isarServiceProvider);
  return service.open();
});

final backupServiceProvider = FutureProvider<BackupService>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return BackupService(isar);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  ref.onDispose(() {
    service.cancelAll();
  });
  return service;
});

final emojiServiceProvider = FutureProvider<EmojiService>((ref) async {
  return EmojiService.create();
});
