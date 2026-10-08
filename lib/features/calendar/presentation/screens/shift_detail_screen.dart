import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/shared_types.dart';
import '../../../../core/time/date_range_extensions.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/shift_instance.dart';
import '../../../../domain/entities/shift_template.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../planning/application/planning_providers.dart';

class ShiftDetailScreen extends ConsumerStatefulWidget {
  const ShiftDetailScreen({
    required this.jobId,
    required this.date,
    this.initialInstance,
    super.key,
  });

  final String jobId;
  final DateTime date;
  final ShiftInstance? initialInstance;

  @override
  ConsumerState<ShiftDetailScreen> createState() => _ShiftDetailScreenState();
}

class _ShiftDetailScreenState extends ConsumerState<ShiftDetailScreen> {
  static const _manualTemplateValue = '__manual__';

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _breakMinutesController;
  late final TextEditingController _noteController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _markAsOffDay;
  late bool _isHoliday;
  late String _selectedTemplateValue;
  bool _isSaving = false;

  bool get _hasExistingOverride =>
      widget.initialInstance?.source == ShiftSource.manual;

  @override
  void initState() {
    super.initState();
    final instance = widget.initialInstance;
    _markAsOffDay = instance?.overrideType == ShiftOverrideType.markOffDay;
    _isHoliday = instance?.isHoliday ?? false;
    _startTime = _timeOfDayFromDateTime(
      instance?.startDateTime ??
          DateTime(widget.date.year, widget.date.month, widget.date.day, 9),
    );
    _endTime = _timeOfDayFromDateTime(
      instance?.endDateTime ??
          DateTime(widget.date.year, widget.date.month, widget.date.day, 17),
    );
    _breakMinutesController = TextEditingController(
      text: (instance?.unpaidBreakMinutes ?? 30).toString(),
    );
    _noteController = TextEditingController(text: instance?.note ?? '');
    _selectedTemplateValue =
        instance?.templateSnapshot?.templateId ?? _manualTemplateValue;
  }

