# R shiny app for final project in STAT 5293
#
# Our R shiny app works fine locally, but somehow when we tried to publish it caused 
# problems. We just can't figure out how to solve it. We talked to the professor 
# about this problem and she said it's fine as long as our app can work. 
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

library(shiny)
library(leaflet)
library(dplyr)

all_data = read.csv("all_data.csv")

ui <- fluidPage(titlePanel("Food in New York"),
                sidebarLayout(
                  sidebarPanel(    
                    selectInput("cuisine", label = h5("Choose a cuisine"),
                                choices = unique(df$cuisine),
                                selected = 0),
                    br(),
                    sliderInput("rating",
                                "Range of rating:",
                                min = 1.0,
                                max = 5.0,
                                value = 3,
                                step = 0.5)
                  ),
                  mainPanel(
                    tabsetPanel(type = "tabs",
                                tabPanel("Map", leafletOutput("mymap",height = 300,width = 500)),
                                tabPanel("Price vs Borough", plotOutput("plot1")),
                                tabPanel("Distribution of review", plotOutput("plot2"))
                                ))
                  
                ))


# Define server logic required to draw a histogram

server <- function(input,output, session){
  output$mymap <- renderLeaflet({
    data = all_data %>%
      dplyr::filter(cuisine == input$cuisine & rating == as.numeric(input$rating))
    
    leaflet(data = data) %>%
      addTiles() %>%
      addCircleMarkers(lng = ~longitude,lat = ~latitude,radius = 1) %>%
      setView(lng=-73.971242, lat=40.730610 , zoom=11)
  })
  
  # price and borough
  output$plot1 <- renderPlot({
    df = all_data
    
    df %>%
      drop_na() %>%
      dplyr::filter(cuisine == input$cuisine & rating == as.numeric(input$rating)) %>%
      group_by(price,borough) %>%
      dplyr::summarise(count = length(borough)) %>%
      ggplot(.) +
      geom_mosaic(aes(x=product(borough), fill=price)) +
      labs(x="", y="Price")+
      ggtitle("Borough vs Price")+
      theme(plot.title = element_text(face = "bold", hjust = 0.5),
            axis.text.x =
              element_text(size  = 8,
                           angle = 45,
                           hjust = 1,
                           vjust = 1),
            axis.text.y=element_text(size = 10)) +
      scale_fill_brewer(palette = "Reds")
  })

  # distribution of rating
  output$plot2 <- renderPlot({
    df = all_data
    
    df %>%
      drop_na() %>%
      dplyr::filter(cuisine == input$cuisine & rating == as.numeric(input$rating)) %>%
      group_by(borough) %>%
      dplyr::summarise(number_reviews = sum(review_count)) %>%
      ggplot(.,aes(x = borough, y = number_reviews)) +
      geom_bar(stat = "identity",fill = "steelblue") +
      labs(x="", y="number of reviews")+
      ggtitle("Number of Reviews Distribution")+
      theme(plot.title = element_text(face = "bold", hjust = 0.5),
            axis.text.x =
              element_text(size  = 8,
                           angle = 45,
                           hjust = 1,
                           vjust = 1),
            axis.text.y=element_text(size = 10)) +
      coord_flip()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

