typedef Minutes = int;
typedef MinorUnits = int;

enum DateRangePreset { week, month, custom }

enum DataOrigin { local, imported, generated, manualOverride }

enum ShiftCategory { day, evening, night, custom }

enum ShiftSource { pattern, manual, imported }

enum ShiftOverrideType {
  replaceWithManualShift,
  markOffDay,
  editGeneratedShift,
}

enum ReminderType { shiftStart, sleep, prep, wake }

enum RoundRule { nearestMinute, nearestFiveMinutes, nearestQuarterHour, none }

enum HolidaySource { manual, regionPack }

enum OvertimePeriodType { daily, weekly }

enum DifferentialRuleType { night, weekend, holiday }

enum DifferentialCombinationMode { additivePremium, exclusiveHighestWins }

enum AllowanceRuleType { perShift, perPeriod }
