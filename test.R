
library(GGally)

library(network)
library(sna)
library(ggplot2)
  
graph = rbind(c(0,2,1),c(0,0,3),c(0,0,0))

colnames(graph) = c("ing sistemas","tudai","ambiental")
rownames(graph) = c("ing sistemas","tudai","ambiental")
graph
net = network(graph, directed = TRUE)

graph
ggnet2(net, mode ="circle", arrow.gap = 0.03, arrow.size = 5, label = TRUE, edge.size = c(graph)[c(graph) > 0])

