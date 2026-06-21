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
  });

  final String title;
  final Widget? body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: theme.brightness == Brightness.light
                ? AppColors.lightBorder
                : AppColors.darkBorder,
          ),
        ),
      ),
      body: body ??
          Center(
            child: Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.brightness == Brightness.light
                        ? AppColors.lightTextSecondary
                        : AppColors.darkTextSecondary,
                  ),
            ),
          ),
      floatingActionButton: floatingActionButton,
    );
  }
}
