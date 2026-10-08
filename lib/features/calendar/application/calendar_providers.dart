import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/identifiers.dart';
import '../../../core/time/app_date_range.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/shift_instance.dart';

class CalendarScheduleQuery {
  const CalendarScheduleQuery({
    required this.jobId,
    required this.range,
  });

  final EntityId jobId;
  final AppDateRange range;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CalendarScheduleQuery &&
        other.jobId == jobId &&
        other.range.start == range.start &&
        other.range.end == range.end;
  }

  @override
  int get hashCode => Object.hash(jobId, range.start, range.end);
}

final calendarScheduleProvider =
    FutureProvider.family<List<ShiftInstance>, CalendarScheduleQuery>((ref, query) async {
      final result = await ref.watch(generatedShiftScheduleUseCaseProvider).call(
            jobId: query.jobId,
            range: query.range,
          );

      return result.when(
        success: (instances) => instances,
        failure: (error) => throw error,
      );
    });
