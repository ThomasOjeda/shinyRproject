
obtainProcessedDataFromUnit = function(unit) {
  
  if(is.null(unit) || is.na(unit)) return(NULL)
  
  if (unit=="Exactas") {
    return(list(hashed_data=readRDS("exa_hashed_data.RDS"),student_distribution_sorted=readRDS("exa_student_distribution.RDS")))
  }
  if (unit=="Humanas") {
    return(list(hashed_data=readRDS("hum_hashed_data.RDS"),student_distribution_sorted=readRDS("hum_student_distribution.RDS")))
    
  }
  if (unit=="Economicas") {
    return(list(hashed_data=readRDS("eco_hashed_data.RDS"),student_distribution_sorted=readRDS("eco_student_distribution.RDS")))
  }
  if (unit=="Veterinarias") {
    return(list(hashed_data=readRDS("vet_hashed_data.RDS"),student_distribution_sorted=readRDS("vet_student_distribution.RDS")))
  }
  if (unit=="Ingeniería") {
    return(list(hashed_data=readRDS("ing_hashed_data.RDS"),student_distribution_sorted=readRDS("ing_student_distribution.RDS")))
  }
  if (unit=="Salud") {
    return(list(hashed_data=readRDS("sal_hashed_data.RDS"),student_distribution_sorted=readRDS("sal_student_distribution.RDS")))
  }
  
  return (NULL)
}


obtainUnits = function() {
  
  return(c("Exactas","Economicas","Humanas","Veterinarias","Ingeniería","Salud"))
}

obtainUnits2 = function() {
  
  return(c("Todas","FAA", "DER", "FSC" ,"VET" ,"EXA", "UEQ" ,"EST", "ESS", "FIO", "FCE" ,"FCH"))
}

obtainYears = function() {
  return(c("2015","2016", "2017", "2018" ,"2019" ,"2020", "2020"))
}

firstYear = function() {
  return(2014)
}



