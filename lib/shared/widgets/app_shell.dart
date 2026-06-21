import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _topLevelRoutes = {
    '/',
    '/vazifalar',
    '/hayot',
    '/moliya',
    '/boshqa',
  };

  int _selectedIndex(String location) {
    if (location.startsWith('/vazifalar')) return 1;
    if (location.startsWith('/hayot')) return 2;
    if (location.startsWith('/moliya')) return 3;
    if (location.startsWith('/boshqa')) return 4;
    return 0;
  }

  bool _showBottomNav(String location) => _topLevelRoutes.contains(location);

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/vazifalar');
      case 2:
        context.go('/hayot');
      case 3:
        context.go('/moliya');
      case 4:
        context.go('/boshqa');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final showNav = _showBottomNav(location);
    final selectedIndex = _selectedIndex(location);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: showNav
          ? ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _onDestinationSelected(context, index),
                  backgroundColor: isLight
                      ? AppColors.glassLight
                      : AppColors.glassDark,
                  indicatorColor: AppColors.navIndicator,
                  elevation: 0,
                  height: 72,
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
                      icon: Icon(Icons.favorite_outline_rounded),
                      selectedIcon: Icon(Icons.favorite_rounded),
                      label: AppStrings.navLife,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.account_balance_wallet_outlined),
                      selectedIcon: Icon(Icons.account_balance_wallet_rounded),
                      label: AppStrings.navFinance,
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
