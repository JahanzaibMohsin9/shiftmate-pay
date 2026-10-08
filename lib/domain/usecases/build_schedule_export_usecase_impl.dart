import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../repositories/repositories.dart';
import 'generate_shift_schedule_usecase_impl.dart';
import 'usecases.dart';

class BuildScheduleExportUseCaseImpl implements BuildScheduleExportUseCase {
  BuildScheduleExportUseCaseImpl({
    required JobRepository jobRepository,
    required GenerateShiftScheduleUseCaseImpl generateShiftScheduleUseCase,
  }) : _jobRepository = jobRepository,
       _generateShiftScheduleUseCase = generateShiftScheduleUseCase;

  final JobRepository _jobRepository;
  final GenerateShiftScheduleUseCaseImpl _generateShiftScheduleUseCase;

  @override
  Future<Result<ScheduleExportBundle>> call({
    required EntityId jobId,
    required AppDateRange range,
  }) async {
    final jobResult = await _jobRepository.getJobById(jobId);
    if (jobResult.isFailure) {
      return jobResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final job = jobResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    if (job == null) {
      return Failure(
        AppError(code: 'job_not_found', message: 'Job $jobId was not found.'),
      );
    }

    final scheduleResult = await _generateShiftScheduleUseCase.call(
      jobId: jobId,
      range: range,
    );
    if (scheduleResult.isFailure) {
      return scheduleResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final instances = scheduleResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    return Success(ScheduleExportBundle(job: job, range: range, instances: instances));
  }
}
