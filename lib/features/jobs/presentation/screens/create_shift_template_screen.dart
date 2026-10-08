import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/common/identifiers.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/shift_template.dart';
import '../../application/jobs_providers.dart';

class CreateShiftTemplateScreen extends ConsumerStatefulWidget {
  const CreateShiftTemplateScreen({
    required this.jobId,
    this.initialTemplate,
    super.key,
  });

  final String jobId;
  final ShiftTemplate? initialTemplate;

  @override
  ConsumerState<CreateShiftTemplateScreen> createState() =>
      _CreateShiftTemplateScreenState();
}

class _CreateShiftTemplateScreenState
    extends ConsumerState<CreateShiftTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _breakMinutesController;
  late final TextEditingController _noteController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late ShiftCategory _category;
  bool _isSaving = false;
  bool _isDeleting = false;

  bool get _isEditing => widget.initialTemplate != null;

  @override
  void initState() {
    super.initState();
    final template = widget.initialTemplate;
    _nameController = TextEditingController(text: template?.name ?? '');
    _breakMinutesController = TextEditingController(
      text: (template?.unpaidBreakMinutes ?? 30).toString(),
    );
    _noteController = TextEditingController(text: template?.defaultNote ?? '');
    _startTime = _timeOfDayFromMinutes(template?.startMinutesLocal ?? (9 * 60));
    _endTime = _timeOfDayFromMinutes(template?.endMinutesLocal ?? (17 * 60));
    _category = template?.category ?? ShiftCategory.day;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breakMinutesController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _isSaving || _isDeleting;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit shift template' : 'Add shift template'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Delete template',
              onPressed: isBusy ? null : _confirmDelete,
              icon: _isDeleting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.pagePaddingWithSafeBottom(context),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Template name',
                hintText: 'e.g. Early shift, Ward nights',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter a name'
                  : null,
            ),
            const SizedBox(height: 16),
            _TimePickerField(
              label: 'Start time',
              value: _startTime,
              onChanged: (value) => setState(() => _startTime = value),
            ),
            const SizedBox(height: 12),
            _TimePickerField(
              label: 'End time',
              value: _endTime,
              onChanged: (value) => setState(() => _endTime = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ShiftCategory>(
              initialValue: _category,
              items: ShiftCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) =>
                  setState(() => _category = value ?? ShiftCategory.day),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breakMinutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Unpaid break minutes',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
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
              decoration: const InputDecoration(
                labelText: 'Default note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_categoryLabel(_category)} • ${_formatTimeOfDay(_startTime)} - ${_formatTimeOfDay(_endTime)}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _endMinutes <= _startMinutes
                          ? 'Overnight shift detected. This template will roll into the next day.'
                          : 'Same-day shift detected.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isBusy ? null : _save,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _isSaving
                    ? 'Saving...'
                    : _isEditing
                    ? 'Save changes'
                    : 'Save template',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startMinutes == _endMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Start and end times cannot be identical. Adjust the end time for overnight shifts.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repository = ref.read(shiftTemplateRepositoryProvider);
    final template = ShiftTemplate(
      id: widget.initialTemplate?.id ?? AppId.generate(),
      jobId: widget.jobId,
      name: _nameController.text.trim(),
      startMinutesLocal: _startMinutes,
      endMinutesLocal: _endMinutes,
      unpaidBreakMinutes: int.parse(_breakMinutesController.text),
      category: _category,
      defaultNote: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final result = await repository.saveTemplate(template);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    result.when(
      success: (_) {
        ref.invalidate(shiftTemplatesForJobProvider(widget.jobId));
        context.pop();
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  Future<void> _confirmDelete() async {
    final template = widget.initialTemplate;
    if (template == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete shift template?'),
        content: Text('Delete "${template.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isDeleting = true);
    final result = await ref
        .read(shiftTemplateRepositoryProvider)
        .deleteTemplate(template.id);

    if (!mounted) {
      return;
    }

    setState(() => _isDeleting = false);

    result.when(
      success: (_) {
        ref.invalidate(shiftTemplatesForJobProvider(widget.jobId));
        context.pop();
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
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
}

class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
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

String _formatTimeOfDay(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

String _categoryLabel(ShiftCategory category) {
  switch (category) {
    case ShiftCategory.day:
      return 'Day';
    case ShiftCategory.evening:
      return 'Evening';
    case ShiftCategory.night:
      return 'Night';
    case ShiftCategory.custom:
      return 'Custom';
  }
}
