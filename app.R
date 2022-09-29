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

      
      graph = rbind(c(0,2,1),c(0,0,3),c(0,0,0))
      
      colnames(graph) = c("ing sistemas","tudai","ambiental")
      rownames(graph) = c("ing sistemas","tudai","ambiental")
      net = network(graph, directed = TRUE)
      
      return (ggnet2(net, mode ="circle", arrow.gap = 0.03, arrow.size = 5, label = TRUE, edge.size = c(graph)[c(graph) > 0]))
      
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
