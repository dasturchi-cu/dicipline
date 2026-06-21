import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifications/notification_service.dart';
import '../notifications/retention_notification_providers.dart';
import '../../features/future_simulator/domain/future_letter_service.dart';
import '../../features/gamification/presentation/providers/gamification_providers.dart';
import '../../features/phase2/presentation/providers/phase2_providers.dart';
import '../router/app_router.dart';
import 'provider_sync.dart';

/// Bildirishnoma bosilganda navigatsiya.
class NotificationRouterBridge extends ConsumerStatefulWidget {
  const NotificationRouterBridge({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationRouterBridge> createState() =>
      _NotificationRouterBridgeState();
}

class _NotificationRouterBridgeState
    extends ConsumerState<NotificationRouterBridge> {
  @override
  void initState() {
    super.initState();
    NotificationService.onPayloadTap = _handlePayload;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshMissedPlanState(ref);
      await syncAllNotifications(ref);
      await scheduleRetentionNotifications(ref);
      await _processLetterDeliveries(ref);
      await checkEmotionIntervention(ref);
      await runDailyBootstrap(ref);
      await runPhase2Bootstrap(ref);
    });
  }

  @override
  void dispose() {
    if (NotificationService.onPayloadTap == _handlePayload) {
      NotificationService.onPayloadTap = null;
    }
    super.dispose();
  }

  void _handlePayload(String payload) {
    if (!mounted) return;
    final router = ref.read(appRouterProvider);
    if (payload.contains('?')) {
      final uri = Uri.parse(payload);
      router.go(uri.path);
    } else {
      router.go(payload);
    }
  }

  Future<void> _processLetterDeliveries(WidgetRef ref) async {
    final delivered =
        await ref.read(futureLetterServiceProvider).processDeliveries();
    if (delivered.isEmpty) return;
    final helper = ref.read(retentionNotificationHelperProvider);
    for (final letter in delivered) {
      await helper.notifyLetterUnlocked(
        horizonLabel: FutureLetterService.horizonLabel(letter.deliveryHorizon),
        letterId: letter.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
