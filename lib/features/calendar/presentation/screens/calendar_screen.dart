import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/feature_gate.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../core/time/app_date_range.dart';
import '../../../../core/time/date_range_extensions.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/entities/planning_alert.dart';
import '../../../../domain/entities/shift_instance.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../pay/application/pay_providers.dart';
import '../../../planning/application/planning_providers.dart';
import '../../application/calendar_providers.dart';
import 'shift_detail_screen.dart';

enum CalendarPresentationMode { week, month }

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarPresentationMode _mode = CalendarPresentationMode.month;
  DateTime _focusedDate = DateTime.now().startOfDay;
  DateTime _selectedDate = DateTime.now().startOfDay;
  String? _selectedJobId;

  AppDateRange get _visibleRange {
    return switch (_mode) {
      CalendarPresentationMode.week => _focusedDate.weekRange(),
      CalendarPresentationMode.month => _buildMonthGridRange(_focusedDate),
    };
  }

  void _goToPreviousRange() {
    setState(() {
      _focusedDate = switch (_mode) {
        CalendarPresentationMode.week => _focusedDate.subtract(
          const Duration(days: 7),
        ),
        CalendarPresentationMode.month => DateTime(
          _focusedDate.year,
          _focusedDate.month - 1,
          1,
        ),
      };
      _selectedDate = _clampSelectionToVisibleRange(
        _selectedDate,
        _visibleRange,
      );
    });
    _syncPaySelection();
  }

  void _goToNextRange() {
    setState(() {
      _focusedDate = switch (_mode) {
        CalendarPresentationMode.week => _focusedDate.add(
          const Duration(days: 7),
        ),
        CalendarPresentationMode.month => DateTime(
          _focusedDate.year,
          _focusedDate.month + 1,
          1,
        ),
      };
      _selectedDate = _clampSelectionToVisibleRange(
        _selectedDate,
        _visibleRange,
      );
    });
    _syncPaySelection();
  }

  void _jumpToToday() {
    final today = DateTime.now().startOfDay;
    setState(() {
      _focusedDate = today;
      _selectedDate = today;
    });
    _syncPaySelection();
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            tooltip: 'Jump to today',
            onPressed: _jumpToToday,
            icon: const Icon(Icons.today_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) => _buildLoadedState(context, jobs),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _CalendarMessageState(
            icon: Icons.error_outline,
            title: 'Unable to load jobs',
            description: error.toString(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, List<Job> jobs) {
    if (jobs.isEmpty) {
      return _CalendarMessageState(
        icon: Icons.work_outline,
        title: 'Create your first job',
        description:
            'Your weekly and monthly schedule will appear here after you add a job and finish setup.',
        actionLabel: 'Create first job',
        onActionPressed: () => context.go(AppRoutes.onboarding),
      );
    }

    final selectedJob = _resolveSelectedJob(jobs);
    _ensurePaySelectionMatchesCalendar(selectedJob.id);
    final visibleRange = _visibleRange;
    final scheduleAsync = ref.watch(
      calendarScheduleProvider(
        CalendarScheduleQuery(jobId: selectedJob.id, range: visibleRange),
      ),
    );
    final planningAlertsAsync = ref.watch(
      planningAlertsProvider(
        PlanningAlertsQuery(jobId: selectedJob.id, range: visibleRange),
      ),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
          calendarScheduleProvider(
            CalendarScheduleQuery(jobId: selectedJob.id, range: visibleRange),
          ),
        );
        await ref.read(
          calendarScheduleProvider(
            CalendarScheduleQuery(jobId: selectedJob.id, range: visibleRange),
          ).future,
        );
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _CalendarHero(
            title: selectedJob.name,
            subtitle: _rangeLabel(visibleRange),
            color: _parseHexColor(selectedJob.colorHex),
            mode: _mode,
            selectedJobId: selectedJob.id,
            jobs: jobs,
            onModeChanged: (mode) {
              setState(() => _mode = mode);
              _syncPaySelection();
            },
            onJobChanged: (jobId) {
              setState(() => _selectedJobId = jobId);
              _syncPaySelection(jobIdOverride: jobId);
            },
            onCalendarExportPressed: () => context.push(AppRoutes.export),
            onPreviousPressed: _goToPreviousRange,
            onNextPressed: _goToNextRange,
          ),
          const SizedBox(height: 16),
          scheduleAsync.when(
            data: (schedule) {
              final instancesByDay = _groupInstancesByDay(schedule);
              final selectedInstances =
                  instancesByDay[_selectedDate] ?? const <ShiftInstance>[];
              final days = _visibleDaysForMode(_mode, _focusedDate);
              return planningAlertsAsync.when(
                data: (alerts) {
                  final alertsByDay = _groupAlertsByDay(alerts);
                  final selectedAlerts =
                      alertsByDay[_selectedDate] ?? const <PlanningAlert>[];
                  return Column(
                    children: [
                      _CalendarSummaryRow(
                        schedule: schedule,
                        range: visibleRange,
                        jobColor: _parseHexColor(selectedJob.colorHex),
                      ),
                      const SizedBox(height: 16),
                      if (_mode == CalendarPresentationMode.week)
                        _WeekCalendarView(
                          days: days,
                          selectedDate: _selectedDate,
                          instancesByDay: instancesByDay,
                          alertsByDay: alertsByDay,
                          jobColor: _parseHexColor(selectedJob.colorHex),
                          onDateSelected: _handleDateSelected,
                          onDateDetailsRequested: _showShiftDetails,
                        )
                      else
                        _MonthCalendarView(
                          focusedDate: _focusedDate,
                          days: days,
                          selectedDate: _selectedDate,
                          instancesByDay: instancesByDay,
                          alertsByDay: alertsByDay,
                          jobColor: _parseHexColor(selectedJob.colorHex),
                          onDateSelected: _handleDateSelected,
                          onDateDetailsRequested: _showShiftDetails,
                        ),
                      const SizedBox(height: 16),
                      _SelectedDateDetailsCard(
                        date: _selectedDate,
                        jobColor: _parseHexColor(selectedJob.colorHex),
                        instances: selectedInstances,
                        alerts: selectedAlerts,
                        onViewDetails: () =>
                            _showShiftDetails(_selectedDate, selectedInstances),
                      ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => _CalendarMessageState(
                  icon: Icons.error_outline,
                  title: 'Unable to load planning alerts',
                  description: error.toString(),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => _CalendarMessageState(
              icon: Icons.event_busy_outlined,
              title: 'Unable to build schedule',
              description: error.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Job _resolveSelectedJob(List<Job> jobs) {
    final selected = jobs.where((job) => job.id == _selectedJobId).firstOrNull;
    final resolved = selected ?? jobs.first;

    if (_selectedJobId != resolved.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() => _selectedJobId = resolved.id);
      });
    }

    return resolved;
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date.startOfDay;
      _focusedDate = _mode == CalendarPresentationMode.week
          ? date.startOfDay
          : DateTime(date.year, date.month, 1);
    });
    _syncPaySelection();
  }

  Future<void> _showShiftDetails(
    DateTime date,
    List<ShiftInstance> instances,
  ) async {
    final selectedJobId = _selectedJobId;
    if (selectedJobId == null) {
      return;
    }

    final didChange = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ShiftDetailScreen(
          jobId: selectedJobId,
          date: date,
          initialInstance: instances.firstOrNull,
        ),
      ),
    );

    if (!mounted || didChange != true) {
      return;
    }

    final query = CalendarScheduleQuery(
      jobId: selectedJobId,
      range: _visibleRange,
    );
    ref.invalidate(calendarScheduleProvider(query));
    ref.invalidate(paySummaryProvider);
    await ref.read(calendarScheduleProvider(query).future);
  }

  void _ensurePaySelectionMatchesCalendar(String jobId) {
    final preset = _mode == CalendarPresentationMode.week
        ? DateRangePreset.week
        : DateRangePreset.month;
    final currentJobId = ref.read(paySelectedJobIdProvider);
    final currentDate = ref.read(paySelectedAnchorDateProvider).startOfDay;
    final currentPreset = ref.read(paySelectedPresetProvider);

    if (currentJobId != jobId ||
        currentDate != _selectedDate.startOfDay ||
        currentPreset != preset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _syncPaySelection(jobIdOverride: jobId);
      });
    }
  }

  void _syncPaySelection({String? jobIdOverride}) {
    ref.read(paySelectedJobIdProvider.notifier).state =
        jobIdOverride ?? _selectedJobId;
    ref.read(paySelectedAnchorDateProvider.notifier).state =
        _selectedDate.startOfDay;
    ref
        .read(paySelectedPresetProvider.notifier)
        .state = _mode == CalendarPresentationMode.week
        ? DateRangePreset.week
        : DateRangePreset.month;
  }
}

class _CalendarHero extends StatelessWidget {
  const _CalendarHero({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.mode,
    required this.selectedJobId,
    required this.jobs,
    required this.onModeChanged,
    required this.onJobChanged,
    required this.onCalendarExportPressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  final String title;
  final String subtitle;
  final Color color;
  final CalendarPresentationMode mode;
  final String selectedJobId;
  final List<Job> jobs;
  final ValueChanged<CalendarPresentationMode> onModeChanged;
  final ValueChanged<String> onJobChanged;
  final VoidCallback onCalendarExportPressed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, // Using existing 'title' property
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                    ),
                    Text(
                      subtitle, // Using existing 'subtitle' property
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: compact ? constraints.maxWidth : 220,
                    child: DropdownMenu<String>(
                      initialSelection: selectedJobId,
                      width: compact ? constraints.maxWidth : 220,
                      leadingIcon: const Icon(Icons.work_outline),
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.light
                            ? AppColors.surfaceLow
                            : AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      menuStyle: MenuStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).brightness == Brightness.light
                              ? AppColors.surfaceHigh
                              : AppColors.surfaceDark,
                        ),
                      ),
                      dropdownMenuEntries: jobs
                          .map(
                            (job) => DropdownMenuEntry<String>(
                              value: job.id,
                              label: job.name,
                            ),
                          )
                          .toList(growable: false),
                      onSelected: (value) {
                        if (value != null) {
                          onJobChanged(value);
                        }
                      },
                    ),
                  ),
                  SegmentedButton<CalendarPresentationMode>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context).brightness ==
                                  Brightness.light
                              ? AppColors.surfaceHigh
                              : AppColors.surfaceDark;
                        }
                        return Theme.of(context).brightness == Brightness.light
                            ? AppColors.surfaceLow
                            : AppColors.surfaceDark;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return Theme.of(context).hintColor;
                      }),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: CalendarPresentationMode.week,
                        label: Text('Week'),
                        icon: Icon(Icons.view_week_outlined),
                      ),
                      ButtonSegment(
                        value: CalendarPresentationMode.month,
                        label: Text('Month'),
                        icon: Icon(Icons.grid_view_rounded),
                      ),
                    ],
                    selected: {mode},
                    onSelectionChanged: (selection) =>
                        onModeChanged(selection.first),
                  ),
                  SizedBox(
                    width: compact ? constraints.maxWidth : null,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FeatureGate(
                          feature: AppFeature.export,
                          lockedLabel:
                              'Calendar sync export is reserved for Premium',
                          entryPoint: 'calendar_sync_action',
                          child: OutlinedButton.icon(
                            onPressed: onCalendarExportPressed,
                            icon: const Icon(Icons.sync_outlined),
                            label: const Text('Sync calendar'),
                          ),
                        ),
                        _HeroActionButton(
                          icon: Icons.chevron_left,
                          onPressed: onPreviousPressed,
                        ),
                        _HeroActionButton(
                          icon: Icons.chevron_right,
                          onPressed: onNextPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.light
          ? AppColors.surfaceLow
          : AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 20),
        ),
      ),
    );
  }
}

