import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class HolidayRuleSet {
  const HolidayRuleSet({
    required this.id,
    required this.jobId,
    required this.holidayMultiplierBps,
    required this.holidaySource,
  });

  final EntityId id;
  final EntityId jobId;
  final int holidayMultiplierBps;
  final HolidaySource holidaySource;
}
