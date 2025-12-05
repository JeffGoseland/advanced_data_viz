
library(shiny)
library(sf)
library(tidyverse)
library(leaflet)

elections <- st_read("data/ElectionResultsByState.shp")
pal <- colorFactor(palette = c("blue", "red"),domain = c("D","R"), na.color = "green")


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Election Viewer"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "year", 
                        label = "Choose a year",
                        choices = names(elections[10:67] %>% st_set_geometry(NULL)),
                        selected = "X2012"
                          )
        ), #sidebarPanel End

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel(title = "Pie",
                     plotOutput("distPlot")
                     
              
            ),#end tabpanel pie
            tabPanel(title = "Map",
                     leafletOutput(outputId = "myMap"))
          )#end tabsetpanel
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    elec.subset <- reactive({
      elec.sub <- elections %>%
        st_set_geometry(NULL)
      return(elec.sub[, input$year])
    })  
  
    output$distPlot <- renderPlot({
     
        
      pie(table(elec.subset()))
      
    }) #end distplot
    output$myMap <- renderLeaflet({
      leaflet()%>%
        addTiles()%>%
        addPolygons(data = elections,color = ~pal(elec.subset()), popup = elec.subset() )
    })# end Mymap
}

# Run the application 
shinyApp(ui = ui, server = server)
