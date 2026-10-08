# ShiftMate Pay - Pay Verification Specification

## 1. Purpose

This document defines the first paid "expected vs actual pay" feature so ShiftMate Premium can help users compare what they believe they earned against what they were actually paid.

## 2. Product Outcome

The feature should answer:

- "Does this payslip look right?"
- "Am I missing overtime, holiday uplift, or allowances?"
- "Where is the mismatch likely coming from?"

The feature should not claim legal certainty. It should provide a structured confidence tool for users.

## 3. Core User Flow

1. user selects a job and pay period
2. app calculates expected pay from schedule and rule data
3. user enters actual payslip values
4. app compares expected and actual totals
5. app highlights likely discrepancy categories
6. app explains what may be missing or inconsistent

## 4. Scope For Release One

### In scope
- manual payslip entry
- expected vs actual comparison
- variance totals
- discrepancy categorization
- plain-language explanations

### Out of scope
- payslip OCR
- automatic payroll import
- tax filing
- legal payroll compliance guarantees
- dispute letter generation

## 5. Payslip Entry Model

Recommended core fields:

- `id`
- `jobId`
- `periodStart`
- `periodEnd`
- `paidAt`
- `grossPayMinor`
- `workedMinutesReported` optional
- `overtimePayMinor` optional
- `holidayPayMinor` optional
- `allowancesMinor` optional
- `notes` optional
- `source` (`manual`)
- `createdAt`
- `updatedAt`

Release one should keep entry friction low. The only truly required field should be gross pay for the selected period, with optional detail fields improving comparison quality.

Entry point:
- the initial UX should launch from the Pay screen with `jobId`, `periodStart`, and `periodEnd` prefilled from the selected summary context
- users should not edit the period inline in release one; they should change the selected period from the Pay screen first

## 6. Comparison Model

Recommended output:

`PayVerificationSummary`
- expectedGrossPayMinor
- actualGrossPayMinor
- totalVarianceMinor
- varianceDirection
- confidence
- discrepancyItems[]
- comparisonWarnings[]

Implementation notes:
- `PayVerificationSummary` now carries variance direction, confidence, comparison type, category-level deltas, and comparison warnings
- current category deltas cover gross pay, overtime, holiday pay, allowances/differentials, and worked minutes when reported
- exact-versus-likely classification is now driven by how much payslip detail is available
- discrepancy items carry with severity, confidence, explanations, and next-step guidance for likely overtime, holiday, allowance, rate-mismatch, shift-gap, incomplete-detail, and complex-rule cases
- the in-app verification screen launches from Pay, with locked period context, local payslip save/edit/delete, expected-vs-actual totals, discrepancy cards, and Premium gating on compare/discrepancy intent

### Variance direction
- `match`
- `underpaid`
- `overpaid`
- `uncertain`

## 7. Discrepancy Categories

The first version should classify likely issues into:

- missing overtime
- missing holiday uplift
- missing allowance
- rate mismatch
- missing or extra shift
- incomplete payslip data
- unsupported rule complexity

## 8. Confidence Model

Confidence should depend on:

- completeness of payslip fields
- completeness of schedule coverage in the selected period
- whether advanced pay rules are enabled
- whether unsupported rule combinations are present

Recommended output levels:

- `high`
- `medium`
- `low`

If confidence is low, the app should say so clearly.

## 9. Comparison Rules

### Exact-match path
If the user enters only gross pay:
- compare expected gross with actual gross
- return simple variance plus general explanations

### Detailed comparison path
If the user also enters component values:
- compare overtime values independently
- compare holiday-related values independently
- compare allowances independently
- use category-specific discrepancy messaging

## 10. Explanation Layer

Each discrepancy item should include:

- short label
- severity
- confidence
- expected amount
- actual amount if available
- plain-language explanation
- suggested next step

### Example explanation
"Expected overtime pay for this period appears higher than the amount entered from your payslip. Review whether overtime hours were paid at the correct rate."

## 11. Severity Model

Recommended severity levels:

- `info`
- `warning`
- `high`

### Suggested use
- `info`: small mismatch or incomplete detail
- `warning`: likely meaningful mismatch
- `high`: large mismatch with high confidence and clear likely cause

## 12. Persistence Requirements

The app should allow users to:

- create a payslip comparison record
- edit it later
- delete it
- keep all data local-first

The user must be able to revisit previous comparisons without recalculating from memory.

## 13. UX Requirements

The UI should:

- use plain language instead of payroll jargon where possible
- keep required input minimal
- avoid panic-inducing warnings
- always show confidence and assumptions
- explain that results are estimates based on available data

Entry form decisions:
- release one should use a single-screen entry form rather than a wizard
- gross pay is the only required user-entered field
- overtime, holiday pay, allowances, worked time, paid date, and notes remain optional
- missing optional fields should lower confidence later instead of blocking save

## 14. Edge Cases

The feature must handle:

- partial schedule coverage in the selected period
- manual overrides after the period has already been compared
- missing optional payslip fields
- jobs with only basic rules enabled
- rule setups the engine cannot confidently model

## 15. Required Tests

### Comparison tests
- exact gross match
- gross underpayment
- gross overpayment
- missing overtime classification
- missing holiday uplift classification
- incomplete payslip lowers confidence

### Persistence tests
- create/edit/delete payslip record
- correct job and period mapping

### UX tests
- empty state
- no discrepancy state
- low-confidence warning state

## 16. Premium Gating Guidance

The premium gate should appear when the user attempts to:

- save a payslip record
- view a full discrepancy explanation
- compare expected and actual pay beyond a teaser summary

This keeps the premium prompt tied to a moment of real intent.

## 17. Related Docs

- [Advanced pay rules spec](advanced-pay-rules-spec.md)
- [Base pay rules spec](pay-rules-spec.md)
