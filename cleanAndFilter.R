###
### Descarta filas repetidas (distinct) y filtra si los argumentos se encuentran presentes
### 

cleanAndFilter = function(year = 1,enrollmentType = NULL, selectedGenre = NULL,selectedUnit=NULL, selectedOffer=NULL) {
  
  result = yd[[year]]
  
  if (!is.null(enrollmentType))
    result = result %>% filter(`TIPO INS` == enrollmentType)
  if (!is.null(selectedGenre))
    result = result %>% filter(`SEXO` == selectedGenre)
  if (!is.null(selectedUnit))
    result = result %>% filter(`UNIDAD` == selectedUnit)
  if (!is.null(selectedOffer))
    result = result %>% filter(`CARRERA` == selectedOffer)
  
  #Descarta posibles filas duplicadas
  result = distinct(result,DOCUMENTO,CARRERA,UNIDAD,.keep_all=TRUE)
  
  return (result)
}