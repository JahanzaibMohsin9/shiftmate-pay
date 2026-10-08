import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/buttons/app_secondary_button.dart';
import '../../../../app/widgets/buttons/primary_button.dart';
import '../../../../core/common/app_constants.dart';
import '../../../../domain/entities/holiday_rule_set.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/entities/pay_rule_set.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../application/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.jobId});

  final String? jobId;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobNameController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _hourlyRateController = TextEditingController(text: '25');
  final _overtimeDailyController = TextEditingController(text: '8');
  final _overtimeWeeklyController = TextEditingController(text: '40');
  final _overtimeMultiplierController = TextEditingController(text: '1.5');
  final _holidayMultiplierController = TextEditingController(text: '2.0');
  final _defaultReminderLeadMinutesController = TextEditingController(
    text: '480',
  );
  String _selectedColorHex = '#4F46E5';
  String? _initializedJobId;

  @override
  void dispose() {
    _jobNameController.dispose();
    _currencyController.dispose();
    _hourlyRateController.dispose();
    _overtimeDailyController.dispose();
    _overtimeWeeklyController.dispose();
    _overtimeMultiplierController.dispose();
    _holidayMultiplierController.dispose();
    _defaultReminderLeadMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    if (widget.jobId != null) {
      final editSetupAsync = ref.watch(_jobForEditingProvider(widget.jobId!));
      return editSetupAsync.when(
        data: (setup) {
          _populateForEditing(setup);
          return _buildFormScaffold(context, state, isEditing: true);
        },
        loading: () => Scaffold(
          appBar: AppBar(title: Text('Edit job')),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Scaffold(
          appBar: AppBar(title: const Text('Edit job')),
          body: Center(
            child: Padding(
              padding: AppSpacing.pagePadding,
              child: Text(
                'Unable to load this job setup. $error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return _buildFormScaffold(context, state, isEditing: false);
  }

  Scaffold _buildFormScaffold(
    BuildContext context,
    OnboardingFormState state, {
    required bool isEditing,
  }) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit job' : 'Job setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            AppSpacing.gapMd,
            Text(
              isEditing ? 'Update job details' : 'Create your first job',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            AppSpacing.gapSm,
            Text(
              isEditing
                  ? 'Keep the job name, pay defaults, holiday multiplier, and reminder lead time current from one place.'
                  : 'Set up the job name, pay defaults, holiday multiplier, and reminder lead time so your calendar and pay estimates feel ready from day one.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.sectionGap,
            TextFormField(
              controller: _jobNameController,
              decoration: const InputDecoration(
                labelText: 'Job name',
                hintText: 'Ward A night rotation',
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter a job name'
                  : null,
            ),
            AppSpacing.gapMd,
            _ColorPickerField(
              selectedColorHex: _selectedColorHex,
              onSelected: (value) => setState(() => _selectedColorHex = value),
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _currencyController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Currency code',
                hintText: 'USD',
              ),
              validator: (value) {
                final normalized = value?.trim().toUpperCase() ?? '';
                if (normalized.length != 3) {
                  return 'Use a 3-letter ISO currency code';
                }
                return null;
              },
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _hourlyRateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Hourly rate'),
              validator: _validatePositiveDecimal,
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _overtimeDailyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily overtime threshold (hours)',
              ),
              validator: _validatePositiveInt,
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _overtimeWeeklyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weekly overtime threshold (hours)',
              ),
              validator: _validatePositiveInt,
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _overtimeMultiplierController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Overtime multiplier',
                helperText:
                    'Example: 1.5 means overtime pays one and a half times the hourly rate.',
              ),
              validator: _validatePositiveDecimal,
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _holidayMultiplierController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Holiday multiplier',
              ),
              validator: _validatePositiveDecimal,
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _defaultReminderLeadMinutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Default reminder lead time (minutes)',
              ),
              validator: _validatePositiveInt,
            ),
            if (state.errorMessage != null) ...[
              AppSpacing.gapMd,
              Text(
                state.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            AppSpacing.sectionGap,
            PrimaryButton(
              text: state.isSubmitting
                  ? 'Saving…'
                  : isEditing
                  ? 'Save job changes'
                  : 'Save and open calendar',
              isLoading: state.isSubmitting,
              icon: state.isSubmitting
                  ? null
                  : Icon(
                      isEditing
                          ? Icons.save_outlined
                          : Icons.rocket_launch_outlined,
                      size: 18,
                    ),
              onPressed: state.isSubmitting ? null : _submit,
            ),
            AppSpacing.gapMd,
            AppSecondaryButton(
              text: isEditing ? 'Cancel' : 'Back to jobs',
              onPressed: () => context.go(AppRoutes.jobs),
              icon: Icon(
                isEditing ? Icons.close_outlined : Icons.arrow_back_outlined,
                size: 18,
              ),
            ),
            AppSpacing.gapLg,
          ],
        ),
      ),
    );
  }

  void _populateForEditing(_EditableJobSetup setup) {
    if (_initializedJobId == setup.job.id) {
      return;
    }

    _initializedJobId = setup.job.id;
    _jobNameController.text = setup.job.name;
    _currencyController.text = setup.job.currencyCode;
    _hourlyRateController.text =
        (setup.job.hourlyRate.minorUnits / AppConstants.minorUnitsPerMajorUnit)
            .toStringAsFixed(2);
    _overtimeDailyController.text =
        ((setup.payRuleSet.overtimeThresholdDailyMinutes ?? 0) /
                AppConstants.minutesPerHour)
            .round()
            .toString();
    _overtimeWeeklyController.text =
        ((setup.payRuleSet.overtimeThresholdWeeklyMinutes ?? 0) /
                AppConstants.minutesPerHour)
            .round()
            .toString();
    _overtimeMultiplierController.text =
        (setup.payRuleSet.overtimeMultiplierBps / 10000).toStringAsFixed(2);
    _holidayMultiplierController.text =
        (setup.holidayRuleSet.holidayMultiplierBps / 10000).toStringAsFixed(2);
    _defaultReminderLeadMinutesController.text =
        (setup.job.defaultSleepLeadMinutes ?? 480).toString();
    _selectedColorHex = setup.job.colorHex;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existingSetup = widget.jobId == null
        ? null
        : await ref.read(_jobForEditingProvider(widget.jobId!).future);

    final route = await ref
        .read(onboardingControllerProvider.notifier)
        .submit(
          existingJobId: existingSetup?.job.id,
          existingPayRuleSetId: existingSetup?.payRuleSet.id,
          existingHolidayRuleSetId: existingSetup?.holidayRuleSet.id,
          jobName: _jobNameController.text,
          colorHex: _selectedColorHex,
          currencyCode: _currencyController.text,
          hourlyRateMajorUnits: double.parse(_hourlyRateController.text),
          overtimeDailyHours: int.parse(_overtimeDailyController.text),
          overtimeWeeklyHours: int.parse(_overtimeWeeklyController.text),
          overtimeMultiplier: double.parse(_overtimeMultiplierController.text),
          holidayMultiplier: double.parse(_holidayMultiplierController.text),
          defaultReminderLeadMinutes: int.parse(
            _defaultReminderLeadMinutesController.text,
          ),
        );

    if (!mounted || route == null) {
      return;
    }

    context.go(route);
  }

  String? _validatePositiveInt(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a value greater than zero';
    }
    return null;
  }

  String? _validatePositiveDecimal(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a value greater than zero';
    }
    return null;
  }
}

