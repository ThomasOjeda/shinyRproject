#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
install.packages("migest")

# Define UI for application that draws a histogram
ui <- fluidPage(

        mainPanel(
           tableOutput("migrat")
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$exaData <- renderTable({
      source("loadExaDataset.R")
      head(exa)
    })
    
    
    output$migrat <- renderPlot({
      mat <- rbind(c(1,1,1),c(2,2,2),c(1,1,1))
      migest.mig_chord(mat)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
