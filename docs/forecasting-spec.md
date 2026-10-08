# ShiftMate Pay - Forecasting Specification

## 1. Goal

Define the first premium forecasting slice so ShiftMate Pay can help shift workers answer:

- how much they are on track to earn over the next 30, 60, or 90 days
- how trustworthy that forecast is when the rota is only partially known
- whether they are on pace to hit a monthly earnings target
- what one extra shift could do to the total later in the flow

The feature should reduce planning stress, not present false certainty.

## 2. Core User Outcome

Forecasting should help a user say:

- `I have a realistic income range for the next few weeks`
- `I can tell when missing schedule data makes the forecast weaker`
- `I know whether I am on pace for my target`
- `I can later test an extra shift without saving it`

## 3. Release-One Scope

### In scope

- rolling 30-day, 60-day, and 90-day forecast windows
- projected gross pay using generated schedules and saved overrides
- coverage-aware confidence output
- monthly earnings-goal tracking rules
- foundations for extra-shift simulation on top of the forecast model

### Out of scope

- tax withholding or net-pay forecasting
- expense budgeting
- savings recommendations
- multiple simultaneous scenarios
- employer payroll-feed reconciliation

## 4. Forecast Window Requirements

Release one should support three forecast presets:

- `30 days`
- `60 days`
- `90 days`

### Rules

- forecasts are anchored from the user-selected day, defaulting to today
- forecast windows are rolling calendar ranges, not payroll cycles
- forecasts should include only shifts inside the selected window
- the domain layer should keep preset handling separate from UI labels so other windows can be added later if needed

## 5. Forecast Calculation Inputs

The first forecast model should use:

- saved job and hourly-rate data
- basic pay rules
- advanced pay rules if enabled
- holiday rules
- generated shifts from active patterns
- saved shift overrides and manual edits

Release one should not depend on imported files, cloud sync, or payslip history.

## 6. Incomplete Schedule Representation

Forecasts must explicitly distinguish between:

- fully covered windows where every day in range is explained by known schedule data
- partially covered windows where only some days are backed by known generated or saved shifts
- empty windows where no future schedule data exists yet

### Coverage output requirements

The forecast result should expose:

- `daysCovered`
- `daysTotal`
- `coverageRatio`
- `coveredShiftCount`
- `uncoveredDayCount`

### Presentation rules

- do not show a single strong total without also surfacing coverage
- if coverage is partial, show both the current scheduled total and a confidence label
- if coverage is empty, explain that the app cannot make a reliable forecast yet

## 7. Confidence Model

The forecast must expose a simple confidence level:

- `high`
- `medium`
- `low`

### Initial confidence rules

#### High confidence

Use `high` when:

- coverage is at least 85 percent of days in range
- an active schedule pattern exists for the full window or overrides explain the remaining days
- no major forecast assumptions are being stretched beyond the generated schedule horizon

#### Medium confidence

Use `medium` when:

- coverage is between 40 percent and 84 percent
- enough schedule data exists to make the total directionally useful
- some uncovered days remain that could materially change the result

#### Low confidence

Use `low` when:

- coverage is below 40 percent
- no active future pattern exists for much of the window
- the forecast is effectively a partial total rather than a dependable projection

### Confidence messaging rules

- confidence should never sound like a legal or payroll guarantee
- low confidence should explain why, not just label the result
- the model should support multiple warnings, such as partial coverage or no future shifts saved

## 8. Partial-Schedule Assumptions

Release one should use conservative assumptions:

- only count known scheduled work
- do not invent unscheduled future shifts
- do not fill uncovered days with pattern guesses unless the schedule engine already generates them from a saved active pattern
- treat uncovered days as unknown rather than zero-income promises

### Required warning examples

- `Only part of this window has scheduled shifts, so this total may be lower than what you actually earn.`
- `No future shifts are currently scheduled for much of this range yet.`

This keeps the forecast trustworthy even when it feels less impressive.

## 9. Earnings Goal Tracking Behavior

Release one goal tracking should focus on monthly gross earnings targets.

### Goal model requirements

- one optional monthly goal per job
- goal stored in minor units
- goal compared against projected earnings for the relevant month
- progress shown as both amount and percentage

### Goal-status states

