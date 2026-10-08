# ShiftMate Pay - Import Specification

## 1. Goal

Define the first import slice so ShiftMate Pay can save users setup time without weakening trust in the schedule or pay model.

Release one should help a user say:

- `I can bring in a rota faster than entering every shift by hand`
- `I can see what will happen before anything is saved`
- `I can catch conflicts before they overwrite my existing schedule`

## 2. Release-One Scope Lock

### In scope

- CSV import only for the first paid release
- local file selection and parsing
- dry-run preview before save
- accepted, skipped, duplicate, and conflicted row states
- import into one selected job at a time
- creation of direct shift instances from accepted rows
- optional creation of reusable shift templates from recurring imported shapes when the user confirms later in the flow

### Explicitly out of scope for release one

- screenshot import
- PDF import
- OCR
- cloud-drive integrations
- email inbox parsing
- automatic template generation without user review
- multi-job auto-matching from one file
- payroll-system-specific adapters

## 3. Import Rollout Order

### Phase 1 - release one

- CSV file import
- manual review and confirmation
- conflict detection against existing saved schedule data

### Phase 2 - immediate post-release backlog

- screenshot import spike based on common rota screenshots
- PDF rota parsing spike for export-style schedules
- OCR privacy and on-device feasibility review

### Phase 3 - later backlog

- employer-specific presets
- remembered column mapping profiles
- smarter repeated-template suggestions

## 4. Supported CSV Model

Import should support one row per shift.

### Required minimum fields

- `date`
- `start_time`
- `end_time`

### Supported optional fields

- `job_name`
- `shift_name`
- `category`
- `unpaid_break_minutes`
- `is_holiday`
- `notes`

### Accepted header aliases

The parser should accept a small alias list instead of forcing one exact export format.

| Canonical field | Accepted headers |
| --- | --- |
| `date` | `date`, `shift_date`, `day` |
| `start_time` | `start`, `start_time`, `clock_in`, `from` |
| `end_time` | `end`, `end_time`, `clock_out`, `to` |
| `job_name` | `job`, `job_name`, `role`, `location` |
| `shift_name` | `shift_name`, `template`, `shift`, `label` |
| `category` | `category`, `type`, `shift_type` |
| `unpaid_break_minutes` | `break`, `break_minutes`, `unpaid_break_minutes` |
| `is_holiday` | `holiday`, `is_holiday`, `bank_holiday` |
| `notes` | `notes`, `note`, `comment`, `comments` |

## 5. CSV Tolerances

Release one should be forgiving about common spreadsheet exports, but not so permissive that it silently creates bad shifts.

### Date tolerances

- support ISO dates such as `2026-04-04`
- support common local-style dates such as `04/04/2026` and `4/4/26`
- support month-name dates such as `4 Apr 2026`
- reject ambiguous date strings if locale inference is unsafe

### Time tolerances

- support 24-hour times such as `19:30`
- support 12-hour times such as `7:30 PM`
- support hour-only values such as `7 PM`
- normalize whitespace and casing
- reject rows where start and end cannot be parsed confidently

### Value tolerances

- trim surrounding whitespace
- treat empty optional fields as null
- normalize `yes`, `true`, `1` to holiday `true`
- normalize `no`, `false`, `0` to holiday `false`
- accept break values in whole minutes only for release one

## 6. Mapping Rules

### Import target

- the user selects one destination job before final import
- rows do not create new jobs in release one
- `job_name` is treated as advisory copy for preview, not as an automatic job-creation signal

### Direct shift creation

Accepted rows should become direct `ShiftInstance` records when:

- date, start, and end parse successfully
- the row is not a duplicate
- the row does not conflict with an existing saved shift in a way that needs review

Imported shifts should use:

- `source = imported`
- parsed holiday flag when present
- parsed break minutes when present, otherwise template/default fallback later
- note text from the file when present

### Template creation rules

Release one should not create templates automatically during CSV import.

Instead:

- the preview layer may identify repeated imported shift shapes
- those repeated shapes can be surfaced later as template suggestions
- template creation remains a separate explicit user action

