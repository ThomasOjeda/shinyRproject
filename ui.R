
library(shinyjs)

jsCode <- 'shinyjs.winprint = function(){
window.print();
}'


ui = navbarPage("Movimientos entre ofertas academicas",

          tabPanel("Estadisticas de movimientos generales",
                   sidebarLayout(
                     sidebarPanel(
                       uiOutput("year_mov_selector"),
                  
                       radioButtons("general_mov_stats_delta", 
                                   label = "Despues de",
                                   choices = list("1 año" = 1, "2 años" = 2,"3 años" = 3),
                                   selected = 1
                                   ),
                       selectInput("genre_mov_selector", label="Genero", choices = c("Todos","Masculino","Femenino")),
                       uiOutput("origin_unit_mov_selector"),
                       uiOutput("destination_unit_mov_selector"),
                       actionButton("mov_stats_update_button", "Calcular"),
                       useShinyjs(),
                       extendShinyjs(text = jsCode, functions = c("winprint")),
                       actionButton("print", "Imprimir")
                       
                     ),
                     mainPanel(

                       plotOutput("general_student_movement_ratios_simple"),
                       #,plotOutput("general_student_movement_ratios_simple_M")
                       #,plotOutput("general_student_movement_ratios_simple_F")

                     )
                   )
                   
          )
          
          # 
          # ,
          # tabPanel("Migraciones",
          #          sidebarLayout(
          #            sidebarPanel(
          #              uiOutput("migrations_unit_selector"),
          #              helpText("Seleccione un rango de años"),
          #              uiOutput("migration_range_selectors") ,
          #              sliderInput("delta", 
          #                          label = "Delta",
          #                          min = 0, max = 10, value = 0)
          #            ),
          #            
          #            mainPanel( fluidPage(
          #              h3("Informacion de migraciones"),
          #              tableOutput("migration_data"),
          #              h3("De las migraciones, porcentaje perteneciente a cada carrera"),
          #              plotOutput("migration_pie_chart")                   
          #                                 
          #                                 ))
          #            
          #          )
          #  ),
          #  tabPanel("Historico de migraciones por carrera",
          #           sidebarLayout(
          #             sidebarPanel(
          #               uiOutput("unit_hist_selector"),
          #               uiOutput("degree_hist_selector")
          #             ),
          #             mainPanel(
          #               plotOutput("migration_history", width = "80%", height = "700px")
          #             )
          #           )
          #             
          #  ),
          #  tabPanel("Red",
          #           plotOutput("network")
          #  )
          
          
          
)
