#' Application server
#'
#' Wires the data upload, validation preview, and visual analytics modules
#' together.
#'
#' @param input,output,session Standard Shiny server arguments.
#' @noRd
app_server <- function(input, output, session) {
  data <- data_upload_server('Upload')

  preview_validation_server('Preview_Validation', data)

  visual_analytics_server('Visual_Analytics', data)

  observeEvent(input$main_nav, {
    updateTabsetPanel(session, "main_content", selected = input$main_nav)
  })

  observe({
    has_data <- tryCatch(!is.null(data()), error = function(e) FALSE)
    session$sendCustomMessage("toggle_nav_data", has_data)
  })
}
