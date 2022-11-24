


readData = function (filename) {
  #Cargar todas las hojas del documento 
  
  sheetNames = readxl::excel_sheets("data.xlsx")
  
  yearlyData = lapply(sheetNames, function(x) 
    
    return (readxl::read_excel("data.xlsx", sheet=x))
  )
  
  yearlyDataSize = length(yearlyData)
  
  for (i in 1:yearlyDataSize){
    colnames(yearlyData[[i]])[4] = "TIPO DOC"
    colnames(yearlyData[[i]])[8] = "TIPO INS"
    yearlyData[[i]]$DOCUMENTO = as.character(yearlyData[[i]]$DOCUMENTO)
    
  }
  
  saveRDS(yearlyData, file= "yearlyData.RDS")
  
}

### Esta version mejorada indica al cargador de excel que debe interpretar los documentos como strings, lo que evita que algunos valores de 
### documento no numericos pasen al dataset con valor NA.

readData2 = function (filename) {
  #Cargar todas las hojas del documento 
  
  sheetNames = readxl::excel_sheets("data.xlsx")
  
  yearlyData = lapply(sheetNames, function(x) {
    
    nms = names(readxl::read_excel("data.xlsx",sheet=x, n_max = 0))
    
    #Se configura un vector que indica que el nro documento debe leerse como texto
    ct <- ifelse(nms=="DOCUMENTO", "text", "guess")
    
    return (readxl::read_excel("data.xlsx", sheet=x, col_types = ct))
    
  }
    
  )
  
  yearlyDataSize = length(yearlyData)
  
  for (i in 1:yearlyDataSize){
    colnames(yearlyData[[i]])[4] = "TIPO DOC"
    colnames(yearlyData[[i]])[8] = "TIPO INS"
    #earlyData[[i]]$DOCUMENTO = as.character(yearlyData[[i]]$DOCUMENTO)
    
  }
  
  saveRDS(yearlyData, file= "yearlyData.RDS")
  
}





