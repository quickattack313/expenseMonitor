# expenseMonitor 0.1.0

- Restructured the project from a standalone Shiny script into a proper
  R package (`DESCRIPTION`, `NAMESPACE`, roxygen2-documented functions,
  `testthat` 3rd-edition test suite).
- Moved the bundled sample data set to `inst/extdata/receipts_test.xlsx`
  following R package conventions.
- Added a test case for `Amount <= 0`, closing a coverage gap surfaced
  while writing `docs/validation_approach.md`.
- Added `docs/validation_approach.md`, a lightweight requirements /
  traceability write-up.
- Added a root-level `app.R` and README deployment instructions for
  shinyapps.io ("app-as-package" deployment via `rsconnect`).
