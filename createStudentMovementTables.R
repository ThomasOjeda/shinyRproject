
###
### Genera las tablas que indican los movimientos de los alumnos con respecto a otras ofertas academicas
###

createStudentMovementTables = function (lowerYear=1,upperYear=2) { 

  #lowerYear=5
  #upperYear=6
  
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
  
  
  return (list(reenrolledOnSameOffer=reenrolledOnSameOffer,movedToDifferentOffer=movedToDifferentOffer,deserted=deserted))
  
  
  

}


source("cleanAndFilter.R")

createStudentMovementTablesV2 = function (lowerYear=1,upperYear=2,selectedOriginUnit = NULL, selectedOriginOffer = NULL,
                                          selectedDestinationUnit = NULL, selectedDestinationOffer = NULL) { 

  # lowerYear=3
  # upperYear=4
  # selectedOriginUnit = NULL
  # selectedOriginOffer = NULL
  # selectedDestinationUnit = NULL
  # selectedDestinationOffer = NULL

  #tambien se debe ver que el tipo del segundo dataset sea reinscripto, hay gente que se inscribe 1 año y al año siguiente de nuevo.
  #Si no hago ese filtrado entonces tomo como que una segunda inscripcion equivale a una rematriculacion
  #EN el segundo dataset 37370585 esta repetido como si se hubiera inscripto por primera vez dos veces, no le encuentro sentido. Si
  #llega a ser un problema habria que hacer un unique.
  #Tener en cuenta que se podrian hacer las operaciones en un orden distinto para aumentar el rendimiento
  
  filteredLowerYearInscriptions = cleanAndFilter(year=lowerYear,enrollmentType = "I", 
                                                 selectedUnit = selectedOriginUnit,selectedOffer = selectedOriginOffer)
  
  
  reenrolledOnSameOffer = filteredLowerYearInscriptions %>% 
    inner_join(cleanAndFilter(year=upperYear,enrollmentType="R",selectedUnit = selectedDestinationUnit,selectedOffer = selectedDestinationOffer),
               by=c("DOCUMENTO","CARRERA","UNIDAD")) %>% 
    select(DOCUMENTO, UNIDAD, CARRERA, SEXO = SEXO.x)
  
  
  movedToDifferentOffer = filteredLowerYearInscriptions %>% 
    inner_join(cleanAndFilter(year=upperYear,enrollmentType="I",selectedUnit=selectedDestinationUnit,selectedOffer=selectedDestinationOffer),
               by=c("DOCUMENTO")) %>% 
    select(DOCUMENTO, SEXO = SEXO.x, UNIDAD.ORIGEN = UNIDAD.x, UNIDAD.DESTINO=UNIDAD.y, CARRERA.ORIGEN = CARRERA.x, CARRERA.DESTINO = CARRERA.y)
  
  
  #Hay alumnos que se INSCRIBEN de nuevo a la misma carrera (no reinscripcion), que se estan considerando movimientos. El siguiente
  #Codigo los cambia de movimientos a rematriculaciones
  
  enrolledAgainOnSameOffer = movedToDifferentOffer %>% filter(UNIDAD.ORIGEN == UNIDAD.DESTINO,CARRERA.ORIGEN == CARRERA.DESTINO)
  movedToDifferentOffer = setdiff(movedToDifferentOffer,enrolledAgainOnSameOffer)
  reenrolledOnSameOffer = union(reenrolledOnSameOffer,enrolledAgainOnSameOffer%>%select(DOCUMENTO,UNIDAD=UNIDAD.ORIGEN,CARRERA = CARRERA.ORIGEN,SEXO))
  
  
  #Los desertores son los que se inscribieron en el primer año y luego no se rematricularon ni se movieron a otra oferta
  #Lo hago con una diferencia de conjuntos
  
  deserted = setdiff(setdiff(
    filteredLowerYearInscriptions  %>% 
      select(DOCUMENTO, UNIDAD, CARRERA, SEXO)
    ,
    movedToDifferentOffer %>% select(DOCUMENTO,UNIDAD = UNIDAD.ORIGEN, CARRERA = CARRERA.ORIGEN,SEXO))
    ,
    reenrolledOnSameOffer
  )
  
  #Puede ocurrir que un alumno que se inscribio a mas de una carrera en el primer periodo luego se haya inscrito 
  #a otras (mas de una) carrera, por lo que hay que filtrar pasajes de carrera repetidos en caso de que se quiera considerar esos
  #casos como un solo cambio de oferta
  #En caso de que el alumno se haya inscrito en 2 ofertas y haya renovado 1, entonces aparecera tanto en la lista de rematriculados
  #como en la lista de movimientos a distinta oferta. PREGUNTAR!!!!!!
  #Hay que continuar procesando estas tablas obtenidas para poder hacer la estadistica por estos "problemas de consistencia"
  
  
  return (list(reenrolledOnSameOffer=reenrolledOnSameOffer,movedToDifferentOffer=movedToDifferentOffer,deserted=deserted))
  
}


## El otro no creo que estaba mal, pero este da mejores resultados porque en el dataset por ejemplo 
## el dni 36827802 en el periodo 2015-2016 se encuentra inscripto a una carrera y luego reinscripto a otra distinta
## cosa que en el v2 no entra como rematriculacion ni movimiento. En esta version entra como movimiento.
## con el dni 34763797 pasa algo parecido. estos casos no estaban contemplados

