import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';
import '../../core/money/currency_amount.dart';

class Job {
  const Job({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.currencyCode,
    required this.hourlyRate,
    required this.payRuleSetId,
    required this.holidayRuleSetId,
    required this.defaultSleepLeadMinutes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final EntityId id;
  final String name;
  final String colorHex;
  final String currencyCode;
  final CurrencyAmount hourlyRate;
  final EntityId? payRuleSetId;
  final EntityId? holidayRuleSetId;
  final Minutes? defaultSleepLeadMinutes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
}
