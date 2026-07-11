#' Preview & validation module UI
#'
#' @param id Module namespace id.
#'
#' @return A `tagList` with a data preview table and validation summary
#'   boxes.
#' @export
#' @import shiny
#' @import bslib
preview_validation_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header('Validation'),
      card_body(
        tableOutput(ns('data_table')),
        uiOutput(ns('validation_boxes'))
      ))
  )
}

#' Preview & validation module server
#'
#' Shows a preview of the uploaded data and runs it through
#' \code{\link{data_validate}}, rendering the results as value boxes
#' (missing values, non-positive prices, non-positive amounts).
#'
#' @param id Module namespace id.
#' @param data Reactive holding the uploaded data, as returned by
#'   \code{\link{data_upload_server}}.
#'
#' @return `NULL`, invisibly. Called for its Shiny rendering side effects.
#' @export
#' @import shiny
#' @import bslib
#' @importFrom bsicons bs_icon
#' @importFrom dplyr if_else
preview_validation_server <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {

      output$data_table <- renderTable({
        # Show the uploaded data - no matter if it has required columns
        req(data())
        data() %>% head(5)
      })


      output$validation_boxes <- renderUI({
        req(data())
        v <- data_validate(data())

        validate(
          need(length(v$missing_cols) == 0,
               paste(if_else(length(v$missing_cols) > 1, 'Missing columns:', 'Missing column: '),
                     paste(v$missing_cols, collapse = ', ')))
        )

        layout_columns(
          value_box(
            title = 'Missing values',
            value = sum(v$na_counts),
            showcase = bs_icon('exclamation-triangle'),
            theme_color = if(sum(v$na_counts) == 0) "success" else "warning",
            lapply(
              c(sprintf("%d %s", v$na_counts[v$na_counts>0],
                        names(v$na_counts[v$na_counts>0]) )),
              p
            )
          ),
          value_box(
            title = 'Price \u2264 0',
            value = sum(v$price_error, na.rm = TRUE),
            showcase = bs_icon("currency-dollar"),
            theme_color = if(sum(v$price_error, na.rm = TRUE) == 0) "success" else "warning",
          ),
          value_box(
            title = 'Amount \u2264 0',
            value = sum(v$amount_error, na.rm = TRUE),
            showcase = bs_icon("cart"),
            theme_color = if(sum(v$amount_error, na.rm = TRUE) == 0) "success" else "warning"
          )
        )

      })


  })
}
