import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/database/app_database.dart';
import 'package:shiftmate_pay/data/repositories/drift_advanced_pay_rule_set_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_actual_payslip_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_job_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_shift_instance_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_shift_pattern_entry_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_shift_pattern_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_shift_template_repository.dart';
import 'package:shiftmate_pay/domain/entities/advanced_pay_rule_set.dart';
import 'package:shiftmate_pay/domain/entities/actual_payslip.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/entities/shift_pattern.dart';
import 'package:shiftmate_pay/domain/entities/shift_pattern_entry.dart';
import 'package:shiftmate_pay/domain/entities/shift_template.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('database CRUD flows', () {
    late AppDatabase database;
    late DriftJobRepository jobRepository;
    late DriftShiftTemplateRepository shiftTemplateRepository;
    late DriftShiftInstanceRepository shiftInstanceRepository;
    late DriftShiftPatternRepository shiftPatternRepository;
    late DriftShiftPatternEntryRepository shiftPatternEntryRepository;
    late DriftAdvancedPayRuleSetRepository advancedPayRuleSetRepository;
    late DriftActualPayslipRepository actualPayslipRepository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      jobRepository = DriftJobRepository(database);
      shiftTemplateRepository = DriftShiftTemplateRepository(database);
      shiftInstanceRepository = DriftShiftInstanceRepository(database);
      shiftPatternRepository = DriftShiftPatternRepository(database);
      shiftPatternEntryRepository = DriftShiftPatternEntryRepository(database);
      advancedPayRuleSetRepository = DriftAdvancedPayRuleSetRepository(
        database,
      );
      actualPayslipRepository = DriftActualPayslipRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('creates, reads, updates, and archives a job', () async {
      final createdAt = DateTime.utc(2026, 1, 1);
      final job = Job(
        id: AppId.generate(),
        name: 'Hospital Nights',
        colorHex: '#4F46E5',
        currencyCode: 'USD',
        hourlyRate: const CurrencyAmount(minorUnits: 3200, currencyCode: 'USD'),
        payRuleSetId: null,
        holidayRuleSetId: null,
        defaultSleepLeadMinutes: 480,
        isArchived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final saveResult = await jobRepository.saveJob(job);
      expect(saveResult.isSuccess, isTrue);

      final listResult = await jobRepository.listJobs();
      final jobs = listResult.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(jobs, hasLength(1));
      expect(jobs.single.name, 'Hospital Nights');

      final updatedJob = Job(
        id: job.id,
        name: 'Hospital Nights Updated',
        colorHex: job.colorHex,
        currencyCode: job.currencyCode,
        hourlyRate: job.hourlyRate,
        payRuleSetId: job.payRuleSetId,
        holidayRuleSetId: job.holidayRuleSetId,
        defaultSleepLeadMinutes: job.defaultSleepLeadMinutes,
        isArchived: false,
        createdAt: job.createdAt,
        updatedAt: DateTime.utc(2026, 1, 2),
      );

      final updateResult = await jobRepository.saveJob(updatedJob);
      expect(updateResult.isSuccess, isTrue);

      final loadedJob = await jobRepository.getJobById(job.id);
      final loaded = loadedJob.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(loaded?.name, 'Hospital Nights Updated');

      final archiveResult = await jobRepository.archiveJob(job.id);
      expect(archiveResult.isSuccess, isTrue);

      final archived = await jobRepository.getJobById(job.id);
      final archivedJob = archived.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(archivedJob?.isArchived, isTrue);
    });

    test('creates, reads, updates, and deletes a shift template', () async {
      final createdAt = DateTime.utc(2026, 1, 1);
      final job = Job(
        id: AppId.generate(),
        name: 'Factory Rotation',
        colorHex: '#0EA5E9',
        currencyCode: 'USD',
        hourlyRate: const CurrencyAmount(minorUnits: 2800, currencyCode: 'USD'),
        payRuleSetId: null,
        holidayRuleSetId: null,
        defaultSleepLeadMinutes: 600,
        isArchived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
      await jobRepository.saveJob(job);

      final template = ShiftTemplate(
        id: AppId.generate(),
        jobId: job.id,
        name: 'Night Shift',
        startMinutesLocal: 22 * 60,
        endMinutesLocal: 6 * 60,
        unpaidBreakMinutes: 30,
        category: ShiftCategory.night,
        defaultNote: 'Bring badge',
      );

      final saveResult = await shiftTemplateRepository.saveTemplate(template);
      expect(saveResult.isSuccess, isTrue);

      final listResult = await shiftTemplateRepository.listTemplatesForJob(
        job.id,
      );
      final templates = listResult.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(templates, hasLength(1));
      expect(templates.single.crossesMidnight, isTrue);

      final updatedTemplate = ShiftTemplate(
        id: template.id,
        jobId: template.jobId,
        name: 'Night Shift Updated',
        startMinutesLocal: template.startMinutesLocal,
        endMinutesLocal: template.endMinutesLocal,
        unpaidBreakMinutes: 45,
        category: template.category,
        defaultNote: template.defaultNote,
      );

      final updateResult = await shiftTemplateRepository.saveTemplate(
        updatedTemplate,
      );
      expect(updateResult.isSuccess, isTrue);

      final fetched = await shiftTemplateRepository.getTemplateById(
        template.id,
      );
      final loaded = fetched.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(loaded?.name, 'Night Shift Updated');
      expect(loaded?.unpaidBreakMinutes, 45);

      final deleteResult = await shiftTemplateRepository.deleteTemplate(
        template.id,
      );
      expect(deleteResult.isSuccess, isTrue);

      final afterDelete = await shiftTemplateRepository.listTemplatesForJob(
        job.id,
      );
      final emptyList = afterDelete.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(emptyList, isEmpty);
    });

    test(
      'lists template categories and preserves custom template notes',
      () async {
        final createdAt = DateTime.utc(2026, 1, 3);
        final job = Job(
          id: AppId.generate(),
          name: 'Ward Coverage',
          colorHex: '#16A34A',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 3000,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 480,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final templates = [
          ShiftTemplate(
            id: AppId.generate(),
            jobId: job.id,
            name: 'Alpha Day',
            startMinutesLocal: 7 * 60,
            endMinutesLocal: 15 * 60,
            unpaidBreakMinutes: 30,
            category: ShiftCategory.day,
            defaultNote: null,
          ),
          ShiftTemplate(
            id: AppId.generate(),
            jobId: job.id,
            name: 'Bravo Evening',
            startMinutesLocal: 15 * 60,
            endMinutesLocal: 23 * 60,
            unpaidBreakMinutes: 45,
            category: ShiftCategory.evening,
            defaultNote: 'Check handover notes',
          ),
          ShiftTemplate(
            id: AppId.generate(),
            jobId: job.id,
            name: 'Charlie Night',
            startMinutesLocal: 23 * 60,
            endMinutesLocal: 7 * 60,
            unpaidBreakMinutes: 30,
            category: ShiftCategory.night,
            defaultNote: null,
          ),
          ShiftTemplate(
            id: AppId.generate(),
            jobId: job.id,
            name: 'Delta Custom',
            startMinutesLocal: 10 * 60,
            endMinutesLocal: 18 * 60,
            unpaidBreakMinutes: 20,
            category: ShiftCategory.custom,
            defaultNote: 'Training day',
          ),
        ];

        for (final template in templates) {
          final saveResult = await shiftTemplateRepository.saveTemplate(
            template,
          );
          expect(saveResult.isSuccess, isTrue);
        }

        final listResult = await shiftTemplateRepository.listTemplatesForJob(
          job.id,
        );
        final loadedTemplates = listResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );

        expect(loadedTemplates.map((template) => template.name).toList(), [
          'Alpha Day',
          'Bravo Evening',
          'Charlie Night',
          'Delta Custom',
        ]);
        expect(loadedTemplates.map((template) => template.category).toSet(), {
          ShiftCategory.day,
          ShiftCategory.evening,
          ShiftCategory.night,
          ShiftCategory.custom,
        });
        expect(
          loadedTemplates
              .singleWhere(
                (template) => template.category == ShiftCategory.custom,
              )
              .defaultNote,
          'Training day',
        );
      },
    );

    test(
      'saves one active rotating pattern per job and deactivates prior patterns',
      () async {
        final createdAt = DateTime.utc(2026, 1, 4);
        final job = Job(
          id: AppId.generate(),
          name: 'Distribution Centre',
          colorHex: '#F97316',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 2600,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 540,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final primaryPattern = ShiftPattern(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Week A',
          cycleLengthDays: 7,
          startDate: DateTime.utc(2026, 1, 5),
          timezone: 'local',
          isActive: true,
        );
        final secondaryPattern = ShiftPattern(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Week B',
          cycleLengthDays: 14,
          startDate: DateTime.utc(2026, 1, 12),
          timezone: 'local',
          isActive: true,
        );

        final firstSave = await shiftPatternRepository.savePattern(
          primaryPattern,
        );
        expect(firstSave.isSuccess, isTrue);

        final secondSave = await shiftPatternRepository.savePattern(
          secondaryPattern,
        );
        expect(secondSave.isSuccess, isTrue);

        final activePatternResult = await shiftPatternRepository
            .getActivePatternForJob(job.id);
        final activePattern = activePatternResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(activePattern?.id, secondaryPattern.id);

        final listedPatternsResult = await shiftPatternRepository
            .listPatternsForJob(job.id);
        final listedPatterns = listedPatternsResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );

        expect(listedPatterns, hasLength(2));
        expect(
          listedPatterns.where((pattern) => pattern.isActive),
          hasLength(1),
        );
        expect(
          listedPatterns
              .singleWhere((pattern) => pattern.id == primaryPattern.id)
              .isActive,
          isFalse,
        );
      },
    );

    test(
      'replaces pattern entries and persists off-day markers with template assignments',
      () async {
        final createdAt = DateTime.utc(2026, 1, 6);
        final job = Job(
          id: AppId.generate(),
          name: 'Clinic Rotation',
          colorHex: '#8B5CF6',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 2900,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 480,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final template = ShiftTemplate(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Early',
          startMinutesLocal: 6 * 60,
          endMinutesLocal: 14 * 60,
          unpaidBreakMinutes: 30,
          category: ShiftCategory.day,
          defaultNote: null,
        );
        await shiftTemplateRepository.saveTemplate(template);

        final pattern = ShiftPattern(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Two day cycle',
          cycleLengthDays: 2,
          startDate: DateTime.utc(2026, 1, 7),
          timezone: 'local',
          isActive: true,
        );
        await shiftPatternRepository.savePattern(pattern);

        final initialEntries = [
          ShiftPatternEntry(
            id: AppId.generate(),
            patternId: pattern.id,
            dayOffset: 0,
            shiftTemplateId: template.id,
            isOffDay: false,
          ),
          ShiftPatternEntry(
            id: AppId.generate(),
            patternId: pattern.id,
            dayOffset: 1,
            shiftTemplateId: null,
            isOffDay: true,
          ),
        ];

        final initialReplace = await shiftPatternEntryRepository.replaceEntries(
          patternId: pattern.id,
          entries: initialEntries,
        );
        expect(initialReplace.isSuccess, isTrue);

        final loadedInitialEntries = await shiftPatternEntryRepository
            .listEntriesForPattern(pattern.id);
        final initialList = loadedInitialEntries.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(initialList, hasLength(2));
        expect(initialList.first.shiftTemplateId, template.id);
        expect(initialList.last.isOffDay, isTrue);

        final replacementEntries = [
          ShiftPatternEntry(
            id: AppId.generate(),
            patternId: pattern.id,
            dayOffset: 0,
            shiftTemplateId: null,
            isOffDay: true,
          ),
        ];

        final replacementResult = await shiftPatternEntryRepository
            .replaceEntries(patternId: pattern.id, entries: replacementEntries);
        expect(replacementResult.isSuccess, isTrue);

        final loadedReplacementEntries = await shiftPatternEntryRepository
            .listEntriesForPattern(pattern.id);
        final replacementList = loadedReplacementEntries.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(replacementList, hasLength(1));
        expect(replacementList.single.dayOffset, 0);
        expect(replacementList.single.isOffDay, isTrue);
        expect(replacementList.single.shiftTemplateId, isNull);
      },
    );

    test(
      'persists notes and holiday flags for manual overrides without corrupting range loads',
      () async {
        final createdAt = DateTime.utc(2026, 1, 8);
        final job = Job(
          id: AppId.generate(),
          name: 'Holiday Cover',
          colorHex: '#DC2626',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 3500,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 480,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final template = ShiftTemplate(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Bank Holiday Day',
          startMinutesLocal: 8 * 60,
          endMinutesLocal: 16 * 60,
          unpaidBreakMinutes: 30,
          category: ShiftCategory.day,
          defaultNote: 'Template baseline',
        );
        await shiftTemplateRepository.saveTemplate(template);

        final override = ShiftInstance(
          id: AppId.generate(),
          jobId: job.id,
          date: DateTime.utc(2026, 1, 9),
          templateSnapshot: ShiftTemplateSnapshot(
            templateId: template.id,
            name: template.name,
            category: template.category,
            startMinutesLocal: template.startMinutesLocal,
            endMinutesLocal: template.endMinutesLocal,
            unpaidBreakMinutes: 15,
            defaultNote: 'Bring ID and timesheet',
          ),
          startDateTime: DateTime.utc(2026, 1, 9, 8),
          endDateTime: DateTime.utc(2026, 1, 9, 14),
          unpaidBreakMinutes: 15,
          source: ShiftSource.manual,
          note: 'Bring ID and timesheet',
          isHoliday: true,
          overrideType: ShiftOverrideType.editGeneratedShift,
        );

        final saveResult = await shiftInstanceRepository.saveInstance(override);
        expect(saveResult.isSuccess, isTrue);

        final rangeResult = await shiftInstanceRepository.listInstancesForRange(
          jobId: job.id,
          range: AppDateRange(
            start: DateTime.utc(2026, 1, 9),
            end: DateTime.utc(2026, 1, 9),
          ),
        );
        final loadedInstances = rangeResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );

        expect(loadedInstances, hasLength(1));
        expect(loadedInstances.single.note, 'Bring ID and timesheet');
        expect(loadedInstances.single.isHoliday, isTrue);
        expect(
          loadedInstances.single.overrideType,
          ShiftOverrideType.editGeneratedShift,
        );
        expect(
          loadedInstances.single.templateSnapshot?.templateId,
          template.id,
        );

        final offDayOverride = ShiftInstance(
          id: AppId.generate(),
          jobId: job.id,
          date: DateTime.utc(2026, 1, 10),
          templateSnapshot: null,
          startDateTime: DateTime.utc(2026, 1, 10),
          endDateTime: DateTime.utc(2026, 1, 10),
          unpaidBreakMinutes: 0,
          source: ShiftSource.manual,
          note: 'Public holiday closed',
          isHoliday: true,
          overrideType: ShiftOverrideType.markOffDay,
        );

        final secondSaveResult = await shiftInstanceRepository.saveInstance(
          offDayOverride,
        );
        expect(secondSaveResult.isSuccess, isTrue);

        final secondRangeResult = await shiftInstanceRepository
            .listInstancesForRange(
              jobId: job.id,
              range: AppDateRange(
                start: DateTime.utc(2026, 1, 9),
                end: DateTime.utc(2026, 1, 10),
              ),
            );
        final combinedInstances = secondRangeResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );

        expect(combinedInstances, hasLength(2));
        expect(combinedInstances.last.note, 'Public holiday closed');
        expect(combinedInstances.last.isHoliday, isTrue);
        expect(
          combinedInstances.last.overrideType,
          ShiftOverrideType.markOffDay,
        );
      },
    );

    test(
      'saves and reloads advanced pay rules with ordered overtime tiers and conditional rules',
      () async {
        final createdAt = DateTime.utc(2026, 1, 11);
        final job = Job(
          id: AppId.generate(),
          name: 'Premium Verification Job',
          colorHex: '#2563EB',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 4100,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 540,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final template = ShiftTemplate(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Night Premium',
          startMinutesLocal: 22 * 60,
          endMinutesLocal: 6 * 60,
          unpaidBreakMinutes: 30,
          category: ShiftCategory.night,
          defaultNote: null,
        );
        await shiftTemplateRepository.saveTemplate(template);

        final ruleSet = AdvancedPayRuleSet(
          id: AppId.generate(),
          jobId: job.id,
          enabled: true,
          overtimeRules: const [
            OvertimeTierRule(
              id: 'weekly_ot',
              periodType: OvertimePeriodType.weekly,
              thresholdMinutes: 2400,
              multiplierBps: 17500,
              priority: 2,
              enabled: true,
            ),
            OvertimeTierRule(
              id: 'daily_ot',
              periodType: OvertimePeriodType.daily,
              thresholdMinutes: 480,
              multiplierBps: 15000,
              priority: 1,
              enabled: true,
            ),
          ],
          differentialRules: [
            DifferentialPayRule(
              id: AppId.generate(),
              type: DifferentialRuleType.night,
              combinationMode: DifferentialCombinationMode.additivePremium,
              enabled: true,
              multiplierBps: 12500,
              startMinutesLocal: 22 * 60,
              endMinutesLocal: 6 * 60,
              shiftTemplateId: template.id,
            ),
          ],
          allowanceRules: [
            AllowancePayRule(
              id: AppId.generate(),
              type: AllowanceRuleType.perShift,
              amountMinor: 1800,
              enabled: true,
              appliesOnHoliday: true,
              shiftTemplateId: template.id,
            ),
          ],
          breakRules: const [
            AdvancedBreakRule(
              id: 'night_break',
              minutes: 45,
              enabled: true,
              shiftCategory: ShiftCategory.night,
            ),
          ],
          version: 1,
          createdAt: createdAt,
          updatedAt: createdAt,
        );

        final saveResult = await advancedPayRuleSetRepository.save(ruleSet);
        expect(saveResult.isSuccess, isTrue);

        final loadResult = await advancedPayRuleSetRepository.getForJob(job.id);
        final loaded = loadResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );

        expect(loaded, isNotNull);
        expect(loaded!.enabled, isTrue);
        expect(loaded.overtimeRules, hasLength(2));
        expect(loaded.overtimeRules.first.priority, 1);
        expect(loaded.overtimeRules.first.periodType, OvertimePeriodType.daily);
        expect(loaded.overtimeRules.last.periodType, OvertimePeriodType.weekly);
        expect(loaded.differentialRules.single.shiftTemplateId, template.id);
        expect(loaded.allowanceRules.single.amountMinor, 1800);
        expect(loaded.breakRules.single.shiftCategory, ShiftCategory.night);
      },
    );

    test(
      'replaces advanced allowance and break rules on subsequent saves',
      () async {
        final createdAt = DateTime.utc(2026, 1, 12);
        final job = Job(
          id: AppId.generate(),
          name: 'Rule replacement job',
          colorHex: '#0F766E',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 2900,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 480,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final initialRuleSet = AdvancedPayRuleSet(
          id: AppId.generate(),
          jobId: job.id,
          enabled: true,
          overtimeRules: const [],
          differentialRules: const [],
          allowanceRules: const [
            AllowancePayRule(
              id: 'initial_allowance',
              type: AllowanceRuleType.perShift,
              amountMinor: 1200,
              enabled: true,
            ),
          ],
          breakRules: const [
            AdvancedBreakRule(
              id: 'initial_break',
              minutes: 30,
              enabled: true,
              shiftCategory: ShiftCategory.day,
            ),
          ],
          version: 1,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await advancedPayRuleSetRepository.save(initialRuleSet);

        final updatedRuleSet = initialRuleSet.copyWith(
          allowanceRules: const [
            AllowancePayRule(
              id: 'updated_allowance',
              type: AllowanceRuleType.perPeriod,
              amountMinor: 4500,
              enabled: true,
              appliesOnHoliday: true,
            ),
          ],
          breakRules: const [
            AdvancedBreakRule(
              id: 'updated_break',
              minutes: 45,
              enabled: true,
              shiftCategory: ShiftCategory.night,
            ),
          ],
          version: 2,
          updatedAt: createdAt.add(const Duration(hours: 4)),
        );

        final saveResult = await advancedPayRuleSetRepository.save(
          updatedRuleSet,
        );
        expect(saveResult.isSuccess, isTrue);

        final loadResult = await advancedPayRuleSetRepository.getForJob(job.id);
        final loaded = loadResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );

        expect(loaded, isNotNull);
        expect(loaded!.allowanceRules, hasLength(1));
        expect(loaded.allowanceRules.single.id, 'updated_allowance');
        expect(loaded.allowanceRules.single.type, AllowanceRuleType.perPeriod);
        expect(loaded.allowanceRules.single.amountMinor, 4500);
        expect(loaded.breakRules, hasLength(1));
        expect(loaded.breakRules.single.id, 'updated_break');
        expect(loaded.breakRules.single.minutes, 45);
        expect(loaded.breakRules.single.shiftCategory, ShiftCategory.night);
      },
    );

    test(
      'creates, edits, lists, loads by period, and deletes actual payslip records',
      () async {
        final createdAt = DateTime.utc(2026, 4, 4, 9);
        final job = Job(
          id: AppId.generate(),
          name: 'Verification Job',
          colorHex: '#1D4ED8',
          currencyCode: 'USD',
          hourlyRate: const CurrencyAmount(
            minorUnits: 3250,
            currencyCode: 'USD',
          ),
          payRuleSetId: null,
          holidayRuleSetId: null,
          defaultSleepLeadMinutes: 480,
          isArchived: false,
          createdAt: createdAt,
          updatedAt: createdAt,
        );
        await jobRepository.saveJob(job);

        final payslip = ActualPayslip(
          id: AppId.generate(),
          jobId: job.id,
          periodStart: DateTime.utc(2026, 3, 30),
          periodEnd: DateTime.utc(2026, 4, 5),
          paidAt: DateTime.utc(2026, 4, 8),
          grossPayMinor: 98500,
          workedMinutesReported: 2280,
          overtimePayMinor: 12500,
          holidayPayMinor: null,
          allowancesMinor: 1800,
          notes: 'Manual payslip entry',
          source: ActualPayslipSource.manual,
          createdAt: createdAt,
          updatedAt: createdAt,
        );

        final saveResult = await actualPayslipRepository.save(payslip);
        expect(saveResult.isSuccess, isTrue);

        final listResult = await actualPayslipRepository.listForJob(job.id);
        final listed = listResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(listed, hasLength(1));
        expect(listed.single.grossPayMinor, 98500);
        expect(listed.single.workedMinutesReported, 2280);
        expect(listed.single.allowancesMinor, 1800);

        final byPeriodResult = await actualPayslipRepository.getForJobAndPeriod(
          jobId: job.id,
          periodStart: DateTime.utc(2026, 3, 30),
          periodEnd: DateTime.utc(2026, 4, 5),
        );
        final byPeriod = byPeriodResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(byPeriod, isNotNull);
        expect(byPeriod!.id, payslip.id);

        final updatedPayslip = payslip.copyWith(
          grossPayMinor: 100250,
          holidayPayMinor: 2400,
          setHolidayPayMinor: true,
          notes: 'Updated after final payslip arrived',
          setNotes: true,
          updatedAt: createdAt.add(const Duration(hours: 2)),
        );

        final updateResult = await actualPayslipRepository.save(updatedPayslip);
        expect(updateResult.isSuccess, isTrue);

        final loadedResult = await actualPayslipRepository.getById(payslip.id);
        final loaded = loadedResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(loaded, isNotNull);
        expect(loaded!.grossPayMinor, 100250);
        expect(loaded.holidayPayMinor, 2400);
        expect(loaded.notes, 'Updated after final payslip arrived');

        final deleteResult = await actualPayslipRepository.delete(payslip.id);
        expect(deleteResult.isSuccess, isTrue);

        final afterDeleteResult = await actualPayslipRepository.getById(
          payslip.id,
        );
        final afterDelete = afterDeleteResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
        expect(afterDelete, isNull);
      },
    );
  });
}
