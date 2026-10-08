import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/database/database_providers.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/export/presentation/screens/export_screen.dart';
import '../../features/import/presentation/screens/csv_import_screen.dart';
import '../../features/jobs/presentation/screens/jobs_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/pay/presentation/screens/advanced_pay_settings_screen.dart';
import '../../features/pay/presentation/screens/forecast_screen.dart';
import '../../features/pay/presentation/screens/pay_screen.dart';
import '../../features/pay/presentation/screens/pay_verification_screen.dart';
import '../../features/patterns/presentation/screens/create_shift_pattern_screen.dart';
import '../../features/premium/presentation/screens/premium_screen.dart';
import '../../features/reminders/presentation/screens/reminders_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/project_foundation_screen.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.jobs,
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final preferences = container.read(appPreferencesProvider);
      final hasCompletedOnboarding = preferences.onboardingCompleted;
      final isOnboardingRoute = state.uri.path == AppRoutes.onboarding;

      if (!hasCompletedOnboarding && !isOnboardingRoute) {
        return AppRoutes.onboarding;
      }

      if (hasCompletedOnboarding && isOnboardingRoute) {
        return AppRoutes.jobs;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.newJob,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.jobs}/:jobId/edit',
        builder: (context, state) =>
            OnboardingScreen(jobId: state.pathParameters['jobId']!),
      ),
      GoRoute(
        path: '${AppRoutes.jobs}/:jobId/patterns/new',
        builder: (context, state) =>
            CreateShiftPatternScreen(jobId: state.pathParameters['jobId']!),
      ),
      GoRoute(
        path: '${AppRoutes.jobs}/:jobId/advanced-pay',
        builder: (context, state) =>
            AdvancedPaySettingsScreen(jobId: state.pathParameters['jobId']!),
      ),
      GoRoute(
        path: '${AppRoutes.jobs}/:jobId/import',
        builder: (context, state) =>
            CsvImportScreen(jobId: state.pathParameters['jobId']!),
      ),
      GoRoute(
        path: AppRoutes.payVerification,
        builder: (context, state) => PayVerificationScreen(
          jobId: state.uri.queryParameters['job_id']!,
          periodStart: DateTime.parse(state.uri.queryParameters['start']!),
          periodEnd: DateTime.parse(state.uri.queryParameters['end']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.forecast,
        builder: (context, state) => ForecastScreen(
          initialJobId: state.uri.queryParameters['job_id']!,
          initialAnchorDate: DateTime.parse(
            state.uri.queryParameters['anchor']!,
          ),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.jobs,
            builder: (context, state) => const JobsScreen(),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: AppRoutes.pay,
            builder: (context, state) => const PayScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: AppRoutes.export,
        builder: (context, state) => const ExportScreen(),
      ),
      GoRoute(
        path: AppRoutes.premium,
        builder: (context, state) => PremiumScreen(
          entryPoint:
              state.uri.queryParameters['entry_point'] ?? 'premium_screen',
          highlightFeature: state.uri.queryParameters['feature'],
        ),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
}

class AppRoutes {
  const AppRoutes._();

  static const onboarding = '/onboarding';
  static const newJob = '/jobs/new';
  static const jobs = '/jobs';
  static const calendar = '/calendar';
  static const pay = '/pay';
  static const payVerification = '/pay/verification';
  static const forecast = '/pay/forecast';
  static const settings = '/settings';
  static const reminders = '/reminders';
  static const export = '/export';
  static const premium = '/premium';
  static const privacyPolicy = '/privacy-policy';

  static String editJob(String jobId) => '/jobs/$jobId/edit';
  static String advancedPaySettings(String jobId) =>
      '/jobs/$jobId/advanced-pay';
  static String csvImport(String jobId) => '/jobs/$jobId/import';

  static String payVerificationRoute({
    required String jobId,
    required DateTime start,
    required DateTime end,
  }) {
    return Uri(
      path: payVerification,
      queryParameters: {
        'job_id': jobId,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      },
    ).toString();
  }

  static String forecastRoute({
    required String jobId,
    required DateTime anchor,
  }) {
    return Uri(
      path: forecast,
      queryParameters: {'job_id': jobId, 'anchor': anchor.toIso8601String()},
    ).toString();
  }

  static String premiumWithContext({
    required String entryPoint,
    String? feature,
  }) {
    return Uri(
      path: premium,
      queryParameters: {
        'entry_point': entryPoint,
        ...?feature == null ? null : {'feature': feature},
      },
    ).toString();
  }
}

class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final index = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (selectedIndex) {
          context.go(_locationForIndex(selectedIndex));
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Pay',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _indexForLocation(String currentLocation) {
    if (currentLocation.startsWith(AppRoutes.calendar)) {
      return 1;
    }
    if (currentLocation.startsWith(AppRoutes.pay)) {
      return 2;
    }
    if (currentLocation.startsWith(AppRoutes.settings)) {
      return 3;
    }

    return 0;
  }

  String _locationForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.jobs;
      case 1:
        return AppRoutes.calendar;
      case 2:
        return AppRoutes.pay;
      case 3:
        return AppRoutes.settings;
      default:
        return AppRoutes.jobs;
    }
  }
}
