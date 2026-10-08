# ShiftMate Pay — Flutter Architecture

## 1. Product Goal
ShiftMate Pay is a Flutter app for shift workers who need three things in one place:
- a reliable rotating shift calendar
- accurate pay estimation including overtime and holiday rules
- lifestyle support such as sleep reminders tied to the next shift

The product should be **offline-first**, fast to open, easy to configure, and monetizable through a freemium model.

## 2. Product Positioning
Core differentiation:
- stronger pay clarity than typical shift calendar apps
- supports recurring patterns instead of forcing manual entry every week
- connects schedule, earnings, and routine in one workflow

## 3. MVP Scope
### Included in MVP
- job setup with hourly rate and pay rules
- rotating shift pattern builder
- manual one-off shift edits
- monthly and weekly calendar views
- per-shift notes
- weekly and monthly pay estimate
- basic overtime support
- holiday pay multiplier support
- local reminders for upcoming shifts and sleep reminders
- home screen widget support where practical
- export schedule as image or PDF
- backup/export of local data

### Excluded from MVP
- cloud sync
- team roster import from employer systems
- payroll integrations
- tax filing support
- smartwatch companion
- AI chat assistant
- multi-platform desktop/web app in MVP

## 4. Recommended Flutter Tech Stack
### App Layer
- **Flutter**
- **Dart**
- **Material 3** for UI styling
- **GoRouter** for navigation
- **Riverpod** for state management and dependency injection
- **Freezed** for immutable models and unions where useful

### Data Layer
- **Drift** or **Isar** for local database
- **SharedPreferences** or **Hive** for lightweight settings cache
- **flutter_local_notifications** for local reminders
- **workmanager** for background rescheduling where supported
- **home_widget** for Android home screen widget integration

### Architecture Pattern
- feature-first clean architecture
- presentation -> application -> domain -> data
- unidirectional state updates
- pure domain services for schedule and pay calculations

### Supporting Libraries
- `timezone`
- `intl`
- `collection`
- `pdf`
- `printing`
- `json_serializable`
- `freezed`

## 5. High-Level Module Structure
```text
lib/
  app/
    router/
    theme/
    bootstrap/
  core/
    common/
    time/
    money/
    utils/
    services/
  features/
    onboarding/
    jobs/
    shifts/
    calendar/
    pay/
    reminders/
    notes/
    export/
    widget/
    settings/
    premium/
  data/
    local/
    repositories/
    mappers/
  domain/
    entities/
    repositories/
    services/
    usecases/
```

### Module Responsibilities
#### core/time
Date math, recurrence expansion, week/month grouping, timezone-safe helpers.

#### core/money
Currency formatting, rounding, pay calculation primitives, overtime math.

#### features/jobs
Manage jobs, base pay, overtime rules, holiday multipliers, premium entitlements for multiple jobs.

#### features/shifts
Create shift templates, assign shifts, override a day, attach notes, mark status.

#### features/calendar
Calendar rendering, agenda list, filters by job, pay preview badges.

#### features/pay
Weekly/monthly summaries, projected totals, breakdown by base/overtime/holiday hours.

#### features/reminders
Shift start reminders, sleep reminders, reminder presets, notification rescheduling.

#### features/export
Export schedule as image/PDF and backup data.

#### features/widget
Upcoming shifts widget and small earnings snapshot widget bridge for Android.

## 6. Core Domain Model

## 6.1 Entities
### Job
```text
Job
- id: String
- name: String
- color: String
- currencyCode: String
- hourlyRateMinor: int
- overtimeRuleSetId: String?
- holidayRuleSetId: String?
- defaultSleepLeadMinutes: int?
- isArchived: bool
- createdAt: DateTime
- updatedAt: DateTime
```

### ShiftTemplate
```text
ShiftTemplate
- id: String
- jobId: String
- name: String
- startTimeLocal: String
- endTimeLocal: String
- unpaidBreakMinutes: int
- category: ShiftCategory (day, night, evening, custom)
- defaultNote: String?
```

### ShiftPattern
```text
ShiftPattern
- id: String
- jobId: String
- name: String
- cycleLengthDays: int
- startDate: DateTime
- timezone: String
- isActive: bool
```

### ShiftPatternEntry
```text
ShiftPatternEntry
- id: String
- patternId: String
- dayOffset: int
- shiftTemplateId: String?
- isOffDay: bool
```

