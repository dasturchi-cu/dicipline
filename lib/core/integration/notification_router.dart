import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifications/notification_service.dart';
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
    router.go(payload);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
