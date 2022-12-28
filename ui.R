
library(shinyjs)

jsCode <- 'shinyjs.printWindow = function(){
window.print();
}'


ui = navbarPage("Movimientos entre ofertas academicas",

          tabPanel("Estadisticas de movimientos",
                   sidebarLayout(
                     sidebarPanel(#style = paste0("width: 30%"),
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
                       extendShinyjs(text = jsCode, functions = c("printWindow")),
                       actionButton("printPage", "Imprimir")
                       
                     ),
                     mainPanel(
                       plotOutput("general_student_movement_ratios_pie"),
                       tableOutput("general_student_movement_ratios_info"),

                     )
                   )
          )
)
