import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/finance_transaction_entity.dart';
import 'package:rejabon_ai/core/database/schemas/habit_entity.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_theme.dart';
import 'package:rejabon_ai/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:rejabon_ai/features/dashboard/presentation/screens/dashboard_screen.dart';
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
      userName: 'Ali',
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
          financeTransactionsProvider
              .overrideWith((ref) => pendingStream<FinanceTransactionEntity>()),
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

  testWidgets('DashboardScreen renders stats when data is ready', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tasksProvider.overrideWith((ref) => Stream.value(<TaskEntity>[])),
          habitsProvider.overrideWith((ref) => Stream.value(<HabitEntity>[])),
          goalsProvider.overrideWith((ref) => Stream.value([])),
          financeTransactionsProvider
              .overrideWith((ref) => Stream.value(<FinanceTransactionEntity>[])),
          aiTipsProvider.overrideWith((ref) async => []),
          settingsProvider.overrideWith(_TestSettingsNotifier.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.todayTasks), findsOneWidget);
    expect(find.text(AppStrings.todayHabits), findsOneWidget);
    expect(find.textContaining('Ali'), findsOneWidget);
  });
}
