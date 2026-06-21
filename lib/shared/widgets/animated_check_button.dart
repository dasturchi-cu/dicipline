import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import 'app_feedback.dart';

class AnimatedCheckButton extends StatefulWidget {
  const AnimatedCheckButton({
    super.key,
    required this.checked,
    required this.onChanged,
    this.activeColor = AppColors.primary,
    this.size = 28,
    this.celebrateOnCheck = false,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final double size;
  final bool celebrateOnCheck;

  @override
  State<AnimatedCheckButton> createState() => _AnimatedCheckButtonState();
}

class _AnimatedCheckButtonState extends State<AnimatedCheckButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.fast,
    );
    _scale = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.spring),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    final next = !widget.checked;
    if (next) {
      await _controller.forward();
      await _controller.reverse();
      if (widget.celebrateOnCheck && mounted) {
        hapticSuccess();
      } else {
        hapticLight();
      }
    } else {
      hapticLight();
    }
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.standard,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.checked
                ? widget.activeColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.size * 0.32),
            border: Border.all(
              color: widget.checked
                  ? widget.activeColor
                  : AppColors.border(Theme.of(context).brightness),
              width: 2,
            ),
          ),
          child: widget.checked
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
              : null,
        ),
      ),
    );
  }
}
