import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/content_insets.dart';
import 'capture_sheet.dart';
/// Modul ekranlari uchun standart scaffold.
class ModuleScreen extends StatelessWidget {
  const ModuleScreen({
    super.key,
    required this.title,
    this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.showDivider = false,
    this.showGlobalCapture = true,
    this.inShell = false,
  });

  final String title;
  final Widget? body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showDivider;
  final bool showGlobalCapture;
  /// Asosiy 5 tab ichidagi sahifa bo'lsa true (pastki nav ustiga bo'shliq).
  final bool inShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    Widget? fab = floatingActionButton;
    if (fab != null) {
      fab = Padding(
        padding: ContentInsets.fabPadding(context, inShell: inShell),
        child: fab,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        automaticallyImplyLeading: showBackButton,
        actions: [
          if (showGlobalCapture && showBackButton && floatingActionButton == null)
            IconButton(
              icon: const Icon(Icons.bolt_rounded),
              tooltip: AppStrings.capture,
              onPressed: () => showCapture(context),
            ),
          ...?actions,
        ],
        bottom: showDivider
            ? PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(
                  height: 1,
                  color: AppColors.border(brightness, subtle: true),
                ),
              )
            : null,
      ),
      body: SafeArea(
        bottom: false,
        child: SizedBox.expand(
          child: body ??
              Center(
                child: Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textSecondary(brightness),
                  ),
                ),
              ),
        ),
      ),
      floatingActionButton: fab,
    );
  }
}
