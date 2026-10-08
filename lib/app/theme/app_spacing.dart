import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  AppSpacing — 4-pt grid spacing system.
//
//  Raw scale:  xs=4 | sm=8 | md=16 | lg=24 | xl=32 | xxl=48
//  Named pads: page (h:20) | section (h:20, v:24) | card (all:16)
// ─────────────────────────────────────────────────────────────
abstract class AppSpacing {
  // ── Raw scale ─────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // ── Page-level padding (horizontal) ───────────────────────
  /// Standard horizontal screen margin (20 px).
  static const double pageHorizontal = 20.0;
  static const EdgeInsets pagePaddingH = EdgeInsets.symmetric(
    horizontal: pageHorizontal,
  );

  /// Full-page content padding (h:20, top:8, bottom:24).
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(
    pageHorizontal,
    8,
    pageHorizontal,
    24,
  );

  static EdgeInsets pagePaddingWithSafeBottom(
    BuildContext context, {
    double top = 8,
    double bottom = 24,
  }) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    return EdgeInsets.fromLTRB(
      pageHorizontal,
      top,
      pageHorizontal,
      bottom + safeBottom,
    );
  }

  // ── Component padding ─────────────────────────────────────
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(20);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );

  // ── Legacy helpers (keep for existing code) ───────────────
  static const EdgeInsets edgeInsetsAllMd = EdgeInsets.all(md);
  static const EdgeInsets edgeInsetsHmd = EdgeInsets.symmetric(horizontal: md);

  // ── Gap widgets (use inside Column/Row) ───────────────────
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);

  /// Consistent vertical gap between sections on a screen (28 px).
  static const SizedBox sectionGap = SizedBox(height: 28);
  static const SizedBox halfSection = SizedBox(height: 14);

  // ── Deprecated: do not use in new code ────────────────────
  // ignore: constant_identifier_names
  static const double radiusSm = 10.0;
  // ignore: constant_identifier_names
  static const double radiusMd = 14.0;
  // ignore: constant_identifier_names
  static const double radiusLg = 20.0;
  // ignore: constant_identifier_names
  static const double radiusPill = 999.0;
}
