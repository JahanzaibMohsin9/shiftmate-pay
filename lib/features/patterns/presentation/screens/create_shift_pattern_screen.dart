import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/common/identifiers.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/entities.dart';
import '../../../calendar/application/calendar_providers.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../pay/application/pay_providers.dart';
import '../../application/pattern_builder_providers.dart';

class CreateShiftPatternScreen extends ConsumerStatefulWidget {
  const CreateShiftPatternScreen({
    required this.jobId,
    this.initialPattern,
    super.key,
  });

  final String jobId;
  final ShiftPattern? initialPattern;

  @override
  ConsumerState<CreateShiftPatternScreen> createState() =>
      _CreateShiftPatternScreenState();
}

class _CreateShiftPatternScreenState
    extends ConsumerState<CreateShiftPatternScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cycleLengthController;
  DateTime? _startDate;
  bool _isActive = true;
  bool _isSaving = false;
  bool _isLoadingInitialEntries = false;
  List<_PatternDayDraft> _draftEntries = const [];

  bool get _isEditing => widget.initialPattern != null;

  @override
  void initState() {
    super.initState();
    final pattern = widget.initialPattern;
    _nameController = TextEditingController(
      text: pattern?.name ?? 'Primary rota',
    );
    _cycleLengthController = TextEditingController(
      text: (pattern?.cycleLengthDays ?? 7).toString(),
    );
    _startDate = pattern?.startDate;
    _isActive = pattern?.isActive ?? true;
    _draftEntries = _buildDraftEntries(pattern?.cycleLengthDays ?? 7);

    if (pattern != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _loadExistingEntries(pattern.id),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cycleLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(
      shiftTemplatesForJobProvider(widget.jobId),
    );
    final activePatternAsync = ref.watch(
      activeShiftPatternForJobProvider(widget.jobId),
    );
    final parsedCycleLength = int.tryParse(_cycleLengthController.text);
    final isBusy = _isSaving || _isLoadingInitialEntries;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit pattern' : 'Build shift pattern'),
      ),
      body: SafeArea(
        child: templatesAsync.when(
          data: (templates) {
            return activePatternAsync.when(
              data: (activePattern) {
                final currentActivePatternId = activePattern?.id;

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: AppSpacing.pagePaddingWithSafeBottom(context),
                    children: [
                      Text(
                        'Create one rotating pattern for this job and assign every day in the cycle to a shift template or an off day.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Pattern name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter a pattern name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cycleLengthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cycle length (days)',
                          helperText:
                              'Every day in the cycle must have an assignment before saving.',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final parsed = int.tryParse(value ?? '');
                          if (parsed == null) {
                            return 'Enter a valid cycle length';
                          }
                          if (parsed < 1 || parsed > 42) {
                            return 'Cycle length must be between 1 and 42 days';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final parsed = int.tryParse(value);
                          if (parsed == null || parsed < 1 || parsed > 42) {
                            return;
                          }

                          setState(() {
                            _draftEntries = _resizeDraftEntries(
                              _draftEntries,
                              parsed,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Pattern start date'),
                        subtitle: Text(
                          _startDate == null
                              ? 'Choose the first day this cycle applies'
                              : DateFormat.yMMMMd().format(_startDate!),
                        ),
                        trailing: OutlinedButton.icon(
                          onPressed: isBusy ? null : _pickStartDate,
                          icon: const Icon(Icons.event_outlined),
                          label: Text(
                            _startDate == null ? 'Choose date' : 'Change',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        value: _isActive,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active pattern'),
                        subtitle: Text(
                          _isActive
                              ? currentActivePatternId == null ||
                                        currentActivePatternId ==
                                            widget.initialPattern?.id
                                    ? 'This pattern will be used as the active rotation for the job.'
                                    : 'Saving as active will deactivate the current active pattern.'
                              : 'Save this pattern as inactive draft data.',
                        ),
                        onChanged: isBusy
                            ? null
                            : (value) => setState(() => _isActive = value),
                      ),
                      const SizedBox(height: 16),
                      if (_isLoadingInitialEntries)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (parsedCycleLength == null ||
                          parsedCycleLength < 1 ||
                          parsedCycleLength > 42)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Enter a valid cycle length to assign day-by-day pattern entries.',
                            ),
                          ),
                        )
                      else if (templates.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'No shift templates available',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Create at least one shift template before building a rotating pattern.',
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        Text(
                          'Cycle assignments',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Assign each cycle day to either a reusable shift template or an off day marker.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        for (final draft in _draftEntries)
                          Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Day ${draft.dayOffset + 1}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  SegmentedButton<_PatternAssignmentKind>(
                                    segments: const [
                                      ButtonSegment(
                                        value: _PatternAssignmentKind.template,
                                        label: Text('Shift'),
                                        icon: Icon(Icons.schedule_outlined),
                                      ),
                                      ButtonSegment(
                                        value: _PatternAssignmentKind.offDay,
                                        label: Text('Off day'),
                                        icon: Icon(Icons.hotel_outlined),
                                      ),
                                    ],
                                    selected: <_PatternAssignmentKind>{
                                      draft.isOffDay
                                          ? _PatternAssignmentKind.offDay
                                          : _PatternAssignmentKind.template,
                                    },
                                    onSelectionChanged: (selection) {
                                      final kind = selection.first;
                                      setState(() {
                                        _draftEntries = [
                                          for (final item in _draftEntries)
                                            if (item.dayOffset ==
                                                draft.dayOffset)
                                              item.copyWith(
                                                isOffDay:
                                                    kind ==
                                                    _PatternAssignmentKind
                                                        .offDay,
                                                shiftTemplateId:
                                                    kind ==
                                                        _PatternAssignmentKind
                                                            .offDay
                                                    ? null
                                                    : (item.shiftTemplateId ??
                                                          templates.first.id),
                                              )
                                            else
                                              item,
                                        ];
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String?>(
                                    initialValue: draft.shiftTemplateId,
                                    decoration: const InputDecoration(
                                      labelText: 'Shift template',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: [
                                      for (final template in templates)
                                        DropdownMenuItem<String?>(
                                          value: template.id,
                                          child: Text(_templateLabel(template)),
                                        ),
                                    ],
                                    onChanged: draft.isOffDay
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _draftEntries = [
                                                for (final item
                                                    in _draftEntries)
                                                  if (item.dayOffset ==
                                                      draft.dayOffset)
                                                    item.copyWith(
                                                      shiftTemplateId: value,
                                                    )
                                                  else
                                                    item,
                                              ];
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: isBusy ? null : () => _save(templates),
                        icon: _isSaving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(_isSaving ? 'Saving...' : 'Save pattern'),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Failed to load active pattern: $error')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load templates: $error')),
        ),
      ),
    );
  }

  Future<void> _loadExistingEntries(String patternId) async {
    setState(() => _isLoadingInitialEntries = true);
    final result = await ref
        .read(shiftPatternEntryRepositoryProvider)
        .listEntriesForPattern(patternId);

    if (!mounted) {
      return;
    }

    result.when(
      success: (entries) {
        final mapped = [
          for (var index = 0; index < _draftEntries.length; index++)
            entries.cast<ShiftPatternEntry?>().firstWhere(
                      (entry) => entry?.dayOffset == index,
                      orElse: () => null,
                    ) ==
                    null
                ? _draftEntries[index]
                : _PatternDayDraft.fromEntry(
                    entries.firstWhere((entry) => entry.dayOffset == index),
                  ),
        ];

        setState(() {
          _draftEntries = mapped;
          _isLoadingInitialEntries = false;
        });
      },
      failure: (error) {
        setState(() => _isLoadingInitialEntries = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final initialDate = _startDate ?? DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _startDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _save(List<ShiftTemplate> templates) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choose a pattern start date before saving.'),
        ),
      );
      return;
    }

    if (templates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create a shift template before saving a pattern.'),
        ),
      );
      return;
    }

    final incompleteDay = _draftEntries
        .where((entry) => !entry.isComplete)
        .firstOrNull;
    if (incompleteDay != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complete the assignment for day ${incompleteDay.dayOffset + 1} before saving.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final patternId = widget.initialPattern?.id ?? AppId.generate();
    final pattern = ShiftPattern(
      id: patternId,
      jobId: widget.jobId,
      name: _nameController.text.trim(),
      cycleLengthDays: _draftEntries.length,
      startDate: DateTime(_startDate!.year, _startDate!.month, _startDate!.day),
      timezone: widget.initialPattern?.timezone ?? 'local',
      isActive: _isActive,
    );

    final entries = [
      for (final draft in _draftEntries) draft.toEntity(patternId: patternId),
    ];

    final patternResult = await ref
        .read(shiftPatternRepositoryProvider)
        .savePattern(pattern);
    if (!mounted) {
      return;
    }

    if (patternResult.isFailure) {
      setState(() => _isSaving = false);
      patternResult.when(
        success: (_) {},
        failure: (error) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message))),
      );
      return;
    }

    final entriesResult = await ref
        .read(shiftPatternEntryRepositoryProvider)
        .replaceEntries(patternId: patternId, entries: entries);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    entriesResult.when(
      success: (_) async {
        ref.invalidate(shiftPatternsForJobProvider(widget.jobId));
        ref.invalidate(activeShiftPatternForJobProvider(widget.jobId));
        ref.invalidate(calendarScheduleProvider);
        ref.invalidate(paySummaryProvider);
        ref.invalidate(jobsProvider);
        await ref
            .read(reminderNotificationServiceProvider)
            .syncAllReminderSchedules();
        if (!mounted) {
          return;
        }
        context.pop();
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  List<_PatternDayDraft> _buildDraftEntries(int cycleLength) {
    return List.generate(
      cycleLength,
      (index) => _PatternDayDraft(dayOffset: index),
      growable: false,
    );
  }

  List<_PatternDayDraft> _resizeDraftEntries(
    List<_PatternDayDraft> current,
    int cycleLength,
  ) {
    return List.generate(cycleLength, (index) {
      if (index < current.length) {
        return current[index];
      }
      return _PatternDayDraft(dayOffset: index);
    }, growable: false);
  }
}

enum _PatternAssignmentKind { template, offDay }

class _PatternDayDraft {
  const _PatternDayDraft({
    required this.dayOffset,
    this.shiftTemplateId,
    this.isOffDay = false,
  });

  final int dayOffset;
  final String? shiftTemplateId;
  final bool isOffDay;

  bool get isComplete => isOffDay || shiftTemplateId != null;

  _PatternDayDraft copyWith({String? shiftTemplateId, bool? isOffDay}) {
    return _PatternDayDraft(
      dayOffset: dayOffset,
      shiftTemplateId: shiftTemplateId,
      isOffDay: isOffDay ?? this.isOffDay,
    );
  }

  ShiftPatternEntry toEntity({required String patternId}) {
    return ShiftPatternEntry(
      id: AppId.generate(),
      patternId: patternId,
      dayOffset: dayOffset,
      shiftTemplateId: isOffDay ? null : shiftTemplateId,
      isOffDay: isOffDay,
    );
  }

  factory _PatternDayDraft.fromEntry(ShiftPatternEntry entry) {
    return _PatternDayDraft(
      dayOffset: entry.dayOffset,
      shiftTemplateId: entry.shiftTemplateId,
      isOffDay: entry.isOffDay,
    );
  }
}

String _templateLabel(ShiftTemplate template) {
  final startHour = (template.startMinutesLocal ~/ 60).toString().padLeft(
    2,
    '0',
  );
  final startMinute = (template.startMinutesLocal % 60).toString().padLeft(
    2,
    '0',
  );
  final endHour = (template.endMinutesLocal ~/ 60).toString().padLeft(2, '0');
  final endMinute = (template.endMinutesLocal % 60).toString().padLeft(2, '0');
  return '${template.name} • $startHour:$startMinute - $endHour:$endMinute';
}
