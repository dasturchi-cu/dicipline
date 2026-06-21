import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/notifications/notification_service.dart';
import 'package:rejabon_ai/core/notifications/retention_notification_helper.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';

final retentionNotificationHelperProvider =
    Provider<RetentionNotificationHelper>((ref) {
  return RetentionNotificationHelper(
    notifications: NotificationService.instance,
    taskRepo: ref.watch(taskRepositoryProvider),
    habitRepo: ref.watch(habitRepositoryProvider),
    goalRepo: ref.watch(goalRepositoryProvider),
    journalRepo: ref.watch(journalRepositoryProvider),
  );
});

Future<void> scheduleRetentionNotifications(WidgetRef ref) async {
  final settings = ref.read(settingsProvider);
  if (!settings.notificationEnabled) return;

  await ref.read(retentionNotificationHelperProvider).scheduleMorningBriefing(
        enabled: true,
        userName: settings.userName,
      );
}

Future<void> checkEmotionIntervention(WidgetRef ref) async {
  final settings = ref.read(settingsProvider);
  await ref.read(retentionNotificationHelperProvider).maybeNotifyEmotionIntervention(
        enabled: settings.notificationEnabled,
      );
}
