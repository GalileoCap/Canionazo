#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Disparo de canion"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("v0",
                  "Velocidad de disparo (m/s):",
                  min = 1,
                  max = 200,
                  value = 100),
      sliderInput("ang_en_grados",
                  "Angulacion del canion (grados):",
                  min = 1,
                  max = 90,
                  value = 45),
      selectInput("color",
                  "Color",
                  colors()
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("tiro_ang")
    )
  )
)

#Mi funcion
g <- 9.80665 #Aceleracion de la gravedad
tiro_ang_params <- function(v0, ang_en_grados){ #U: Los params para un tiro
  r <- list()
  r$ang <- ang_en_grados*pi/180 #Pasa a radianes
  r$d <- (v0^2)/g*cos(r$ang)*sin(r$ang)
  r$h <- ((r$d/2)^2)-((r$d/2)/cos(r$ang))^2
  r$a <- -(r$h^1/2)/(r$d/2)^2 
  r$b <- 4*(r$h^1/2)/r$d
  r$c <- (r$h^1/2)+r$a*(r$d/2)^2
  r
}

tiro_ang_y <- function(v0, ang_en_grados, x){ #U: La altura para cada punto del tiro
  p <- tiro_ang_params(v0, ang_en_grados)
  y <- -(p$a*x^2+p$b*x+p$c) #Calcula el y
  ifelse(y<0, NA, y) #Si y es menor qe 0 (choco contra el piso), devuelve nada, si es mayor me da el valor.
}

tiro_ang <- function(v0, ang_en_grados, col){
  
  curve(tiro_ang_y(v0, ang_en_grados, x),
        xlab = "Distancia",
        ylab = "Altura",
        xlim = c(0,1000), #Fija al grafico, pero no a la funcion
        ylim = c(0,500), #Idem
        col = col)
}

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$tiro_ang <- renderPlot({
    tiro_ang(input$v0,input$ang, input$color)
  })
}


# Run the application 
shinyApp(ui = ui, server = server)