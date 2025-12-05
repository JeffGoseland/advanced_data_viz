#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
    theme = bs_theme(bootswatch = 'superhero'),
    
    # Application title
    titlePanel("Old Geyser takes how long to blow?"),
  
    hr(),
    
    # Copy the line below to make a text input box
    textInput("text", label = h3("Fav Color"), value = "blue"),
    
    hr(), 
    
    # Copy the line below to make a select box 
    selectInput("select", label = h3("Favorite Blue Color"), 
                choices = list("steelblue" = 1, "blue" = 2, "lightblue" = 3, 'darkblue' = 4, 'turquoise' = 5, 'purple' = 6), 
                selected = 1),
    
    hr(),
    
    fluidRow(column(3, verbatimTextOutput("value"))),
    
    hr(), 
    
    column(4,
           
           # Copy the line below to make a slider bar 
           sliderInput("slider1", label = h3("width of lines"), min = 0, 
                       max = 40, value = 6)
    ),
    hr(), 

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 75,
                        value = 10)
        ),


        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # bslib::bs_themer()

  output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)

      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, 
           col = input$text, 
           border = input$select,
           linewidth = input$slider1,
           xlab = 'Waiting time to next eruption (in mins)',
           main = 'Histogram of waiting times')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
