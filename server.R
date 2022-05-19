library(shiny)
library(dplyr)
library(tidyr)

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

shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x,
         breaks = bins,
         col = 'darkgray',
         border = 'white')
    
  })
  
})
