import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app.dart';
import '../../data/local/database/database_providers.dart';
import '../routing/app_router.dart';
import 'app_bootstrap_data.dart';
import 'app_provider_observer.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _reportUnhandledError(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _reportUnhandledError(error, stack);
    return true;
  };

  ErrorWidget.builder = (details) => _AppErrorWidget(details: details);

  await runZonedGuarded<Future<void>>(() async {
    final bootstrapData = await AppBootstrapData.initialize();
    final router = createAppRouter();
    final observers = bootstrapData.enableDebugLogging
        ? const [AppProviderObserver()]
        : const <ProviderObserver>[];

    runApp(
      ProviderScope(
        observers: observers,
        overrides: [
          appBootstrapDataProvider.overrideWithValue(bootstrapData),
          appPreferencesProvider.overrideWithValue(bootstrapData.preferences),
        ],
        child: ShiftMatePayApp(routerConfig: router),
      ),
    );
  }, _reportUnhandledError);
}

void _reportUnhandledError(Object error, StackTrace? stack) {
  debugPrint('Unhandled app error: $error');
  if (stack != null) {
    debugPrintStack(stackTrace: stack);
  }
}

class _AppErrorWidget extends StatelessWidget {
  const _AppErrorWidget({required this.details});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Please close and reopen ShiftMate Pay.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
