migrations <- readxl::read_excel("datos migraciones ofuscado.xlsx");

migrations

cleanFirstSet <- migrations[0:202,c(1,2,4, 6,20,36,49,52)]

colnames(cleanFirstSet) <- c("unit","id","sex","adm_year","career","fin_total","fin_last_year,","fin_this_year")

cleanFirstSet[10:20,]


#habria que poner un valor por defecto en las columnas NA