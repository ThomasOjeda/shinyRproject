

### Indica al cargador de excel que debe interpretar los documentos como strings, lo que evita que algunos valores de 
### documento no numericos pasen al dataset con valor NA.

readData2 = function () {
  
  filename = "prueba.xlsx"
  #Cargar todas las hojas del documento 
  
  sheetNames = readxl::excel_sheets(filename)
  
  yearlyData = lapply(sheetNames, function(x) {
    
    nms = names(readxl::read_excel(filename,sheet=x, n_max = 0))
    
    #Se configura un vector que indica que el nro documento debe leerse como texto
    ct <- ifelse(nms=="DOCUMENTO", "text", "guess")
    
    return (readxl::read_excel(filename, sheet=x, col_types = ct))
    
  }
    
  )
  
  yearlyDataSize = length(yearlyData)
  
  for (i in 1:yearlyDataSize){
    colnames(yearlyData[[i]])[4] = "TIPO DOC"
    colnames(yearlyData[[i]])[8] = "TIPO INS"

  }
  
  saveRDS(yearlyData, file= "datos_test.RDS")
  
}

### Igual que readData2 pero con el arreglo de ingenieria de sistemas en quequen

readData3 = function () {
  
  filename = "data.xlsx"
  #Cargar todas las hojas del documento 
  
  sheetNames = readxl::excel_sheets(filename)
  
  yearlyData = lapply(sheetNames, function(x) {
    
    nms = names(readxl::read_excel(filename,sheet=x, n_max = 0))
    
    #Se configura un vector que indica que el nro documento debe leerse como texto
    ct <- ifelse(nms=="DOCUMENTO", "text", "guess")
    
    return (readxl::read_excel(filename, sheet=x, col_types = ct))
    
  }
  
  )
  
  yearlyDataSize = length(yearlyData)
  
  for (i in 1:yearlyDataSize){
    colnames(yearlyData[[i]])[4] = "TIPO DOC"
    colnames(yearlyData[[i]])[8] = "TIPO INS"

    #Modificación para incluir a los alumnos de ingenieria de quequen en el calculo de ingenieria de exactas.
    yearlyData[[i]]["UNIDAD"][yearlyData[[i]]["UNIDAD"] == "UEQ" & yearlyData[[i]]["CARRERA"] == "Ciclo Inicial en Ingeniería"] = "EXA"
    yearlyData[[i]]["CARRERA"][yearlyData[[i]]["UNIDAD"] == "EXA" & yearlyData[[i]]["CARRERA"] == "Ciclo Inicial en Ingeniería"] = "Ingeniería de Sistemas"
    
  }
  

  saveRDS(yearlyData, file= "yearlyData.RDS")
  
}





