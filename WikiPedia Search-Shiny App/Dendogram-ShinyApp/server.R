# Example: Shiny app that search Wikipedia web pages
# File: server.R 
library(shiny)
library(tm)
library(stringi)
library(proxy)
source("WikiSearch.R")

shinyServer(function(input, output) {
  output$distPlot <- renderPlot({ 
    result <- SearchWiki(input$select)
    plot(result, labels = input$select, sub = "",main="Wikipedia Search")
  })
})
