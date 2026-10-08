import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
//  AppTypography — Inter-based type scale.
//
//  Scale rationale (4-pt base, modular scale ~1.2×):
//    Display   → hero numbers, pay amounts, big stats
//    Headline  → screen titles, section openers
//    Title     → card titles, list headers
//    Body      → readable paragraph and detail text
//    Label     → buttons, chips, metadata, nav labels
// ─────────────────────────────────────────────────────────────
abstract class AppTypography {
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme(
      const TextTheme(
        // Display — pay amounts, hero figures
        displayLarge:  TextStyle(fontWeight: FontWeight.w800, fontSize: 48, letterSpacing: -2.0, height: 1.08),
        displayMedium: TextStyle(fontWeight: FontWeight.w800, fontSize: 40, letterSpacing: -1.6, height: 1.1),
        displaySmall:  TextStyle(fontWeight: FontWeight.w800, fontSize: 32, letterSpacing: -1.2, height: 1.12),

        // Headline — page/screen titles
        headlineLarge:  TextStyle(fontWeight: FontWeight.w700, fontSize: 28, letterSpacing: -0.8, height: 1.2),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: -0.6, height: 1.22),
        headlineSmall:  TextStyle(fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.4, height: 1.25),

        // Title — card heads, section sub-titles
        titleLarge:  TextStyle(fontWeight: FontWeight.w600, fontSize: 17, letterSpacing: -0.2, height: 1.3),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: -0.1, height: 1.35),
        titleSmall:  TextStyle(fontWeight: FontWeight.w600, fontSize: 13, letterSpacing:  0.0, height: 1.4),

        // Body — prose, descriptions, form help text
        bodyLarge:  TextStyle(fontWeight: FontWeight.w400, fontSize: 16, letterSpacing: 0.0, height: 1.6),
        bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, letterSpacing: 0.0, height: 1.57),
        bodySmall:  TextStyle(fontWeight: FontWeight.w400, fontSize: 12, letterSpacing: 0.0, height: 1.5),

        // Label — buttons, chips, nav, timestamps, metadata
        labelLarge:  TextStyle(fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.1, height: 1.4),
        labelMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.2, height: 1.4),
        labelSmall:  TextStyle(fontWeight: FontWeight.w500, fontSize: 11, letterSpacing: 0.4, height: 1.4),
      ),
    );
  }
}
