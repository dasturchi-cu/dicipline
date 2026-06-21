import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/ai/ai_orchestrator.dart';
import 'core/database/isar_service.dart';
import 'core/notifications/notification_service.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.init();
  await NotificationService.init();
  await AiService.initialize();

  final container = ProviderContainer();
  await container.read(settingsProvider.notifier).load();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const RejabonApp(),
    ),
  );
}
