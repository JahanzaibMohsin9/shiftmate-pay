import '../common/app_constants.dart';
import 'app_date_range.dart';
import 'timezone_utils.dart';

extension DateTimeRangeHelpers on DateTime {
  DateTime get startOfDay => TimezoneUtils.atStartOfDay(this);

  DateTime get endOfDay => TimezoneUtils.atEndOfDay(this);

  AppDateRange weekRange({int firstDayOfWeek = DateTime.monday}) {
    final normalized = startOfDay;
    final delta = (normalized.weekday - firstDayOfWeek) % AppConstants.daysPerWeek;
    final start = normalized.subtract(Duration(days: delta));

    return AppDateRange(
      start: start,
      end: start.add(
        const Duration(days: AppConstants.daysPerWeek - 1),
      ),
    );
  }

  AppDateRange monthRange() {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1, 0);

    return AppDateRange(start: start, end: end);
  }
}
