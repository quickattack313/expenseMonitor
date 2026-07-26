#' Visual analytics module UI
#'
#' A short description, three summary value boxes (total expenses,
#' receipt count, average per day), the date range filter, and the
#' chart tabs (bar chart / calendar heatmap).
#'
#' @param id Module namespace id.
#'
#' @return A `tagList` with the summary boxes and a `navset_card_tab`
#'   holding the bar chart and calendar heatmap.
#' @export
#' @import shiny
#' @import bslib
#' @import plotly
visual_analytics_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$p(
      class = "section-description",
      "Explore spending patterns over time and identify unusually high expenses."
    ),
    uiOutput(ns('summary_boxes')),
    dateRangeInput(ns('daterange'), "Date range:",
                   start  = "2024-12-01",
                   end    = "2025-01-31",
                   format = "dd/mm/yy"),
    navset_card_tab(
      nav_panel("Bar chart", plotlyOutput(ns('plot1'), height = "600px")),
      nav_panel("Calendar heatmap", plotlyOutput(ns('plot2'), height = "600px"))
    )
  )
}

#' Visual analytics module server
#'
#' Renders three summary value boxes (total expenses, receipt count,
#' average expenses per day), an interactive bar plot of daily expenses
#' (with the most expensive receipts highlighted), and a calendar
#' heatmap of daily expenses over the selected date range.
#'
#' @param id Module namespace id.
#' @param data Reactive holding the uploaded data, as returned by
#'   \code{\link{data_upload_server}}. Expected to contain an `Id` column
#'   of the form `"ddmmyy_receiptNo"` plus `Store`, `Item`, `Category`,
#'   `Price`, and `Amount`.
#'
#' @return `NULL`, invisibly. Called for its Shiny rendering side effects.
#' @export
#' @import shiny
#' @import bslib
#' @import plotly
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import lubridate
visual_analytics_server <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {

      parsed_data <- reactive({
        req(data())
        data() %>%
          separate(Id, into = c('date_raw', 'Receipt_no'), sep = "_") %>%
          mutate(
            Date = as.Date(date_raw, format = "%d%m%y"),
            Receipt_no = as.character(Receipt_no)
          ) %>%
          select(-date_raw) %>%
          select(c('Date', 'Receipt_no', 'Store', 'Item', 'Category', 'Price', 'Amount'))
      })

      output$summary_boxes <- renderUI({
        df <- parsed_data()

        total_expenses <- sum(df$Price)
        receipts_count <- df %>% distinct(Date, Receipt_no) %>% nrow()
        daily_totals <- df %>% group_by(Date) %>% summarize(Expenses = sum(Price), .groups = "drop")
        avg_per_day <- mean(daily_totals$Expenses)

        layout_columns(
          value_box(
            title = "Total expenses",
            value = sprintf("%.2f zł", total_expenses),
            showcase = bsicons::bs_icon("wallet2"),
            theme_color = "success"
          ),
          value_box(
            title = "Receipts",
            value = receipts_count,
            showcase = bsicons::bs_icon("receipt"),
            theme_color = "success"
          ),
          value_box(
            title = "Average per day",
            value = sprintf("%.2f zł", avg_per_day),
            showcase = bsicons::bs_icon("calendar-check"),
            theme_color = "success"
          )
        )
      })

      output$plot1 <- renderPlotly({

        df <- parsed_data()

        df2 <- df %>%
          group_by(Date, Receipt_no) %>%
          summarize(Expenses = sum(Price), .groups = "drop") %>%
          mutate(gradient_fill = ifelse(Expenses > 100, Expenses, NA)) %>%
          arrange(Date, desc(Expenses))

        high_receipts <- df2 %>%
          filter(Expenses > 100) %>%
          select(Date, Receipt_no)

        most_expensive_text <- df %>%
          semi_join(high_receipts, by=c('Date', 'Receipt_no')) %>%
          group_by(Date, Receipt_no) %>%
          slice_max(Price) %>%
          ungroup() %>%
          mutate(Text = paste0(Item, ' (', Price, ' zł)')) %>%
          select(Date, Receipt_no, Text)

        df2 <- df2 %>%
          group_by(Date) %>%
          mutate(Var_order = rank(Expenses, ties.method = 'first')) %>%
          ungroup() %>%
          left_join(most_expensive_text, by = c('Date', 'Receipt_no')) %>%
          mutate(Tooltip_text = ifelse(Expenses > 100, paste0(
            'Date: ', Date,
            '<br>Expenses: ', Expenses, ' zł',
            '<br>The most expensive item: ', Text
          ),paste0(
            'Date: ', Date,
            '<br>Expenses: ', Expenses, ' zł'
          )))

        main_plot <- ggplot(df2, aes(x = Date, y = Expenses,
                        fill = gradient_fill,
                        group = Var_order,
                        text = Tooltip_text)) +
                geom_col(color = "black", linewidth = 0.3) +
                scale_fill_gradient(name = 'Expenses > 100 zł', low = "#D9B54A", high = "#B55239", na.value = '#D8DDD2') +
                scale_x_date(
                  date_labels = "%d-%m-%y\n%a"
                ) +
                theme_minimal() +
                theme(
                  text = element_text(family = "Comic Neue"),
                  plot.background = element_rect(fill = "transparent", color = NA),
                  panel.background = element_rect(fill = "transparent", color = NA),
                  legend.background = element_rect(fill = "transparent", color = NA)
                )
        ggplotly(main_plot, tooltip = 'text') %>%
          layout(paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')

      })

      output$plot2 <- renderPlotly({

        pal <- app_palette()
        req(input$daterange)
        df <- parsed_data()

        df2 <- df %>%
          group_by(Date) %>%
          summarize(Expenses = sum(Price), .groups = "drop") %>%
          arrange(Date, desc(Expenses))

        calendar_start <- make_date(year = year(input$daterange[1]), month(input$daterange[1]), 1)
        calendar_end <- ceiling_date(input$daterange[2], unit = "month") - days(1)

        df2 <- df2 %>%
          complete(Date = seq.Date(calendar_start, calendar_end, by = "day")) %>%
          mutate(weekday = wday(Date, label = TRUE, week_start = 1),
                 month = month(Date, label = TRUE),
                 week = isoweek(Date))
        df2$week[df2$month == "gru" & df2$week == 1] <- 53

        heatmap_plot <- df2 %>%
          ggplot(aes(weekday, -week, fill = Expenses, text = paste0('Date: ', Date, '<br>Expenses: ', Expenses, ' zł'))) +
          geom_tile(colour = "white") +
          geom_text(aes(label = day(Date)), size = 2.5, color = pal$light_fg) +
          scale_fill_gradient(
            low = "#D9B54A",
            high = "#B55239",
            na.value = "#D8DDD2",
            name = "Expenses"
          ) +
          facet_wrap(~month, nrow = 1, scales = "free") +
          theme_minimal() +
          theme(
            text = element_text(family = "Comic Neue"),
            aspect.ratio = 1 / 2,
            legend.position = "top",
            axis.title = element_blank(),
            axis.text.y = element_blank(),
            panel.grid = element_blank(),
            axis.ticks = element_blank(),
            strip.text = element_text(family = "Comic Neue", face = "bold", size = 12),
            plot.background = element_rect(fill = "transparent", color = NA),
            panel.background = element_rect(fill = "transparent", color = NA),
            legend.background = element_rect(fill = "transparent", color = NA)
          )

        ggplotly(heatmap_plot, tooltip = 'text') %>%
          layout(paper_bgcolor = 'rgba(0,0,0,0)', plot_bgcolor = 'rgba(0,0,0,0)')
      })

  })
}
