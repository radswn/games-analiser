library(shiny)
library(shinydashboard)
library(flexdashboard)
library(dplyr)
library(tidyr)
library(tidyverse)
library(DT)
library(fontawesome)
library(shinyalert)

games <- read.csv('data/games_info.csv') %>%
  select(
    name,
    release_date,
    developer,
    genres,
    achievements,
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
  shinyalert("Welcome", includeText("data/help.txt"), type = "info")

  output$table <-
    DT::renderDataTable(
      merged,
      options = list(
        paging = FALSE,
        scrollY = "500px",
        autoWidth = TRUE,
        columnDefs =
          list(list(
            visible = FALSE, targets = c(seq(5, 8), seq(10, 113))
          )),
        columnDefs = list(list(targets = '_all', width = '100px'))
      ),
      selection = 'single'
    )
  
  output$playersMeter <- renderGauge(gauge(
    merged$`avg.2021-February`[input$table_rows_selected[1]],
    min = 0,
    max = max(merged[input$table_rows_selected[1], 10:113]),
    sectors = gaugeSectors(
      success = c(0.666 * max(merged[input$table_rows_selected[1], 10:113]), max(merged[input$table_rows_selected[1], 10:113])),
      warning = c(0.333 * max(merged[input$table_rows_selected[1], 10:113]), 0.666 * max(merged[input$table_rows_selected[1], 10:113])),
      danger = c(0, 0.333 * max(merged[input$table_rows_selected[1], 10:113]))
    )
  ))
  
  output$achievements <-
    shinydashboard::renderValueBox(
      shinydashboard::valueBox(
        value = ifelse(
          length(input$table_rows_selected),
          merged$achievements[input$table_rows_selected[1]],
          "-"
        ),
        subtitle = "Total number of achievements",
        icon = icon("trophy"),
        color = "aqua"
      )
    )
  
  output$playtime <-
    shinydashboard::renderValueBox(
      shinydashboard::valueBox(
        value = ifelse(
          length(input$table_rows_selected),
          merged$average_playtime[input$table_rows_selected[1]],
          "-"
        ),
        subtitle = "Average playtime in minutes",
        icon = icon("clock"),
        color = "orange"
      )
    )
  
  output$ratings <-
    shinydashboard::renderValueBox({
      if (length(input$table_rows_selected)) {
        val = round(
          100 * merged$positive_ratings[input$table_rows_selected[1]] / (merged$positive_ratings[input$table_rows_selected[1]] + merged$negative_ratings[input$table_rows_selected[1]]),
          1
        )
        if (val >= 75) {
          co = "green"
          ic = icon("thumbs-up")
        } else{
          if (val >= 50) {
            co = "orange"
            ic = icon("question")
          } else{
            co = "red"
            ic = icon("thumbs-down")
          }
        }
      } else{
        val = "-"
        co = "black"
        ic = icon("alien")
      }
      shinydashboard::valueBox(
        value = val,
        subtitle = "Positive ratings [%]",
        color = co,
        icon = ic
      )
      
    })
  
  everysecond <- function(x) {
    x[seq(2, length(x), 2)] <- ""
    x
  }
  
  output$plot <- renderPlot({
    ifelse((length(input$table_rows_selected)),
           df <-
             data.frame(unlist(names(merged)[113:10]), unlist(merged[input$table_rows_selected, 113:10])),
           df <-
             data.frame(unlist(names(merged)[113:10]), rep(0, 104)))
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
      theme(
        axis.text.x = element_text(
          angle = 90,
          vjust = 0.5,
          hjust = 1
        ),
        axis.title.y = element_blank()
      )
    
  })
})
