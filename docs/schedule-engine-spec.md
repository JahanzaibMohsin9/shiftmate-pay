# ShiftMate Pay — Schedule Engine Specification

## 1. Purpose
The schedule engine expands rotating patterns into concrete shift instances that the calendar, pay summaries, reminders, widgets, and exports all consume.

It must be deterministic, timezone-safe, and easy to test.

## 2. Inputs
- active `Job`
- active `ShiftPattern`
- related `ShiftPatternEntry` records
- referenced `ShiftTemplate` records
- manual overrides for the requested date range
- requested date range for expansion
- timezone from the pattern/job context

## 3. Outputs
- expanded list of `ShiftInstance`

Each generated instance must contain enough snapshot data to preserve historical correctness even if the original template changes later.

## 4. Core Rules

### 4.1 Pattern expansion
- pattern expansion starts from the pattern start date
- each day in the visible range maps to a cycle offset using modulo arithmetic
- each cycle offset points to either:
  - a shift template reference, or
  - an off-day marker

### 4.2 Off-days
- if the pattern entry is an off-day, no generated working shift is created for that date

### 4.3 Manual overrides win
- if a manual override exists for a date, it overrides the generated pattern result for that date
- override types may include:
  - replace with manual shift
  - mark as off
  - edit generated times/details

### 4.4 Overnight shifts
- if end time is logically earlier than start time, treat the shift as overnight
- overnight shifts must end on the next calendar day
- duration must still be calculated in total paid minutes minus unpaid breaks

### 4.5 Determinism
- the same inputs must always produce the same expanded instances
- generation must not mutate source templates or source patterns

## 5. Generation Algorithm

### Step 1 — Normalize the request window
- normalize requested range to local day boundaries
- resolve timezone before date math

### Step 2 — Load source records
- load the active pattern
- load all entries for the pattern
- load template references used by the entries
- load manual overrides intersecting the range

### Step 3 — Expand by date
For each date in the requested range:
- check for manual override first
- if override exists, generate the override-based result
- otherwise calculate day offset from pattern start date
- map offset into cycle length
- read matching pattern entry
- if off-day, skip working shift generation
- if shift template exists, generate a `ShiftInstance`

### Step 4 — Materialize timestamps
- combine local date with template start time
- combine local date with template end time
- if end time is before or equal to start time, roll end to the next day
- store paid break data and source metadata

### Step 5 — Return ordered results
- return instances sorted by `startDateTime`

## 6. Recommended Domain Service Shape

```text
PatternExpansionService
- expand({
    pattern,
    entries,
    templates,
    overrides,
    rangeStart,
    rangeEnd,
    timezone,
  }): List<ShiftInstance>
```

## 7. Data Rules
- source of truth stays in local persistence
- generated instances may be cached for performance, but cache must be invalidated after edits affecting schedule output
- manual overrides must preserve enough metadata to explain why an instance differs from the pattern

## 8. Edge Cases

### Required MVP coverage
- 30-day and 31-day month transitions
- leap year February boundaries
- overnight shifts crossing midnight
- pattern starting before the requested window
- pattern starting inside the requested window
- manual off-day override on an otherwise working day
- manual working-day override on an off-day
- deleted or archived templates referenced by old snapshot data

### Timezone and DST expectations
- timezone should be resolved before expansion
- local schedule intent is more important than UTC storage semantics for the user-facing experience
- DST edge cases must not silently corrupt duration or date grouping

## 9. Dependencies on Other Features
- pay engine consumes expanded instances only
- reminders schedule against expanded upcoming instances
- calendar renders expanded instances
- export uses expanded instances for schedule snapshots
- widgets depend on a small future slice of expanded instances
- planning alerts evaluate expanded instances plus user planning settings; planning alerts do not alter schedule generation itself

## 10. Test Matrix

### Unit tests
- cycle mapping correctness
- off-day generation behavior
- override precedence
- overnight end-date rollover
- deterministic output with identical input

### Integration tests
- create pattern → view calendar
- edit one day → verify updated schedule
- modify template → ensure intended generated changes for future use while preserving historical snapshots where applicable

## 11. Non-Goals for MVP
- AI-assisted pattern discovery
- employer roster import
- highly localized labor scheduling rules beyond the current domain model

## 12. Implementation Notes
- the pattern builder currently allows one job-level rotating pattern flow from the jobs area
- users define:
  - pattern name
  - cycle length in days
  - cycle start date
  - active vs inactive status
- every cycle day must be assigned before save to either:
  - a stored `ShiftTemplate`, or
  - an explicit off-day marker
- repository persistence currently enforces a single active pattern per job by deactivating existing active rows when a new active pattern is saved
- pattern entries are replaced atomically per pattern so day-by-day assignments stay in sync with the saved cycle length
- schedule expansion consumes these persisted `ShiftPattern` and `ShiftPatternEntry` records as the authoritative recurrence inputs
