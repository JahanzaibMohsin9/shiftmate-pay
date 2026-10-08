import '../../core/common/shared_types.dart';
import '../entities/shift_instance.dart';

class ShiftDurationCalculator {
  const ShiftDurationCalculator();

  Minutes calculateTotalMinutes(ShiftInstance instance) {
    final minutes = instance.endDateTime.difference(instance.startDateTime).inMinutes;
    return minutes < 0 ? 0 : minutes;
  }

  Minutes calculatePaidMinutes(ShiftInstance instance) {
    return calculatePaidMinutesWithBreak(
      instance: instance,
      unpaidBreakMinutes: instance.unpaidBreakMinutes,
    );
  }

  Minutes calculatePaidMinutesWithBreak({
    required ShiftInstance instance,
    required Minutes unpaidBreakMinutes,
  }) {
    final totalMinutes = calculateTotalMinutes(instance);
    final paidMinutes = totalMinutes - unpaidBreakMinutes;
    return paidMinutes < 0 ? 0 : paidMinutes;
  }
}
