library(shiny)
library(ggplot2)
library(shinyalert)

css <- HTML("
.html-widget.gauge svg {
  height: 250px;
  width: 600px;
}")

ui <- dashboardPage(
  dashboardHeader(title = "Games Analiser"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(tags$style(css)),
    fluidRow(
      useShinyalert(force = TRUE),
      box(plotOutput("plot", height = 400),
          title = "Average number of players"),
      box(DT::dataTableOutput('table', height = 300), style = "overflow-y: scroll")
    ),
    fluidRow(
      box(
        gaugeOutput('playersMeter'),
        title = "Players currently playing",
        width = 4
      ),
      box(uiOutput('tags'), title = 'Tags', width = 4),
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
        title = 'Table filters',
        width = 4
      )
    ),
    fluidRow(
      shinydashboard::valueBoxOutput('ratings'),
      shinydashboard::valueBoxOutput('achievements'),
      shinydashboard::valueBoxOutput('playtime')
    )
  )
)
