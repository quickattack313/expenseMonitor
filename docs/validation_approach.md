# Validation approach

> This is a lightweight, illustrative example of a **Computer System
> Validation (CSV)**-style approach, written to demonstrate the concept —
> it is **not** a formal GxP validation package. In regulated environments
> (e.g. pharma, under FDA 21 CFR Part 11 / EU Annex 11), any computer
> system used to generate data feeding into a regulated process must have
> documented evidence that it behaves correctly and consistently:
> requirements are written down, tests are written against them, and a
> traceability matrix ties the two together so gaps in coverage are
> visible rather than assumed away.

## User requirements

| ID | Requirement | Implemented in |
|----|-------------|-----------------|
| REQ-01 | The system shall identify and report any required column (`Id`, `Store`, `Item`, `Price`, `Amount`) missing from the uploaded data set. | `data_validate()` — `R/validation.R` |
| REQ-02 | The system shall count missing (`NA`) values per column, once all required columns are present. | `data_validate()` — `R/validation.R` |
| REQ-03 | The system shall flag every row where `Price <= 0`. | `data_validate()` — `R/validation.R` |
| REQ-04 | The system shall flag every row where `Amount <= 0`. | `data_validate()` — `R/validation.R` |
| REQ-05 | The system shall accept only `.csv` and `.xlsx` uploads, and show a visible warning for any other file type instead of failing silently. | `data_upload_server()` — `R/mod_data_upload.R` |

## Traceability matrix

| Requirement | Test | Status |
|-------------|------|--------|
| REQ-01 | `test_that('missing columns', ...)` — `tests/testthat/test-validation.R` | Covered |
| REQ-02 | `test_that('missing columns', ...)` (`na_counts` assertions) and `test_that('Price is different than a number > 0', ...)` — `tests/testthat/test-validation.R` | Covered |
| REQ-03 | `test_that('Price is different than a number > 0', ...)` — `tests/testthat/test-validation.R` | Covered |
| REQ-04 | `test_that('Amount is different than a number > 0', ...)` — `tests/testthat/test-validation.R` | Covered |
| REQ-05 | — | **Not covered.** `data_upload_server()` is Shiny reactive/UI logic and isn't exercised by `testthat` unit tests. Closing this gap would require an integration test with [`{shinytest2}`](https://rstudio.github.io/shinytest2/) driving a real browser session (upload a `.txt` file, assert the `shinyFeedback` warning appears). |

REQ-04 was added to this matrix *before* a corresponding test existed —
building the matrix surfaced that `Amount <= 0` had no test case even
though `data_validate()` already computed `amount_error`. The missing
test (`test_that('Amount is different than a number > 0', ...)`) was
added to close that gap, which is the traceability matrix doing its job:
making a real coverage hole visible instead of leaving it implicit.

## Scope note

A real CSV package for a regulated system would additionally include a
signed validation plan, risk assessment, formal test scripts with
execution evidence (screenshots/logs), and change-control records tying
each code change back to a re-validation decision. That's intentionally
out of scope here — the goal of this document is to show the underlying
requirements → tests → traceability pattern, not to claim GxP compliance
for a personal hobby project.
