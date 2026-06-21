import 'package:flutter/material.dart';

import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/features/gamification/domain/models/rpg_models.dart';

/// XP mukofot animatsiyasi — dopamin qatlami.
void showXpRewardOverlay(
  BuildContext context, {
  required int amount,
  required String statType,
  bool leveledUp = false,
  int? newLevel,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) => _XpRewardOverlay(
      amount: amount,
      statEmoji: StatType.emoji(statType),
      leveledUp: leveledUp,
      newLevel: newLevel,
      onDone: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _XpRewardOverlay extends StatefulWidget {
  const _XpRewardOverlay({
    required this.amount,
    required this.statEmoji,
    required this.leveledUp,
    required this.newLevel,
    required this.onDone,
  });

  final int amount;
  final String statEmoji;
  final bool leveledUp;
  final int? newLevel;
  final VoidCallback onDone;

  @override
  State<_XpRewardOverlay> createState() => _XpRewardOverlayState();
}

class _XpRewardOverlayState extends State<_XpRewardOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _scale = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.elasticOut),
      ),
    );
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );
    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) {
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity.value,
              child: SlideTransition(
                position: _slide,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.heroGradientLight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+${widget.amount} XP ${widget.statEmoji}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        if (widget.leveledUp && widget.newLevel != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '🎉 ${widget.newLevel}-daraja!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
