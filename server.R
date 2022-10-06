
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$migration_data <- renderTable ( {
    
    source("createMigrationTable.R")
    
    return (createMigrationTable(input$start_year,input$delta))
    
  })
  
  
  
  output$network <- renderPlot({
    
    source("createRelationshipNetwork.R")
    
    return(createRelationshipNetwork())
    
  })
  
  
  output$migration_pie_chart <- renderPlot({
    
    slices <- c(10, 12,4, 16, 8)
    lbls <- c("US", "UK", "Australia", "Germany", "France")
    return (    pie((createMigrationTable(input$start_year,input$delta))[,2], labels = (createMigrationTable(input$start_year,input$delta))[,1], main="Pie Chart of Countries")
)
    
  })
}