library(markdown)

student_distribution_sorted = readRDS("exa_student_distribution.RDS")

ui = navbarPage("Estadisticas de Migraciones",

                
                tabPanel("Migraciones",
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
                           
                           mainPanel( fluidPage(
                             tableOutput("migration_data"),
                             
                             plotOutput("migration_pie_chart")                   
                                                
                                                ))
                           
                         )
           ),
           tabPanel("Red",
                    plotOutput("network")
           )
)
