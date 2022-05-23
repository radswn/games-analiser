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
      box(
        sliderInput(
          'priceFilter',
          label = 'Price',
          min = 0,
          max = 69,
          value = c(0, 69)
        ),
        dateRangeInput(
          'dateFilter',
          label = 'Date',
          start = '1998-11-08',
          end = '2019-05-01',
          min = '1998-01-01',
          max = '2022-01-01'
        ),
        width = 4
      ),
      box(uiOutput('tags'), width = 4),
      box(gaugeOutput('playersMeter'), width = 4)
    ),
    fluidRow(
      shinydashboard::valueBoxOutput('ratings'),
      shinydashboard::valueBoxOutput('achievements'),
      shinydashboard::valueBoxOutput('playtime')
    )
  )
)
