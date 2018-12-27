
# Example: Shiny app that search Wikipedia web pages
# File: server.R 
library(shiny)
library(tm)
library(stringi)
library(proxy)
library(SnowballC)
library(RColorBrewer)
source("WikiSearch.R")

shinyServer(function(input, output) {
  output$wordCloudPlot <- renderPlot({
    output <- SearchWiki(input$select)
    term<-order(output,decreasing = TRUE)
      wordcloud(names(output[head(term,n=50)]), output[head(term,n=50)],
               scale=c(4,0.9), colors=brewer.pal(6, "Dark2"))
  
  })
})
