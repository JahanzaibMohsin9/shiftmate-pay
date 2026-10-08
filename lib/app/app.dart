import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/local/database/database_providers.dart';
import '../features/reminders/application/reminder_providers.dart';
import '../features/settings/application/theme_mode_controller.dart';
import 'theme/app_theme.dart';

class ShiftMatePayApp extends ConsumerStatefulWidget {
  const ShiftMatePayApp({
    required this.routerConfig,
    super.key,
  });

  final GoRouter routerConfig;

  @override
  ConsumerState<ShiftMatePayApp> createState() => _ShiftMatePayAppState();
}

class _ShiftMatePayAppState extends ConsumerState<ShiftMatePayApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(reminderNotificationServiceProvider).syncAllReminderSchedules();
      } catch (_) {
        // App boot should remain safe when notifications are unavailable.
      }
      ref.invalidate(reminderNotificationPermissionProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp.router(
      title: 'ShiftMate Pay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: widget.routerConfig,
    );
  }
}
