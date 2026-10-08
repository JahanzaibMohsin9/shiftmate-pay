import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

// ─────────────────────────────────────────────────────────────
//  AppTheme — Premium, minimalist Material 3 theme.
//
//  Design principles:
//  • Flat surfaces: 0 elevation, 1 px border instead of shadow
//  • Zinc-based neutrals (warm, not cold slate)
//  • Electric violet accent — consistent throughout
//  • Generous radius (md=14, sheets=28)
//  • Clean nav bar: no pill indicator, colored icon + label only
// ─────────────────────────────────────────────────────────────
class AppTheme {
  const AppTheme._();

  // ── Light ─────────────────────────────────────────────────
  static ThemeData light() {
    const cs = ColorScheme(
      brightness: Brightness.light,
      primary:            AppColors.primary,
      onPrimary:          Colors.white,
      primaryContainer:   AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primaryDark,
      secondary:          AppColors.primary,
      onSecondary:        Colors.white,
      secondaryContainer: AppColors.primaryContainer,
      onSecondaryContainer: AppColors.primaryDark,
      tertiary:           AppColors.primary,
      onTertiary:         Colors.white,
      error:              AppColors.error,
      onError:            Colors.white,
      errorContainer:     AppColors.errorTint,
      onErrorContainer:   AppColors.error,
      surface:            AppColors.surface0Light,
      onSurface:          AppColors.textPrimaryLight,
      onSurfaceVariant:   AppColors.textSecondaryLight,
      outline:            AppColors.borderLight,
      outlineVariant:     AppColors.borderLight,
      surfaceContainerLowest: AppColors.backgroundLight,
      surfaceContainerLow:    AppColors.surface1Light,
      surfaceContainer:       AppColors.surface1Light,
      surfaceContainerHigh:   AppColors.surface0Light,
      surfaceContainerHighest: AppColors.surface0Light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      textTheme: AppTypography.textTheme.apply(
        bodyColor:    AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // ── AppBar ────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryLight,
          size: 22,
        ),
        titleTextStyle: AppTypography.textTheme.titleLarge!.copyWith(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ── Navigation Bar ────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface0Light,
        elevation: 0,
        height: 62,
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(
          AppColors.primary.withValues(alpha: 0.06),
        ),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTypography.textTheme.labelSmall!.copyWith(
            color: selected ? AppColors.primary : AppColors.textTertiaryLight,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.textTertiaryLight,
            size: 22,
          );
        }),
      ),

      // ── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface0Light,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),

      // ── Divider ───────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // ── Buttons ───────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 50)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            AppTypography.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 50)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.borderStrongLight, width: 1.5),
          ),
          foregroundColor: WidgetStatePropertyAll(AppColors.textPrimaryLight),
          textStyle: WidgetStatePropertyAll(
            AppTypography.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
          textStyle: WidgetStatePropertyAll(
            AppTypography.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),

      // ── FAB ───────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),

      // ── Input ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface1Light,
        hintStyle: AppTypography.textTheme.bodyMedium!.copyWith(
          color: AppColors.textTertiaryLight,
        ),
        labelStyle: AppTypography.textTheme.bodyMedium!.copyWith(
          color: AppColors.textSecondaryLight,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ── Bottom Sheet ──────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface0Light,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brSheetTop,
        ),
        dragHandleColor: AppColors.borderStrongLight,
        dragHandleSize: Size(36, 4),
        showDragHandle: true,
      ),

      // ── Snack Bar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryLight,
        contentTextStyle: AppTypography.textTheme.bodyMedium!.copyWith(
          color: AppColors.backgroundLight,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),

      // ── Chip ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface1Light,
        side: const BorderSide(color: AppColors.borderLight, width: 1),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brFull),
        labelStyle: AppTypography.textTheme.labelMedium!.copyWith(
          color: AppColors.textSecondaryLight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── List tile ─────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minLeadingWidth: 0,
      ),

      // ── Dialog ────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface0Light,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),

      shadowColor: const Color(0x14000000),
    );
  }

  // ── Dark ──────────────────────────────────────────────────
  static ThemeData dark() {
    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary:            AppColors.primaryLight,
      onPrimary:          Colors.white,
      primaryContainer:   AppColors.primaryContainerDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary:          AppColors.primaryLight,
      onSecondary:        Colors.white,
      secondaryContainer: AppColors.primaryContainerDark,
      onSecondaryContainer: AppColors.primaryLight,
      tertiary:           AppColors.primaryLight,
      onTertiary:         Colors.white,
      error:              Color(0xFFFF6B81),
      onError:            Colors.white,
      errorContainer:     Color(0xFF4A0010),
      onErrorContainer:   Color(0xFFFF6B81),
      surface:            AppColors.surface0Dark,
      onSurface:          AppColors.textPrimaryDark,
      onSurfaceVariant:   AppColors.textSecondaryDark,
      outline:            AppColors.borderDark,
      outlineVariant:     AppColors.borderDark,
      surfaceContainerLowest: AppColors.backgroundDark,
      surfaceContainerLow:    AppColors.surface0Dark,
      surfaceContainer:       AppColors.surface0Dark,
      surfaceContainerHigh:   AppColors.surface1Dark,
      surfaceContainerHighest: AppColors.surface1Dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      textTheme: AppTypography.textTheme.apply(
        bodyColor:    AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // ── AppBar ────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimaryDark,
          size: 22,
        ),
        titleTextStyle: AppTypography.textTheme.titleLarge!.copyWith(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ── Navigation Bar ────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface0Dark,
        elevation: 0,
        height: 62,
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(
          AppColors.primaryLight.withValues(alpha: 0.08),
        ),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTypography.textTheme.labelSmall!.copyWith(
            color: selected ? AppColors.primaryLight : AppColors.textTertiaryDark,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primaryLight : AppColors.textTertiaryDark,
            size: 22,
          );
        }),
      ),

      // ── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface0Dark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),

      // ── Divider ───────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // ── Buttons ───────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 50)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(
            AppTypography.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 50)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.borderStrongDark, width: 1.5),
          ),
          foregroundColor: WidgetStatePropertyAll(AppColors.textPrimaryDark),
          textStyle: WidgetStatePropertyAll(
            AppTypography.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(AppColors.primaryLight),
          textStyle: WidgetStatePropertyAll(
            AppTypography.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),

      // ── FAB ───────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),

      // ── Input ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface1Dark,
        hintStyle: AppTypography.textTheme.bodyMedium!.copyWith(
          color: AppColors.textTertiaryDark,
        ),
        labelStyle: AppTypography.textTheme.bodyMedium!.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ── Bottom Sheet ──────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface0Dark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brSheetTop,
        ),
        dragHandleColor: AppColors.borderStrongDark,
        dragHandleSize: Size(36, 4),
        showDragHandle: true,
      ),

      // ── Snack Bar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface1Dark,
        contentTextStyle: AppTypography.textTheme.bodyMedium!.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),

      // ── Chip ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface1Dark,
        side: const BorderSide(color: AppColors.borderDark, width: 1),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brFull),
        labelStyle: AppTypography.textTheme.labelMedium!.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── List tile ─────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minLeadingWidth: 0,
      ),

      // ── Dialog ────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface0Dark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),

      shadowColor: const Color(0x3D000000),
    );
  }
}

