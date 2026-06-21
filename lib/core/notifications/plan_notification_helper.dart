import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/schemas/plan_entity.dart';
import '../providers/core_providers.dart';
import 'notification_service.dart';

/// Kunlik reja bandlari uchun mahalliy bildirishnomalar.
class PlanNotificationHelper {
  PlanNotificationHelper(this._notifications);

  final NotificationService _notifications;

  static int notificationIdForItem(int planId, int itemIndex) =>
      20000 + planId * 100 + itemIndex;

  String _bodyForItem(PlanItemEmbedded item, int leadMinutes) {
    if (leadMinutes <= 0) {
      return '${item.emoji} ${item.title} vaqti keldi!';
    }
    return '${item.emoji} ${leadMinutes} daqiqadan so\'ng ${item.title.toLowerCase()} vaqti.';
  }

  Future<void> syncPlan({
    required PlanEntity plan,
    required bool notificationsEnabled,
    required int leadMinutes,
  }) async {
    for (var i = 0; i < plan.items.length; i++) {
      await syncItem(
        planId: plan.id,
        itemIndex: i,
        item: plan.items[i],
        notificationsEnabled: notificationsEnabled,
        leadMinutes: leadMinutes,
      );
    }
  }

  Future<void> syncItem({
    required int planId,
    required int itemIndex,
    required PlanItemEmbedded item,
    required bool notificationsEnabled,
    required int leadMinutes,
  }) async {
    final id = notificationIdForItem(planId, itemIndex);
    await _notifications.cancel(id);

    if (!notificationsEnabled || item.isCompleted) {
      return;
    }

    final reminderTime = item.startTime.subtract(
      Duration(minutes: leadMinutes),
    );

    if (reminderTime.isBefore(DateTime.now())) {
      return;
    }

    try {
      await _notifications.schedule(
        id: id,
        title: 'REJABON AI',
        body: _bodyForItem(item, leadMinutes),
        scheduledDate: reminderTime,
        payload: '/reja',
      );
    } catch (_) {
      // Exact alarm ruxsati yo'q bo'lsa ham reja saqlanadi.
    }
  }

  Future<void> cancelPlan(int planId, int itemCount) async {
    for (var i = 0; i < itemCount; i++) {
      await _notifications.cancel(notificationIdForItem(planId, i));
    }
  }

  Future<void> rescheduleAll({
    required bool notificationsEnabled,
    required int leadMinutes,
    required List<PlanEntity> plans,
  }) async {
    if (!notificationsEnabled) {
      return;
    }

    for (final plan in plans) {
      await syncPlan(
        plan: plan,
        notificationsEnabled: notificationsEnabled,
        leadMinutes: leadMinutes,
      );
    }
  }
}

final planNotificationHelperProvider =
    Provider<PlanNotificationHelper>((ref) {
  return PlanNotificationHelper(ref.watch(notificationServiceProvider));
});
