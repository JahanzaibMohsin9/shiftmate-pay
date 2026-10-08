import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  AppShadows — Box-shadow tokens.
//
//  Design principle: Flat-first (border + background contrast)
//  Only use shadows for overlays, modals, and FABs.
// ─────────────────────────────────────────────────────────────
abstract class AppShadows {
  // ── Light theme shadows ───────────────────────────────────

  /// No shadow — border-only cards (default).
  static const List<BoxShadow> none = [];

  /// Very subtle lift — hover states, active cards.
  static const List<BoxShadow> smLight = [
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium — FAB, bottom sheets, dropdowns.
  static const List<BoxShadow> mdLight = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  // ── Dark theme shadows ────────────────────────────────────

  static const List<BoxShadow> smDark = [
    BoxShadow(
      color: Color(0x1F000000), // 12% black
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: Color(0x3D000000), // 24% black
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // ── Helper ────────────────────────────────────────────────
  static List<BoxShadow> sm(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? smLight : smDark;

  static List<BoxShadow> md(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? mdLight : mdDark;
}
