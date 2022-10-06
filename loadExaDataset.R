
library(rlist)
library(hash)
library(GGally)
library(network)
library(sna)
library(ggplot2)


library("dplyr")
exa = readxl::read_excel("exactas.xlsx");

exa = exa[,c("Id ofuscado","CARRERA","SEXO","TIPO","INGRESO","CALIDAD","FINALES total","INSC CURS","finales aprob año anterior","finales AprobadosActual")]

exa[exa$CARRERA == "NA","CARRERA"] = "sin_carrera"



exa = subset(exa, SEXO=="M")

student_distribuion_unsorted = exa %>% count(CARRERA)

student_distribuion_sorted = arrange(student_distribuion_unsorted,CARRERA)

vertex_size = unlist(student_distribuion_sorted [,2])

#View(exa)

h <- hash() 

  for (i in 1:nrow(exa)) {
    
    if (is.null(h[[toString(exa[i,"Id ofuscado"])]])) {
      h[[toString(exa[[i,"Id ofuscado"]])]] = list(exa[[i, "CARRERA"]])
    }
    else {
      h[[toString(exa[[i,"Id ofuscado"]])]] = list.append(h[[toString(exa[[i,"Id ofuscado"]])]],exa[[i, "CARRERA"]])
    }
  }


#solo matchear con los siguientes. sumar parte diagonal inferior y superior de la matrix

#all(exa$`Id ofuscado` %in% keys(h)) #Determina que todos los elementos del conjutno de ids estan ingresados de alguna manera en el hash

graph = matrix(0,length(unique(exa$CARRERA)),length(unique(exa$CARRERA)))

sorted_degree_list = sort(unique(exa$CARRERA))

colnames(graph) = sorted_degree_list

rownames(graph) = sorted_degree_list

for (k in keys(h))
  if (length(h[[k]]) > 1)
  for (i in 1:(length(h[[k]])-1)) 
    for (j in (i+1):length(h[[k]]))
      graph[h[[k]][[i]],h[[k]][[j]]] = graph[h[[k]][[i]],h[[k]][[j]]] + 1 

#colnames(graph) = NULL

#rownames(graph) =  NULL

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

acronym_sorted_degree_list =  gsub('\\b(\\pL)\\pL{2,}|.','\\U\\1',sorted_degree_list,perl = TRUE)

colnames(graph) = acronym_sorted_degree_list

rownames(graph) = acronym_sorted_degree_list

net = network(graph)

graph

#colores aleatorios

edge_color = colors()[floor(runif(length(c(graph)[c(graph) > 0]), min=1, max=length(colors())))]
node_color = colors()[floor(runif(length(acronym_sorted_degree_list), min=1, max=length(colors())))]
current_plot = ggnet2(net,mode="circle", edge.size = log(c(graph)[c(graph) > 0] + 1), edge.color = edge_color, node.size = log(vertex_size +1), node.label =acronym_sorted_degree_list, node.color = node_color)
current_plot


