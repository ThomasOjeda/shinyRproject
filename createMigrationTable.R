library(hash)
library(dplyr)

createMigrationTable = function (target,delta) {
  
  hashed_data = readRDS("exa_hashed_data.RDS")
  student_distribution_sorted = readRDS("exa_student_distribution.RDS")
  
  #moving_students_graph = matrix(0,length(student_distribution_sorted$CARRERA),length(student_distribution_sorted$CARRERA))
  
  migrations_per_degree_vector = vector(mode="numeric", length = length(student_distribution_sorted$CARRERA))
  names(migrations_per_degree_vector) = student_distribution_sorted$CARRERA
  
  
  target_year = target
  delta_year = delta
  
  migration_data = vector(mode = "numeric", length = length(student_distribution_sorted$CARRERA))
  
  names(migration_data)  = student_distribution_sorted$CARRERA
  
  for (k in keys(hashed_data))
    if (length(hashed_data[[k]][["inscriptions"]]) > 1) {
      
      #generar estadisticas de alumnos inscritos en mas de una carrera en un rango de años
      
      lowerind = -1
      
      for (i in 1:(length(hashed_data[[k]][["inscriptions"]])))
        if (hashed_data[[k]][["inscriptions"]][[i]][["year"]] == target_year) {
          lowerind = i
          break
        }
      
      if (lowerind > -1 && lowerind < length(hashed_data[[k]][["inscriptions"]])) {
        
        for (upperind in (lowerind+1):(length(hashed_data[[k]][["inscriptions"]])))
          if (between(hashed_data[[k]][["inscriptions"]][[upperind]][["year"]],target_year,target_year+delta_year)) {
            migration_data[[hashed_data[[k]][["inscriptions"]][[lowerind]][["degree"]]]] = 
              migration_data[[hashed_data[[k]][["inscriptions"]][[lowerind]][["degree"]]]] + 1
            break
          }
        else{
          break
        }
      }
    }
  
  
  migration_data = migration_data / student_distribution_sorted[,toString(target_year)]
  
  migration_data$Carrera = student_distribution_sorted$CARRERA
  
  migration_data= migration_data[, c(2,1)]
  
  colnames(migration_data) [2] = "% de alumnos que se han inscrito a otra carrera en el periodo"
  
  #Como hay carreras que no tienen alumnos inscriptos en el año, puede que se divida por cero, a continuacion se 
  #limpia el resultado de dichas divisiones.
  
  is.nan.data.frame <- function(x)
    do.call(cbind, lapply(x, is.nan))
  
  migration_data[is.nan(migration_data)] = 0
  
  return(migration_data)
} 

createMigrationTable(2022,0)

