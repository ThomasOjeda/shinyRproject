library(hash)
library(dplyr)

is.nan.data.frame <- function(x)
  do.call(cbind, lapply(x, is.nan))

createMigrationTable = function (hashed_data,student_distribution_sorted,target=2022,delta=0) {
  
  
  #hashed_data = readRDS("exa_hashed_data.RDS")
  #student_distribution_sorted = readRDS("exa_student_distribution.RDS")
  
  #moving_students_graph = matrix(0,length(student_distribution_sorted$CARRERA),length(student_distribution_sorted$CARRERA))
  
  migrations_per_degree_vector = vector(mode="numeric", length = length(student_distribution_sorted$CARRERA))
  names(migrations_per_degree_vector) = student_distribution_sorted$CARRERA
  
  
  target_year = target
  delta_year = delta
  
  migration_data = vector(mode = "numeric", length = length(student_distribution_sorted$CARRERA))
  
  names(migration_data)  = student_distribution_sorted$CARRERA
  
  for (k in keys(hashed_data))
    if (length(hashed_data[[k]][["inscriptions"]]) > 1) {
      

      lowerind = -1
      
      for (i in 1:(length(hashed_data[[k]][["inscriptions"]])))
        if (hashed_data[[k]][["inscriptions"]][[i]][["year"]] == target_year) {
          lowerind = i
          break
        }
      
      if (lowerind > -1 && lowerind < length(hashed_data[[k]][["inscriptions"]])) {
        deg = hashed_data[[k]][["inscriptions"]][[lowerind]][["degree"]]
        ##agregar una matriz para saber a donde migro
        for (upperind in (lowerind+1):(length(hashed_data[[k]][["inscriptions"]])))
          if (between(hashed_data[[k]][["inscriptions"]][[upperind]][["year"]],target_year,target_year+delta_year)) {
            migration_data[[deg]] = migration_data[[deg]] + 1
            break
          }
        else{
          break
        }
      }
    }
  
  
  migration_data_frame = (migration_data / student_distribution_sorted[,toString(target_year)]) * 100
  
  migration_data_frame$Carrera = student_distribution_sorted$CARRERA
  
  migration_data_frame$Cantidad_de_Migraciones = migration_data
  
  migration_data_frame$Cantidad_de_Inscriptos = data.frame(student_distribution_sorted[,toString(target_year)])
  
  migration_data_frame= migration_data_frame[, c(2,3,4,1)]
  
  
  colnames(migration_data_frame) [1] = "Carrera"
  colnames(migration_data_frame) [2] = "Migraciones"
  colnames(migration_data_frame) [3] = "Inscritos"
  colnames(migration_data_frame) [4] = "% de migracion"
  

  
  #Como hay carreras que no tienen alumnos inscriptos en el año, puede que se divida por cero, a continuacion se 
  #limpia el resultado de dichas divisiones.

  
  migration_data_frame[is.nan(migration_data_frame)] = 0
  

  
  
  return(migration_data_frame)
} 


