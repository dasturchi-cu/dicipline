import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ekran pastidagi tizim tugmalari va ilova navigatsiyasi uchun bo'shliq.
class ContentInsets {
  ContentInsets._();

  static const shellNavBarHeight = 64.0;
  static const shellNavGap = 12.0;
  static const pageGap = 16.0;

  static double systemBottom(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;

  /// Shell ichidagi scroll kontent uchun (nav + tizim paneli).
  static double shellScrollBottom(BuildContext context) =>
      systemBottom(context) + shellNavBarHeight + shellNavGap;

  /// Sub-sahifalar (orqaga tugmasi bor) uchun.
  static double pageScrollBottom(BuildContext context) =>
      systemBottom(context) + pageGap;

  static EdgeInsets scrollPadding(
    BuildContext context, {
    bool inShell = false,
    double horizontal = AppSpacing.md,
    double top = AppSpacing.md,
  }) {
    return EdgeInsets.fromLTRB(
      horizontal,
      top,
      horizontal,
      inShell ? shellScrollBottom(context) : pageScrollBottom(context),
    );
  }

  static EdgeInsets dialogInsets(BuildContext context) {
    final bottom = systemBottom(context);
    return EdgeInsets.fromLTRB(16, 24, 16, 16 + bottom);
  }

  static EdgeInsets fabPadding(BuildContext context, {bool inShell = false}) {
    if (!inShell) return EdgeInsets.zero;
    return EdgeInsets.only(bottom: shellNavBarHeight + shellNavGap);
  }
}
