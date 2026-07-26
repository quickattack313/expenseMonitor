# expenseMonitor

A small Shiny application, packaged as a proper R package, for uploading,
validating, and visually exploring personal expense data extracted from
receipts.

Upload a CSV or Excel file of receipt line items, get immediate feedback
on schema/data-quality issues (missing columns, missing values, non-positive
prices or amounts), then explore daily spending through an interactive
plot.

## Installation

```r
# install.packages("remotes")
remotes::install_github("quickattack313/expenseMonitor")
```

## Usage

```r
library(expenseMonitor)
run_app()
```

Expected input columns: `Id`, `Store`, `Item`, `Price` (numeric, > 0),
`Amount` (numeric, > 0).

To try the app without your own data, upload the sample file bundled at
`system.file("extdata", "receipts_test.xlsx", package = "expenseMonitor")`
on the Upload page.

## Live demo

Deployed on shinyapps.io:https://019f5d05-54a4-c8ab-6d18-f898d6de2f72.share.connect.posit.cloud/

## Project structure

This is a regular R package (`DESCRIPTION`, `NAMESPACE`, roxygen2-documented
functions in `R/`, `testthat` unit tests in `tests/`), not a bare Shiny
script. The root-level `app.R` is a thin entry point used for
`rsconnect`/shinyapps.io "app-as-package" deployment — it installs the
package from `DESCRIPTION` and calls `run_app()`.

- `R/mod_*.R` — Shiny modules (upload, validation preview, visual analytics)
- `R/validation.R` — `data_validate()`, the core validation logic
- `R/run_app.R` — public entry point
- `docs/validation_approach.md` — a lightweight CSV (Computer System
  Validation)-style requirements/traceability write-up

## Deployment

To deploy to your own shinyapps.io account:

```r
install.packages("rsconnect")

# One-time account setup — copy the token/secret from
# https://www.shinyapps.io/admin/#/tokens into this call, run locally:
rsconnect::setAccountInfo(name = "<account>", token = "<token>", secret = "<secret>")

rsconnect::deployApp()
```

## Tests

```r
devtools::test()
# or
testthat::test_dir("tests/testthat")
```
