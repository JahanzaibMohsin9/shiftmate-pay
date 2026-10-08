# ShiftMate Pay - Testing Strategy

## 1. Objective
The testing strategy protects the most failure-prone parts of the product:
- schedule expansion
- overtime and holiday pay calculations
- reminder rescheduling
- persistence-backed feature flows
- premium trust features that affect money confidence

## 2. Testing Priorities

### Priority 1 - Domain correctness
Critical domain logic must have automated unit tests:
- schedule expansion
- shift duration math
- overtime allocation
- holiday calculations
- pay aggregation

### Priority 2 - Workflow integrity
Key user journeys must have integration coverage:
- onboarding to first job
- job to pattern to calendar
- shift override to pay summary refresh
- backup/export basics

### Priority 3 - UI stability
High-value UI flows should have widget or UI tests:
- pattern builder flow
- calendar rendering state changes
- pay breakdown visibility
- reminder settings flow

### Priority 4 - Premium trust features
The next paid growth phase must add automated coverage for:
- advanced pay-rule interpretation
- expected vs actual pay comparison
- discrepancy classification
- forecast calculations
- import parsing and conflict review

## 3. Test Pyramid

### Unit tests
Target:
- the majority of automated coverage

Focus:
- pure Dart services
- mappers
- utility classes
- validation logic

### Integration tests
Target:
- feature slices that cross data, application, and presentation boundaries

Focus:
- repository-backed flows
- schedule generation and pay updates after edits
- export and reminder triggers where practical

### UI tests
Target:
- smaller set of high-value interaction paths

Focus:
- forms, transitions, and visual state conditions that are easy to regress

## 4. Minimum Required Coverage by Area

### Schedule engine
- recurrence expansion
- off-day handling
- override precedence
- overnight shifts
- month boundary behavior
- timezone-sensitive scenarios

### Pay engine
- base pay
- unpaid break deduction
- daily overtime
- weekly overtime
- holiday multiplier
- combined overtime and holiday cases
- rounding consistency

### Premium pay extensions
- multiple overtime tiers
- night differential overlap
- weekend differential overlap
- allowances by shift or period
- advanced break override scope conflicts
- advanced pay settings controller save flows
- advanced-rule precedence and stacking behavior

### Pay verification
- exact gross comparison
- underpayment and overpayment detection
- discrepancy confidence lowering when user input is incomplete
- category-level mismatch classification
- payslip CRUD and job-period lookup coverage
- exact-versus-likely comparison classification

### Forecasting and planning
- 30-day, 60-day, and 90-day forecast windows
- coverage-ratio and uncovered-day metadata
- low/medium/high forecast confidence classification
- partial-schedule warning generation
- monthly earnings-goal status classification
- monthly overtime-target status classification
- forecast nudge generation for target states
- extra-shift simulation impact on totals and goal state
- planning alert generation for overlap, rest gap, consecutive days, overtime caps, and availability conflicts
- recurring weekly availability conflict detection

### Import
- CSV parsing correctness
- CSV header alias handling
- date/time normalization
- boolean and whitespace normalization
- duplicate detection
- conflict classification against generated and saved shifts
- conflict preview generation
- dry-run import preview row-state counts

### Data layer
- repository mapping correctness
- create/update/delete persistence for jobs, templates, patterns, overrides, and premium verification data
- migration safety checks where feasible

### Reminders
- next shift lookup
- rolling 14-day scheduling window boundaries
- sleep recommendation time calculation
- short-rest reminder wording when planning settings define a minimum rest target
- reminder rule persistence
- schedule change triggers rescheduling intent

## 5. Core Test Scenarios

### Unit test scenarios
- pattern starts before visible range
- overnight shift ends next day
- leap-year February expansion
- weekly overtime threshold crossed exactly on boundary
- holiday shift with unpaid break
- same inputs produce same pay breakdown
- night differential overlaps only part of a shift
- expected and actual gross values classify into the correct variance direction
- forecast confidence drops correctly when future schedule coverage is sparse
- monthly goal status changes correctly as projected earnings move above or below target
- monthly overtime target status changes correctly as projected overtime moves above or below target
- recurring availability rule that crosses midnight still flags the correct shift
- short-rest reminder wording appears without changing the underlying reminder timing

### Integration scenarios
- create job -> create pattern -> view calendar -> view pay summary
- edit one shift -> confirm calendar and pay summary update
- add note and holiday flag -> verify persistence and summary reflection
- export generated schedule data successfully
- configure advanced pay rules -> verify projected pay changes as expected
- save a payslip comparison -> verify discrepancy summary loads correctly
- load a forecast window -> verify coverage and confidence match generated schedule data
- import CSV in dry-run mode -> verify accepted, duplicate, conflict, and skipped counts match the normalized rows
- save planning settings -> verify calendar or pay warnings appear in the relevant period
- save planning settings with rest target -> verify reminder preview wording reflects short-rest risk when applicable

### UI scenarios
- onboarding validation errors
- pattern builder save flow
- calendar month/week switching
- pay screen empty state and populated state
- reminders toggles and lead-time changes
- premium verification flow empty, mismatch, and no-discrepancy states
- payslip entry form gross-only save path and optional-detail expansion behavior
- forecast screen empty, partial-coverage, and high-confidence states
- import preview empty, mixed-result, and confirmation-gated states

## 6. Test Data Strategy
- use deterministic fixed dates in tests
- use explicit timezone values in schedule tests
- use factory helpers for jobs, templates, patterns, shift instances, and future payslip records
- keep money fixtures in minor units only
- include scenarios with incomplete user-entered payslip data
- include scenarios with partial future schedule coverage and no-future-shifts states

## 7. Environments and Execution
- run unit tests on every development cycle
- run integration tests before merging feature slices
- run manual device QA for reminders and export flows on Android builds
- run premium trust-feature regression before any paid release candidate

## 8. Regression Policy
- every bug in schedule or pay logic must add a regression test
- never fix a critical rules bug without capturing a reproducing case first
- keep a short list of known edge cases in release notes until resolved
- every premium discrepancy false-positive or false-negative must add a regression case once reproduced
- rerun the pay-rules regression tests before merging verification, discrepancy, forecast, or import logic that touches pay totals

## 9. Manual QA Focus Areas
- offline-first behavior
- month transitions in calendar
- shift override refresh behavior
- reminder scheduling after edits
- export output correctness
- premium gating behavior
- advanced pay-rule comprehension
- pay verification clarity and trust
- forecast confidence wording and goal-status calmness

## 10. Definition of Testing Done
A feature is not complete until:
- relevant unit tests are added or updated
- affected integration flow still passes
- manual verification is done for the user-visible path
- newly discovered edge cases are recorded
