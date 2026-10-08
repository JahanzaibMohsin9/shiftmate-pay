class AppEntitlement {
  const AppEntitlement({
    required this.premium,
    required this.multipleJobsEnabled,
    required this.widgetsEnabled,
    required this.advancedPayRulesEnabled,
    required this.payVerificationEnabled,
    required this.forecastingEnabled,
    required this.importEnabled,
    required this.exportEnabled,
    required this.remindersEnabled,
  });

  /// The free-tier baseline available in the MVP without an upgrade.
  factory AppEntitlement.free() => const AppEntitlement(
    premium: false,
    multipleJobsEnabled: false,
    widgetsEnabled: false,
    advancedPayRulesEnabled: false,
    payVerificationEnabled: false,
    forecastingEnabled: false,
    importEnabled: false,
    exportEnabled: false,
    remindersEnabled: false,
  );

  /// Full premium entitlement — returned once a purchase is verified.
  factory AppEntitlement.premium() => const AppEntitlement(
    premium: true,
    multipleJobsEnabled: true,
    widgetsEnabled: true,
    advancedPayRulesEnabled: true,
    payVerificationEnabled: true,
    forecastingEnabled: true,
    importEnabled: true,
    exportEnabled: true,
    remindersEnabled: true,
  );

  final bool premium;
  final bool multipleJobsEnabled;
  final bool widgetsEnabled;
  final bool advancedPayRulesEnabled;
  final bool payVerificationEnabled;
  final bool forecastingEnabled;
  final bool importEnabled;
  final bool exportEnabled;
  final bool remindersEnabled;

  /// Returns true if a named feature is enabled for this entitlement tier.
  bool canAccess(AppFeature feature) {
    switch (feature) {
      case AppFeature.multipleJobs:
        return multipleJobsEnabled;
      case AppFeature.widgets:
        return widgetsEnabled;
      case AppFeature.advancedPayRules:
        return advancedPayRulesEnabled;
      case AppFeature.payVerification:
        return payVerificationEnabled;
      case AppFeature.forecasting:
        return forecastingEnabled;
      case AppFeature.import:
        return importEnabled;
      case AppFeature.export:
        return exportEnabled;
      case AppFeature.reminders:
        return remindersEnabled;
    }
  }
}

/// Named set of premium features that can be individually checked.
enum AppFeature {
  multipleJobs,
  widgets,
  advancedPayRules,
  payVerification,
  forecasting,
  import,
  export,
  reminders,
}
