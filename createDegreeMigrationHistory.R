library(hash)
library(dplyr)
library(egg)
createDegreeMigrationHistory = function (hashed_data,targetDegree) {

 
   #hashed_data=readRDS("exa_hashed_data.RDS")
 # targetDegree="Ingeniería de Sistemas"
  
  if (is.null(hashed_data) || is.null(targetDegree)) return (NULL)


  migrationYears = data.frame()
  
  for (k in keys(hashed_data))
    if (length(hashed_data[[k]][["inscriptions"]]) > 1) {
      

      lowerind = -1
      
      for (i in 1:(length(hashed_data[[k]][["inscriptions"]])))
        if (hashed_data[[k]][["inscriptions"]][[i]][["degree"]] == targetDegree) {
          lowerind = i
          break
        }
      
      #MEJORA: Considerar tambien inscripciones en el año que esten registradas en la lista antes del lowerind
      if (lowerind > -1 && lowerind < length(hashed_data[[k]][["inscriptions"]])) {
        for (upperind in (lowerind+1):(length(hashed_data[[k]][["inscriptions"]]))) {
          migrationYears[nrow(migrationYears)+1,"year"] = hashed_data[[k]][["inscriptions"]][[upperind]][["year"]]
          migrationYears[nrow(migrationYears),"sex"] = hashed_data[[k]][["sex"]]
        }
      }
    }
  
  #Se crean los historiales totales por sexo y totales (suma). 
  migrationHistory = migrationYears %>% group_by(year) %>% summarise(count = n(), sex="Suma")
  migrationHistoryBySex = migrationYears %>% group_by(year,sex) %>% summarise(count = n())
  
  migrationHistoryMerge = rbind(migrationHistory,migrationHistoryBySex)
  #Se juntan en un mismo dataframe para visualizacion
  
  boxplot = ggplot(migrationYears, aes(x=sex, y=year))+ geom_boxplot() + 
    ggtitle(paste("Distribucion por cuartiles de años de migracion de",targetDegree))
  
  historyPlot = ggplot(migrationHistoryMerge, aes(x=year, y= count, color = sex)) + geom_line()+ 
    geom_point() + scale_x_continuous(labels=as.character(migrationHistoryMerge$year),breaks=migrationHistoryMerge$year) + 
    #scale_y_continuous(labels=as.character(migrationHistoryMerge$count),breaks=migrationHistoryMerge$count) +
    ggtitle(paste("Historia de migracion de",targetDegree))
  
  combinedPlot = ggarrange(historyPlot,boxplot, nrow = 2, ncol = 1)
  
  return(combinedPlot)
}


