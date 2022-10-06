student_distribution_sorted = readRDS("exa_student_distribution.RDS")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  titlePanel("Migraciones De Carreras"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Seleccione un rango de años"),
      
      sliderInput("start_year", 
                  label = "Año de comienzo",
                  min = as.numeric(colnames(student_distribution_sorted)[2]), 
                  max = as.numeric(colnames(student_distribution_sorted)[ncol(student_distribution_sorted)]), 
                  value = as.numeric(colnames(student_distribution_sorted)[ncol(student_distribution_sorted)])) ,
      sliderInput("delta", 
                  label = "Delta",
                  min = 0, max = 6, value = 0)
    ),
    
    mainPanel( tableOutput("migration_data"))
    
  )
)