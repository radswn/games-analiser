library(shiny)
library(dplyr)
library(tidyr)
library(tidyverse)
library(DT)
library(flexdashboard)

games <- read.csv('data/games_info.csv') %>%
  select(
    name,
    release_date,
    developer,
    genres,
    positive_ratings,
    negative_ratings,
    average_playtime,
    price
  )

players <- read.csv('data/games_players.csv') %>%
  select(gamename,
         year,
         month,
         avg) %>%
  mutate(month = substr(month, 1, nchar(month) - 1)) %>%
  unite(date, c("year", "month"), sep = '-')

rshpd <-
  reshape(players,
          idvar = "gamename",
          timevar = "date",
          direction = "wide")

merged <- merge(games, rshpd, by.x = 'name', by.y = 'gamename')
merged[is.na(merged)] <- 0

shinyServer(function(input, output, session) {
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x,
         breaks = bins,
         col = 'darkgray',
         border = 'white')
    
  })
  output$table <-
    renderDataTable(
      merged,
      options = list(
        pageLength = 7,
        autoWidth = TRUE,
        columnDefs =
          list(list(
            visible = FALSE, targets = c(seq(9, 112))
          )),
        columnDefs = list(list(targets = '_all', width = '100px')),
        scrollX = TRUE
      ),
      selection = 'single'
      
    )
  
  output$playersMeter = renderGauge(gauge(
    merged$`avg.2021-February`[input$table_rows_selected[1]],
    min = 0,
    max = max(merged[input$table_rows_selected[1], 9:112]),
    sectors = gaugeSectors(
      success = c(0.666 * max(merged[input$table_rows_selected[1], 9:112]), max(merged[input$table_rows_selected[1], 9:112])),
      warning = c(0.333 * max(merged[input$table_rows_selected[1], 9:112]), 0.666 * max(merged[input$table_rows_selected[1], 9:112])),
      danger = c(0, 0.333 * max(merged[input$table_rows_selected[1], 9:112]))
    )
  ))
  
  
  output$x4 = renderPrint({
    s = input$table_rows_selected
    if (length(s)) {
      cat('These rows were selected:\n\n')
      cat(merged[s])
    }
  })
  
  everysecond <- function(x) {
    x[seq(2, length(x), 2)] <- ""
    x
  }
  
  output$plot <- renderPlot({
    if (length(input$table_rows_selected)) {
      df <-
        data.frame(unlist(names(merged)[112:9]), unlist(merged[input$table_rows_selected, 112:9]))
    } else{
      df <-
        data.frame(unlist(names(merged)[112:9]), rep(0, 104))
    }
    colnames(df) <- c('date', 'average_number_of_players')
    df$date <- gsub("avg.", "", df$date)
    ggplot(data = df, aes(x = date, y = average_number_of_players)) +
      geom_bar(
        stat = 'identity',
        fill = "orange",
        width = 0.7,
        position = position_dodge(width = 1.0)
      ) +
      scale_x_discrete(labels = everysecond(df$date)) +
      theme_minimal() +
      ggtitle("Average number of players") +
      theme(
        axis.text.x = element_text(
          angle = 90,
          vjust = 0.5,
          hjust = 1
        ),
        axis.title.y = element_blank(),
        plot.title = element_text(size = 40, face = "bold")
      )
    
  })
  
})
