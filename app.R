
library(shiny)

# Run the application 
source("server.R")
source("ui")
shinyApp(ui = ui, server = server)