### ShiftInstance
```text
ShiftInstance
- id: String
- jobId: String
- date: DateTime
- shiftTemplateSnapshot
- startDateTime: DateTime
- endDateTime: DateTime
- unpaidBreakMinutes: int
- source: ShiftSource (pattern, manual, import)
- note: String?
- isHoliday: bool
- overrideType: ShiftOverrideType?
```

### PayRuleSet
```text
PayRuleSet
- id: String
- jobId: String
- overtimeThresholdDailyMinutes: int?
- overtimeThresholdWeeklyMinutes: int?
- overtimeMultiplierBps: int
- doubleTimeThresholdMinutes: int?
- doubleTimeMultiplierBps: int?
- roundRule: RoundRule
```

### HolidayRuleSet
```text
HolidayRuleSet
- id: String
- jobId: String
- holidayMultiplierBps: int
- holidaysSource: HolidaySource (manual, regionPack)
```

### ReminderRule
```text
ReminderRule
- id: String
- jobId: String
- type: ReminderType (shiftStart, sleep, wake)
- leadMinutes: int
- enabled: bool
```

### PayPeriodSummary
Derived, not stored permanently unless cached.

### AppEntitlement
```text
AppEntitlement
- premium: bool
- multipleJobsEnabled: bool
- widgetsEnabled: bool
- advancedPayRulesEnabled: bool
- exportEnabled: bool
```

## 6.2 Derived Models
- shift duration in paid minutes
- weekly total hours
- monthly projected pay
- overtime bucket totals
- next shift + sleep recommendation
- calendar cell summaries

## 7. Data Storage Strategy
### Local Database
Use a local database as source of truth.

Recommended choice:
- **Drift** if you want SQL clarity, migrations, and strong query control
- **Isar** if you want simpler local persistence and faster setup

For this app, **Drift** is the better fit because pay summaries, joins, filters, and export queries may grow more complex.

Tables/collections:
- jobs
- shift_templates
- shift_patterns
- shift_pattern_entries
- shift_instances
- pay_rule_sets
- holiday_rule_sets
- reminder_rules
- local_holidays
- export_history

### Preferences
Use lightweight storage for:
- default calendar view
- first day of week
- default currency
- notification permission status flags
- widget display settings
- premium state cache

### Why Offline-First
This app should still work without network because shift workers may be on site, commuting, or in low-connectivity conditions.

## 8. Schedule Generation Engine
This is the most important technical component.

### Responsibilities
- expand a shift pattern into visible dates
- handle off-days and repeating cycles
- support overnight shifts crossing midnight
- allow manual override for specific days
- keep generated instances deterministic

### Approach
Use a **pattern expansion service** in the domain layer.

Inputs:
- active pattern
- date range
- shift templates
- overrides

Outputs:
- list of `ShiftInstance`

### Rules
- if a manual override exists for a date, it wins
- if the pattern says off-day, generate no working shift
- overnight shifts create end datetime on next day
- pay calculations always use expanded instances, not raw templates

## 9. Pay Calculation Engine
This is the second most critical component.

### Inputs
- job pay rules
- shift instances in a pay period
- holiday flags
- unpaid break minutes
- daily/weekly overtime thresholds

### Output
```text
PayBreakdown
- baseMinutes
- overtimeMinutes
- doubleTimeMinutes
- holidayMinutes
- grossPayMinor
- lineItems[]
```

### Recommended Design
Implement pure domain services:
- `ShiftDurationCalculator`
- `OvertimeAllocator`
- `HolidayPayCalculator`
- `GrossPayCalculator`
- `PaySummaryBuilder`

### Important Constraints
- use integer minor units for currency, never floating-point for stored money
- use minute-level arithmetic for time
- make rules testable with unit tests
- support country-specific logic later without rewriting the engine

## 10. Reminder and Notification System
### Reminder Types
- shift starts in X minutes
- sleep reminder before next shift
- optional wake reminder

### Scheduling Strategy
- `flutter_local_notifications` for notification delivery
- `workmanager` for resilient background refresh where supported
- compute notifications for the next rolling window, for example 14 days
- reschedule on:
  - reboot
  - app update
  - timezone change
  - job/pattern/reminder edits

### Important Flutter Caveat
Background reliability can vary by platform and OEM behavior. Since the MVP is Android-focused, keep reminder logic optimized for Android first.

