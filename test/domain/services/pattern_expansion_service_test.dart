import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/entities/shift_pattern.dart';
import 'package:shiftmate_pay/domain/entities/shift_pattern_entry.dart';
import 'package:shiftmate_pay/domain/entities/shift_template.dart';
import 'package:shiftmate_pay/domain/services/pattern_expansion_service.dart';

void main() {
  group('PatternExpansionService', () {
    const service = PatternExpansionService();
    const jobId = 'job-1';
    const patternId = 'pattern-1';
    const dayTemplateId = 'template-day';
    const nightTemplateId = 'template-night';

    final pattern = ShiftPattern(
      id: patternId,
      jobId: jobId,
      name: 'Four day rotation',
      cycleLengthDays: 4,
      startDate: DateTime(2026, 1, 1),
      timezone: 'local',
      isActive: true,
    );

    final dayTemplate = ShiftTemplate(
      id: dayTemplateId,
      jobId: jobId,
      name: 'Day',
      startMinutesLocal: 8 * 60,
      endMinutesLocal: 16 * 60,
      unpaidBreakMinutes: 30,
      category: ShiftCategory.day,
      defaultNote: 'Base day shift',
    );

    final nightTemplate = ShiftTemplate(
      id: nightTemplateId,
      jobId: jobId,
      name: 'Night',
      startMinutesLocal: 22 * 60,
      endMinutesLocal: 6 * 60,
      unpaidBreakMinutes: 45,
      category: ShiftCategory.night,
      defaultNote: null,
    );

    final entries = [
      const ShiftPatternEntry(
        id: 'entry-0',
        patternId: patternId,
        dayOffset: 0,
        shiftTemplateId: dayTemplateId,
        isOffDay: false,
      ),
      const ShiftPatternEntry(
        id: 'entry-1',
        patternId: patternId,
        dayOffset: 1,
        shiftTemplateId: nightTemplateId,
        isOffDay: false,
      ),
      const ShiftPatternEntry(
        id: 'entry-2',
        patternId: patternId,
        dayOffset: 2,
        shiftTemplateId: null,
        isOffDay: true,
      ),
      const ShiftPatternEntry(
        id: 'entry-3',
        patternId: patternId,
        dayOffset: 3,
        shiftTemplateId: dayTemplateId,
        isOffDay: false,
      ),
    ];

    test('expands visible date ranges deterministically and skips off-days', () {
      final range = AppDateRange(
        start: DateTime(2026, 1, 2),
        end: DateTime(2026, 1, 7),
      );

      final first = service.expand(
        pattern: pattern,
        entries: entries,
        templates: [dayTemplate, nightTemplate],
        overrides: const [],
        range: range,
      );

      final second = service.expand(
        pattern: pattern,
        entries: entries,
        templates: [dayTemplate, nightTemplate],
        overrides: const [],
        range: range,
      );

      expect(first.map((instance) => instance.id).toList(), [
        'generated:pattern-1:2026-01-02',
        'generated:pattern-1:2026-01-04',
        'generated:pattern-1:2026-01-05',
        'generated:pattern-1:2026-01-06',
      ]);
      expect(first.map((instance) => instance.date.day).toList(), [2, 4, 5, 6]);
      expect(first.map((instance) => instance.startDateTime.day).toList(), [2, 4, 5, 6]);
      expect(first.map((instance) => instance.id).toList(), second.map((instance) => instance.id).toList());
      expect(first.map((instance) => instance.startDateTime).toList(), second.map((instance) => instance.startDateTime).toList());
    });

    test('rolls overnight shifts into the next day', () {
      final range = AppDateRange(
        start: DateTime(2026, 1, 2),
        end: DateTime(2026, 1, 2),
      );

      final instances = service.expand(
        pattern: pattern,
        entries: entries,
        templates: [dayTemplate, nightTemplate],
        overrides: const [],
        range: range,
      );

      expect(instances, hasLength(1));
      final overnight = instances.single;
      expect(overnight.templateSnapshot?.templateId, nightTemplateId);
      expect(overnight.startDateTime, DateTime(2026, 1, 2, 22));
      expect(overnight.endDateTime, DateTime(2026, 1, 3, 6));
      expect(overnight.endDateTime.day, overnight.startDateTime.day + 1);
    });

    test('expands cleanly across month boundaries and leap days', () {
      final leapPattern = ShiftPattern(
        id: 'pattern-leap',
        jobId: jobId,
        name: 'Leap rotation',
        cycleLengthDays: 2,
        startDate: DateTime(2024, 2, 28),
        timezone: 'local',
        isActive: true,
      );

      final leapEntries = [
        const ShiftPatternEntry(
          id: 'leap-entry-0',
          patternId: 'pattern-leap',
          dayOffset: 0,
          shiftTemplateId: dayTemplateId,
          isOffDay: false,
        ),
        const ShiftPatternEntry(
          id: 'leap-entry-1',
          patternId: 'pattern-leap',
          dayOffset: 1,
          shiftTemplateId: nightTemplateId,
          isOffDay: false,
        ),
      ];

      final instances = service.expand(
        pattern: leapPattern,
        entries: leapEntries,
        templates: [dayTemplate, nightTemplate],
        overrides: const [],
        range: AppDateRange(
          start: DateTime(2024, 2, 28),
          end: DateTime(2024, 3, 2),
        ),
      );

      expect(instances.map((instance) => instance.date), [
        DateTime(2024, 2, 28),
        DateTime(2024, 2, 29),
        DateTime(2024, 3, 1),
        DateTime(2024, 3, 2),
      ]);
      expect(instances[1].startDateTime, DateTime(2024, 2, 29, 22));
      expect(instances[1].endDateTime, DateTime(2024, 3, 1, 6));
      expect(instances.last.id, 'generated:pattern-leap:2024-03-02');
    });

    test('gives manual overrides precedence over generated entries', () {
      final range = AppDateRange(
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 4),
      );

      final manualReplacement = ShiftInstance(
        id: AppId.generate(),
        jobId: jobId,
        date: DateTime(2026, 1, 1),
        templateSnapshot: const ShiftTemplateSnapshot(
          templateId: null,
          name: 'Training',
          category: ShiftCategory.custom,
          startMinutesLocal: 9 * 60,
          endMinutesLocal: 12 * 60,
          unpaidBreakMinutes: 0,
          defaultNote: 'Manual replacement',
        ),
        startDateTime: DateTime(2026, 1, 1, 9),
        endDateTime: DateTime(2026, 1, 1, 12),
        unpaidBreakMinutes: 0,
        source: ShiftSource.manual,
        note: 'Manual replacement',
        isHoliday: false,
        overrideType: ShiftOverrideType.replaceWithManualShift,
      );

      final offDayOverride = ShiftInstance(
        id: AppId.generate(),
        jobId: jobId,
        date: DateTime(2026, 1, 4),
        templateSnapshot: null,
        startDateTime: DateTime(2026, 1, 4),
        endDateTime: DateTime(2026, 1, 4),
        unpaidBreakMinutes: 0,
        source: ShiftSource.manual,
        note: 'Rest day',
        isHoliday: false,
        overrideType: ShiftOverrideType.markOffDay,
      );

      final instances = service.expand(
        pattern: pattern,
        entries: entries,
        templates: [dayTemplate, nightTemplate],
        overrides: [manualReplacement, offDayOverride],
        range: range,
      );

      expect(instances.map((instance) => instance.date.day).toList(), [1, 2]);
      expect(instances.first.id, manualReplacement.id);
      expect(instances.first.source, ShiftSource.manual);
      expect(instances.every((instance) => instance.date.day != 4), isTrue);
    });
  });
}
