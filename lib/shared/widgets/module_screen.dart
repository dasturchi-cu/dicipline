import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Modul ekranlari uchun standart scaffold.
class ModuleScreen extends StatelessWidget {
  const ModuleScreen({
    super.key,
    required this.title,
    this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.showDivider = true,
  });

  final String title;
  final Widget? body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
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
      body: body ??
          Center(
            child: Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
          ),
      floatingActionButton: floatingActionButton,
    );
  }
}
