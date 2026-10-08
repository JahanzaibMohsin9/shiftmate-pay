import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/preferences/app_preferences.dart';

class AppBootstrapData {
  const AppBootstrapData({
    required this.environmentName,
    required this.initializedAt,
    required this.enableDebugLogging,
    required this.preferences,
  });

  final String environmentName;
  final DateTime initializedAt;
  final bool enableDebugLogging;
  final AppPreferences preferences;

  static Future<AppBootstrapData> initialize() async {
    final preferences = await AppPreferences.create();

    return AppBootstrapData(
      environmentName: kReleaseMode ? 'production' : 'development',
      initializedAt: DateTime.now().toUtc(),
      enableDebugLogging: !kReleaseMode,
      preferences: preferences,
    );
  }
}

final appBootstrapDataProvider = Provider<AppBootstrapData>(
  (ref) => throw UnimplementedError('Bootstrap data must be overridden before app startup.'),
);
