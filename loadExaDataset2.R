library(rlist)
library(hash)
library(tidyr)

data = readxl::read_excel("exactas.xlsx");

data = data[,c("Id ofuscado","CARRERA","SEXO","TIPO","INGRESO","CALIDAD","FINALES total","INSC CURS","finales aprob año anterior","finales AprobadosActual")]

data[data$CARRERA == "NA","CARRERA"] = "sin_carrera"

student_distribuion_unsorted = data %>% count(CARRERA,INGRESO) %>% spread(INGRESO,n) 
student_distribuion_unsorted[is.na(student_distribuion_unsorted)] = 0

student_distribuion_sorted = arrange(student_distribuion_unsorted,CARRERA)

saveRDS(student_distribuion_sorted, file = "exa_student_distribution.RDS")


h <- hash() 

for (i in 1:nrow(data)) {
  
  if (is.null(h[[toString(data[i,"Id ofuscado"])]])) {
    h[[toString(data[[i,"Id ofuscado"]])]] = list(sex = data[[i, "SEXO"]], inscriptions = 
    list(list(degree = data[[i, "CARRERA"]], year = data[[i, "INGRESO"]], exams = data[[i, "FINALES total"]],LYexams = data[[i, "finales aprob año anterior"]], TYexams = data[[i, "finales AprobadosActual"]],
    coursesInscriptions = data[[i, "INSC CURS"]])))
  }
  else {
    h[[toString(data[[i,"Id ofuscado"]])]][["inscriptions"]] = 
    list.append(h[[toString(data[[i,"Id ofuscado"]])]][["inscriptions"]], 
    list(degree = data[[i, "CARRERA"]], year = data[[i, "INGRESO"]], exams = data[[i, "FINALES total"]],LYexams = data[[i, "finales aprob año anterior"]], TYexams = data[[i, "finales AprobadosActual"]],
    coursesInscriptions = data[[i, "INSC CURS"]]))
  }
}

###codigo para hacer ordenamiento de las listas de inscripciones por año
for (k in keys(h))
  h[[k]][["inscriptions"]] = 
  h[[k]][["inscriptions"]][order(sapply(h[[k]][["inscriptions"]],function(x) x[["year"]]))]

saveRDS(h, file = "exa_hashed_data.RDS")

#all(exa$`Id ofuscado` %in% keys(h)) #Determina que todos los elementos del conjutno de ids estan ingresados de alguna manera en el hash

