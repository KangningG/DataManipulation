library(shiny)
library(ggplot2)

# dataset <-get_data360(indicator_id = c(204, 205), output_type = 'long') %>% 
#   merge(select(get_metadata360(),iso3,region), by.x="Country ISO3", by.y="iso3") %>% 
#   filter(!(region == "NAC"))

dataset <- result4_2

shinyUI(pageWithSidebar(

  headerPanel("WB"),
  sidebarPanel(
    
    # selectInput('x', 'X', names(dataset)[6]),
    # selectInput('y', 'Y', dataset[1:2,3]),
    # selectInput('color', 'Color', c('None', names(dataset)[6])),
    
    selectInput('y', 'Y', names(dataset)),
    selectInput('x', 'X', names(dataset)),
    selectInput('color', 'Color', c('None', names(dataset))),
     checkboxInput('smooth', 'Smooth')
  ),

  mainPanel(
    plotOutput('plot')
  )
))