- `on_track`
- `at_risk`
- `off_track`
- `not_enough_data`

### Initial rules

- `on_track`: projected earnings meet or exceed goal with medium or high confidence
- `at_risk`: projected earnings are within 10 percent below goal or confidence is low with partial coverage
- `off_track`: projected earnings are meaningfully below goal with enough coverage to trust the warning
- `not_enough_data`: there is too little future schedule coverage to judge pace responsibly

### Messaging principles

- prefer calm progress language over pressure language
- highlight what is known versus what is still missing
- if confidence is low, lead with that before implying the goal is missed

## 10. Extra-Shift Simulation Behavior

### Release-one simulation rules

- simulate one additional shift at a time
- use an existing shift template first when available
- calculate projected pay impact without saving the shift
- respect basic and advanced pay rules
- apply the simulated shift only inside the current forecast window

### Output expectations

- additional projected pay
- updated forecast total
- whether the added shift changes goal status
- whether the added shift likely triggers overtime or differential changes

### Guardrails

- simulation is advisory only
- the app should not imply the shift is guaranteed or actually scheduled

## 11. Forecast Output Shape

The forecast domain model supports:

- selected range
- projected gross pay
- projected base, overtime, holiday, allowance, and differential totals where available
- coverage metadata
- confidence level
- confidence warnings
- monthly-goal progress summary when applicable
- future hook for best-case or simulated totals

## 12. UX Guidance

- lead with one clear projected total, then explain confidence directly below it
- show coverage in plain language such as `18 of 30 days covered`
- avoid finance jargon like `confidence interval`
- if confidence is low, offer helpful next steps such as adding future shifts or importing a rota later
- tie Premium prompts to the moment a user wants deeper planning insight, not before they see a partial result

## 13. Testing Guidance

Automated coverage includes:

- empty 30-day window
- partial 30-day window with low confidence
- near-complete 60-day window with medium or high confidence
- 90-day window with generated repeating pattern coverage
- monthly goal on-track classification
- monthly goal at-risk classification
- monthly goal not-enough-data classification
- extra-shift preview affecting overtime or goal status

## 14. Open Risks And Carry-Forwards

- repeating patterns may make longer windows look more certain than real-life rosters if the user has frequent manual changes
- month-based goals and rolling forecast windows will need careful UX wording when they overlap imperfectly
- future import features should increase coverage, but forecast confidence must still reflect missing days honestly
- if a user has no future schedule at all, the product should prefer a helpful empty state over a misleading zero-income total

## 15. Implementation Notes

- `IncomeForecastSummary` now carries projected pay totals, coverage metadata, confidence, warnings, and optional monthly goal progress
- the first forecast use case reuses generated schedules plus the existing gross-pay calculator instead of maintaining a separate pay-calculation path
- coverage now counts days explained by active pattern entries or saved overrides, not only days with paid shifts
- current automated coverage includes empty, sparse partial, and fully covered forecast windows, plus advanced-rule totals and monthly goal progress

- forecast summaries now include overtime-target progress alongside earnings-goal progress
- target tracking is centralized in `ForecastTargetTracker` so goal and overtime status rules stay consistent
- the forecast model now emits user-facing nudges for on-track, at-risk, off-track, and not-enough-data target states
- partial-coverage rules now directly influence both earnings-goal and overtime-target status so the app avoids overconfident target messaging

- the forecast UI now lives in a dedicated `ForecastScreen` launched from Pay
- users can switch between 30-day, 60-day, and 90-day views and move the anchor window backward or forward
- the screen shows current scheduled totals, coverage, confidence, and a clearly-labeled pace scenario when the forecast window is only partially covered
- Premium teaser copy is now tied to forecast-insight intent rather than shown only from a generic upgrade page

- forecast planning now includes an `Extra-shift simulation` card for Premium users on the forecast screen
- users can choose one saved shift template and one day inside the active forecast window, then preview the result without saving anything
- the simulation reuses the same gross-pay calculator as the main forecast so overtime, advanced differentials, allowances, and break behavior stay aligned
- preview output now shows added pay, updated total, added worked time, and labels when overtime, differential, or allowance behavior changes
- a dedicated simulation use case plus widget coverage now protects the non-persistent what-if flow and out-of-range validation
