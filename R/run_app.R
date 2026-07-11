#' Run the expenseMonitor Shiny application
#'
#' Launches the expenseMonitor app, which lets you upload a receipts data
#' set (CSV or Excel), validates it against the expected column schema, and
#' provides interactive visual analytics of your expenses.
#'
#' @param ... Additional arguments passed on to \code{\link[shiny]{shinyApp}}.
#'
#' @return A Shiny application object (as returned by \code{shinyApp}); when
#'   run interactively this starts the app.
#' @export
#' @importFrom shiny shinyApp
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function(...) {
  shinyApp(ui = app_ui(), server = app_server, ...)
}
