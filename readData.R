
#Cargar todas las hojas del documento 

sheetNames = readxl::excel_sheets("data.xlsx")

yearlyData = lapply(sheetNames, function(x) 
  
  return (readxl::read_excel("data.xlsx", sheet=x))
)

yearlyDataSize = length(yearlyData)

for (i in 1:yearlyDataSize)
yearlyData[[i]]$DOCUMENTO = as.character(yearlyData[[i]]$DOCUMENTO)


yearlyData[[1]] %>% inner_join(yearlyData[[2]],by=c("DOCUMENTO","CARRERA")) #Esto esta bien, pero acordarse que 
#tambien se debe ver que el tipo del segundo dataset sea reinscripto, hay gente que se inscribe 1 año y al año siguiente de nuevo.
#Si no hago ese filtrado entonces tomo como que una segunda inscripcion equivale a una rematriculacion


yearlyData[[1]] %>% count(DOCUMENTO)

