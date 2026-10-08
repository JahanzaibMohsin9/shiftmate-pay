# ShiftMate Pay - Advanced Pay Rules Specification

## 1. Purpose

This document defines the first post-MVP expansion of ShiftMate Pay's pay engine so Premium can solve more realistic shift-worker pay scenarios and support trustworthy pay verification later.

## 2. Goals

The advanced pay rules system should:

- represent common shift-worker pay complexity without becoming a payroll engine for every country
- stay deterministic and testable
- remain local-first
- support readable summaries in the UI
- feed forecasting and expected-vs-actual comparison features

## 3. Non-Goals

The first advanced rules release will not:

- calculate taxes or net pay
- guarantee payroll compliance for every employer
- support every union contract edge case
- interpret scanned payslips automatically
- handle arbitrarily complex formula builders

## 4. Core Principles

- all monetary amounts use integer minor units
- all durations use minutes
- rule evaluation must be deterministic
- rules must have explicit precedence
- UI must describe rules in plain language
- basic pay setups must continue to work unchanged

## 5. Supported Rule Families In Release One

### Overtime rules
- daily overtime threshold
- weekly overtime threshold
- multiple overtime tiers
- optional double-time tiers

### Differential rules
- night differential
- weekend differential
- holiday uplift

### Allowance rules
- flat per-shift allowance
- flat per-period allowance
- conditional allowances by shift template or day type

### Break rules
- unpaid break minutes
- advanced break handling when specific shift types need different break assumptions

## 6. Domain Modeling Direction

### Rule scope
Rules should be attached to a `Job`, with optional narrower applicability for:

- a shift template
- a day type
- a pay period calculation context

### Recommended aggregate

`AdvancedPayRuleSet`
- `jobId`
- `enabled`
- `overtimeRules[]`
- `differentialRules[]`
- `allowanceRules[]`
- `breakRules[]`
- `version`
- `updatedAt`

## 7. Rule Types

### Overtime tier

Recommended fields:
- `id`
- `scope`
- `thresholdMinutes`
- `multiplierBps`
- `periodType` (`daily` or `weekly`)
- `priority`
- `enabled`

### Differential rule

Recommended fields:
- `id`
- `type` (`night`, `weekend`, `holiday`)
- `appliesWhen`
- `multiplierBps` or `flatAmountMinor`
- `combinationMode`
- `enabled`

### Allowance rule

Recommended fields:
- `id`
- `type` (`perShift`, `perPeriod`)
- `amountMinor`
- `conditions`
- `enabled`

### Break rule

Recommended fields:
- `id`
- `minutes`
- `conditions`
- `enabled`

## 8. Rule Applicability Model

The engine must know whether a rule applies based on:

- job
- shift template or category
- holiday flag
- weekend/day-of-week
- time window overlap
- total worked minutes in the relevant period

This should be represented with explicit predicates rather than hidden ad hoc checks.

## 9. Combination And Precedence Rules

### Recommended precedence
1. compute gross worked minutes
2. apply break deductions
3. allocate overtime buckets
4. evaluate differentials
5. add allowances
6. build human-readable breakdown output

### Overtime precedence
- allocate lower threshold overtime before higher threshold overtime tiers
- daily overtime allocates before weekly overtime unless the product explicitly states otherwise
- the same worked minute must not be counted in two overtime buckets

### Differential precedence
- differentials may coexist with overtime when permitted by `combinationMode`
- holiday uplift must be explicit about whether it stacks additively or multiplicatively
- if multiple differentials would conflict, the spec must choose one or define stacking clearly

## 10. Combination Modes

Recommended initial support:

- `additivePremium`
- `exclusiveHighestWins`

Avoid broader formula-builder flexibility in release one.

## 11. Night Differential Model

Night differential should support:

- a configurable local time window such as 22:00 to 06:00
- partial overlap with a shift
- overnight window crossing midnight

The engine must calculate only the overlapped minutes, not the entire shift.
Current implementation assumption:
- if unpaid break timing is unknown, deducted break minutes are applied from the end of the shift window for deterministic overlap calculations

## 12. Weekend Differential Model

Weekend differential should support:

