#' Application UI
#'
#' Builds the top-level UI: a sidebar acting as a page menu (Upload /
#' Validation / Analysis), and a main panel whose content switches to
#' match the selected menu item.
#'
#' @return A `bslib` page UI definition.
#' @import shiny
#' @import bslib
#' @importFrom shinyFeedback useShinyFeedback
#' @noRd
app_ui <- function() {
  page_sidebar(
    title = "Expense Monitor",
    theme = app_theme(),
    sidebar = sidebar(
      width = 260,
      app_nav_menu(
        choices = c("Upload", "Validation", "Analysis"),
        icons = c("file-arrow-up", "patch-check", "bar-chart"),
        requires_data = c(FALSE, TRUE, TRUE)
      )
    ),
    useShinyFeedback(),
    tabsetPanel(
      id = "main_content",
      type = "hidden",
      tabPanelBody(
        "Upload",
        h4("Upload receipts"),
        div(
          class = "upload-page",
          data_upload_ui('Upload')
        )
      ),
      tabPanelBody(
        "Validation",
        preview_validation_ui('Preview_Validation')
      ),
      tabPanelBody(
        "Analysis",
        h4("Visual analytics"),
        visual_analytics_ui('Visual_Analytics')
      )
    )
  )
}
