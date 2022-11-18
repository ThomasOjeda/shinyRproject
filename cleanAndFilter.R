###
### Descarta filas repetidas (distinct) y filtra si los argumentos se encuentran presentes
### 

cleanAndFilter = function(year = 1,enrollmentType = NULL,selectedUnit=NULL, selectedOffer=NULL) {
  
  result = distinct(yd[[year]],DOCUMENTO,CARRERA,UNIDAD,.keep_all=TRUE)
  
  if (!is.null(enrollmentType))
  result = result %>% filter(`TIPO INS` == enrollmentType)
  if (!is.null(selectedUnit))
  result = result %>% filter(`UNIDAD` == selectedUnit)
  if (!is.null(selectedOffer))
  result = result %>% filter(`CARRERA` == selectedOffer)
  
  return (result)
}