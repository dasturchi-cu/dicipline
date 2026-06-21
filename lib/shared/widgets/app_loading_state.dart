import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

class AppLoadingState extends StatefulWidget {
  const AppLoadingState({
    super.key,
    this.message = AppStrings.loading,
    this.showMessage = false,
    this.lineCount = 3,
    this.padding,
  });

  final String message;
  final bool showMessage;
  final int lineCount;
  final EdgeInsetsGeometry? padding;

  @override
  State<AppLoadingState> createState() => _AppLoadingStateState();
}

class _AppLoadingStateState extends State<AppLoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = brightness == Brightness.light
        ? AppColors.lightBorder
        : AppColors.darkBorder;
    final highlightColor = brightness == Brightness.light
        ? AppColors.lightSurface
        : AppColors.darkTextSecondary.withValues(alpha: 0.2);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showMessage) ...[
            Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          _ShimmerBox(
            controller: _controller,
            baseColor: baseColor,
            highlightColor: highlightColor,
            height: 120,
            borderRadius: AppRadius.lg,
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < widget.lineCount; i++) ...[
            _ShimmerBox(
              controller: _controller,
              baseColor: baseColor,
              highlightColor: highlightColor,
              height: 16,
              widthFactor: i == widget.lineCount - 1 ? 0.6 : 1.0,
              borderRadius: AppRadius.sm,
            ),
            if (i < widget.lineCount - 1) const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.controller,
    required this.baseColor,
    required this.highlightColor,
    required this.height,
    this.widthFactor = 1.0,
    this.borderRadius = AppRadius.sm,
  });

  final AnimationController controller;
  final Color baseColor;
  final Color highlightColor;
  final double height;
  final double widthFactor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FractionallySizedBox(
          widthFactor: widthFactor,
          alignment: Alignment.centerLeft,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment(-1.0 - controller.value * 2, 0),
                end: Alignment(1.0 - controller.value * 2, 0),
                colors: [baseColor, highlightColor, baseColor],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}
