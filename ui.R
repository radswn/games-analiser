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
      box(DT::dataTableOutput('table', height = 500), style = "overflow-y: scroll")
    ),
    fluidRow(
      shinydashboard::valueBoxOutput('ratings'),
      shinydashboard::valueBoxOutput('achievements'),
      shinydashboard::valueBoxOutput('playtime')
    ),
    box(gaugeOutput('playersMeter'))
  )
)
