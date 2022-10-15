
obtainHashedDataFromUnit = function(unit) {
  
  if (unit=="Exactas") {
   return(readRDS("exa_hashed_data.RDS"))

  }
  if (unit=="Humanas") {
    return(readRDS("hum_hashed_data.RDS"))

  }
  if (unit=="Economicas") {
    return(readRDS("eco_hashed_data.RDS"))
  }
  
  
  return (NULL)
}


obtainStudentDistributionFromUnit = function(unit) {
  
  if (unit=="Exactas") {
    return(readRDS("exa_student_distribution.RDS"))

  }
  if (unit=="Humanas") {
    return(readRDS("hum_student_distribution.RDS"))

  }
  if (unit=="Economicas") {
    return(readRDS("eco_student_distribution.RDS"))

  }
  
  return(NULL)
}