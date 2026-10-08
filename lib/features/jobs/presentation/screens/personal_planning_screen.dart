import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../core/common/app_constants.dart';
import '../../../../core/common/identifiers.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/availability_rule.dart';
import '../../../../domain/entities/planning_settings.dart';
import '../../../planning/application/planning_providers.dart';

class PersonalPlanningScreen extends ConsumerStatefulWidget {
  const PersonalPlanningScreen({
    required this.jobId,
    required this.jobName,
    super.key,
  });

  final String jobId;
  final String jobName;

  @override
  ConsumerState<PersonalPlanningScreen> createState() =>
      _PersonalPlanningScreenState();
}

class _PersonalPlanningScreenState
    extends ConsumerState<PersonalPlanningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _minimumRestHoursController = TextEditingController();
  final _maxConsecutiveDaysController = TextEditingController();
  final _weeklyOvertimeHoursController = TextEditingController();
  final _monthlyOvertimeHoursController = TextEditingController();
  bool _planningAlertsEnabled = true;
  bool _isSaving = false;
  String? _initializedSettingsId;

  @override
  void dispose() {
    _minimumRestHoursController.dispose();
    _maxConsecutiveDaysController.dispose();
    _weeklyOvertimeHoursController.dispose();
    _monthlyOvertimeHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(
      planningSettingsForJobProvider(widget.jobId),
    );
    final availabilityAsync = ref.watch(
      availabilityRulesForJobProvider(widget.jobId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Planning support')),
      body: settingsAsync.when(
        data: (settings) {
          _initializeFromSettings(settings);
          return availabilityAsync.when(
            data: (rules) => Form(
              key: _formKey,
              child: ListView(
                padding: AppSpacing.pagePaddingWithSafeBottom(context),
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.jobName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Optional worker-side guidance for rest, overtime, and availability. It never blocks edits.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Planning rules',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: _planningAlertsEnabled,
                          title: const Text('Enable planning alerts'),
                          subtitle: const Text(
                            'Show worker-side guidance for rest, overtime, and availability conflicts.',
                          ),
                          onChanged: _isSaving
                              ? null
                              : (value) => setState(
                                  () => _planningAlertsEnabled = value,
                                ),
                        ),
                        const SizedBox(height: 8),
                        _HoursField(
                          controller: _minimumRestHoursController,
                          label: 'Minimum rest gap (hours)',
                          helper:
                              'Leave blank to disable. A gentle warning appears when shifts are too close together.',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _maxConsecutiveDaysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max consecutive work days',
                            helperText:
                                'Leave blank to disable. Warnings appear after the streak passes this number.',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validatePositiveOptionalInt,
                        ),
                        const SizedBox(height: 12),
                        _HoursField(
                          controller: _weeklyOvertimeHoursController,
                          label: 'Weekly overtime cap (hours)',
                          helper:
                              'Leave blank to disable. This tracks planned overtime above your pay-rule thresholds.',
                        ),
                        const SizedBox(height: 12),
                        _HoursField(
                          controller: _monthlyOvertimeHoursController,
                          label: 'Monthly overtime cap (hours)',
                          helper:
                              'Leave blank to disable. Best used as a planning target rather than a hard rule.',
                        ),
                        const SizedBox(height: 16),
                        _PlanningRuleSummary(
                          planningAlertsEnabled: _planningAlertsEnabled,
                          minimumRestHours: _minimumRestHoursController.text,
                          maxConsecutiveDays:
                              _maxConsecutiveDaysController.text,
                          weeklyOvertimeHours:
                              _weeklyOvertimeHoursController.text,
                          monthlyOvertimeHours:
                              _monthlyOvertimeHoursController.text,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _isSaving ? null : _saveSettings,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            _isSaving ? 'Saving...' : 'Save planning rules',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Availability',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use weekly rules for your usual unavailable windows and one-off dates for exceptions.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _AvailabilitySection(
                          title: 'Weekly rules',
                          emptyLabel: 'No weekly availability rules saved yet.',
                          rules: rules
                              .where(
                                (rule) =>
                                    rule.type == AvailabilityRuleType.recurring,
                              )
                              .toList(growable: false),
                          onAdd: () => _showAddRecurringRuleDialog(),
                          onDelete: _deleteRule,
                        ),
                        const SizedBox(height: 20),
                        _AvailabilitySection(
                          title: 'One-off dates',
                          emptyLabel: 'No unavailable dates saved yet.',
                          rules: rules
                              .where(
                                (rule) =>
                                    rule.type == AvailabilityRuleType.oneOff,
                              )
                              .toList(growable: false),
                          onAdd: () => _showAddUnavailableDialog(),
                          onDelete: _deleteRule,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _ErrorState(message: error.toString()),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: error.toString()),
      ),
    );
  }

  void _initializeFromSettings(PlanningSettings? settings) {
    if (_initializedSettingsId == settings?.id) {
      return;
    }
    _initializedSettingsId = settings?.id;
    _planningAlertsEnabled = settings?.planningAlertsEnabled ?? true;
    _minimumRestHoursController.text = settings?.minimumRestMinutes == null
        ? ''
        : ((settings!.minimumRestMinutes!) / AppConstants.minutesPerHour)
              .toStringAsFixed(1)
              .replaceFirst(RegExp(r'\.0$'), '');
    _maxConsecutiveDaysController.text =
        settings?.maxConsecutiveWorkDays?.toString() ?? '';
    _weeklyOvertimeHoursController.text =
        settings?.weeklyOvertimeCapMinutes == null
        ? ''
        : ((settings!.weeklyOvertimeCapMinutes!) / AppConstants.minutesPerHour)
              .toStringAsFixed(1)
              .replaceFirst(RegExp(r'\.0$'), '');
    _monthlyOvertimeHoursController.text =
        settings?.monthlyOvertimeCapMinutes == null
        ? ''
        : ((settings!.monthlyOvertimeCapMinutes!) / AppConstants.minutesPerHour)
              .toStringAsFixed(1)
              .replaceFirst(RegExp(r'\.0$'), '');
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final existing = await ref.read(
      planningSettingsForJobProvider(widget.jobId).future,
    );
    final now = DateTime.now().toUtc();
    final settings = PlanningSettings(
      id: existing?.id ?? AppId.generate(),
      jobId: widget.jobId,
      planningAlertsEnabled: _planningAlertsEnabled,
      minimumRestMinutes: _parseHoursToMinutes(
        _minimumRestHoursController.text,
      ),
      maxConsecutiveWorkDays: _parseOptionalInt(
        _maxConsecutiveDaysController.text,
      ),
      weeklyOvertimeCapMinutes: _parseHoursToMinutes(
        _weeklyOvertimeHoursController.text,
      ),
      monthlyOvertimeCapMinutes: _parseHoursToMinutes(
        _monthlyOvertimeHoursController.text,
      ),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final result = await ref
        .read(planningSettingsRepositoryProvider)
        .save(settings);
    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);
    result.when(
      success: (_) {
        ref.invalidate(planningSettingsForJobProvider(widget.jobId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Planning rules saved.')));
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  Future<void> _showAddUnavailableDialog() async {
    final result = await showDialog<_UnavailableDraft>(
      context: context,
      builder: (context) => const _AddUnavailableDialog(),
    );
    if (result == null) {
      return;
    }

    final now = DateTime.now().toUtc();
    final saveResult = await ref
        .read(availabilityRuleRepositoryProvider)
        .save(
          AvailabilityRule(
            id: AppId.generate(),
            jobId: widget.jobId,
            type: AvailabilityRuleType.oneOff,
            state: result.state,
            startDateTime: result.start,
            endDateTime: result.end,
            weekday: null,
            startMinuteOfDay: null,
            endMinuteOfDay: null,
            note: result.note,
            isEnabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        );

    if (!mounted) {
      return;
    }

    saveResult.when(
      success: (_) {
        ref.invalidate(availabilityRulesForJobProvider(widget.jobId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unavailable date saved.')),
        );
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  Future<void> _showAddRecurringRuleDialog() async {
    final result = await showDialog<_RecurringDraft>(
      context: context,
      builder: (context) => const _AddRecurringRuleDialog(),
    );
    if (result == null) {
      return;
    }

    final now = DateTime.now().toUtc();
    final saveResult = await ref
        .read(availabilityRuleRepositoryProvider)
        .save(
          AvailabilityRule(
            id: AppId.generate(),
            jobId: widget.jobId,
            type: AvailabilityRuleType.recurring,
            state: result.state,
            startDateTime: null,
            endDateTime: null,
            weekday: result.weekday,
            startMinuteOfDay: result.startMinuteOfDay,
            endMinuteOfDay: result.endMinuteOfDay,
            note: result.note,
            isEnabled: true,
            createdAt: now,
            updatedAt: now,
          ),
        );

    if (!mounted) {
      return;
    }

    saveResult.when(
      success: (_) {
        ref.invalidate(availabilityRulesForJobProvider(widget.jobId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Weekly rule saved.')));
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  Future<void> _deleteRule(String ruleId) async {
    final result = await ref
        .read(availabilityRuleRepositoryProvider)
        .delete(ruleId);
    if (!mounted) {
      return;
    }

    result.when(
      success: (_) {
        ref.invalidate(availabilityRulesForJobProvider(widget.jobId));
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  String? _validatePositiveOptionalInt(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value!);
    if (parsed == null || parsed <= 0) {
      return 'Enter a value greater than zero or leave blank';
    }
    return null;
  }

  int? _parseOptionalInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
  }

  int? _parseHoursToMinutes(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return (parsed * AppConstants.minutesPerHour).round();
  }
}

class _HoursField extends StatelessWidget {
  const _HoursField({
    required this.controller,
    required this.label,
    required this.helper,
  });

  final TextEditingController controller;
  final String label;
  final String helper;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return null;
        }
        final parsed = double.tryParse(value!);
        if (parsed == null || parsed <= 0) {
          return 'Enter a value greater than zero or leave blank';
        }
        return null;
      },
    );
  }
}

class _AvailabilityRuleTile extends StatelessWidget {
  const _AvailabilityRuleTile({required this.rule, required this.onDelete});

  final AvailabilityRule rule;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accent = rule.state == AvailabilityState.unavailable
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    final formatter = DateFormat('d MMM yyyy, h:mm a');
    final weekdayLabels = const {
      DateTime.monday: 'Mon',
      DateTime.tuesday: 'Tue',
      DateTime.wednesday: 'Wed',
      DateTime.thursday: 'Thu',
      DateTime.friday: 'Fri',
      DateTime.saturday: 'Sat',
      DateTime.sunday: 'Sun',
    };
    final recurringLabel =
        '${weekdayLabels[rule.weekday] ?? 'Day'} ${_formatRuleMinute(rule.startMinuteOfDay)} - ${_formatRuleMinute(rule.endMinuteOfDay)}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            rule.state == AvailabilityState.unavailable
                ? Icons.block_outlined
                : Icons.bedtime_outlined,
            color: accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.state == AvailabilityState.unavailable
                      ? 'Unavailable'
                      : 'Prefer off',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: accent),
                ),
                const SizedBox(height: 4),
                Text(
                  rule.type == AvailabilityRuleType.oneOff
                      ? '${formatter.format(rule.startDateTime!)} - ${formatter.format(rule.endDateTime!)}'
                      : recurringLabel,
                ),
                if (rule.note?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(rule.note!.trim()),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class _UnavailableDraft {
  const _UnavailableDraft({
    required this.start,
    required this.end,
    required this.state,
    required this.note,
  });

  final DateTime start;
  final DateTime end;
  final AvailabilityState state;
  final String? note;
}

class _RecurringDraft {
  const _RecurringDraft({
    required this.weekday,
    required this.startMinuteOfDay,
    required this.endMinuteOfDay,
    required this.state,
    required this.note,
  });

  final int weekday;
  final int startMinuteOfDay;
  final int endMinuteOfDay;
  final AvailabilityState state;
  final String? note;
}

class _AddUnavailableDialog extends StatefulWidget {
  const _AddUnavailableDialog();

  @override
  State<_AddUnavailableDialog> createState() => _AddUnavailableDialogState();
}

class _AddUnavailableDialogState extends State<_AddUnavailableDialog> {
  final _noteController = TextEditingController();
  late DateTime _start;
  late DateTime _end;
  AvailabilityState _state = AvailabilityState.unavailable;

  @override
  void initState() {
    super.initState();
    _start = DateTime.now().add(const Duration(days: 1));
    _start = DateTime(_start.year, _start.month, _start.day, 9);
    _end = _start.add(const Duration(hours: 8));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('d MMM yyyy, h:mm a');

    return AlertDialog(
      title: const Text('Add unavailable date'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<AvailabilityState>(
              initialValue: _state,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: AvailabilityState.unavailable,
                  child: Text('Unavailable'),
                ),
                DropdownMenuItem(
                  value: AvailabilityState.preferOff,
                  child: Text('Prefer off'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _state = value);
                }
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _pickDateTime(isStart: true),
              icon: const Icon(Icons.schedule_outlined),
              label: Text('Start: ${formatter.format(_start)}'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _pickDateTime(isStart: false),
              icon: const Icon(Icons.schedule_outlined),
              label: Text('End: ${formatter.format(_end)}'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _end.isAfter(_start)
              ? () => Navigator.of(context).pop(
                  _UnavailableDraft(
                    start: _start,
                    end: _end,
                    state: _state,
                    note: _noteController.text.trim().isEmpty
                        ? null
                        : _noteController.text.trim(),
                  ),
                )
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final current = isStart ? _start : _end;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) {
      return;
    }
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (pickedTime == null || !mounted) {
      return;
    }

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      if (isStart) {
        _start = combined;
        if (!_end.isAfter(_start)) {
          _end = _start.add(const Duration(hours: 8));
        }
      } else {
        _end = combined;
      }
    });
  }
}

class _AddRecurringRuleDialog extends StatefulWidget {
  const _AddRecurringRuleDialog();

  @override
  State<_AddRecurringRuleDialog> createState() =>
      _AddRecurringRuleDialogState();
}

class _AddRecurringRuleDialogState extends State<_AddRecurringRuleDialog> {
  final _noteController = TextEditingController();
  int _weekday = DateTime.monday;
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 17, minute: 0);
  AvailabilityState _state = AvailabilityState.unavailable;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add weekly rule'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _weekday,
              decoration: const InputDecoration(
                labelText: 'Weekday',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: DateTime.monday, child: Text('Monday')),
                DropdownMenuItem(
                  value: DateTime.tuesday,
                  child: Text('Tuesday'),
                ),
                DropdownMenuItem(
                  value: DateTime.wednesday,
                  child: Text('Wednesday'),
                ),
                DropdownMenuItem(
                  value: DateTime.thursday,
                  child: Text('Thursday'),
                ),
                DropdownMenuItem(value: DateTime.friday, child: Text('Friday')),
                DropdownMenuItem(
                  value: DateTime.saturday,
                  child: Text('Saturday'),
                ),
                DropdownMenuItem(value: DateTime.sunday, child: Text('Sunday')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _weekday = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AvailabilityState>(
              initialValue: _state,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: AvailabilityState.unavailable,
                  child: Text('Unavailable'),
                ),
                DropdownMenuItem(
                  value: AvailabilityState.preferOff,
                  child: Text('Prefer off'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _state = value);
                }
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _pickTime(isStart: true),
              icon: const Icon(Icons.schedule_outlined),
              label: Text('Start: ${_start.format(context)}'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _pickTime(isStart: false),
              icon: const Icon(Icons.schedule_outlined),
              label: Text('End: ${_end.format(context)}'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            _RecurringDraft(
              weekday: _weekday,
              startMinuteOfDay: (_start.hour * 60) + _start.minute,
              endMinuteOfDay: (_end.hour * 60) + _end.minute,
              state: _state,
              note: _noteController.text.trim().isEmpty
                  ? null
                  : _noteController.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }
}

class _AvailabilitySection extends StatelessWidget {
  const _AvailabilitySection({
    required this.title,
    required this.emptyLabel,
    required this.rules,
    required this.onAdd,
    required this.onDelete,
  });

  final String title;
  final String emptyLabel;
  final List<AvailabilityRule> rules;
  final VoidCallback onAdd;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(title == 'Weekly rules' ? 'Add weekly' : 'Add date'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (rules.isEmpty)
          Text(
            emptyLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AvailabilityRuleTile(
                rule: rule,
                onDelete: () => onDelete(rule.id),
              ),
            ),
          ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _PlanningRuleSummary extends StatelessWidget {
  const _PlanningRuleSummary({
    required this.planningAlertsEnabled,
    required this.minimumRestHours,
    required this.maxConsecutiveDays,
    required this.weeklyOvertimeHours,
    required this.monthlyOvertimeHours,
  });

  final bool planningAlertsEnabled;
  final String minimumRestHours;
  final String maxConsecutiveDays;
  final String weeklyOvertimeHours;
  final String monthlyOvertimeHours;

  @override
  Widget build(BuildContext context) {
    final chips = <String>[
      planningAlertsEnabled ? 'Alerts on' : 'Alerts off',
      if (minimumRestHours.trim().isNotEmpty) 'Rest $minimumRestHours h',
      if (maxConsecutiveDays.trim().isNotEmpty) 'Max $maxConsecutiveDays days',
      if (weeklyOvertimeHours.trim().isNotEmpty)
        'Weekly OT $weeklyOvertimeHours h',
      if (monthlyOvertimeHours.trim().isNotEmpty)
        'Monthly OT $monthlyOvertimeHours h',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map(
            (chip) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(chip),
            ),
          )
          .toList(growable: false),
    );
  }
}

String _formatRuleMinute(int? totalMinutes) {
  if (totalMinutes == null) {
    return '--:--';
  }
  final normalized = totalMinutes % (24 * 60);
  final hour = (normalized ~/ 60).toString().padLeft(2, '0');
  final minute = (normalized % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}