##Los documentos que difieren en los movimienos de v2 y v3
# [1] "36827802" "39589085" "36608435" "37031737" "38284156" "35888951" "36045072" "37405498" "34763797" "36383780" "37152240" "38106534" "35333920"
# [14] "36688770" "34961367" "26972033" "37350999" "38831575" "33898830" "37031592" "38430623" "36442748" "35867928" "35888776" "35130134" "33189115"
# [27] "32181361" "30180022" "31708579" "38045888" "32257583" "29533980" "31584700" "32563474" "37245242" "38626156" "35098916" "37623777" "38129732"
# [40] "37344738" "35996349" "38014767" "36528140" "38270485" "38129580" "37238401" "37790975" "31227724" "39550773" "32425361" "14868598" "36852851"
# [53] "37899924" "26966262" "37238326" "37237220" "37337654" "33772262" "35332804" "35829224" "33797620" "31727464" "31156104" "94742714" "32800419"
# [66] "35332571" "17633345" "37218198" "95062035" "33908382" "35774607" "41799561" "38529612" "26271362" "33347325" "33307405" "39170375" "38951046"
# [79] "36608185" "36834231" "37766382" "37909129" "36809314" "32995480" "34751354" "38529699" "16487366" "38082079"
##ALGUNA QUE OTRA CARRERA CAMBIO DE NOMBRE, OTRAS SON LAS MATERIAS LIBRES O NO SE QUE

createStudentMovementTablesV3 = function (lowerYear=1,upperYear=2,selectedOriginUnit = NULL, selectedOriginOffer = NULL,
                                          selectedDestinationUnit = NULL, selectedDestinationOffer = NULL) { 
# 
#   lowerYear=1
#   upperYear=2
#   selectedOriginUnit = NULL
#   selectedOriginOffer = NULL
#   selectedDestinationUnit = NULL
#   selectedDestinationOffer = NULL
  
  #tambien se debe ver que el tipo del segundo dataset sea reinscripto, hay gente que se inscribe 1 año y al año siguiente de nuevo.
  #Si no hago ese filtrado entonces tomo como que una segunda inscripcion equivale a una rematriculacion
  #EN el segundo dataset 37370585 esta repetido como si se hubiera inscripto por primera vez dos veces, no le encuentro sentido. Si
  #llega a ser un problema habria que hacer un unique.
  #Tener en cuenta que se podrian hacer las operaciones en un orden distinto para aumentar el rendimiento
  
  filteredLowerYearAppearances = cleanAndFilter(year=lowerYear,enrollmentType = "I"
                                                , selectedUnit = selectedOriginUnit,selectedOffer = selectedOriginOffer)
  
  filteredUpperYearAppearances = cleanAndFilter(year=upperYear,selectedUnit=selectedDestinationUnit,selectedOffer=selectedDestinationOffer)
  
  reenrolledOnSameOffer = filteredLowerYearAppearances %>% 
    inner_join(filteredUpperYearAppearances,
               by=c("DOCUMENTO","CARRERA","UNIDAD")) %>%
    select(DOCUMENTO, UNIDAD, CARRERA, SEXO = SEXO.x)

  #Habra algunos de los registrados como movimientos que tambien seran registrados como reenrolled.
  
  movedToDifferentOffer = filteredLowerYearAppearances %>% 
    inner_join(filteredUpperYearAppearances,
               by=c("DOCUMENTO")) %>% 
    select(DOCUMENTO, SEXO = SEXO.x, UNIDAD.ORIGEN = UNIDAD.x, UNIDAD.DESTINO=UNIDAD.y, CARRERA.ORIGEN = CARRERA.x, CARRERA.DESTINO = CARRERA.y)
  
  
  #Hay alumnos que se INSCRIBEN de nuevo a la misma carrera (no reinscripcion), que se estan considerando movimientos. El siguiente
  #Codigo los cambia de movimientos a rematriculaciones
  
  # enrolledAgainOnSameOffer = movedToDifferentOffer %>% filter(UNIDAD.ORIGEN == UNIDAD.DESTINO,CARRERA.ORIGEN == CARRERA.DESTINO)
  # movedToDifferentOffer = setdiff(movedToDifferentOffer,enrolledAgainOnSameOffer)
  # reenrolledOnSameOffer = union(reenrolledOnSameOffer,enrolledAgainOnSameOffer%>%select(DOCUMENTO,UNIDAD=UNIDAD.ORIGEN,CARRERA = CARRERA.ORIGEN,SEXO))
  # 
  
  #Los desertores son los que se inscribieron en el primer año y luego no tuvieron ningun tipo de aparicion en el año superior
  #Lo hago con una diferencia de conjuntos
  
  deserted = setdiff(setdiff(
    filteredLowerYearAppearances  %>% 
      select(DOCUMENTO, UNIDAD, CARRERA, SEXO)
    ,
    movedToDifferentOffer %>% select(DOCUMENTO,UNIDAD = UNIDAD.ORIGEN, CARRERA = CARRERA.ORIGEN,SEXO))
    ,
    reenrolledOnSameOffer #Como movedToDifferentOffer contiene a reenrolledOnSameOffer, esta resta seria innecesaria
  )
  
  #Puede ocurrir que un alumno que se inscribio a mas de una carrera en el primer periodo luego se haya inscrito 
  #a otras (mas de una) carrera, por lo que hay que filtrar pasajes de carrera repetidos en caso de que se quiera considerar esos
  #casos como un solo cambio de oferta
  #En caso de que el alumno se haya inscrito en 2 ofertas y haya renovado 1, entonces aparecera tanto en la lista de rematriculados
  #como en la lista de movimientos a distinta oferta. PREGUNTAR!!!!!!
  #Hay que continuar procesando estas tablas obtenidas para poder hacer la estadistica por estos "problemas de consistencia"
  
  
  return (list(reenrolledOnSameOffer=reenrolledOnSameOffer,movedToDifferentOffer=movedToDifferentOffer,deserted=deserted))
  
}
