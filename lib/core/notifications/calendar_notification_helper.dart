import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/schemas/calendar_event_entity.dart';
import '../providers/core_providers.dart';
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

    try {
      await _notifications.schedule(
        id: id,
        title: event.title,
        body: event.description?.isNotEmpty == true
            ? event.description!
            : 'Tadbir boshlanishiga ${event.reminderMinutes} daqiqa qoldi',
        scheduledDate: reminderTime,
        payload: '/boshqa/kalendar',
      );
    } catch (_) {
      // Ruxsat yo'q bo'lsa tadbir baribir saqlanadi.
    }
  }

  Future<void> cancelEventReminder(int eventId) {
    return _notifications.cancel(notificationIdForEvent(eventId));
  }

  Future<void> rescheduleAll({
    required bool notificationsEnabled,
    required List<CalendarEventEntity> events,
  }) async {
    if (!notificationsEnabled) {
      await _notifications.cancelAll();
      return;
    }

    for (final event in events) {
      await syncEventReminder(event: event, notificationsEnabled: notificationsEnabled);
    }
  }
}

final calendarNotificationHelperProvider =
    Provider<CalendarNotificationHelper>((ref) {
  return CalendarNotificationHelper(ref.watch(notificationServiceProvider));
});
