install.packages("rlist")
install.packages("hash")
library("rlist")
library(hash)


exa = readxl::read_excel("exactas.xlsx");

exa = exa[,c("Id ofuscado","CARRERA","SEXO","TIPO","INGRESO","CALIDAD","FINALES total","INSC CURS","finales aprob año anterior","finales AprobadosActual")]

exa[exa$CARRERA == "NA","CARRERA"] = "sin_carrera"

View(exa)

data_list <- list()



data_list = list.append(data_list, 516156)

data_list

h <- hash() 


  for (i in 1:nrow(exa)) {
    
    if (is.null(h[[exa[i,"Id ofuscado"]]])) {
      h[[exa[i,"Id ofuscado"]]] = list(exa[i, "CARRERA"])
    }
    else {
      h[[exa[i,"Id ofuscado"]]] = list.append(h[[exa[i,"Id ofuscado"]]],list(exa[i, "CARRERA"]))
    }
  }

h[[toString(exa[1,"Id ofuscado"])]]





