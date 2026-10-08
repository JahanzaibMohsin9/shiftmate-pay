import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/features/settings/application/theme_mode_controller.dart';

void main() {
  test('theme mode controller reads and persists the selected theme mode', () async {
    SharedPreferences.setMockInitialValues({
      'theme_mode': 'dark',
    });
    final preferences = AppPreferences(await SharedPreferences.getInstance());

    final container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(themeModeControllerProvider), ThemeMode.dark);

    await container.read(themeModeControllerProvider.notifier).setThemeMode(ThemeMode.light);

    expect(container.read(themeModeControllerProvider), ThemeMode.light);
    expect(preferences.themeModePreference, 'light');
  });
}
