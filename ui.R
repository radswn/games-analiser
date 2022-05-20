library(shiny)
library(ggplot2)

dataset <- diamonds

ui <- fluidPage(
  title = "Diamonds Explorer",
  
  hr(),
  fluidRow(column(6, plotOutput("plot", height = 500)),
           column(6,
                  DT::dataTableOutput('table'))),
  fluidRow(
    column(
      4,
      h4("Diamonds Explorer 1"),
      sliderInput(
        'sampleSize',
        'Sample Size',
        min = 1,
        max = nrow(dataset),
        value = min(1000, nrow(dataset)),
        step = 500,
        round = 0
      ),
      br(),
      checkboxInput('jitter', 'Jitter'),
      checkboxInput('smooth', 'Smooth')
    ),
    column(
      2,
      selectInput('x', 'X', names(dataset)),
      selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
      selectInput('color', 'Color', c('None', names(dataset)))
    ),
    column(6,
           gaugeOutput('playersMeter'))
  ),
  fluidRow(
    column(
      3,
      h4("Diamonds Explorer 3"),
      sliderInput(
        'sampleSize',
        'Sample Size',
        min = 1,
        max = nrow(dataset),
        value = min(1000, nrow(dataset)),
        step = 500,
        round = 0
      ),
      br(),
      checkboxInput('jitter', 'Jitter'),
      checkboxInput('smooth', 'Smooth')
    ),
    column(
      3,
      selectInput('x', 'X', names(dataset)),
      selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
      selectInput('color', 'Color', c('None', names(dataset)))
    ),
    column(
      3,
      h4("Diamonds Explorer 4"),
      sliderInput(
        'sampleSize',
        'Sample Size',
        min = 1,
        max = nrow(dataset),
        value = min(1000, nrow(dataset)),
        step = 500,
        round = 0
      ),
      br(),
      checkboxInput('jitter', 'Jitter'),
      checkboxInput('smooth', 'Smooth')
    )
  )
)