class _EditableJobSetup {
  const _EditableJobSetup({
    required this.job,
    required this.payRuleSet,
    required this.holidayRuleSet,
  });

  final Job job;
  final PayRuleSet payRuleSet;
  final HolidayRuleSet holidayRuleSet;
}

final _jobForEditingProvider = FutureProvider.family<_EditableJobSetup, String>(
  (ref, jobId) async {
    final jobs = await ref.watch(jobsProvider.future);
    final job = jobs.firstWhere((entry) => entry.id == jobId);
    final payRuleSet = await ref.watch(payRuleSetForJobProvider(jobId).future);
    final holidayRuleSet = await ref.watch(
      holidayRuleSetForJobProvider(jobId).future,
    );

    if (payRuleSet == null || holidayRuleSet == null) {
      throw StateError('This job is missing saved pay defaults.');
    }

    return _EditableJobSetup(
      job: job,
      payRuleSet: payRuleSet,
      holidayRuleSet: holidayRuleSet,
    );
  },
);

class _ColorPickerField extends StatelessWidget {
  const _ColorPickerField({
    required this.selectedColorHex,
    required this.onSelected,
  });

  final String selectedColorHex;
  final ValueChanged<String> onSelected;

  static const _options = <String>[
    '#4F46E5',
    '#0EA5E9',
    '#16A34A',
    '#F97316',
    '#DC2626',
  ];

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Job color'),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final option in _options)
            InkWell(
              onTap: () => onSelected(option),
              child: CircleAvatar(
                radius: selectedColorHex == option ? 18 : 16,
                backgroundColor: Color(
                  int.parse(option.replaceFirst('#', '0xFF')),
                ),
                child: selectedColorHex == option
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
