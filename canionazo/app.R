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
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("d",
                     "Distancia:",
                     min = 0,
                     max = 1000,
                     value = 113),
         sliderInput("h",
                     "Altura:",
                     min = 1,
                     max = 50,
                     value = 10),
         selectInput("color",
                     "Color",
                     colors()
         )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("tiro_bas")
      )
   )
)

#Mi funcion
tiro_bas <- function(d,h, col){
  a <- -h/(d/2)^2 
  b <- 4*h/d
  c <- h+a*(d/2)^2
  
  curve(a*x^2+b*x+c, 
        xlab = "Distancia", #Nombra al eje x
        ylab = "Altura", #Nombra al eje x
        xlim = c(0,1000), #Fija al grafico, pero no a la funcion
        ylim = c(0,50), #Idem
        col = col #Define el color del grafico
        )
}

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$tiro_bas <- renderPlot({
     tiro_bas(input$d,input$h, input$color)
   })
}


# Run the application 
shinyApp(ui = ui, server = server)

