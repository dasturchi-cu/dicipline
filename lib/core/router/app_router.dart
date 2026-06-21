import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_planning/presentation/screens/ai_planning_screens.dart';
import '../../features/analytics/presentation/screens/analytics_hub_screen.dart';
import '../../features/focus/presentation/screens/focus_mode_screen.dart';
import '../../features/vision_board/presentation/screens/vision_board_screen.dart';
import '../../features/future_letters/presentation/screens/letter_unlock_screen.dart';
import '../../features/ceo_review/presentation/screens/ceo_review_screen.dart';
import '../../features/capture/presentation/screens/inbox_screen.dart';
import '../../features/challenges/presentation/screens/challenges_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/finance/presentation/screens/finance_screen.dart';
import '../../features/future_planning/presentation/screens/future_planning_screen.dart';
import '../../features/decision_assistant/presentation/screens/decision_assistant_screen.dart';
import '../../features/action_engine/presentation/screens/action_engine_screen.dart';
import '../../features/life_map/presentation/screens/life_map_screen.dart';
import '../../features/future_simulator/presentation/screens/future_simulator_screen.dart';
import '../../features/gamification/presentation/screens/character_screen.dart';
import '../../features/gamification/presentation/screens/achievement_showcase_screen.dart';
import '../../features/emergency/presentation/screens/emergency_mode_screen.dart';
import '../../features/ai_memory/presentation/screens/ai_memory_screen.dart';
import '../../features/life_twin/presentation/screens/life_twin_screen.dart';
import '../../features/social/presentation/screens/social_screen.dart';
import '../../features/voice_ai/presentation/screens/voice_coach_screen.dart';
import '../../features/life/presentation/screens/life_screens.dart';
import '../../features/life_areas/presentation/screens/life_areas_screen.dart';
import '../../features/more/presentation/screens/more_screens.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/second_brain/presentation/screens/second_brain_screen.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';
import '../../features/tasks/presentation/screens/tasks_screens.dart';
import '../../features/time_tracking/presentation/screens/time_analytics_screen.dart';
import '../../features/time_tracking/presentation/screens/time_tracker_screen.dart';
import '../../features/timeline/presentation/screens/life_timeline_screen.dart';
import '../../features/timeline/presentation/screens/milestones_screen.dart';
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
      if (location == '/moliya') {
        return '/hayot/moliya';
      }
      if (location == '/boshqa/vaqt-analitika') {
        return '/boshqa/analitika';
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
            path: '/qahramon',
            pageBuilder: (context, state) =>
                _shellPage(state, const CharacterScreen()),
            routes: [
              GoRoute(
                path: 'yutuqlar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const AchievementShowcaseScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/favqulodda',
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) =>
                _materialPage(state, const EmergencyModeScreen()),
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
              GoRoute(
                path: 'sohalar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const LifeAreasScreen()),
              ),
              GoRoute(
                path: 'kelajak',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const FuturePlanningScreen()),
              ),
              GoRoute(
                path: 'xat/:id',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  return _materialPage(
                    state,
                    LetterUnlockScreen(letterId: id),
                  );
                },
              ),
              GoRoute(
                path: 'vizion',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const VisionBoardScreen()),
              ),
              GoRoute(
                path: 'simulyator',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const FutureSimulatorScreen()),
              ),
              GoRoute(
                path: 'vaqt',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const TimeTrackerScreen()),
              ),
              GoRoute(
                path: 'timeline',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const LifeTimelineScreen()),
              ),
              GoRoute(
                path: 'yutuqlar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const MilestonesScreen()),
              ),
              GoRoute(
                path: 'moliya',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const FinanceScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/boshqa',
            pageBuilder: (context, state) =>
                _shellPage(state, const MoreHubScreen()),
            routes: [
              GoRoute(
                path: 'analitika',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const AnalyticsHubScreen()),
              ),
              GoRoute(
                path: 'fokus',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const FocusModeScreen()),
              ),
              GoRoute(
                path: 'ikkinchi-miya',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const SecondBrainScreen()),
              ),
              GoRoute(
                path: 'xotira',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const AiMemoryScreen()),
              ),
              GoRoute(
                path: 'ceo-hisobot',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const CeoReviewScreen()),
              ),
              GoRoute(
                path: 'inbox',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const InboxScreen()),
              ),
              GoRoute(
                path: 'vaqt-analitika',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const TimeAnalyticsScreen()),
              ),
              GoRoute(
                path: 'musobaqalar',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const ChallengesScreen()),
              ),
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
                routes: [
                  GoRoute(
                    path: 'ovoz',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) =>
                        _materialPage(state, const VoiceCoachScreen()),
                  ),
                ],
              ),
              GoRoute(
                path: 'life-twin',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const LifeTwinScreen()),
              ),
              GoRoute(
                path: 'qaror-yordam',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const DecisionAssistantScreen()),
              ),
              GoRoute(
                path: 'action-engine',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const ActionEngineScreen()),
              ),
              GoRoute(
                path: 'life-map',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const LifeMapScreen()),
              ),
              GoRoute(
                path: 'ijtimoiy',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _materialPage(state, const SocialScreen()),
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
