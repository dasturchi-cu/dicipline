import 'package:flutter/animation.dart';

/// Shared motion tokens — meaningful, not decorative.
class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration entrance = Duration(milliseconds: 500);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve decelerate = Curves.decelerate;

  static Duration stagger(int index, {int baseMs = 40}) {
    return Duration(milliseconds: index * baseMs);
  }
}
