import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/database/database_providers.dart';

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final preference = ref.watch(appPreferencesProvider).themeModePreference;
    return _themeModeFromPreference(preference);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }

    state = mode;
    await ref
        .read(appPreferencesProvider)
        .setThemeModePreference(_themeModeToPreference(mode));
  }

  ThemeMode _themeModeFromPreference(String preference) {
    switch (preference) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToPreference(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
