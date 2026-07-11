#' Data upload module UI
#'
#' @param id Module namespace id.
#'
#' @return A `tagList` with a file input and an upload button.
#' @export
#' @import shiny
#' @import bslib
data_upload_ui <- function(id) {
  ns <- NS(id)
  tagList(
    card(
      card_header('Upload'),
      card_body(
        fill = TRUE,
        max_height = 600,
        fileInput(ns('data_file'), 'Choose CSV or Excel File', accept = c('.xlsx', '.csv')),
        actionButton(ns('upload_button'), 'Upload!')
      )
    )
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

      observeEvent(input$data_file, {
        hideFeedback('data_file')
      })

      return(data)

  })
}
