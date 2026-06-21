import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_planning/presentation/screens/ai_planning_screens.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/finance/presentation/screens/finance_screen.dart';
import '../../features/life/presentation/screens/life_screens.dart';
import '../../features/more/presentation/screens/more_screens.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import '../../features/tasks/presentation/screens/tasks_screens.dart';
import '../../shared/widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

Page<void> _materialPage(GoRouterState state, Widget child) {
  return MaterialPage<void>(key: state.pageKey, child: child);
}

Page<void> _shellPage(GoRouterState state, Widget child) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.keepAlive();

  final refreshListenable = ValueNotifier<int>(0);
  ref.onDispose(refreshListenable.dispose);

  ref.listen(
    settingsProvider.select((settings) => settings.onboardingCompleted),
    (previous, next) {
      if (previous != next) {
        refreshListenable.value++;
      }
    },
  );

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final settings = ref.read(settingsProvider);
      final location = state.matchedLocation;
      final onOnboarding = location == '/onboarding';

      if (!settings.onboardingCompleted && !onOnboarding) {
        return '/onboarding';
      }
      if (settings.onboardingCompleted && onOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            _materialPage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: '/reja',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            _materialPage(state, const AiPlanningScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                _shellPage(state, const DashboardScreen()),
          ),
          GoRoute(
            path: '/vazifalar',
            pageBuilder: (context, state) =>
                _shellPage(state, const TasksListScreen()),
            routes: [
              GoRoute(
                path: 'yangi',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const TaskFormScreen()),
              ),
              GoRoute(
                path: 'tahrirlash/:id',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) => _materialPage(
                  state,
                  TaskFormScreen(taskId: state.pathParameters['id']),
                ),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) => _materialPage(
                  state,
                  TaskDetailScreen(taskId: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/hayot',
            pageBuilder: (context, state) =>
                _shellPage(state, const LifeHubScreen()),
            routes: [
              GoRoute(
                path: 'odatlar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const HabitsScreen()),
              ),
              GoRoute(
                path: 'maqsadlar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const GoalsScreen()),
              ),
              GoRoute(
                path: 'kundalik',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const JournalScreen()),
              ),
              GoRoute(
                path: 'mashq',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const WorkoutScreen()),
              ),
              GoRoute(
                path: "ta'lim",
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const StudyScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/moliya',
            pageBuilder: (context, state) =>
                _shellPage(state, const FinanceScreen()),
          ),
          GoRoute(
            path: '/boshqa',
            pageBuilder: (context, state) =>
                _shellPage(state, const MoreHubScreen()),
            routes: [
              GoRoute(
                path: 'eslatmalar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const NotesScreen()),
              ),
              GoRoute(
                path: 'kalendar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const CalendarScreen()),
              ),
              GoRoute(
                path: 'hujjatlar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const DocumentsScreen()),
              ),
              GoRoute(
                path: 'murabbiy',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const AiCoachScreen()),
              ),
              GoRoute(
                path: 'sozlamalar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

extension SafeNavigation on BuildContext {
  void pushOnce(String location) {
    final current = GoRouterState.of(this).uri.toString();
    if (current == location || current.startsWith('$location?')) {
      return;
    }
    push(location);
  }
}
