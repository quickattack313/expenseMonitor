visual_analytics_ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns('test_but'), 'Test'),
    dateRangeInput(ns('daterange'), "Date range:",
                   start  = "2024-12-01",
                   end    = "2025-01-31",
                   format = "dd/mm/yy"),
    plotlyOutput(ns('plot1'), height = "600px")#,
    #plotlyOutput(ns('plot2'), height = "600px"),
  )
}

visual_analytics_server <- function(id, data) {
  moduleServer(
    id, 
    function(input, output, session) {
      
       
 
      
      output$plot1 <- renderPlotly({
        
        df <- data() %>%
          separate(Id, into = c('date_raw', 'Receipt_no'), sep = "_") %>%
          mutate(
            Date = as.Date(date_raw, format = "%d%m%y"),
            Receipt_no = as.character(Receipt_no)
          ) %>%
          select(-date_raw) %>%
          select(c('Date', 'Receipt_no', 'Store', 'Item', 'Category', 'Price', 'Amount'))
        
        
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
          mutate(Text = paste0(Item, ' (', Price, 'zł)')) %>%
          select(Date, Receipt_no, Text)
        
        df2 <- df2 %>% 
          group_by(Date) %>%
          mutate(Var_order = rank(Expenses, ties.method = 'first')) %>%
          ungroup() %>%
          left_join(most_expensive_text, by = c('Date', 'Receipt_no')) %>%
          mutate(Tooltip_text = ifelse(Expenses > 100, paste0(
            'Date: ', Date,
            '<br>Expenses: ', Expenses, 'zł',
            '<br>The most expensive item: ', Text
          ),paste0(
            'Date: ', Date,
            '<br>Expenses: ', Expenses, 'zł'
          )))
        
        main_plot <- ggplot(df2, aes(x = Date, y = Expenses, 
                        fill = gradient_fill, 
                        group = Var_order, 
                        text = Tooltip_text)) +
                geom_col(color='black') +
                scale_fill_gradient(name = 'Expenses > 100 zł', low = "yellow", high = "red", na.value = 'grey') +
                scale_x_date(
                  date_labels = "%d-%m-%y\n%a"
                ) +      
                theme_minimal()
        ggplotly(main_plot, tooltip = 'text')
        
      })
      
      
      observeEvent(input$test_but,{
        
        
        
          
        df <- data() %>%
          separate(Id, into = c('date_raw', 'Receipt_no'), sep = "_") %>%
          mutate(
            Date = as.Date(date_raw, format = "%d%m%y"),
            Receipt_no = as.character(Receipt_no)
          ) %>%
          select(-date_raw) %>%
          select(c('Date', 'Receipt_no', 'Store', 'Item', 'Category', 'Price', 'Amount'))
        
        df2 <- df %>% 
          group_by(Date) %>% 
          summarize(Expenses = sum(Price), .groups = "drop") %>%
          arrange(Date, desc(Expenses))
        
        calendar_start <- make_date(year = year(input$daterange[1]), month(input$daterange[1]), 1)
        calendar_end <- ceiling_date(input$daterange[2], unit = "month") - days(1)
        
        df2 <- df2 %>%
          complete(Date = seq.Date(calendar_start, calendar_end, by = "day"))
        
        #browser()
        df2 <- df2 %>% 
          mutate(weekday = wday(Date, label = T, week_start = 1),
                 month = month(Date, label = T),
                 day = day(Date),
                 week = isoweek(Date))
        df2$week[df2$month=="gru" & df2$week ==1] = 53
        df2 <- df2 %>% 
          group_by(month) %>% 
          mutate(monthweek = 1 + week - min(week))
        
        
        
        df2 %>%
          ggplot(aes(weekday,-week, fill = Expenses)) +
          geom_tile(colour = "white")  + 
          geom_text(aes(label = day(Date)), size = 2.5, color = "black") +
          theme(aspect.ratio = 1/2,
                legend.position = "top",
                legend.key.width = unit(3, "cm"),
                axis.title.x = element_blank(),
                axis.title.y = element_blank(),
                axis.text.y = element_blank(),
                panel.grid = element_blank(),
                axis.ticks = element_blank(),
                panel.background = element_blank(),
                legend.title.align = 0.5,
                strip.background = element_blank(),
                strip.text = element_text(face = "bold", size = 15),
                panel.border = element_rect(colour = "grey", fill=NA, size=1),
                plot.title = element_text(hjust = 0.5, size = 21, face = "bold",
                                          margin = margin(0,0,0.5,0, unit = "cm"))) +
          # scale_fill_gradientn(colours = c("#6b9235", "white", "red"),
          #                      values = scales::rescale(c(-1, -0.05, 0, 0.05, 1)), 
          #                      name = "Values",
          #                      guide = guide_colorbar(title.position = "top", 
          #                                             direction = "horizontal")) +
          scale_fill_gradient2(
            low = "#6b9235",
            #mid = "white",
            high = "red",
            midpoint = 500,
            na.value = "grey80",
            name = "Values",
            guide = guide_colorbar(
              title.position = "top",
              direction = "horizontal"
            )
          )+
          facet_wrap(~month, nrow = 1, ncol = 2, scales = "free") +
          labs(title = "Calendar heatmap 2019")+
          labs(fill = "Expenses\n(grey = brak danych)")
          
        
        
        
        
        
        
        
        data <- runif(33)
        cl <- calendR(from = min(df$Date),
                      to = max(df$Date),
                start = "M",
                special.days = data,
                gradient = TRUE,
                low.col = "#4F8A5B",
                special.col = "white",
                bg.col = "#FF9ECF",
                legend.pos = "bottom",
                legend.title = "Title")
          
        output$plot2 <- renderPlotly({
          cl
        })
        
        
      
       })
      
      
      
  })
}