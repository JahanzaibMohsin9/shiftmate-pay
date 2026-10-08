import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  static const bool _providerLoggingEnabled = bool.fromEnvironment(
    'SHIFTMATE_LOG_PROVIDERS',
    defaultValue: false,
  );

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _log('added', provider, value);
    super.didAddProvider(provider, value, container);
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _log('disposed', provider, null);
    super.didDisposeProvider(provider, container);
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _log('updated', provider, newValue);
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  void _log(String event, ProviderBase<Object?> provider, Object? value) {
    if (kReleaseMode || !_providerLoggingEnabled) {
      return;
    }

    debugPrint('[Riverpod][$event] ${provider.name ?? provider.runtimeType} => $value');
  }
}
