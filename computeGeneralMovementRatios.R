
### Criterios:
### Para determinar que un alumno pertenece a (REMATRICULADO): Se rematriculo en alguna de sus inscripciones originales
### Para determinar que un alumno pertenece a (MOVIMIENTO): Se inscribio en otra oferta y no pertenece a (REMATRICULADO)
### Para determinar que un alumno pertenece a (DESERCION): No pertenece a (REMATRICULADO) ni (MOVIMIENTO)
source("createStudentMovementTables.R")


computeGeneralMovementRatios = function (lowerYear, upperYear, selectedOriginUnit = NULL, selectedOriginOffer = NULL,
                                         selectedDestinationUnit = NULL, selectedDestinationOffer = NULL) {
  
    # lowerYear=1 
    # upperYear=2
    # selectedOriginUnit = NULL
    # selectedOriginOffer = NULL
    # selectedDestinationUnit = NULL
    # selectedDestinationOffer = NULL
    #   
    # 
    tb = createStudentMovementTablesV3(lowerYear,upperYear,selectedOriginUnit, selectedOriginOffer,
                                         selectedDestinationUnit, selectedDestinationOffer)
    
    reenrolledIds = unique(tb$reenrolledOnSameOffer$DOCUMENTO)
    
    reenrolledAmount = length(reenrolledIds) 
    
    #Hay que cambiar el nombre de moved a appeared
    
    movedIds = setdiff(unique(tb$movedToDifferentOffer$DOCUMENTO),reenrolledIds)
    
    movedAmount = length(movedIds)
    
    desertedIds = setdiff(setdiff(unique(tb$deserted$DOCUMENTO),movedIds),reenrolledIds)
    
    desertedAmount = length(desertedIds)
    
    enrolled = length(
      unique(
        (cleanAndFilter(year=lowerYear,enrollmentType="I",selectedUnit=selectedOriginUnit,selectedOffer=selectedOriginOffer))$DOCUMENTO))
    
    
    reenrolledPercent = reenrolledAmount/enrolled
    
    movedPercent = movedAmount/enrolled
    
    desertedPercent = desertedAmount/enrolled
    
    return(list(reenrolledAmount=reenrolledAmount,movedAmount=movedAmount,desertedAmount=desertedAmount,reenrolledPercent=reenrolledPercent,
                movedPercent=movedPercent,desertedPercent=desertedPercent))


  
}

###Este codigo es para probar otra version del generador de tablas
computeGeneralMovementRatios2 = function (lowerYear, upperYear, selectedOriginUnit = NULL, selectedOriginOffer = NULL,
                                         selectedDestinationUnit = NULL, selectedDestinationOffer = NULL) {
  # lowerYear=1 
  # upperYear=2
  # selectedOriginUnit = NULL
  # selectedOriginOffer = NULL
  # selectedDestinationUnit = NULL
  # selectedDestinationOffer = NULL
  
  tb = createStudentMovementTablesV2(lowerYear,upperYear,selectedOriginUnit, selectedOriginOffer,
                                     selectedDestinationUnit, selectedDestinationOffer)
  
  reenrolledIds = unique(tb$reenrolledOnSameOffer$DOCUMENTO)
  
  reenrolledAmount = length(reenrolledIds) 
  
  #Hay que cambiar el nombre de moved a appeared
  
  movedIds = setdiff(unique(tb$movedToDifferentOffer$DOCUMENTO),reenrolledIds)
  
  movedAmount = length(movedIds)
  
  desertedIds = setdiff(setdiff(unique(tb$deserted$DOCUMENTO),movedIds),reenrolledIds)
  
  desertedAmount = length(desertedIds)
  
  enrolled = length(
    unique(
      (cleanAndFilter(year=lowerYear,enrollmentType="I",selectedUnit=selectedOriginUnit,selectedOffer=selectedOriginOffer))$DOCUMENTO))
  
  
  reenrolledPercent = reenrolledAmount/enrolled
  
  movedPercent = movedAmount/enrolled
  
  desertedPercent = desertedAmount/enrolled
  
  return(list(reenrolledAmount=reenrolledAmount,movedAmount=movedAmount,desertedAmount=desertedAmount,reenrolledPercent=reenrolledPercent,
              movedPercent=movedPercent,desertedPercent=desertedPercent))
  
  
  
}