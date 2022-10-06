library(hash)
library(dplyr)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$migration_data <- renderTable ( {
    
    source("createMigrationTable.R")
    
    return (createMigrationTable(input$start_year,input$delta))
    
  })
  
  
  
  output$degree_relationship <- renderPlot({
    
    
    library(network)
    library(sna)
    library(ggplot2)
    library(hash)
    library(GGally)
    
    hashed_data = readRDS("exa_hashed_data.RDS")
    
    student_distribution_sorted = readRDS("exa_student_distribution.RDS")
    
    vertex_size = unlist(student_distribution_sorted[,2])
    
    graph = matrix(0,length(student_distribution_sorted$CARRERA),length(student_distribution_sorted$CARRERA))
    
    colnames(graph) = student_distribution_sorted$CARRERA
    
    rownames(graph) = student_distribution_sorted$CARRERA
    
    
    for (k in keys(hashed_data))
      if (length(hashed_data[[k]][["inscriptions"]]) > 1)
        for (i in 1:(length(hashed_data[[k]][["inscriptions"]])-1)) 
          for (j in (i+1):length(hashed_data[[k]][["inscriptions"]]))
          {
            graph[hashed_data[[k]][["inscriptions"]][[i]][["degree"]],hashed_data[[k]][["inscriptions"]][[j]][["degree"]]] = 
              graph[hashed_data[[k]][["inscriptions"]][[i]][["degree"]],hashed_data[[k]][["inscriptions"]][[j]][["degree"]]] + 1 
            
            
            
          }
    
    
    acronym_sorted_degree_list =  gsub('\\b(\\pL)\\pL{2,}|.','\\U\\1',student_distribution_sorted$CARRERA,perl = TRUE)
    
    colnames(graph) = acronym_sorted_degree_list
    
    rownames(graph) = acronym_sorted_degree_list
    
    
    
    #Puede ocurrir que la diagonal tenga valores mayores a cero ya que el dataset tiene algunos registros repetidos
    #graph
    
    #Sumar diagonal inferior de la matriz a la diagonal superior
    
    if (nrow(graph) > 1)
      for (i in 2:nrow(graph))  
        for(j in 1:(i-1))
          graph[j,i] = graph[j,i] + graph[i,j]
    
    #limpiar diagonal inferior y diagonal
    
    if (nrow(graph) > 1)
      for (i in 1:nrow(graph))  
        for(j in 1:(i))
          graph[i,j] = 0
    
    
    net = network(graph)
    
    graph
    
    #colores aleatorios
    
    edge_color = colors()[floor(runif(length(c(graph)[c(graph) > 0]), min=1, max=length(colors())))]
    node_color = colors()[floor(runif(length(acronym_sorted_degree_list), min=1, max=length(colors())))]
    current_plot = ggnet2(net,mode="circle", edge.size = log(c(graph)[c(graph) > 0] + 1), edge.color = edge_color, node.size = log(vertex_size +1), node.label =acronym_sorted_degree_list, node.color = node_color)
    return(current_plot)
    
  })
}