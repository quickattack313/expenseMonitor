
data_validate <- function(df) {
  
  req_cols <- c('Id', 'Store', 'Item', 'Price', 'Amount')
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






