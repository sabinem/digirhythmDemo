#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(digiRhythm)
library(shiny)
DATA_DIR <- './data/'

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Periodic animal behaviour visualization with DigiRhythm"),
    # Drop down menu to select input file
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "filename",
          "Sample configuration:",
          list.files(DATA_DIR, pattern = '.*\\.csv$', recursive = T)
        ),
        # Drop down menu to select activity variable
        selectInput(
          "activity",
          "Activity metric:",
          c('Motion.Index', 'Steps'),
          selected = 'Steps'
        ),
        # Allow user to specify a time range
        dateRangeInput(
          "timerange",
          "Time range:",
          start = "2020-04-30",
          end = "2020-12-10",
          min = NULL,
          max = NULL,
          format = "yyyy-mm-dd",
        ),
        # Slider to tune sampling rate
        sliderInput(
          "sampling",
          "Sampling rate (minutes):",
          min = 15,
          max = 90,
          value = 15,
          step = 15,
        ),
        checkboxInput('rm_outliers', 'Remove outliers', value = F),
      ),

      # Show a plot of the generated distribution
      mainPanel(
        fluidRow(
          column(6, plotOutput("actogram"), plotOutput("daily_avg")),
          column(6, plotOutput("diurnality"), plotOutput("dfc")))
      )
    )
)

# Define server logic
server <- function(input, output) {
  # Dynamically re-read data when user changes the input file
  load_func <- function(inp, sampling, rm_outliers = F) {
    df <- import_raw_activity_data(
      filename = paste0(DATA_DIR, inp),
      skipLines = 7,
      act.cols.names = c('Date', 'Time', 'Motion Index', 'Steps'),
      sampling = sampling
    )
    # Remove outlier records if the box was checked
    if (rm_outliers == T) {
      df <- remove_activity_outliers(df)
    }
    return(df)
  }
  act_data <- reactive({
    load_func(input$filename, input$sampling, input$rm_outliers)
  })

  # Generate actogram visualization based on all input parameters
  output$actogram <- renderPlot({
    actogram(
      act_data(),
      activity = input$activity,
      activity_alias = input$activity,
      start = input$timerange[1],
      end = input$timerange[2],
      save = NULL
    )
  })
  output$daily_avg <- renderPlot({
    daily_average_activity(
      act_data(),
      activity = input$activity,
      activity_alias = input$activity,
      start = input$timerange[1],
      end = input$timerange[2],
      save = NULL
    )
  })
  output$diurnality <- renderPlot({
    diurnality(act_data(), activity = input$activity)
  })
  output$dfc <- renderPlot({
    x <- digiRhythm::dfc(
      data = act_data(),
      activity = input$activity,
      sampling = input$sampling,
      sig = 0.05,
      plot = TRUE,
      verbose = FALSE)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
