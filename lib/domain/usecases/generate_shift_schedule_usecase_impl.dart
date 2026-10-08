import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/pattern_expansion_service.dart';
import 'usecases.dart';

class GenerateShiftScheduleUseCaseImpl implements GenerateShiftScheduleUseCase {
  GenerateShiftScheduleUseCaseImpl({
    required ShiftPatternRepository shiftPatternRepository,
    required ShiftPatternEntryRepository shiftPatternEntryRepository,
    required ShiftTemplateRepository shiftTemplateRepository,
    required ShiftInstanceRepository shiftInstanceRepository,
    required PatternExpansionService patternExpansionService,
  }) : _shiftPatternRepository = shiftPatternRepository,
       _shiftPatternEntryRepository = shiftPatternEntryRepository,
       _shiftTemplateRepository = shiftTemplateRepository,
       _shiftInstanceRepository = shiftInstanceRepository,
       _patternExpansionService = patternExpansionService;

  final ShiftPatternRepository _shiftPatternRepository;
  final ShiftPatternEntryRepository _shiftPatternEntryRepository;
  final ShiftTemplateRepository _shiftTemplateRepository;
  final ShiftInstanceRepository _shiftInstanceRepository;
  final PatternExpansionService _patternExpansionService;

  @override
  Future<Result<List<ShiftInstance>>> call({
    required EntityId jobId,
    required AppDateRange range,
  }) async {
    final activePatternResult = await _shiftPatternRepository.getActivePatternForJob(jobId);
    return switch (activePatternResult) {
      Success<ShiftPattern?>(value: final pattern?) => _expandSchedule(pattern: pattern, range: range),
      Success<ShiftPattern?>(value: null) => const Success(<ShiftInstance>[]),
      Failure<ShiftPattern?>(error: final error) => Failure(error),
    };
  }

  Future<Result<List<ShiftInstance>>> _expandSchedule({
    required ShiftPattern pattern,
    required AppDateRange range,
  }) async {
    final entriesResult = await _shiftPatternEntryRepository.listEntriesForPattern(pattern.id);
    if (entriesResult.isFailure) {
      return entriesResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final templatesResult = await _shiftTemplateRepository.listTemplatesForJob(pattern.jobId);
    if (templatesResult.isFailure) {
      return templatesResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final overridesResult = await _shiftInstanceRepository.listInstancesForRange(
      jobId: pattern.jobId,
      range: range,
    );
    if (overridesResult.isFailure) {
      return overridesResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final entries = entriesResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final templates = templatesResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final overrides = overridesResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    return Success(
      _patternExpansionService.expand(
        pattern: pattern,
        entries: entries,
        templates: templates,
        overrides: overrides,
        range: range,
      ),
    );
  }
}
