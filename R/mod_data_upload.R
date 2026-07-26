#' Locate the bundled sample receipts file
#'
#' Works whether or not the app is running as an installed package:
#' `system.file()` finds it when expenseMonitor is installed, and this
#' falls back to a path relative to the working directory otherwise
#' (e.g. Posit Connect Cloud's git-based deploys, which run app.R
#' directly against the loose repo checkout -- see `app.R`).
#'
#' @return Path to `receipts_test.xlsx`.
#' @noRd
sample_file_path <- function() {
  installed_path <- system.file("extdata", "receipts_test.xlsx", package = "expenseMonitor")
  if (nzchar(installed_path)) return(installed_path)
  file.path("inst", "extdata", "receipts_test.xlsx")
}

#' Data upload module UI
#'
#' Rendered as a centered "dropzone" card on the Upload page, with a
#' "Try with example data..." link below the Browse/Upload row that
#' loads the bundled sample file directly (no real upload needed).
#' Followed by the required-columns hint, then a success banner that
#' only appears once a file has actually been processed successfully.
#'
#' @param id Module namespace id.
#'
#' @return A `tagList` with a file input, an upload button, the
#'   example-data shortcut, the required-columns hint, and the
#'   upload-status banner.
#' @export
#' @import shiny
data_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "upload-dropzone",
      tags$p(class = "upload-hint", "Drag a file here or click to browse"),
      div(
        class = "upload-input-row",
        fileInput(ns('data_file'), NULL, accept = c('.xlsx', '.csv')),
        actionButton(ns('upload_button'), 'Upload!')
      ),
      actionButton(ns('try_example'), 'Try with example data...', class = "upload-try-example")
    ),
    tags$p(
      class = "upload-columns-hint",
      bsicons::bs_icon("info-circle"),
      sprintf(" Required columns: %s", paste(required_columns(), collapse = ", "))
    ),
    uiOutput(ns('upload_status'))
  )
}

#' Data upload module server
#'
#' Reads the uploaded CSV or Excel file into a tibble when the upload
#' button is clicked, or loads the bundled sample file when "Try with
#' example data..." is clicked instead. Unsupported file extensions
#' surface a \pkg{shinyFeedback} warning instead of failing silently.
#'
#' @param id Module namespace id.
#'
#' @return A reactive holding the uploaded data as a tibble, or `NULL` if
#'   no valid file has been uploaded yet.
#' @export
#' @import shiny
#' @import shinyFeedback
#' @importFrom tools file_ext
#' @importFrom dplyr as_tibble
data_upload_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

      data_val <- reactiveVal(NULL)
      uploaded_name <- reactiveVal(NULL)

      observeEvent(input$upload_button, {
        req(input$data_file)
        ext <- input$data_file$name %>% file_ext()

        if (ext == 'csv'){
          hideFeedback('data_file')
          data_val(input$data_file$datapath %>% readr::read_csv() %>% as_tibble())
          uploaded_name(input$data_file$name)

        } else if (ext == 'xlsx') {
          hideFeedback('data_file')
          data_val(input$data_file$datapath %>% readxl::read_excel() %>% as_tibble())
          uploaded_name(input$data_file$name)

        }
        else{
          showFeedbackWarning(
            inputId = 'data_file',
            text = 'Read CSV or Excel file!'
          )
        }

      })

      observeEvent(input$try_example, {
        data_val(sample_file_path() %>% readxl::read_excel() %>% as_tibble())
        uploaded_name("receipts_test.xlsx")
      })

      observeEvent(input$data_file, {
        hideFeedback('data_file')
        uploaded_name(NULL)
      })

      output$upload_status <- renderUI({
        req(uploaded_name())
        div(
          class = "upload-success-box",
          bsicons::bs_icon("check-circle", class = "upload-success-icon"),
          div(class = "upload-success-text", sprintf("%s uploaded successfully!", uploaded_name()))
        )
      })

      return(data_val)

  })
}
