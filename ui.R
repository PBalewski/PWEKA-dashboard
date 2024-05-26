library(shiny)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(sliderInput("testRange", 
                             label = "Boredom [%]:",
                             min = 0, max = 100,
                             value = c(0, 100))),
    mainPanel(textOutput("testText"))
  )
))