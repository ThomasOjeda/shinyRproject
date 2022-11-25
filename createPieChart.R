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


createPieChart2 = function(labeledNumbers,labeledPercentages) {
  
  
  dataForPie = labeledNumbers
  labelNames = c("Rematriculados","Movimientos","Sin datos")
  labeledPercentages = format(round(labeledPercentages, 3)*100, nsmall = 1)
  
  pieLabels = paste(labeledPercentages,"%",labelNames)

  dataForPie <- data.frame(
    situacion=pieLabels,
    val=dataForPie
  )
  
  ggplot(dataForPie, aes(x="", y=val, fill=situacion)) +
    geom_bar(stat="identity", width=1, color="white") +
    coord_polar("y", start=0) +
    theme_void() + # remove background, grid, numeric labels
    scale_fill_manual(values=c("#E7F66D", "#A2B1B5", "#91F55E"))
}
