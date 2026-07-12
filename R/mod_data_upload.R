#' Data upload module UI
#'
#' Rendered as a centered "dropzone" card on the Upload page, followed
#' immediately by the required-columns hint. Below that sits a success
#' banner that only appears once a file has actually been processed
#' successfully, showing the file name.
#'
#' @param id Module namespace id.
#'
#' @return A `tagList` with a file input, an upload button, the
#'   required-columns hint, and the upload-status banner.
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
      )
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
#' button is clicked. Unsupported file extensions surface a
#' \pkg{shinyFeedback} warning instead of failing silently.
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

      data <- eventReactive(input$upload_button, {
        req(input$data_file)
        ext <- input$data_file$name %>% file_ext()

        if (ext == 'csv'){
          hideFeedback('data_file')
          return(input$data_file$datapath %>% readr::read_csv() %>% as_tibble())

        } else if (ext == 'xlsx') {
          hideFeedback('data_file')
          return(input$data_file$datapath %>% readxl::read_excel() %>% as_tibble())

        }
        else{
          showFeedbackWarning(
            inputId = 'data_file',
            text = 'Read CSV or Excel file!'
          )
          return(NULL)
        }

      })

      uploaded_name <- reactiveVal(NULL)

      observeEvent(input$data_file, {
        hideFeedback('data_file')
        uploaded_name(NULL)
      })

      observeEvent(input$upload_button, {
        d <- tryCatch(data(), error = function(e) NULL)
        if (!is.null(d)) {
          uploaded_name(input$data_file$name)
        }
      })

      output$upload_status <- renderUI({
        req(uploaded_name())
        div(
          class = "upload-success-box",
          bsicons::bs_icon("check-circle", class = "upload-success-icon"),
          div(class = "upload-success-text", sprintf("%s uploaded successfully!", uploaded_name()))
        )
      })

      return(data)

  })
}
