import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  ref.listen(settingsProvider, (previous, next) => refreshListenable.value++);

  return GoRouter(
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
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/vazifalar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TasksListScreen(),
            ),
            routes: [
              GoRoute(
                path: 'yangi',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TaskFormScreen(),
              ),
              GoRoute(
                path: 'tahrirlash/:id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => TaskFormScreen(
                  taskId: state.pathParameters['id'],
                ),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => TaskDetailScreen(
                  taskId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/hayot',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LifeHubScreen(),
            ),
            routes: [
              GoRoute(
                path: 'odatlar',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const HabitsScreen(),
              ),
              GoRoute(
                path: 'maqsadlar',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const GoalsScreen(),
              ),
              GoRoute(
                path: 'kundalik',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const JournalScreen(),
              ),
              GoRoute(
                path: 'mashq',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const WorkoutScreen(),
              ),
              GoRoute(
                path: "ta'lim",
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const StudyScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/moliya',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FinanceScreen(),
            ),
          ),
          GoRoute(
            path: '/boshqa',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MoreHubScreen(),
            ),
            routes: [
              GoRoute(
                path: 'eslatmalar',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const NotesScreen(),
              ),
              GoRoute(
                path: 'kalendar',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CalendarScreen(),
              ),
              GoRoute(
                path: 'hujjatlar',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const DocumentsScreen(),
              ),
              GoRoute(
                path: 'murabbiy',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const AiCoachScreen(),
              ),
              GoRoute(
                path: 'sozlamalar',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
