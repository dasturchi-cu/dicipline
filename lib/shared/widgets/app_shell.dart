import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/content_insets.dart';
import '../../features/capture/presentation/providers/capture_providers.dart';
import '../../features/time_tracking/domain/time_tracker_notifier.dart';
import 'app_feedback.dart';

/// 4 tab shell — Home, Tasks, Life, More.
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _topLevelRoutes = {
    '/',
    '/vazifalar',
    '/hayot',
    '/boshqa',
  };

  int _selectedIndex(String location) {
    if (location.startsWith('/vazifalar')) return 1;
    if (location.startsWith('/hayot')) return 2;
    if (location.startsWith('/boshqa')) return 3;
    return 0;
  }

  bool _showBottomNav(String location) => _topLevelRoutes.contains(location);

  void _onDestinationSelected(BuildContext context, int index) {
    hapticLight();
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/vazifalar');
      case 2:
        context.go('/hayot');
      case 3:
        context.go('/boshqa');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final showNav = _showBottomNav(location);
    final selectedIndex = _selectedIndex(location);
    final brightness = Theme.of(context).brightness;
    final timer = ref.watch(timeTrackerProvider);

    return Scaffold(
      body: Column(
        children: [
          if (timer.state != TimerState.idle) _ActiveTimerBar(timer: timer),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: showNav
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface(brightness),
                border: Border(
                  top: BorderSide(
                    color: AppColors.border(brightness, subtle: true),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 4),
                child: NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _onDestinationSelected(context, index),
                  backgroundColor: Colors.transparent,
                  indicatorColor: AppColors.primary.withValues(alpha: 0.1),
                  elevation: 0,
                  height: ContentInsets.shellNavBarHeight,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: AppStrings.navHome,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.check_circle_outline_rounded),
                      selectedIcon: Icon(Icons.check_circle_rounded),
                      label: AppStrings.navTasks,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.spa_outlined),
                      selectedIcon: Icon(Icons.spa_rounded),
                      label: AppStrings.navLife,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.more_horiz_rounded),
                      selectedIcon: Icon(Icons.more_horiz_rounded),
                      label: AppStrings.navMore,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _ActiveTimerBar extends ConsumerWidget {
  const _ActiveTimerBar({required this.timer});

  final ActiveTimerSession timer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = timer.elapsedSeconds ~/ 60;
    final s = timer.elapsedSeconds % 60;
    final notifier = ref.read(timeTrackerProvider.notifier);

    return Material(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${timer.label} · ${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              IconButton(
                icon: Icon(
                  timer.state == TimerState.running
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (timer.state == TimerState.running) {
                    notifier.pause();
                  } else {
                    notifier.start();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop_rounded, color: Colors.white),
                onPressed: () => notifier.stop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
