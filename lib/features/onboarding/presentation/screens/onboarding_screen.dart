import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/notifications/notification_service.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/design_tokens.dart';
import 'package:rejabon_ai/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';

/// 3 bosqich, ~60 soniya — tez va aniq onboarding.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  var _step = 0;
  var _selectedGoal = 0;
  var _notificationsEnabled = true;
  var _finishing = false;

  static const _goalPresets = [
    ('🎯', 'Shaxsiy rivojlanish'),
    ('📚', 'Ingliz tili'),
    ('💪', 'Sog\'lom hayot'),
    ('💼', 'Karyera'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.onboardingNameRequired)),
      );
      return;
    }
    if (_step < 2) {
      _pageController.nextPage(
        duration: AppMotion.normal,
        curve: AppMotion.standard,
      );
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);

    try {
      final name = _nameController.text.trim();
      final (_, goalTitle) = _goalPresets[_selectedGoal];

      if (_notificationsEnabled) {
        await NotificationService.instance.requestPermissions();
      }

      await ref.read(goalRepositoryProvider).create(
            title: goalTitle,
            progress: 0,
          );

      await ref.read(habitRepositoryProvider).create(
            name: 'Kundalik reja',
            emoji: '✅',
          );

      await ref.read(settingsProvider.notifier).completeOnboardingWith(
            userName: name,
            persona: 'all',
            notificationsEnabled: _notificationsEnabled,
          );

      await ref.read(playerProfileRepositoryProvider).getOrCreate();
      await runDailyBootstrap(ref);

      if (!mounted) return;
      context.go('/');
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTypography.sectionLabel(brightness).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_step + 1}/3',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary(brightness),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: (_step + 1) / 3,
                  minHeight: 3,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcome(theme, brightness),
                  _buildGoalPick(theme, brightness),
                  _buildStart(theme, brightness),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: _step == 2
                    ? (_finishing ? AppStrings.loading : AppStrings.getStarted)
                    : AppStrings.next,
                onPressed: _finishing ? null : _next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(ThemeData theme, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.onboardingFastTitle,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.onboardingFastDesc,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary(brightness),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            AppStrings.onboardingNameLabel,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _next(),
            decoration: InputDecoration(
              hintText: AppStrings.onboardingNameHint,
              filled: true,
              fillColor: AppColors.surface(brightness, elevated: true),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPick(ThemeData theme, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.onboardingPickGoal, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.onboardingPickGoalDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(brightness),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...List.generate(_goalPresets.length, (index) {
            final (emoji, label) = _goalPresets[index];
            final selected = _selectedGoal == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Material(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.surface(brightness, elevated: true),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => setState(() => _selectedGoal = index),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.border(brightness, subtle: true),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(label, style: theme.textTheme.titleMedium),
                        ),
                        if (selected)
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStart(ThemeData theme, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.onboardingPermissionsTitle,
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.onboardingReadyDesc,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary(brightness),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
            title: const Text(AppStrings.onboardingNotifications),
            subtitle: Text(AppStrings.onboardingNotificationsDesc),
          ),
        ],
      ),
    );
  }
}
