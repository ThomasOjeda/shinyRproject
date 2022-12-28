source("createMigrationTable.R")
source("createMigrationPieChart.R")
source("createRelationshipNetwork.R")
source("obtainDataFromUnit.R")
source("createDegreeMigrationHistory.R")
source("computeGeneralMovementRatios.R")
source("createPieChart.R")

server <- function(input, output) {
  
  ###Se hace que yd sea una variable global para que pueda ser accedida incluso desde otros ambitos.(operador <<-)
  yd <<- readRDS("yearlyData.RDS")
  #yd <<- readRDS("datos_test.RDS")
  
  observeEvent(input$printPage, {
    js$printWindow()
  }) 
  
  update_mov_stats <- eventReactive(input$mov_stats_update_button, {
    
    return (list(general_mov_stats_year=as.numeric(input$year_mov_selector) - firstYear(),
                 general_mov_stats_delta=input$general_mov_stats_delta,
                 genre_mov_stats_selector = input$genre_mov_selector,
                 origin_unit_mov_selector=input$origin_unit_mov_selector,
                 destination_unit_mov_selector=input$destination_unit_mov_selector))
  })
  
  output$general_student_movement_ratios_pie <- renderPlot ({
    
    inputs = update_mov_stats()
    lowerYear = inputs$general_mov_stats_year
    upperYear = inputs$general_mov_stats_year + as.numeric(inputs$general_mov_stats_delta)
    selectedGenre = inputs$genre_mov_stats_selector
    selectedOriginUnit = inputs$origin_unit_mov_selector
    selectedDestinationUnit = inputs$destination_unit_mov_selector
    
    if(selectedOriginUnit=="Todas") selectedOriginUnit = NULL
    if(selectedDestinationUnit=="Todas") selectedDestinationUnit = NULL
    
    if(selectedGenre == "Todos") selectedGenre = NULL
    else if (selectedGenre == "Masculino") selectedGenre = "M"
    else selectedGenre = "F"
    
    ratios = computeGeneralMovementRatiosSimple(lowerYear,upperYear,selectedGenre=selectedGenre,selectedOriginUnit=selectedOriginUnit,selectedDestinationUnit=selectedDestinationUnit)
    
    names(ratios) = c("Inscriptos","Rematriculados","Movimientos","Sin_Datos","Porcentaje_Rematriculados","Porcentaje_Movimientos","Porcentaje_SinDatos")

    
    output$general_student_movement_ratios_info <- renderTable({
      ratiosTable = data.frame(ratios)
      ratiosTable$Porcentaje_Rematriculados = format(round(ratiosTable$Porcentaje_Rematriculados,4),nsmall=4)
      ratiosTable$Porcentaje_Movimientos = format(round(ratiosTable$Porcentaje_Movimientos,4),nsmall=4)
      ratiosTable$Porcentaje_SinDatos = format(round(ratiosTable$Porcentaje_SinDatos,4),nsmall=4)
      
      return (ratiosTable)
    })
    
    createPieChart2(unlist(ratios[2:4]),unlist(ratios[5:7]))
    
    
  })
  
  output$year_mov_selector <- renderUI({
    
    return(selectInput("year_mov_selector", label="Año", choices = obtainYears()))
  })
  
  output$origin_unit_mov_selector <- renderUI({
    
    return(selectInput("origin_unit_mov_selector", label="Filtro unidad primer año", choices = obtainUnits2()))
  })
  
  ###No se usa 
  output$origin_offer_mov_selector <- renderUI({
    
    processedData = obtainProcessedDataFromUnit(input$unit_hist)
    
    return(selectInput("origin_offer_mov_selector", label="Oferta", choices = processedData$student_distribution_sorted$CARRERA))
  })
  
  output$destination_unit_mov_selector <- renderUI({
    
    return(selectInput("destination_unit_mov_selector", label="Filtro unidad año destino", choices = obtainUnits2()))
  })
  
  ###No se usa 
  output$destination_offer_mov_selector <- renderUI({
    
    processedData = obtainProcessedDataFromUnit(input$unit_hist)
    
    return(selectInput("destination_offer_mov_selector", label="Oferta", choices = processedData$student_distribution_sorted$CARRERA))
  })
   

}
