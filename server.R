library(shiny)

# Section 1

function(input, output) {
  
# Section 2
  
  output$testText <- renderText({
    
    # Section 3
    
    paste0('Hello there! I see youa re borde tberwewn ', 
           input$testRange[1],
           ' and ',
           input$testRange[2])
  })
}