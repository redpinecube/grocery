library(shiny)
library(ggplot2)
library(readr)

data <- read_csv("data/clean/clean_data.csv")
ui <- fluidPage(
  titlePanel("Price Visualization Over Time in 2024"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("time", 
                  "Choose a time:",
                  min = min(data$time),  
                  max = max(data$time),
                  value = min(data$time), 
                  step = 1,
                  animate = animationOptions(
                    interval = 1000,  
                    loop = FALSE,
                    playButton = NULL,
                    pauseButton = NULL
                  )
      )
    ),
    
    mainPanel(
      plotOutput("price_plot")
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    subset(data, time == input$time)
  })
  output$price_plot <- renderPlot({
    plot_data <- filtered_data()
    if (nrow(plot_data) == 0) {
      return(NULL)
    }
    

    ggplot(plot_data, aes(x = time, y = price_per_unit)) +
      geom_point(color = "blue", size = 3) +  
      geom_segment(aes(x = time, xend = time, y = 0, yend = price_per_unit), 
                   color = "red", size = 1) +  
      scale_y_continuous(labels = scales::comma) +  
      labs(title = paste("Prices at Time:", input$time),
           x = "Time",
           y = "Price per Unit") +
      theme_minimal() +
      theme(axis.text.x = element_blank())
  })
}

shinyApp(ui = ui, server = server)
