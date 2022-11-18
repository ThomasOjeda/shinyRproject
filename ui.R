
ui = navbarPage("Movimientos entre ofertas academicas",
          tabPanel("Estadisticas de movimientos generales",
                   sidebarLayout(
                     sidebarPanel(
                       sliderInput("general_mov_stats_year", 
                                   label = "Año",
                                   min = 1, max = 6, value = 1),
                       radioButtons("general_mov_stats_delta", 
                                   label = "Despues de",
                                   choices = list("1 año" = 1, "2 años" = 2,"3 años" = 3),
                                   selected = 1
                                   ),
                       uiOutput("origin_unit_mov_selector"),
                       uiOutput("destination_unit_mov_selector"),
                       actionButton("mov_stats_update_button", "Go")
                       
                     ),
                     mainPanel(
                       plotOutput("general_student_movement_ratios")
                     )
                   )
                   
          ),

          
          tabPanel("Migraciones",
                   sidebarLayout(
                     sidebarPanel(
                       uiOutput("migrations_unit_selector"),
                       helpText("Seleccione un rango de años"),
                       uiOutput("migration_range_selectors") ,
                       sliderInput("delta", 
                                   label = "Delta",
                                   min = 0, max = 10, value = 0)
                     ),
                     
                     mainPanel( fluidPage(
                       h3("Informacion de migraciones"),
                       tableOutput("migration_data"),
                       h3("De las migraciones, porcentaje perteneciente a cada carrera"),
                       plotOutput("migration_pie_chart")                   
                                          
                                          ))
                     
                   )
           ),
           tabPanel("Historico de migraciones por carrera",
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput("unit_hist_selector"),
                        uiOutput("degree_hist_selector")
                      ),
                      mainPanel(
                        plotOutput("migration_history", width = "80%", height = "700px")
                      )
                    )
                      
           ),
           tabPanel("Red",
                    plotOutput("network")
           )
)
