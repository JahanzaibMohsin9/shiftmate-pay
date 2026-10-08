import '../../core/common/shared_types.dart';

class HolidayMultiplierCalculator {
  const HolidayMultiplierCalculator();

  MinorUnits calculatePremium({
    required Minutes holidayMinutes,
    required MinorUnits hourlyRateMinor,
    required int holidayMultiplierBps,
  }) {
    if (holidayMinutes <= 0) {
      return 0;
    }

    final premiumMultiplierBps = holidayMultiplierBps - 10000;
    if (premiumMultiplierBps <= 0) {
      return 0;
    }

    return _calculateAmount(
      minutes: holidayMinutes,
      hourlyRateMinor: hourlyRateMinor,
      multiplierBps: premiumMultiplierBps,
    );
  }

  MinorUnits _calculateAmount({
    required Minutes minutes,
    required MinorUnits hourlyRateMinor,
    required int multiplierBps,
  }) {
    final numerator = minutes * hourlyRateMinor * multiplierBps;
    return numerator ~/ 600000;
  }
}