### Notification Payload
- title
- next shift time
- job name
- hours until shift
- action buttons if supported: view schedule, snooze, mark seen

## 11. Widget Architecture
### MVP Widgets
- upcoming shift widget
- compact week snapshot widget

### Data Flow
- widget requests snapshot from repository
- snapshot built from next N days of shift instances
- widget updates on midnight rollover and relevant edits
- use `home_widget` to bridge Flutter state with Android widgets

### Important Constraint
The widget UI itself remains Android-native under the hood even if the main app is Flutter.

## 12. Export Architecture
### Export Types
- image export of weekly/monthly schedule
- PDF export of schedule and pay summary
- backup export as JSON

### Design
- render export models from the same domain data used by UI
- isolate export mapping from presentation widgets
- keep PDF generation in a dedicated exporter service
- use `pdf` and `printing` packages where appropriate

## 13. Smart Pattern Detection
This is not required for launch but should be architected as a pluggable service.

### Goal
User enters 1–2 weeks of shifts manually. App suggests a repeating rotation.

### Interface
```text
PatternSuggestionService
- suggestPattern(shiftHistory: List<ShiftInstance>): PatternSuggestion?
```

### Suggested MVP Algorithm
- detect repeating sequence over day labels and start/end times
- compute smallest repeating cycle with confidence score
- ask user to confirm before applying

No remote model is required.

## 14. Subscription / Premium Boundaries
### Free
- one job
- calendar
- basic pattern builder
- basic pay estimate
- simple notifications

### Premium
- multiple jobs
- widgets
- export PDF/image
- advanced pay rules
- holiday packs
- more reminder presets

Keep entitlement checks centralized behind a `FeatureGateRepository`.

## 15. Screen Map
- Onboarding
- Jobs List
- Create/Edit Job
- Shift Templates
- Pattern Builder
- Calendar
- Shift Detail
- Pay Summary
- Reminders Settings
- Export Screen
- Premium Screen
- App Settings

## 16. Suggested Data Relationships
```text
Job 1---N ShiftTemplate
Job 1---N ShiftPattern
ShiftPattern 1---N ShiftPatternEntry
Job 1---N ShiftInstance
Job 1---1 PayRuleSet
Job 1---1 HolidayRuleSet
Job 1---N ReminderRule
```

## 17. Testing Strategy
### Unit Tests
- shift expansion across 30/31-day months
- overnight shift calculations
- daylight savings / timezone-safe behavior where applicable
- overtime threshold edge cases
- holiday + overtime combined calculation
- rounding and money correctness

### Integration Tests
- create job -> create pattern -> view pay estimate
- edit one shift -> pay summary updates
- backup/export and restore
- notification rescheduling after edit

### UI Tests
- pattern builder flow
- pay breakdown visibility
- widget config flow where supported

## 18. Analytics Events
Keep analytics lightweight and privacy-conscious.

Track:
- job_created
- pattern_created
- first_shift_generated
- pay_estimate_viewed
- export_completed
- widget_enabled
- premium_paywall_viewed
- premium_purchased

## 19. Privacy and Permissions
### Permissions
- notifications
- optional storage/media access depending on Android version and export flow

### Privacy Principles
- local-first by default
- no account required for MVP
- no location tracking
- no server dependency for core scheduling and pay logic

## 20. Build Order
### Phase 1
- core data model
- jobs
- shift templates
- pattern builder
- calendar

### Phase 2
- pay engine
- reminders
- notes per shift

### Phase 3
- export
- widget bridge
- premium gating

### Phase 4
- smart pattern suggestion
- holiday packs
- backup/restore polish

## 21. Biggest Technical Risks
- recurrence expansion bugs
- pay rules becoming too country-specific too early
- calendar UI complexity consuming too much time
- notification reliability on Android OEM devices
- widget integration complexity in Flutter

## 22. Recommended MVP Rule
Do not try to support every labor rule on day one. Build:
- one hourly rate
- daily overtime threshold
- weekly overtime threshold
- holiday multiplier
- unpaid break handling

That is enough for a strong first release.

## 23. Flutter-Specific Recommendation
For this project, keep the **domain logic framework-agnostic**.

That means:
- scheduling rules should not depend on Flutter widgets
- pay calculations should live in pure Dart services
- repositories should abstract the local database choice
- notification and widget integrations should stay behind platform service interfaces

This will keep the app maintainable and make later refactoring easier if platform-specific code grows.