  @override
  void dispose() {
    _breakMinutesController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(
      shiftTemplatesForJobProvider(widget.jobId),
    );
    final planningAlertsAsync = ref.watch(
      planningAlertsForDayProvider((jobId: widget.jobId, date: widget.date)),
    );
    final effectiveDate = widget.date.startOfDay;

    return Scaffold(
      appBar: AppBar(title: const Text('Shift detail')),
      body: templatesAsync.when(
        data: (templates) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(effectiveDate),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _hasExistingOverride
                    ? 'Editing a saved manual override for this day.'
                    : widget.initialInstance == null
                    ? 'Create a manual shift or mark this day as off.'
                    : 'Convert this generated shift into a one-off manual override.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              planningAlertsAsync.when(
                data: (alerts) => alerts.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PlanningAlertsCard(alerts: alerts),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
              SwitchListTile.adaptive(
                value: _markAsOffDay,
                contentPadding: EdgeInsets.zero,
                title: const Text('Mark this day as off'),
                subtitle: const Text(
                  'This override hides the generated shift for the selected day.',
                ),
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _markAsOffDay = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedTemplateValue,
                decoration: const InputDecoration(
                  labelText: 'Template snapshot',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: _manualTemplateValue,
                    child: Text('Custom manual shift'),
                  ),
                  ...templates.map(
                    (template) => DropdownMenuItem<String>(
                      value: template.id,
                      child: Text(template.name),
                    ),
                  ),
                ],
                onChanged: _markAsOffDay || _isSaving
                    ? null
                    : (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _selectedTemplateValue = value);
                        final selectedTemplate = _findTemplateByValue(
                          templates,
                          value,
                        );
                        if (selectedTemplate != null) {
                          _applyTemplateDefaults(selectedTemplate);
                        }
                      },
              ),
              const SizedBox(height: 16),
              _TimePickerField(
                label: 'Start time',
                value: _startTime,
                enabled: !_markAsOffDay && !_isSaving,
                onChanged: (value) => setState(() => _startTime = value),
              ),
              const SizedBox(height: 12),
              _TimePickerField(
                label: 'End time',
                value: _endTime,
                enabled: !_markAsOffDay && !_isSaving,
                onChanged: (value) => setState(() => _endTime = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _breakMinutesController,
                keyboardType: TextInputType.number,
                enabled: !_markAsOffDay && !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Unpaid break minutes',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_markAsOffDay) {
                    return null;
                  }
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid break duration';
                  }
                  if (parsed >= _shiftDurationMinutes) {
                    return 'Break must be shorter than the shift duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: _isHoliday,
                contentPadding: EdgeInsets.zero,
                title: const Text('Mark as holiday shift'),
                subtitle: const Text(
                  'Holiday pay and summaries will treat this shift as holiday work.',
                ),
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _isHoliday = value),
              ),
              const SizedBox(height: 16),
              _OverridePreviewCard(
                date: effectiveDate,
                markAsOffDay: _markAsOffDay,
                isHoliday: _isHoliday,
                selectedTemplate: _findTemplateByValue(
                  templates,
                  _selectedTemplateValue,
                ),
                startTime: _startTime,
                endTime: _endTime,
                breakMinutes: int.tryParse(_breakMinutesController.text) ?? 0,
                note: _noteController.text.trim(),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : () => _save(templates),
                icon: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Saving...' : 'Save override'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Future<void> _save(List<ShiftTemplate> templates) async {
    if (!_markAsOffDay && !_formKey.currentState!.validate()) {
      return;
    }

    if (!_markAsOffDay && _startMinutes == _endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Start and end times cannot be identical.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final existing = widget.initialInstance;
    final selectedTemplate = _findTemplateByValue(
      templates,
      _selectedTemplateValue,
    );
    final day = widget.date.startOfDay;

    final instance = _markAsOffDay
        ? ShiftInstance(
            id: _buildOverrideId(existing, day),
            jobId: widget.jobId,
            date: day,
            templateSnapshot: null,
            startDateTime: day,
            endDateTime: day,
            unpaidBreakMinutes: 0,
            source: ShiftSource.manual,
            note: _trimmedNote,
            isHoliday: _isHoliday,
            overrideType: ShiftOverrideType.markOffDay,
          )
        : _buildWorkingOverride(
            day: day,
            existing: existing,
            selectedTemplate: selectedTemplate,
          );

    final result = await ref
        .read(shiftInstanceRepositoryProvider)
        .saveInstance(instance);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    result.when(
      success: (_) async {
        await ref
            .read(reminderNotificationServiceProvider)
            .syncAllReminderSchedules();
        if (!mounted) {
          return;
        }
        Navigator.of(context).pop(true);
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  ShiftInstance _buildWorkingOverride({
    required DateTime day,
    required ShiftInstance? existing,
    required ShiftTemplate? selectedTemplate,
  }) {
    final start = DateTime(
      day.year,
      day.month,
      day.day,
      _startTime.hour,
      _startTime.minute,
    );
    var end = DateTime(
      day.year,
      day.month,
      day.day,
      _endTime.hour,
      _endTime.minute,
    );
    if (!end.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }

    final breakMinutes = int.parse(_breakMinutesController.text);
    final note = _trimmedNote;
    final templateSnapshot = selectedTemplate != null
        ? ShiftTemplateSnapshot(
            templateId: selectedTemplate.id,
            name: selectedTemplate.name,
            category: selectedTemplate.category,
            startMinutesLocal: _startMinutes,
            endMinutesLocal: _endMinutes,
            unpaidBreakMinutes: breakMinutes,
            defaultNote: note,
          )
        : ShiftTemplateSnapshot(
            templateId: null,
            name: existing?.templateSnapshot?.name ?? 'Manual shift',
            category:
                existing?.templateSnapshot?.category ?? ShiftCategory.custom,
            startMinutesLocal: _startMinutes,
            endMinutesLocal: _endMinutes,
            unpaidBreakMinutes: breakMinutes,
            defaultNote: note,
          );

    final isEditingGenerated =
        existing != null && existing.source == ShiftSource.pattern;

    return ShiftInstance(
      id: _buildOverrideId(existing, day),
      jobId: widget.jobId,
      date: day,
      templateSnapshot: templateSnapshot,
      startDateTime: start,
      endDateTime: end,
      unpaidBreakMinutes: breakMinutes,
      source: ShiftSource.manual,
      note: note,
      isHoliday: _isHoliday,
      overrideType: isEditingGenerated
          ? ShiftOverrideType.editGeneratedShift
          : ShiftOverrideType.replaceWithManualShift,
    );
  }

  String _buildOverrideId(ShiftInstance? existing, DateTime day) {
    if (existing != null && existing.source == ShiftSource.manual) {
      return existing.id;
    }
    return 'override:${widget.jobId}:${DateFormat('yyyy-MM-dd').format(day)}';
  }

  ShiftTemplate? _findTemplateByValue(
    List<ShiftTemplate> templates,
    String value,
  ) {
    if (value == _manualTemplateValue) {
      return null;
    }
    for (final template in templates) {
      if (template.id == value) {
        return template;
      }
    }
    return null;
  }

  void _applyTemplateDefaults(ShiftTemplate template) {
    setState(() {
      _startTime = _timeOfDayFromMinutes(template.startMinutesLocal);
      _endTime = _timeOfDayFromMinutes(template.endMinutesLocal);
      _breakMinutesController.text = template.unpaidBreakMinutes.toString();
      _noteController.text = template.defaultNote ?? '';
    });
  }

  String? get _trimmedNote {
    final trimmed = _noteController.text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  int get _startMinutes => (_startTime.hour * 60) + _startTime.minute;

  int get _endMinutes => (_endTime.hour * 60) + _endTime.minute;

  int get _shiftDurationMinutes {
    final duration = _endMinutes - _startMinutes;
    return duration > 0 ? duration : duration + (24 * 60);
  }

  TimeOfDay _timeOfDayFromMinutes(int totalMinutes) {
    final normalized = totalMinutes % (24 * 60);
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  }

  TimeOfDay _timeOfDayFromDateTime(DateTime value) {
    return TimeOfDay(hour: value.hour, minute: value.minute);
  }
}

class _PlanningAlertsCard extends StatelessWidget {
  const _PlanningAlertsCard({required this.alerts});

  final List<dynamic> alerts;

  @override
  Widget build(BuildContext context) {
    final topAlerts = alerts.take(2).toList(growable: false);
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.errorContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Planning alerts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...topAlerts.map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• ${alert.title}'),
              ),
            ),
            if (alerts.length > topAlerts.length)
              Text(
                '+ ${alerts.length - topAlerts.length} more warning(s) for this day',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final TimeOfDay value;
  final bool enabled;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: !enabled
          ? null
          : () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: value,
              );
              if (picked != null) {
                onChanged(picked);
              }
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value.format(context))],
      ),
    );
  }
}

class _OverridePreviewCard extends StatelessWidget {
  const _OverridePreviewCard({
    required this.date,
    required this.markAsOffDay,
    required this.isHoliday,
    required this.selectedTemplate,
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    required this.note,
  });

  final DateTime date;
  final bool markAsOffDay;
  final bool isHoliday;
  final ShiftTemplate? selectedTemplate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int breakMinutes;
  final String note;

  @override
  Widget build(BuildContext context) {
    final label = markAsOffDay
        ? 'Off day override'
        : selectedTemplate?.name ?? 'Custom manual shift';

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preview', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              markAsOffDay
                  ? 'Marked off for ${DateFormat('d MMM yyyy').format(date)}'
                  : '${_formatTimeOfDay(startTime)} - ${_formatTimeOfDay(endTime)} · $breakMinutes min break',
            ),
            if (isHoliday) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.celebration_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text('Holiday shift'),
                ],
              ),
            ],
            if (note.isNotEmpty) ...[const SizedBox(height: 4), Text(note)],
          ],
        ),
      ),
    );
  }
}

String _formatTimeOfDay(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}
