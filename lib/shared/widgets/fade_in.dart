import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';

/// Staggered entrance animation for list sections.
class FadeIn extends StatefulWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 0),
    this.offsetY = 12,
  });

  final Widget child;
  final int index;
  final Duration delay;
  final double offsetY;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.entrance,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: AppMotion.standard);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetY / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AppMotion.standard));

    Future<void>.delayed(
      widget.delay + AppMotion.stagger(widget.index),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
