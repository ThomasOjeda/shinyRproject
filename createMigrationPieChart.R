createMigrationPieChart = function (migrationTable) {
  dataForPie = migrationTable
  dataForPie = dataForPie[dataForPie[,2] > 0,]
  return(pie(dataForPie[,2], labels = paste(round(prop.table(dataForPie[,2])*100), "%", dataForPie[,1], sep = "")))
}