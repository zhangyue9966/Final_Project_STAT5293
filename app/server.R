#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(gtools)
library(leaflet)

all_data = read.csv("all_data.csv")

server <- function(input,output, session){

  # 
  # data <- reactive({
  #   x <- all_data %>%
  #     filter(cuisine == input$cuisine & rating == as.numeric(input$rating))
  # })

  output$mymap <- renderLeaflet({

  # dataset <- data()
  m <- 
    all_data %>%
    filter(cuisine == input$cuisine & rating == as.numeric(input$rating)) %>%
    leaflet(data = .) %>%
    addTiles() %>%
    addCircleMarkers(lng = ~longitude,lat = ~latitude,radius = 1) %>%
    setView(lng=-73.971242, lat=40.730610 , zoom=11)
  m
  })
  
# price and borough
  output$plot1 <- renderPlot({
    all_data %>%
      drop_na() %>%
      filter(cuisine == input$cuisine & rating == as.numeric(input$rating)) %>%
      group_by(price,borough) %>%
      summarise(count = length(borough)) %>%
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
    all_data %>%
      drop_na() %>%
      filter(cuisine == input$cuisine & rating == as.numeric(input$rating)) %>%
      group_by(borough) %>%
      summarise(number_reviews = sum(review_count)) %>%
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
            axis.text.y=element_text(size = 10))
  })
}
