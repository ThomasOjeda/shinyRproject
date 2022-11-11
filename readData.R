


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




