class AppDateRange {
  AppDateRange({
    required this.start,
    required this.end,
  }) : assert(!end.isBefore(start), 'End must not be before start.');

  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);
  int get daySpan => end.difference(start).inDays + 1;

  bool contains(DateTime value) =>
      !value.isBefore(start) && !value.isAfter(end);

  AppDateRange shiftBy(Duration offset) => AppDateRange(
        start: start.add(offset),
        end: end.add(offset),
      );

  @override
  String toString() => 'AppDateRange(start: $start, end: $end)';
}
