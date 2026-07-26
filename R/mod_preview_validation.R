#' Preview & validation module UI
#'
#' Two plain (cardless) subsections, matching the Upload page's style:
#' "Validation" (three summary value boxes) and "Preview" (a filterable,
#' paginated data table).
#'
#' @param id Module namespace id.
#'
#' @return A `tagList` with the validation boxes and the preview table.
#' @export
#' @import shiny
preview_validation_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h4("Validation"),
    uiOutput(ns('validation_boxes')),
    h4("Preview", class = "mt-5"),
    DT::dataTableOutput(ns('data_table'))
  )
}

#' Preview & validation module server
#'
#' Shows a preview of the uploaded data (filterable, 10 rows per page)
#' and runs it through \code{\link{data_validate}}, rendering the
#' results as value boxes (missing values, non-positive prices,
#' non-positive amounts).
#'
#' @param id Module namespace id.
#' @param data Reactive holding the uploaded data, as returned by
#'   \code{\link{data_upload_server}}.
#'
#' @return `NULL`, invisibly. Called for its Shiny rendering side effects.
#' @export
#' @import shiny
#' @import bslib
#' @importFrom dplyr if_else
preview_validation_server <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {

      output$data_table <- DT::renderDataTable({
        req(data())
        data()
      }, filter = 'top', rownames = FALSE, options = list(pageLength = 10))


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
            showcase = lucide_icon('triangle-alert'),
            theme_color = if(sum(v$na_counts) == 0) "success" else "warning",
            lapply(
              c(sprintf("%d %s", v$na_counts[v$na_counts>0],
                        names(v$na_counts[v$na_counts>0]) )),
              p
            )
          ),
          value_box(
            title = 'Price ≤ 0',
            value = sum(v$price_error, na.rm = TRUE),
            showcase = lucide_icon("badge-dollar-sign"),
            theme_color = if(sum(v$price_error, na.rm = TRUE) == 0) "success" else "warning",
          ),
          value_box(
            title = 'Amount ≤ 0',
            value = sum(v$amount_error, na.rm = TRUE),
            showcase = lucide_icon("shopping-basket"),
            theme_color = if(sum(v$amount_error, na.rm = TRUE) == 0) "success" else "warning"
          )
        )

      })


  })
}
