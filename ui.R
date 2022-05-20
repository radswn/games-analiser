library(shiny)
library(ggplot2)


ui <- dashboardPage(
  dashboardHeader(title = "Games analiser"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(fluidRow(
    box(plotOutput("plot", height = 500),
        title = "Average number of players"),
    box(DT::dataTableOutput('table', height = 500))
  ),
  fluidRow(gaugeOutput('playersMeter')),
  fluidRow(
    box(
      shinydashboard::valueBoxOutput('achievements', width = 6),
      shinydashboard::valueBoxOutput('playtime', width = 6)
    )
  ))
)
