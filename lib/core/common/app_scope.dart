class AppScope {
  const AppScope({required this.freeFeatures, required this.premiumFeatures});

  final List<String> freeFeatures;
  final List<String> premiumFeatures;

  static const current = AppScope(
    freeFeatures: [
      'One job',
      'Calendar',
      'Basic pattern builder',
      'Basic pay estimate',
      'Simple notifications',
      'JSON backup/export',
    ],
    premiumFeatures: [
      'Multiple jobs',
      'Home screen widgets',
      'PDF schedule export',
      'Calendar .ics export for personal calendars',
      'Advanced pay rules',
      'Payslip verification and discrepancy checks',
      '30, 60, and 90 day income forecasting',
      'CSV rota import with preview-before-save',
      'Personalized prep reminders and richer reminder previews',
    ],
  );
}
