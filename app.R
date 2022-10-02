#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(GGally)

library(network)
library(sna)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

        mainPanel(
           plotOutput("migrat")
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    
    output$migrat <- renderPlot({

      
      source("loadExaDataset.R")
      
      return (current_plot)
      
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
