
# Input data:
# Id        : character
# Store     : character
# Item      : character
# Price     : numeric > 0
# Amount    : numeric > 0

library(shiny)
library(bslib)
library(bsicons)
library(dplyr)
library(tidyr)
library(tools)
library(readr)
library(readxl)
library(magrittr)
library(shinyFeedback)
library(ggplot2)
library(plotly)
library(calendR)
library(ggimage)
library(uuid)
library(lubridate)

source('R/validation.R')
source('R/modules/data_upload_module.R')
source('R/modules/preview_validation_module.R')
source('R/modules/visual_analytics_module.R')


# Define UI for application that draws a histogram
ui <- page_fillable(
    useShinyFeedback(),
    navset_card_tab(
        nav_panel(
            "1. Start",
            data_upload_ui('Upload'),
            preview_validation_ui('Preview_Validation')
        ),
        nav_panel("2. Filters", "Page B content"),
        nav_panel("3. Statistics", "Page C content"),
        nav_panel("4. Visual Analytics", 
                  visual_analytics_ui('Visual_Analytics'),
                  
                  "Page D content"),
        nav_menu(
            "Other links",
            nav_panel("D", "Panel D content"),
            "----",
            "Description:",
            nav_item(a(
                "Shiny", href = "https://shiny.posit.co", target = "_blank"
            )),
        ),
    ),
    id = "tab"
)



server <- function(input, output) {

    
    data <- data_upload_server('Upload')
    
    preview_validation_server('Preview_Validation', data)

    visual_analytics_server('Visual_Analytics', data)
    
    

}

# Run the application 
shinyApp(ui = ui, server = server)
