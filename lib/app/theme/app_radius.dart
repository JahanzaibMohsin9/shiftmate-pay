import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  AppRadius — Centralized border-radius tokens.
//
//  Philosophy: Rounder = friendlier, more premium.
//  xs  → 6  : tiny badges, inline tags
//  sm  → 10 : inputs, small chips, nav items
//  md  → 14 : standard cards, buttons
//  lg  → 20 : large cards, modals
//  xl  → 28 : bottom sheets, onboarding hero areas
//  full→ 999: pill shapes (FAB labels, lozenges)
// ─────────────────────────────────────────────────────────────
abstract class AppRadius {
  // ── Raw values ────────────────────────────────────────────
  static const double xs   =  6.0;
  static const double sm   = 10.0;
  static const double md   = 14.0;
  static const double lg   = 20.0;
  static const double xl   = 28.0;
  static const double full = 999.0;

  // ── BorderRadius conveniences ─────────────────────────────
  static const BorderRadius brXs   = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm   = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl   = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));

  /// Bottom-sheet top-only rounding (xl).
  static const BorderRadius brSheetTop = BorderRadius.only(
    topLeft:  Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}
