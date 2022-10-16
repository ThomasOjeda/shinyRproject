
ui = navbarPage("Estadisticas de Migraciones",

                
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