This keeps import review focused on trust and correctness first.

### Override vs direct shift rules

Import should create a manual-style direct shift record for accepted rows, then let the existing schedule engine treat it as an override where applicable.

Use import as an override when:

- there is already generated schedule coverage on the same job and date
- the imported row clearly replaces what the generated pattern would have shown that day

Use import as a direct shift when:

- there is no existing shift on that date
- the imported row adds future schedule coverage that was previously missing

## 7. Conflict Handling Design

The preview must classify every row before save.

### Accepted

- row parsed successfully
- no existing shift on the same job/date/time meaningfully overlaps

### Duplicate

- imported row matches an existing saved shift closely enough that saving it again would create noise
- first release duplicate match should use same date plus same normalized start and end time

### Conflict

- imported row overlaps a saved shift for the same job/day but differs in time, holiday flag, break, or notes
- imported row would replace a generated or manually edited day in a non-trivial way

### Skipped

- required fields missing
- parsing failed
- row resolves to an invalid shift such as zero-length duration without an overnight interpretation

## 8. Review Flow

Release one review should follow this order:

1. choose file
2. parse and normalize rows
3. show preview summary counts
4. show accepted rows first
5. show duplicates, conflicts, and skipped rows in separate sections
6. require explicit confirm before saving accepted rows

### Review principles

- never save immediately after parsing
- lead with plain-language explanations, not import jargon
- keep row-level reasons short and actionable
- allow users to back out without changing existing schedule data

## 9. Conflict Resolution Rules For Release One

Release one should keep conflict resolution intentionally simple:

- accepted rows can be imported in batch
- duplicate rows are skipped by default
- conflicted rows are excluded from the batch and shown for manual follow-up
- users resolve conflicts by editing schedule data manually after preview, not by inline merge tools yet

This avoids building a brittle merge UI too early.

## 10. Preview Output Requirements

The import preview model should expose:

- total rows seen
- accepted row count
- duplicate row count
- conflict row count
- skipped row count
- row-level normalized shift values
- row-level reason codes and user-facing messages

## 11. Premium and UX Positioning

- CSV import is a Premium feature because it saves real setup time
- the paywall should appear after preview value is visible, near confirmation intent
- free users should be able to understand what the import would do before being asked to upgrade

## 12. Testing Guidance

Automated coverage includes:

- header alias handling
- mixed date and time formats
- whitespace and boolean normalization
- malformed rows with clear error messages
- duplicate detection against saved shifts
- conflict classification against generated and manual schedule data
- dry-run preview counts and row-state grouping

## 13. Open Risks And Carry-Forwards

- date-format ambiguity can silently create bad schedules if the parser is too permissive
- imported rows may conflict with generated schedule patterns more often than users expect
- some rota exports use separate duration columns instead of end time; that stays out of scope for release one
- screenshot and PDF import remain valuable, but should only follow once CSV trust and preview behavior are solid

## 14. Implementation Notes

- CSV parsing now lives in a dedicated `CsvShiftImportParser` service
- the parser supports the release-one header aliases defined in this spec instead of one rigid export format
- date parsing now accepts ISO, month-name, and common slash formats while rejecting ambiguous slash dates that could silently create the wrong shifts
- time parsing now supports 24-hour, 12-hour, and hour-only inputs, including overnight normalization when end time falls before start time
- parser coverage now includes realistic rota-like rows plus malformed, ambiguous, and invalid-value cases

- dry-run preview building now lives in `BuildShiftImportPreviewUseCaseImpl` backed by `ShiftImportPreviewBuilder`
- parsed rows are mapped into proposed imported `ShiftInstance` records without persistence
- preview rows are classified into accepted, duplicate, conflict, and skipped states with short user-facing reasons
- duplicate detection now handles close matches against existing saved shifts, while overlap detection surfaces generated and manual schedule conflicts for review
- preview totals now expose accepted, duplicate, conflict, and skipped counts for the review-before-save screen
