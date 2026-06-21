import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/goal_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/intelligence/intelligence_providers.dart';
import 'package:rejabon_ai/core/intelligence/models/life_insight.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_theme.dart';
import 'package:rejabon_ai/features/ai_planning/domain/models/plan_models.dart';
import 'package:rejabon_ai/features/ai_planning/presentation/providers/ai_planning_provider.dart';
import 'package:rejabon_ai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:rejabon_ai/core/database/schemas/inbox_item_entity.dart';
import 'package:rejabon_ai/features/capture/presentation/providers/capture_providers.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/phase2/presentation/providers/phase2_providers.dart';
import 'package:rejabon_ai/features/briefing/domain/daily_briefing_service.dart';
import 'package:rejabon_ai/features/retention/domain/daily_retention_engine.dart';
import 'package:rejabon_ai/features/retention/presentation/providers/retention_providers.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';

Stream<List<T>> pendingStream<T>() {
  final controller = StreamController<List<T>>();
  return controller.stream;
}

class _TestSettingsNotifier extends SettingsNotifier {
  @override
  AppSettings build() {
    return const AppSettings(
      themeMode: ThemeMode.light,
      onboardingCompleted: true,
      userName: 'Muhammadsodiq',
      notificationEnabled: true,
    );
  }
}

void main() {
  testWidgets('DashboardScreen shows loading while providers load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tasksProvider.overrideWith((ref) => pendingStream<TaskEntity>()),
          habitsProvider.overrideWith((ref) => pendingStream<HabitEntity>()),
          goalsProvider.overrideWith((ref) => pendingStream<GoalEntity>()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const DashboardScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(AppLoadingState), findsOneWidget);
  });

  testWidgets('DashboardScreen renders 5-zone production layout when data is ready',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tasksProvider.overrideWith((ref) => Stream.value(<TaskEntity>[])),
          habitsProvider.overrideWith((ref) => Stream.value(<HabitEntity>[])),
          goalsProvider.overrideWith(
            (ref) => Stream.value([
              GoalEntity.create(title: 'IELTS 7.0', progress: 72),
            ]),
          ),
          journalProvider.overrideWith((ref) => Stream.value([])),
          inboxProvider.overrideWith((ref) => Stream.value(<InboxItemEntity>[])),
          settingsProvider.overrideWith(_TestSettingsNotifier.new),
          lifeScoreProvider.overrideWith(
            (ref) async => const LifeScoreBreakdown(
              overall: 72,
              discipline: 70,
              health: 65,
              learning: 60,
              finance: 55,
              sleep: 50,
              goals: 45,
            ),
          ),
          dailyRetentionBundleProvider.overrideWith(
            (ref) async => const DailyRetentionBundle(
              dailyInsight: 'Bugun IELTS o\'qishni davom eting.',
              dailyPrediction: '',
              coachingLine: '',
              progressLine: '',
              rewardHint: '',
              streakHint: '',
              returnReason: '',
            ),
          ),
          dailyBriefingProvider.overrideWith((ref) {
            return DailyBriefing(
              greeting: 'Bugun yaxshi kun.',
              priorities: const ['Bitta muhim vazifani bajaring'],
              goalProgressLine: '',
              streakLine: '',
              moodLine: '',
              aiAdvice: 'Barqaror qoling.',
              productivityPrediction: '',
              habitReminders: const [],
            );
          }),
          lifeBrainTopInsightProvider.overrideWith(
            (ref) => const LifeInsight(
              id: 'test',
              headline: 'Fokus',
              body: 'IELTS rejasini davom eting.',
              actionRoute: '/boshqa/life-twin',
              priority: 1,
              source: InsightSource.rule,
            ),
          ),
          playerProfileProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Muhammadsodiq'), findsWidgets);
    expect(find.text(AppStrings.mainGoal), findsOneWidget);
    expect(find.text(AppStrings.lifeScore), findsOneWidget);
    expect(find.text(AppStrings.aiRecommendation), findsOneWidget);
    expect(find.text(AppStrings.quickActions), findsOneWidget);
    expect(find.text('IELTS 7.0'), findsOneWidget);
    expect(find.text('72'), findsWidgets);
  });
}
