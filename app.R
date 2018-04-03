#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(tibble)
library(dplyr)
library(DT)

gb <- read_csv("data/guestbook.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Guestbook"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        textInput("name", "Name", "Data Summary"),
        textInput("date", "Date", "Data Summary"),
        textInput("msg",  "Message", "Data Summary"),
        
        # http://shiny.rstudio.com/articles/action-buttons.html
        actionButton("do", "Sign the book")
      ),
      
      # https://shiny.rstudio.com/reference/shiny/1.0.5/renderDataTable.html
      mainPanel(
         DTOutput('table')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$table <- renderDT(gb)
   
   observeEvent(input$do, {
     newsign <- tibble(
       name     = input$name,
       date     = input$date,
       message  = input$msg
     )
     
     gb <- bind_rows(gb, newsign)
     write_csv(gb, "data/guestbook.csv")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

