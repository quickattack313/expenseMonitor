#' Validate an uploaded receipts data set
#'
#' Checks a data frame against the expected receipts schema: presence of
#' the required columns, counts of missing values per column, and rows
#' where `Price` or `Amount` are not strictly positive.
#'
#' Expected input columns:
#' \itemize{
#'   \item `Id` (character)
#'   \item `Store` (character)
#'   \item `Item` (character)
#'   \item `Price` (numeric, > 0)
#'   \item `Amount` (numeric, > 0)
#' }
#'
#' @param df A data frame (or tibble) to validate.
#'
#' @return A list with:
#' \describe{
#'   \item{required_cols}{The full set of required column names.}
#'   \item{missing_cols}{Required columns absent from `df`.}
#'   \item{na_counts}{Named vector of `NA` counts per column, or `NULL`
#'     if columns are missing.}
#'   \item{price_error}{Logical vector flagging rows where `Price <= 0`,
#'     or `NULL` if columns are missing.}
#'   \item{amount_error}{Logical vector flagging rows where `Amount <= 0`,
#'     or `NULL` if columns are missing.}
#' }
#' @export
#'
#' @examples
#' df <- data.frame(
#'   Id = "1", Store = "Store1", Item = "Bread",
#'   Price = 5, Amount = 1
#' )
#' data_validate(df)
#' Required receipt columns
#'
#' Single source of truth for the expected receipts schema, shared by
#' \code{\link{data_validate}} and the upload page's column hint.
#'
#' @return Character vector of required column names.
#' @noRd
required_columns <- function() {
  c('Id', 'Store', 'Item', 'Price', 'Amount')
}

data_validate <- function(df) {

  req_cols <- required_columns()
  mis_cols <- setdiff(req_cols, colnames(df))
  if (length(mis_cols) > 0) {
    return(
      list(
        required_cols = req_cols,
        missing_cols = mis_cols,
        na_counts = NULL,
        price_error = NULL,
        amount_error = NULL
      )
    )
  } else{
    na_cnt <- colSums(is.na(df))
    prc_err <- df$Price <= 0
    amnt_err <- df$Amount <= 0
    return(
      list(
        required_cols = req_cols,
        missing_cols = mis_cols,
        na_counts = na_cnt,
        price_error = prc_err,
        amount_error = amnt_err
      )
    )
  }
}