- Saturday and Sunday by default
- configurable included days later if needed
- mixed shifts that cross from weekday to weekend

As with night differential, only the qualifying minutes should receive the uplift.

## 13. Holiday Uplift Model

Holiday treatment should support:

- whole-shift holiday flags in release one
- additive premium above base pay
- optional coexistence with overtime when allowed by configuration

If holiday logic stacks with overtime, the output must make that visible instead of hiding it in one number.

## 14. Allowance Model

Initial allowance support should include:

- flat allowance per worked shift
- flat allowance when a specific template is used
- flat allowance when a holiday or night condition is present

Avoid mileage and reimbursement-style expense modeling in release one.
Current implementation status:
- per-shift allowances are supported
- per-period allowances are supported
- template-qualified and holiday-qualified allowances are supported

## 15. Output Contract

The advanced pay engine should produce:

`AdvancedPayBreakdown`
- totalWorkedMinutes
- baseMinutes
- overtimeBuckets[]
- differentialItems[]
- allowanceItems[]
- grossPayMinor
- warnings[]

### Breakdown item requirements
- stable type identifier
- plain-language label
- amount in minor units
- qualifying minutes where applicable
- enough metadata to support export and pay verification

## 16. Validation Rules

- thresholds must be non-negative
- tier thresholds must be strictly increasing within the same scope
- multiplier basis points must be valid integers
- amount fields must not be negative unless a deduction type is intentionally supported later
- night windows must be valid even when crossing midnight
- rule conflicts should surface user-friendly validation errors

## 17. Required Test Matrix

### Overtime
- daily threshold crossed exactly
- weekly threshold crossed exactly
- multiple overtime tiers in the same period
- overnight shift contributing to overtime totals

### Differentials
- partial night overlap
- weekend crossover
- holiday with overtime
- highest-wins vs additive behavior

### Allowances
- allowance attached to template
- allowance attached to a qualifying shift type
- allowance applied once per period rather than per shift

### Regression
- basic MVP jobs still calculate correctly with no advanced rules enabled
- repeated runs produce identical output

## 18. UI Requirements

The UI should:

- separate basic and advanced pay settings
- show plain-language rule summaries
- show examples where possible
- warn when combinations may surprise the user
- explain that the app models expected pay, not legal payroll guarantees

## 19. Migration Notes

Existing jobs should default to:

- advanced rules disabled
- current MVP pay behavior unchanged

Migration must never silently reinterpret existing overtime or holiday settings in a way that changes current totals unexpectedly.

## 20. Persistence And Migration Plan

### Schema additions in the first foundation slice
- `AdvancedPayRuleSetsTable`
- `OvertimeTierRulesTable`
- `DifferentialRulesTable`
- `AllowanceRulesTable`
- `AdvancedBreakRulesTable`
- `ActualPayslipsTable`

### Migration approach
- bump the Drift schema version from `1` to `2`
- add only new tables in the upgrade path
- avoid rewriting existing MVP pay-rule records during migration
- keep current `PayRuleSet` and `HolidayRuleSet` behavior untouched

### Backfill defaults
- no existing job is auto-enrolled into advanced pay rules
- advanced rule sets should be absent until explicitly created
- payslip records start empty for all existing users

### Safety checklist
- old jobs must still calculate pay exactly as before when no advanced rule set exists
- existing reminder, schedule, and export records must remain unaffected
- the app must be able to run against a fresh database and a migrated database

## 21. Implementation Notes

Built so far:
- advanced pay-rule domain entities created
- persistence schema extended for advanced rules and future payslip records
- repository support added for saving and loading advanced pay-rule sets
- automated tests added for domain behavior and persistence-backed CRUD
- tier-aware overtime allocation implemented for daily and weekly thresholds
- regression tests added for multi-tier overtime allocation
- differential pay calculator implemented for night, weekend, and holiday-style premium rules
- additive and exclusive-highest-wins combination behavior covered by tests
- allowance calculator implemented for per-shift and per-period premium rules
- advanced break resolution added with template-first, category-second precedence

## 22. Related Docs

- [Pay verification spec](pay-verification-spec.md)
- [Base pay rules spec](pay-rules-spec.md)
