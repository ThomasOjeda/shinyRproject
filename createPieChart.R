###
###  Transforma un vector de numeros con nombres para crear un grafico de torta
###

createPieChart = function(labeledNumbers) {
  dataForPie = labeledNumbers
  names(dataForPie) = c("Rematriculados","Movimientos","Sin datos")
  dataForPie = dataForPie[dataForPie > 0]
  pieLabels = unlist(names(dataForPie))
  return(pie(unlist(dataForPie), labels = paste(round((unlist(dataForPie)/(Reduce('+',dataForPie)))*100), "% ", pieLabels, sep = "")))
  
}