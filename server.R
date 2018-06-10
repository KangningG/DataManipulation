library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  dataset <- result4_2
  output$plot <- reactivePlot(function() {
    
    # p <- ggplot(dataset, aes(x=Observation, cond=Indicator,fill=Indicator)) +
    #   geom_histogram(binwidth=.75, alpha=.25, position="identity")
    
    # p <- qplot(input$x, input$y, data = dataset) + labs(x = "x", y = "y")
    p <- ggplot(dataset, aes(x = input$x, y = input$y)) + geom_point()
    if (input$color != 'None')
      p <- p + 
        aes_string(color=input$color) + 
        theme(legend.position="right")
    
    if (input$smooth)
      p <- p + 
        geom_smooth() + 
        theme(legend.position="right")
    
    print(p)
    
  },
  )
  
})

