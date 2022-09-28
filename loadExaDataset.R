exa <- readxl::read_excel("exactas.xlsx");

exa <- exa[,c("Id ofuscado","CARRERA","SEXO","TIPO","INGRESO","CALIDAD","FINALES total","INSC CURS","finales aprob año anterior","finales AprobadosActual")]

exa[exa$CARRERA == "NA","CARRERA"] = "sin_carrera"



