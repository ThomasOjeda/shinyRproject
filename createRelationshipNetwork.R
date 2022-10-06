library(network)
library(sna)
library(ggplot2)
library(hash)
library(GGally)

hashed_data = readRDS("exa_hashed_data.RDS")
student_distribution_sorted = readRDS("exa_student_distribution.RDS")

degree_relationship_graph = matrix(0,length(student_distribution_sorted$CARRERA),length(student_distribution_sorted$CARRERA))
colnames(degree_relationship_graph) = student_distribution_sorted$CARRERA
rownames(degree_relationship_graph) = student_distribution_sorted$CARRERA


for (k in keys(hashed_data))
  if (length(hashed_data[[k]][["inscriptions"]]) > 1) {
    
    #generar grafo de relacion de carreras
    for (i in 1:(length(hashed_data[[k]][["inscriptions"]])-1)) 
      for (j in (i+1):length(hashed_data[[k]][["inscriptions"]]))
      {
          degree_relationship_graph[hashed_data[[k]][["inscriptions"]][[i]][["degree"]],hashed_data[[k]][["inscriptions"]][[j]][["degree"]]] = 
            degree_relationship_graph[hashed_data[[k]][["inscriptions"]][[i]][["degree"]],hashed_data[[k]][["inscriptions"]][[j]][["degree"]]] + 1 
      }
    }



acronym_sorted_degree_list =  gsub('\\b(\\pL)\\pL{2,}|.','\\U\\1',student_distribution_sorted$CARRERA,perl = TRUE)

colnames(degree_relationship_graph) = acronym_sorted_degree_list

rownames(degree_relationship_graph) = acronym_sorted_degree_list



#Puede ocurrir que la diagonal tenga valores mayores a cero ya que el dataset tiene algunos registros repetidos
#graph

#Sumar diagonal inferior de la matriz a la diagonal superior

if (nrow(degree_relationship_graph) > 1)
  for (i in 2:nrow(degree_relationship_graph))  
    for(j in 1:(i-1))
      degree_relationship_graph[j,i] = degree_relationship_graph[j,i] + degree_relationship_graph[i,j]

#limpiar diagonal inferior y diagonal

if (nrow(degree_relationship_graph) > 1)
  for (i in 1:nrow(degree_relationship_graph))  
    for(j in 1:(i))
      degree_relationship_graph[i,j] = 0


net = network(degree_relationship_graph)


#colores aleatorios

edge_color = colors()[floor(runif(length(c(degree_relationship_graph)[c(degree_relationship_graph) > 0]), min=1, max=length(colors())))]
node_color = colors()[floor(runif(length(acronym_sorted_degree_list), min=1, max=length(colors())))]

vertex_size = rowSums(student_distribution_sorted[,2:ncol(student_distribution_sorted)])

current_plot = ggnet2(net,mode="circle", edge.size = log(c(degree_relationship_graph)[c(degree_relationship_graph) > 0] + 1), 
                      edge.color = edge_color, node.size = log(vertex_size +1), 
                      node.label =acronym_sorted_degree_list, node.color = node_color)
current_plot
