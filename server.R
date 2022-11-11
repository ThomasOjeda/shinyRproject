source("createMigrationTable.R")
source("createMigrationPieChart.R")
source("createRelationshipNetwork.R")
source("obtainDataFromUnit.R")
source("createDegreeMigrationHistory.R")
server <- function(input, output) {
  
  
  output$migration_data <- renderTable ( {
    
    processedData = obtainProcessedDataFromUnit(input$migration_unit_selector)

    migrationTable = createMigrationTable(processedData$hashed_data,processedData$student_distribution_sorted,input$start_year,input$delta)
    
    output$migration_pie_chart <- renderPlot({
      
      
      return (createMigrationPieChart(migrationTable))
      
    })
    
    return (migrationTable)
    
  })
  
  output$migration_history <- renderPlot({
    
    processedData = obtainProcessedDataFromUnit(input$unit_hist)

    return(createDegreeMigrationHistory(processedData$hashed_data,input$degree_hist))
    
  })
  
  
  output$network <- renderPlot({
    
    
    return(createRelationshipNetwork())
    
  })
  
  output$unit_hist_selector <- renderUI({
    
    return(selectInput("unit_hist", label="Unidad academica", choices = obtainUnits()))
  })
  
  output$degree_hist_selector <- renderUI({
    
    processedData = obtainProcessedDataFromUnit(input$unit_hist)
    
    return(selectInput("degree_hist", label="Carrera", choices = processedData$student_distribution_sorted$CARRERA))
  })
  
  
  
  output$migrations_unit_selector <- renderUI({
    
    return(selectInput("migration_unit_selector", label="Unidad academica", choices = obtainUnits()))
    
  })
  
  output$migration_range_selectors <- renderUI({
    processedData = obtainProcessedDataFromUnit(input$migration_unit_selector)
    
    return(
      sliderInput("start_year", 
                  label = "Año de comienzo",
                  min = as.numeric(colnames(processedData$student_distribution_sorted)[2]), 
                  max = as.numeric(colnames(processedData$student_distribution_sorted)[ncol(processedData$student_distribution_sorted)]), 
                  value = as.numeric(colnames(processedData$student_distribution_sorted)[ncol(processedData$student_distribution_sorted)]))
    )
    
  })

}
