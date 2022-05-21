library(shiny)
library(ggplot2)
library(shinyalert)


ui <- dashboardPage(
  dashboardHeader(title = "Games analiser"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      useShinyalert(force = TRUE),
      box(plotOutput("plot", height = 500),
          title = "Average number of players"),
      box(DT::dataTableOutput('table', height = 500))
    ),
    fluidRow(box(
      shinydashboard::valueBoxOutput('ratings', width = 6)
    ),
    box(gaugeOutput('playersMeter')), ),
    fluidRow(
      box(
        shinydashboard::valueBoxOutput('achievements', width = 6),
        shinydashboard::valueBoxOutput('playtime', width = 6)
        
      )
    )
  )
)
