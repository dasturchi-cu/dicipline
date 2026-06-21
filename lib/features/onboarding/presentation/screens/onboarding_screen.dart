import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const _pages = [
    (
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      icon: Icons.dashboard_customize_outlined,
    ),
    (
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      icon: Icons.offline_bolt_outlined,
    ),
    (
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _OnboardingView();
  }
}

class _OnboardingView extends ConsumerStatefulWidget {
  const _OnboardingView();

  @override
  ConsumerState<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<_OnboardingView> {
  final _controller = PageController();
  var _currentPage = 0;

  Future<void> _finish() async {
    await ref.read(settingsProvider.notifier).completeOnboarding();
    if (!mounted) {
      return;
    }
    context.go('/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == OnboardingScreen._pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text(AppStrings.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: OnboardingScreen._pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = OnboardingScreen._pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.icon, size: 80, color: theme.colorScheme.primary),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  for (var i = 0; i < OnboardingScreen._pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  const Spacer(),
                  AppButton(
                    label: isLastPage ? AppStrings.getStarted : AppStrings.next,
                    onPressed: isLastPage
                        ? _finish
                        : () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
