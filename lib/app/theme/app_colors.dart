import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  AppColors — Single source of truth for all color tokens.
//  4 sections: Brand, Semantic, Light surfaces, Dark surfaces.
// ─────────────────────────────────────────────────────────────
abstract class AppColors {
  // ── Brand (Electric Violet) ───────────────────────────────
  static const Color primary          = Color(0xFF7C3AED); // violet-600
  static const Color primaryLight     = Color(0xFFA78BFA); // violet-400
  static const Color primaryDark      = Color(0xFF5B21B6); // violet-800
  static const Color primaryContainer = Color(0xFFEDE9FE); // violet-100 (light)
  static const Color primaryContainerDark = Color(0xFF2E1065); // violet-950 (dark)

  // ── Semantic ──────────────────────────────────────────────
  static const Color success        = Color(0xFF059669); // emerald-600
  static const Color successTint    = Color(0xFFD1FAE5); // emerald-100
  static const Color error          = Color(0xFFE11D48); // rose-600
  static const Color errorTint      = Color(0xFFFFE4E6); // rose-100
  static const Color warning        = Color(0xFFD97706); // amber-600
  static const Color warningTint    = Color(0xFFFEF3C7); // amber-100
  static const Color info           = Color(0xFF0284C7); // sky-600
  static const Color infoTint       = Color(0xFFE0F2FE); // sky-100

  // ── Light Theme ───────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFFAFAFA); // warm off-white
  static const Color surface0Light   = Color(0xFFFFFFFF); // card / sheet surface
  static const Color surface1Light   = Color(0xFFF4F4F5); // inner tinted area
  static const Color textPrimaryLight   = Color(0xFF09090B); // zinc-950
  static const Color textSecondaryLight = Color(0xFF71717A); // zinc-500
  static const Color textTertiaryLight  = Color(0xFFA1A1AA); // zinc-400
  static const Color borderLight     = Color(0xFFE4E4E7); // zinc-200
  static const Color borderStrongLight = Color(0xFFD4D4D8); // zinc-300
  static const Color dividerLight    = Color(0xFFF4F4F5); // zinc-100

  // ── Dark Theme ────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF09090B); // zinc-950
  static const Color surface0Dark   = Color(0xFF18181B); // zinc-900 — cards
  static const Color surface1Dark   = Color(0xFF27272A); // zinc-800 — inner chips/tags
  static const Color textPrimaryDark   = Color(0xFFFAFAFA); // zinc-50
  static const Color textSecondaryDark = Color(0xFFA1A1AA); // zinc-400
  static const Color textTertiaryDark  = Color(0xFF71717A); // zinc-500
  static const Color borderDark     = Color(0xFF27272A); // zinc-800
  static const Color borderStrongDark  = Color(0xFF3F3F46); // zinc-700
  static const Color dividerDark    = Color(0xFF27272A); // zinc-800

  // ── Backwards-compat aliases (used by existing screens) ───
  // ignore: constant_identifier_names
  static const Color surfaceLow  = surface1Light;
  // ignore: constant_identifier_names
  static const Color surfaceHigh = surface0Light;
  // ignore: constant_identifier_names
  static const Color backgroundDarkCompat = backgroundDark;
  // ignore: constant_identifier_names
  static const Color surfaceDark = surface0Dark;
  // ignore: constant_identifier_names
  static const Color textHighLight   = textPrimaryLight;
  // ignore: constant_identifier_names
  static const Color textMediumLight = textSecondaryLight;
  // ignore: constant_identifier_names
  static const Color textHighDark    = textPrimaryDark;
  // ignore: constant_identifier_names
  static const Color textMediumDark  = textSecondaryDark;
  static const Color surfaceLight    = surface0Light;

  // ── Overlay / scrim ───────────────────────────────────────
  static const Color scrimLight = Color(0x14000000); // black 8%
  static const Color scrimDark  = Color(0x29000000); // black 16%
}
