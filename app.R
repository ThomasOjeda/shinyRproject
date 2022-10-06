
library(shiny)

# Run the application 
source("server.R")
source("userInterface.R")
shinyApp(ui = ui, server = server)