class _CalendarSummaryRow extends StatelessWidget {
  const _CalendarSummaryRow({
    required this.schedule,
    required this.range,
    required this.jobColor,
  });

  final List<ShiftInstance> schedule;
  final AppDateRange range;
  final Color jobColor;

  @override
  Widget build(BuildContext context) {
    final workingDays = schedule
        .where((instance) => !_isOffDay(instance))
        .length;
    final offDays = schedule.where(_isOffDay).length;
    final holidayDays = schedule.where((instance) => instance.isHoliday).length;

    return Row(
      children: [
        Expanded(
          child: _SummaryChip(
            label: 'Scheduled',
            value: '$workingDays shifts',
            accent: jobColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryChip(
            label: 'Off days',
            value: '$offDays days',
            accent: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryChip(
            label: 'Holidays',
            value: '$holidayDays flagged',
            accent: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final IconData icon = _getIconForLabel(label); // Resolve icon here

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    if (label.contains('Scheduled')) return Icons.calendar_today_rounded;
    if (label.contains('Off')) return Icons.bed_rounded;
    return Icons.celebration_rounded;
  }
}

class _WeekCalendarView extends StatelessWidget {
  const _WeekCalendarView({
    required this.days,
    required this.selectedDate,
    required this.instancesByDay,
    required this.alertsByDay,
    required this.jobColor,
    required this.onDateSelected,
    required this.onDateDetailsRequested,
  });

  final List<DateTime> days;
  final DateTime selectedDate;
  final Map<DateTime, List<ShiftInstance>> instancesByDay;
  final Map<DateTime, List<PlanningAlert>> alertsByDay;
  final Color jobColor;
  final ValueChanged<DateTime> onDateSelected;
  final Future<void> Function(DateTime date, List<ShiftInstance> instances)
  onDateDetailsRequested;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WeekdayHeader(days: days),
        const SizedBox(height: 12),
        ...days.map((day) {
          final instances = instancesByDay[day] ?? const <ShiftInstance>[];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () => onDateSelected(day),
              child: Row(
                children: [
                  _DayNumberBadge(
                    date: day,
                    selected: _isSameDay(day, selectedDate),
                    color: jobColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DayAgendaPreview(
                      date: day,
                      instances: instances,
                      alerts: alertsByDay[day] ?? const <PlanningAlert>[],
                      color: jobColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onDateDetailsRequested(day, instances),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _MonthCalendarView extends StatelessWidget {
  const _MonthCalendarView({
    required this.focusedDate,
    required this.days,
    required this.selectedDate,
    required this.instancesByDay,
    required this.alertsByDay,
    required this.jobColor,
    required this.onDateSelected,
    required this.onDateDetailsRequested,
  });

  final DateTime focusedDate;
  final List<DateTime> days;
  final DateTime selectedDate;
  final Map<DateTime, List<ShiftInstance>> instancesByDay;
  final Map<DateTime, List<PlanningAlert>> alertsByDay;
  final Color jobColor;
  final ValueChanged<DateTime> onDateSelected;
  final Future<void> Function(DateTime date, List<ShiftInstance> instances)
  onDateDetailsRequested;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double cellHeight = 72.0;

        return Column(
          children: [
            _WeekdayHeader(days: days.take(7).toList(growable: false)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: cellHeight,
              ),
              itemBuilder: (context, index) {
                final day =
                    days[index]; // Renamed from 'date' to 'day' to match original context
                final instances =
                    instancesByDay[day] ??
                    const <ShiftInstance>[]; // Using existing instancesByDay
                final isCurrentMonth =
                    day.month ==
                    focusedDate.month; // Using existing focusedDate
                final isToday = _isSameDay(
                  day,
                  DateTime.now(),
                ); // Added isToday check

                return _MonthDayCell(
                  date: day,
                  isCurrentMonth: isCurrentMonth,
                  isSelected: _isSameDay(day, selectedDate),
                  isToday: isToday, // Pass isToday
                  instances: instances, // Pass instances
                  alerts: alertsByDay[day] ?? const <PlanningAlert>[],
                  jobColor: jobColor, // Pass jobColor
                  onTap: () => onDateSelected(day),
                  onLongPress: () => onDateDetailsRequested(day, instances),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.days});

  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days
          .take(7)
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  DateFormat(
                    'EEEEE',
                  ).format(day), // Use single letter for header
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday, // Added isToday
    required this.instances, // Added instances
    required this.alerts,
    required this.jobColor, // Added jobColor
    required this.onTap,
    required this.onLongPress,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday; // New property
  final List<ShiftInstance> instances; // New property
  final List<PlanningAlert> alerts;
  final Color jobColor; // New property
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final hasShift = instances.isNotEmpty;
    final isOff = instances.any(
      (i) => i.overrideType == ShiftOverrideType.markOffDay,
    );
    final hasAlerts = alerts.isNotEmpty;
    final alertColor = _alertColorForSeverity(
      alerts.isEmpty ? null : alerts.first.severity,
    );

    final Color onSurfaceColor = isSelected
        ? Colors.white
        : isCurrentMonth
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.day}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: onSurfaceColor,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (hasShift)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasAlerts)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : alertColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : isOff
                              ? AppColors.warning
                              : jobColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                )
              else if (hasAlerts)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : alertColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedDateDetailsCard extends StatelessWidget {
  const _SelectedDateDetailsCard({
    required this.date,
    required this.jobColor,
    required this.instances,
    required this.alerts,
    required this.onViewDetails,
  });

  final DateTime date;
  final Color jobColor;
  final List<ShiftInstance> instances;
  final List<PlanningAlert> alerts;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected day',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, d MMMM').format(date),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.edit_calendar_outlined),
                label: const Text('Edit day'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (instances.isEmpty)
            Text(
              'No shift is scheduled for this day yet. Use Edit day to add a one-off shift or mark the day as off.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: instances
                  .map(
                    (instance) =>
                        _ShiftPill(instance: instance, color: jobColor),
                  )
                  .toList(growable: false),
            ),
          if (alerts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _alertColorForSeverity(
                  alerts.first.severity,
                ).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planning summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  ...alerts
                      .take(2)
                      .map(
                        (alert) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('• ${alert.title}'),
                        ),
                      ),
                  if (alerts.length > 2)
                    Text('+ ${alerts.length - 2} more alert(s) on this day'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayAgendaPreview extends StatelessWidget {
  const _DayAgendaPreview({
    required this.date,
    required this.instances,
    required this.alerts,
    required this.color,
  });

  final DateTime date;
  final List<ShiftInstance> instances;
  final List<PlanningAlert> alerts;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('EEEE, d MMM').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        if (instances.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No shift planned',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (alerts.isNotEmpty) ...[
                const SizedBox(height: 4),
                _PlanningAlertCaption(alerts: alerts),
              ],
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: instances
                    .map(
                      (instance) =>
                          _ShiftPill(instance: instance, color: color),
                    )
                    .toList(growable: false),
              ),
              if (alerts.isNotEmpty) ...[
                const SizedBox(height: 6),
                _PlanningAlertCaption(alerts: alerts),
              ],
            ],
          ),
      ],
    );
  }
}

class _PlanningAlertCaption extends StatelessWidget {
  const _PlanningAlertCaption({required this.alerts});

  final List<PlanningAlert> alerts;

  @override
  Widget build(BuildContext context) {
    final first = alerts.first;
    final color = _alertColorForSeverity(first.severity);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(
            alerts.length == 1
                ? first.title
                : '${alerts.length} planning alerts',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ShiftPill extends StatelessWidget {
  const _ShiftPill({required this.instance, required this.color});

  final ShiftInstance instance;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isOff = _isOffDay(instance);
    final baseColor = isOff ? AppColors.warning : color;
    final label = isOff
        ? 'Off day'
        : (instance.templateSnapshot?.name ?? 'Manual shift');
    final holidayColor = AppColors.success;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$label · ${_timeRangeLabel(instance)}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: baseColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (instance.isHoliday ||
                    (instance.note?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (instance.isHoliday)
                        _ShiftMetaBadge(
                          icon: Icons.celebration_rounded,
                          label: 'Holiday',
                          color: holidayColor,
                        ),
                      if (instance.note?.trim().isNotEmpty ?? false)
                        _ShiftMetaBadge(
                          icon: Icons.note_outlined,
                          label: instance.note!.trim(),
                          color: baseColor,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftMetaBadge extends StatelessWidget {
  const _ShiftMetaBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayNumberBadge extends StatelessWidget {
  const _DayNumberBadge({
    required this.date,
    required this.selected,
    required this.color,
  });

  final DateTime date;
  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: selected ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(date).substring(0, 1),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? Colors.white : color,
            ),
          ),
          Text(
            '${date.day}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: selected ? Colors.white : color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarMessageState extends StatelessWidget {
  const _CalendarMessageState({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (actionLabel != null && onActionPressed != null) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onActionPressed,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Map<DateTime, List<ShiftInstance>> _groupInstancesByDay(
  List<ShiftInstance> instances,
) {
  final grouped = <DateTime, List<ShiftInstance>>{};

  for (final instance in instances) {
    final key = instance.date.startOfDay;
    grouped.putIfAbsent(key, () => <ShiftInstance>[]).add(instance);
  }

  return grouped;
}

Map<DateTime, List<PlanningAlert>> _groupAlertsByDay(
  List<PlanningAlert> alerts,
) {
  final grouped = <DateTime, List<PlanningAlert>>{};
  for (final alert in alerts) {
    final key = alert.date.startOfDay;
    grouped.putIfAbsent(key, () => <PlanningAlert>[]).add(alert);
  }
  for (final entry in grouped.entries) {
    entry.value.sort((left, right) {
      final severityCompare = right.severity.index.compareTo(
        left.severity.index,
      );
      if (severityCompare != 0) {
        return severityCompare;
      }
      return left.title.compareTo(right.title);
    });
  }
  return grouped;
}

List<DateTime> _visibleDaysForMode(
  CalendarPresentationMode mode,
  DateTime focusedDate,
) {
  return switch (mode) {
    CalendarPresentationMode.week => List<DateTime>.generate(
      7,
      (index) => focusedDate.weekRange().start.add(Duration(days: index)),
    ),
    CalendarPresentationMode.month => List<DateTime>.generate(
      _buildMonthGridRange(focusedDate).daySpan,
      (index) =>
          _buildMonthGridRange(focusedDate).start.add(Duration(days: index)),
    ),
  };
}

AppDateRange _buildMonthGridRange(DateTime date) {
  final monthRange = date.monthRange();
  final start = monthRange.start.weekRange().start;
  final end = monthRange.end.weekRange().end;
  return AppDateRange(start: start, end: end);
}

DateTime _clampSelectionToVisibleRange(
  DateTime selectedDate,
  AppDateRange range,
) {
  if (range.contains(selectedDate)) {
    return selectedDate;
  }

  return range.start;
}

String _rangeLabel(AppDateRange range) {
  final sameMonth =
      range.start.month == range.end.month &&
      range.start.year == range.end.year;
  final sameYear = range.start.year == range.end.year;

  if (sameMonth) {
    return '${DateFormat('d').format(range.start)}–${DateFormat('d MMMM yyyy').format(range.end)}';
  }

  if (sameYear) {
    return '${DateFormat('d MMM').format(range.start)} – ${DateFormat('d MMM yyyy').format(range.end)}';
  }

  return '${DateFormat('d MMM yyyy').format(range.start)} – ${DateFormat('d MMM yyyy').format(range.end)}';
}

String _timeRangeLabel(ShiftInstance instance) {
  final format = DateFormat('h:mm a');
  if (_isOffDay(instance)) {
    return 'Marked off';
  }

  return '${format.format(instance.startDateTime)} – ${format.format(instance.endDateTime)}';
}

bool _isOffDay(ShiftInstance instance) {
  return instance.overrideType == ShiftOverrideType.markOffDay;
}

bool _isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

Color _parseHexColor(String hex) {
  final sanitized = hex.replaceFirst('#', '');
  final value = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
  return Color(int.parse(value, radix: 16));
}

Color _alertColorForSeverity(PlanningAlertSeverity? severity) {
  switch (severity) {
    case PlanningAlertSeverity.risk:
      return Colors.redAccent;
    case PlanningAlertSeverity.attention:
      return AppColors.warning;
    case PlanningAlertSeverity.info:
      return AppColors.primary;
    case null:
      return AppColors.warning;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
