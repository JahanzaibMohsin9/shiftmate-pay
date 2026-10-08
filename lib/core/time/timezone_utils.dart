final class TimezoneUtils {
  const TimezoneUtils._();

  static DateTime atStartOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime atEndOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day, 23, 59, 59, 999, 999);

  static DateTime combineLocalDateAndMinutes({
    required DateTime day,
    required int minutes,
  }) {
    final normalizedDay = atStartOfDay(day);
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    return DateTime(
      normalizedDay.year,
      normalizedDay.month,
      normalizedDay.day,
      hours,
      remainingMinutes,
    );
  }

  static int differenceInWholeMinutes({
    required DateTime start,
    required DateTime end,
  }) => end.difference(start).inMinutes;
}
