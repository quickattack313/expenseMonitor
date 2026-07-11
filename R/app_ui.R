#' Application UI
#'
#' Builds the top-level UI: a data upload / validation tab and a visual
#' analytics tab.
#'
#' @return A `bslib` page UI definition.
#' @import shiny
#' @import bslib
#' @importFrom shinyFeedback useShinyFeedback
#' @noRd
app_ui <- function() {
  page_fillable(
    theme = app_theme(),
    useShinyFeedback(),
    app_theme_toggle(),
    navset_card_tab(
      nav_panel(
        "1. Start",
        data_upload_ui('Upload'),
        preview_validation_ui('Preview_Validation')
      ),
      nav_panel(
        "2. Visual Analytics",
        visual_analytics_ui('Visual_Analytics')
      )
    ),
    id = "tab"
  )
}
