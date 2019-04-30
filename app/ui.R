#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

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
                                  tabPanel("Distribution of review", plotOutput("plot2"))))
                           
                ))

