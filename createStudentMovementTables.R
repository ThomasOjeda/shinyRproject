
###
### Genera las tablas que indican los movimientos de los alumnos con respecto a otras ofertas academicas
###

createStudentMovementTables = function (lowerYear=1,upperYear=2) { 

  #lowerYear=5
  #upperYear=6
  
  yd = readRDS("yearlyData.RDS")

  #tambien se debe ver que el tipo del segundo dataset sea reinscripto, hay gente que se inscribe 1 año y al año siguiente de nuevo.
  #Si no hago ese filtrado entonces tomo como que una segunda inscripcion equivale a una rematriculacion
  #EN el segundo dataset 37370585 esta repetido como si se hubiera inscripto por primera vez dos veces, no le encuentro sentido. Si
  #llega a ser un problema habria que hacer un unique.
  #Tener en cuenta que se podrian hacer las operaciones en un orden distinto para aumentar el rendimiento
  
  # filtrando (DOCUMENTO,CARRERA) repetidos
  reenrolledOnSameOffer = (distinct(yd[[lowerYear]],DOCUMENTO,CARRERA,UNIDAD,.keep_all=TRUE)) %>% filter(`TIPO INS` == "I") %>% 
    inner_join(distinct(yd[[upperYear]],DOCUMENTO,CARRERA,UNIDAD,.keep_all=TRUE) %>% filter(`TIPO INS` == "R"),by=c("DOCUMENTO","CARRERA","UNIDAD")) %>% 
    select(DOCUMENTO, UNIDAD, CARRERA, SEXO = SEXO.x)
  
  missingFromSameOffer = setdiff(distinct(yd[[lowerYear]],DOCUMENTO,CARRERA,UNIDAD,.keep_all=TRUE) %>% filter(`TIPO INS` == "I") %>% 
                                   select(DOCUMENTO,UNIDAD, CARRERA, SEXO) , reenrolledOnSameOffer)

  
  movedToDifferentOffer = missingFromSameOffer %>% inner_join(distinct(yd[[upperYear]],DOCUMENTO,CARRERA,UNIDAD,.keep_all=TRUE) %>% 
                                                   filter(`TIPO INS` == "I") %>%
                                                   select(DOCUMENTO,UNIDAD,CARRERA), by="DOCUMENTO") %>% 
                          select(DOCUMENTO, SEXO, UNIDAD.ORIGEN = UNIDAD.x, UNIDAD.DESTINO=UNIDAD.y, CARRERA.ORIGEN = CARRERA.x, CARRERA.DESTINO = CARRERA.y)
  
  deserted = setdiff(missingFromSameOffer,movedToDifferentOffer %>% select(DOCUMENTO,UNIDAD = UNIDAD.ORIGEN, CARRERA = CARRERA.ORIGEN,SEXO))
  
  #Puede ocurrir que un alumno que se inscribio a mas de una carrera en el primer periodo luego se haya inscrito 
  #a otras (mas de una) carrera, por lo que hay que filtrar pasajes de carrera repetidos en caso de que se quiera considerar esos
  #casos como un solo cambio de oferta
  #En caso de que el alumno se haya inscrito en 2 ofertas y haya renovado 1, entonces aparecera tanto en la lista de rematriculados
  #como en la lista de movimientos a distinta oferta. PREGUNTAR!!!!!!
  #Hay que continuar procesando estas tablas obtenidas para poder hacer la estadistica por estos "problemas de consistencia"
  
  
  return (list(reenrolledOnSameOffer=reenrolledOnSameOffer,missingFromSameOffer=missingFromSameOffer,movedToDifferentOffer=movedToDifferentOffer,deserted=deserted))
  
  
  

  }