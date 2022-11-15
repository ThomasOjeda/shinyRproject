
### Criterios:
### Para determinar que un alumno pertenece a (REMATRICULADO): Se rematriculo en alguna de sus inscripciones originales
### Para determinar que un alumno pertenece a (MOVIMIENTO): Se inscribio en otra oferta y no pertenece a (REMATRICULADO)
### Para determinar que un alumno pertenece a (DESERCION): No pertenece a (REMATRICULADO) ni (MOVIMIENTO)
source("createStudentMovementTables.R")

computeGeneralMovementRatios = function () {
  
  lowerYear=5
  
  upperYear=7
  
  tb = createStudentMovementTables(lowerYear,upperYear)
  
  reenrolledIds = unique(tb$reenrolledOnSameOffer$DOCUMENTO)
  
  reenrolledAmount = length(reenrolledIds) 
  
  movedIds = setdiff(tb$movedToDifferentOffer$DOCUMENTO,reenrolledIds)
  
  movedAmount = length(movedIds)
  
  desertedIds = setdiff(setdiff(tb$deserted$DOCUMENTO,movedIds),reenrolledIds)
  
  desertedAmount = length(desertedIds)
  
  yd = readRDS("yearlyData.RDS")
  
  reenrolledPercent = reenrolledAmount/length(unique((yd[[lowerYear]] %>% filter(`TIPO INS`=="I"))$DOCUMENTO))
  
  movedPercent = movedAmount/length(unique((yd[[lowerYear]] %>% filter(`TIPO INS`=="I"))$DOCUMENTO))
  
  desertedPercent = desertedAmount/length(unique((yd[[lowerYear]] %>% filter(`TIPO INS`=="I"))$DOCUMENTO))
  
  
  
}