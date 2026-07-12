# Column and derived-variable names referenced via non-standard evaluation
# in dplyr/ggplot2 pipelines (R/mod_visual_analytics.R). Declared here so
# `R CMD check` does not flag them as undefined global variables.
utils::globalVariables(c(
  "Id", "date_raw", "Date", "Receipt_no", "Price", "Expenses",
  "gradient_fill", "Item", "Text", "Var_order", "Tooltip_text",
  "weekday", "month", "week"
))

#' @importFrom utils head
NULL
