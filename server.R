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
  
  observeEvent(input$print, {
    js$winprint()
  })
  
  update_mov_stats <- eventReactive(input$mov_stats_update_button, {
    
    return (list(general_mov_stats_year=as.numeric(input$year_mov_selector) - firstYear(),
                 general_mov_stats_delta=input$general_mov_stats_delta,
                 genre_mov_stats_selector = input$genre_mov_selector,
                 origin_unit_mov_selector=input$origin_unit_mov_selector,
                 destination_unit_mov_selector=input$destination_unit_mov_selector))
  })
  
  ###Este codigo es para probar otra version del creador de tablas
  # output$general_student_movement_ratios <- renderPlot ({
  #   
  # inputs = update_mov_stats()  
  # lowerYear = inputs$general_mov_stats_year  
  # upperYear = inputs$general_mov_stats_year + as.numeric(inputs$general_mov_stats_delta)
  # 
  # selectedOriginUnit = inputs$origin_unit_mov_selector
  # selectedDestinationUnit = inputs$destination_unit_mov_selector
  # 
  # if(selectedOriginUnit=="Todas") selectedOriginUnit = NULL
  # if(selectedDestinationUnit=="Todas") selectedDestinationUnit = NULL
  # 
  # ratios = computeGeneralMovementRatios(lowerYear,upperYear,selectedOriginUnit=selectedOriginUnit,selectedDestinationUnit=selectedDestinationUnit)  
  # 
  # 
  # ###ESTO HAY QUE CAMBIARLO PORQUE ESTA HORRIBLE EL CODIGO (pero por ahora anda...)
  # 
  # 
  # names(ratios) = c("Rematriculados","Movimientos","SinDatos","Porcent.Reinscriptos","Porcent.Movimientos","Porcent.SinDatos")
  # grid.arrange(tableGrob(data.frame(ratios),rows=NULL),createPieChart(ratios[1:3]),nrow=4)
  # 
  #   
  # })
  
  
  output$general_student_movement_ratios_simple <- renderPlot ({

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


    ###ESTO HAY QUE CAMBIARLO PORQUE ESTA HORRIBLE EL CODIGO (pero por ahora anda...)


    names(ratios) = c("Inscriptos","Rematriculados","Movimientos","SinDatos","Porcent.Rematriculados","Porcent.Movimientos","Porcent.SinDatos")
    grid.arrange(tableGrob(data.frame(ratios),rows=NULL),createPieChart(ratios[2:4]),nrow=4)


  })
  
  ###Codigo para calcular estadisticas solo de hombres
  output$general_student_movement_ratios_simple_M <- renderPlot ({
    
    inputs = update_mov_stats()
    lowerYear = inputs$general_mov_stats_year
    upperYear = inputs$general_mov_stats_year + as.numeric(inputs$general_mov_stats_delta)
    selectedGenre = inputs$genre_mov_stats_selector
    selectedOriginUnit = inputs$origin_unit_mov_selector
    selectedDestinationUnit = inputs$destination_unit_mov_selector
    
    if(selectedOriginUnit=="Todas") selectedOriginUnit = NULL
    if(selectedDestinationUnit=="Todas") selectedDestinationUnit = NULL
    
    ratios = computeGeneralMovementRatiosSimple(lowerYear,upperYear,selectedGenre="M",selectedOriginUnit=selectedOriginUnit,selectedDestinationUnit=selectedDestinationUnit)
    
    
    ###ESTO HAY QUE CAMBIARLO PORQUE ESTA HORRIBLE EL CODIGO (pero por ahora anda...)
    
    
    names(ratios) = c("Rematriculados","Movimientos","SinDatos","Porcent.Reinscriptos","Porcent.Movimientos","Porcent.SinDatos")
    grid.arrange(tableGrob(data.frame(ratios),rows=NULL),createPieChart(ratios[1:3]),nrow=4)
    
    
  })
  
  ###Codigo para calcular estadisticas solo de mujeres
  output$general_student_movement_ratios_simple_F <- renderPlot ({
    
    inputs = update_mov_stats()
    lowerYear = inputs$general_mov_stats_year
    upperYear = inputs$general_mov_stats_year + as.numeric(inputs$general_mov_stats_delta)
    selectedGenre = inputs$genre_mov_stats_selector
    selectedOriginUnit = inputs$origin_unit_mov_selector
    selectedDestinationUnit = inputs$destination_unit_mov_selector
    
    if(selectedOriginUnit=="Todas") selectedOriginUnit = NULL
    if(selectedDestinationUnit=="Todas") selectedDestinationUnit = NULL
    
    ratios = computeGeneralMovementRatiosSimple(lowerYear,upperYear,selectedGenre="F",selectedOriginUnit=selectedOriginUnit,selectedDestinationUnit=selectedDestinationUnit)
    
    
    ###ESTO HAY QUE CAMBIARLO PORQUE ESTA HORRIBLE EL CODIGO (pero por ahora anda...)
    
    
    names(ratios) = c("Rematriculados","Movimientos","SinDatos","Porcent.Reinscriptos","Porcent.Movimientos","Porcent.SinDatos")
    grid.arrange(tableGrob(data.frame(ratios),rows=NULL),createPieChart(ratios[1:3]),nrow=4)
    
    
  })
  
  output$year_mov_selector <- renderUI({
    
    return(selectInput("year_mov_selector", label="Año", choices = obtainYears()))
  })
  
  output$origin_unit_mov_selector <- renderUI({
    
    return(selectInput("origin_unit_mov_selector", label="Filtro unidad primer año", choices = obtainUnits2()))
  })
  
  ###No se usa todavia
  output$origin_offer_mov_selector <- renderUI({
    
    processedData = obtainProcessedDataFromUnit(input$unit_hist)
    
    return(selectInput("origin_offer_mov_selector", label="Oferta", choices = processedData$student_distribution_sorted$CARRERA))
  })
  
  output$destination_unit_mov_selector <- renderUI({
    
    return(selectInput("destination_unit_mov_selector", label="Filtro unidad año destino", choices = obtainUnits2()))
  })
  
  ###No se usa todavia
  output$destination_offer_mov_selector <- renderUI({
    
    processedData = obtainProcessedDataFromUnit(input$unit_hist)
    
    return(selectInput("destination_offer_mov_selector", label="Oferta", choices = processedData$student_distribution_sorted$CARRERA))
  })
  
  

  
  
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
