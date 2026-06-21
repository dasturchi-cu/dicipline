import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/schemas/calendar_event_entity.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import '../providers/core_providers.dart';
import '../providers/repository_providers.dart';
import 'notification_service.dart';

/// Kalendar tadbirlari uchun mahalliy bildirishnomalarni boshqaradi.
class CalendarNotificationHelper {
  CalendarNotificationHelper(this._notifications);

  final NotificationService _notifications;

  static int notificationIdForEvent(int eventId) => 10000 + eventId;

  Future<void> syncEventReminder({
    required CalendarEventEntity event,
    required bool notificationsEnabled,
  }) async {
    final id = notificationIdForEvent(event.id);
    await _notifications.cancel(id);

    if (!notificationsEnabled || !event.hasReminder) {
      return;
    }

    final reminderTime = event.startTime.subtract(
      Duration(minutes: event.reminderMinutes),
    );

    if (reminderTime.isBefore(DateTime.now())) {
      return;
    }

    await _notifications.schedule(
      id: id,
      title: event.title,
      body: event.description?.isNotEmpty == true
          ? event.description!
          : 'Tadbir boshlanishiga ${event.reminderMinutes} daqiqa qoldi',
      scheduledDate: reminderTime,
      payload: '/boshqa/kalendar',
    );
  }

  Future<void> cancelEventReminder(int eventId) {
    return _notifications.cancel(notificationIdForEvent(eventId));
  }

  Future<void> rescheduleAll(WidgetRef ref) async {
    final enabled = ref.read(settingsProvider).notificationEnabled;
    if (!enabled) {
      await _notifications.cancelAll();
      return;
    }

    final events = await ref.read(calendarRepositoryProvider).getAll();
    for (final event in events) {
      await syncEventReminder(event: event, notificationsEnabled: enabled);
    }
  }
}

final calendarNotificationHelperProvider =
    Provider<CalendarNotificationHelper>((ref) {
  return CalendarNotificationHelper(ref.watch(notificationServiceProvider));
});
