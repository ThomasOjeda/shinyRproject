
missingStudents = function (lowerYear=1,upperYear=2) {

  lowerYear=1
  upperYear=2
  
  yd = readRDS("yearlyData.RDS")

  #tambien se debe ver que el tipo del segundo dataset sea reinscripto, hay gente que se inscribe 1 año y al año siguiente de nuevo.
  #Si no hago ese filtrado entonces tomo como que una segunda inscripcion equivale a una rematriculacion
  #EN el segundo dataset 37370585 esta repetido como si se hubiera inscripto por primera vez dos veces, no le encuentro sentido. Si
  #llega a ser un problema habria que hacer un unique.
  #Tener en cuenta que se podrian hacer las operaciones en un orden distinto para aumentar el rendimiento
  
  #reenrolled = (yd[[lowerYear]] %>% filter(`TIPO INS` == "I")) %>% 
  #  inner_join((yd[[upperYear]] %>% filter(`TIPO INS` == "R")),by=c("DOCUMENTO","CARRERA")) %>% 
  #  select(DOCUMENTO, CARRERA)
  
  #missing = setdiff(yd[[lowerYear]] %>% filter(`TIPO INS` == "I") %>% select(DOCUMENTO, CARRERA) , reenrolled)
  
  #variante filtrando (DOCUMENTO,CARRERA) repetidos
  reenrolledOnSameOffer = (distinct(yd[[lowerYear]],DOCUMENTO,CARRERA,.keep_all=TRUE)) %>% filter(`TIPO INS` == "I") %>% 
    inner_join(distinct(yd[[upperYear]],DOCUMENTO,CARRERA,.keep_all=TRUE) %>% filter(`TIPO INS` == "R"),by=c("DOCUMENTO","CARRERA","UNIDAD")) %>% 
    select(DOCUMENTO, UNIDAD, CARRERA, SEXO = SEXO.x)
  
  missingFromSameOffer = setdiff(distinct(yd[[lowerYear]],DOCUMENTO,CARRERA,.keep_all=TRUE) %>% filter(`TIPO INS` == "I") %>% 
                                   select(DOCUMENTO,UNIDAD, CARRERA, SEXO) , reenrolledOnSameOffer)

  movedToDifferentOffer = missingFromSameOffer %>% inner_join(yd[[upperYear]] %>% filter(`TIPO INS` == "I") %>% 
                          select(DOCUMENTO,UNIDAD,CARRERA), by="DOCUMENTO") %>% 
                          select(DOCUMENTO, SEXO, UNIDAD.ORIGEN = UNIDAD.x, UNIDAD.DESTINO=UNIDAD.y, CARRERA.ORIGEN = CARRERA.x, CARRERA.DESTINO = CARRERA.y)
  
}