# ShiftMate Pay — Pay Rules Specification

## 1. Purpose
This document defines the MVP pay calculation behavior so the implementation remains predictable, testable, and consistent across UI, export, and summaries.

## 2. Core Principles
- use integer **minor currency units** only for stored and computed money
- use **minutes** only for duration calculations
- compute pay from expanded `ShiftInstance` records, not from templates or raw pattern definitions
- keep all pay services pure and framework-agnostic

## 3. MVP Inputs
- hourly rate in minor units
- shift start and end timestamps
- unpaid break minutes
- holiday flag
- daily overtime threshold in minutes
- weekly overtime threshold in minutes
- overtime multiplier in basis points
- optional double-time threshold and multiplier if enabled later
- holiday multiplier in basis points

## 4. Derived Metrics
- paid minutes per shift
- base minutes
- overtime minutes
- double-time minutes if supported
- holiday minutes
- gross pay in minor units

## 5. Minimum MVP Rule Set
- one hourly rate per job
- unpaid breaks reduce paid minutes
- daily overtime threshold supported
- weekly overtime threshold supported
- holiday multiplier supported
- holiday and overtime combinations must be handled consistently

## 6. Calculation Order

### Step 1 — Determine paid minutes
`paidMinutes = totalShiftMinutes - unpaidBreakMinutes`

Rules:
- paid minutes cannot be negative
- overnight shifts are calculated from actual start/end timestamps

### Step 2 — Allocate overtime buckets
For MVP:
- apply daily overtime where daily threshold is exceeded
- apply weekly overtime where weekly threshold is exceeded
- avoid double-counting the same minute into multiple overtime buckets unless explicitly designed later

Recommended practical rule for MVP:
- allocate daily overtime first at shift/day level
- then allocate remaining weekly overtime on eligible remaining minutes

### Step 3 — Mark holiday minutes
- if a shift is flagged as holiday, apply the holiday multiplier to the relevant minutes according to the chosen compounding rule

### Step 4 — Compute monetary totals
- compute base pay from base minutes
- compute overtime premium from overtime minutes and multiplier
- compute holiday premium from holiday minutes and multiplier
- combine into one gross pay total in minor units

## 7. Multiplier Rules

### Basis points
Use basis points to avoid floating-point math:
- `10000` = 1.00x
- `15000` = 1.50x
- `20000` = 2.00x

### Examples
- overtime at 1.5x = `15000`
- holiday at 2.0x = `20000`

## 8. Rounding Rules
- keep calculations integer-based wherever possible
- convert hourly rate to per-minute value in a deterministic way
- apply a single documented rounding strategy consistently

Recommended MVP rule:
- derive per-minute rate from hourly rate with controlled integer rounding
- round final line items consistently before summing, or sum raw minute-level calculations consistently and round once at the end
- once chosen, do not mix strategies across screens

## 9. Holiday and Overtime Interaction
This must be explicitly defined to avoid inconsistent expectations.

Recommended MVP approach:
- holiday minutes are tracked separately in the breakdown
- overtime and holiday logic are both represented in the final line items
- if compounding is needed, define it centrally in the pay engine and test it thoroughly

If simplification is required for MVP delivery speed:
- support additive logic through clearly named line items
- document that country-specific payroll nuances are out of scope for the first release

## 10. Output Contract

```text
PayBreakdown
- baseMinutes
- overtimeMinutes
- doubleTimeMinutes
- holidayMinutes
- grossPayMinor
- lineItems[]
```

Suggested line item fields:
- type
- label
- minutes
- rateMinor
- multiplierBps
- amountMinor

Implemented structure:
- `PayBreakdown` exposes `totalWorkedMinutes`, `baseMinutes`, `overtimeMinutes`, `holidayMinutes`, `basePayMinor`, `overtimePayMinor`, `holidayPayMinor`, and `grossPayMinor`
- `PayLineItem` currently supports `base`, `overtime`, and `holidayPremium` item types
- holiday pay is modeled as an additive premium above base pay so holiday shifts remain visible in both base and premium breakdowns

## 11. Example Scenarios

### Example A — Simple shift, no overtime
- hourly rate: 2000 minor units
- shift length: 8h
- unpaid break: 30m
- paid minutes: 450
- all minutes base minutes

Expected result:
- base minutes = 450
- overtime minutes = 0
- holiday minutes = 0

### Example B — Daily overtime
- daily overtime threshold: 480 minutes
- paid minutes worked in a day: 600

Expected result:
- base minutes = 480
- overtime minutes = 120

### Example C — Holiday shift
- shift flagged as holiday
- holiday multiplier applies to holiday minutes

Expected result:
- holiday line item is present
- gross pay reflects holiday-adjusted amount per defined rule

### Example D — Overnight shift
- start: 22:00
- end: 06:00 next day
- unpaid break: 30m

Expected result:
- duration handled correctly across midnight
- pay uses full paid minutes, not same-day clock subtraction

## 12. Validation Rules
- hourly rate must be positive
- unpaid break cannot exceed total shift duration
- thresholds must be non-negative
- multipliers must be valid basis-point integers

## 13. Required Tests
- base pay correctness
- unpaid break deduction
- overnight duration pay
- daily overtime threshold edges
- weekly overtime threshold edges
- holiday multiplier correctness
- combined holiday + overtime scenarios
- rounding consistency across repeated calculations

## 14. Out of Scope for MVP
- taxes
- allowances and bonuses
- union-specific rules
- automatic country-specific payroll interpretation
- split-rate shifts
- multiple overlapping premium rules beyond the defined MVP set

## 15. Implementation Notes
- shift duration is calculated from actual timestamps and then reduced by unpaid break minutes
- overtime allocation applies daily overtime first, then applies any remaining weekly overtime without double-counting minutes already allocated to daily overtime
- gross pay is calculated as `base pay + overtime pay + holiday premium`
- overtime and holiday multipliers use basis-point integer arithmetic only
