## FR DATA
library(shiny)
library(dygraphs)
library(xts)
library(shinydashboard)

source("CTT_FILES.R")  # constant variables

setwd(path_save_files)
load("./FR_data.Rdata")


# Use a fluid Bootstrap layout
ui <- fluidPage(    
  
  # Give the page a title
  titlePanel("FR Data"),
  
  # Generate a row with a sidebar
  sidebarLayout( 
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("data", "Data Type:", choices = c("Hour","Day"))
    ),
    
    # Create a spot for the plot
    fluidRow(
      tabBox(width = 250,
             tabPanel(title = "Sulphur dioxide (air)", dygraphOutput("dygraph1")),
             tabPanel(title = "Particulate matter < 10 µm (aerosol)", dygraphOutput("dygraph2")),
             tabPanel(title = "Nitrogen dioxide (air)", dygraphOutput("dygraph3")),
             tabPanel(title = "Benzene (air)", dygraphOutput("dygraph4")),
             tabPanel(title = "Carbon monoxide (air)", dygraphOutput("dygraph5")),
             tabPanel(title = "Ozone (air)", dygraphOutput("dygraph6"))
             ))

  )
)

# Define a server for the Shiny app
server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$dygraph1 <- renderDygraph({
    
    if (input$data == "Hour"){ts = FR_data_raw$ts_hour}
    if (input$data == "Day"){ts = FR_data_raw$ts_day}

    # Render a plot
    df = ts[[1]]
    df$na_count <- rowSums(is.na(df))
    df$row_count <- length(colnames(df))-2-df$na_count
    df_n = df[c("Date", "row_count")]
    
    ts1 = xts(df_n$row_count, order.by = df_n$Date)
    dygraph(ts1) %>% dyRangeSelector()

  })
  
  output$dygraph2 <- renderDygraph({
    
    if (input$data == "Hour"){ts = FR_data_raw$ts_hour}
    if (input$data == "Day"){ts = FR_data_raw$ts_day}
    
    df = ts[[2]]
    df$na_count <- rowSums(is.na(df))
    df$row_count <- length(colnames(df))-2-df$na_count
    df_n = df[c("Date", "row_count")]
    
    ts1 = xts(df_n$row_count, order.by = df_n$Date)
    dygraph(ts1) %>% dyRangeSelector()
    
  })
  
  output$dygraph3 <- renderDygraph({
    
    if (input$data == "Hour"){ts = FR_data_raw$ts_hour}
    if (input$data == "Day"){ts = FR_data_raw$ts_day}
    
    df = ts[[3]]
    df$na_count <- rowSums(is.na(df))
    df$row_count <- length(colnames(df))-2-df$na_count
    df_n = df[c("Date", "row_count")]
    
    ts1 = xts(df_n$row_count, order.by = df_n$Date)
    dygraph(ts1) %>% dyRangeSelector()
    
  })
  
  output$dygraph4 <- renderDygraph({
    
    if (input$data == "Hour"){ts = FR_data_raw$ts_hour}
    if (input$data == "Day"){ts = FR_data_raw$ts_day}
    
    df = ts[[4]]
    df$na_count <- rowSums(is.na(df))
    df$row_count <- length(colnames(df))-2-df$na_count
    df_n = df[c("Date", "row_count")]
    
    ts1 = xts(df_n$row_count, order.by = df_n$Date)
    dygraph(ts1) %>% dyRangeSelector()
    
  })
  
  output$dygraph5 <- renderDygraph({
    
    if (input$data == "Hour"){ts = FR_data_raw$ts_hour}
    if (input$data == "Day"){ts = FR_data_raw$ts_day}
    
    df = ts[[5]]
    df$na_count <- rowSums(is.na(df))
    df$row_count <- length(colnames(df))-2-df$na_count
    df_n = df[c("Date", "row_count")]
    
    ts1 = xts(df_n$row_count, order.by = df_n$Date)
    dygraph(ts1) %>% dyRangeSelector()
    
  })
  
  output$dygraph6 <- renderDygraph({
    
    if (input$data == "Hour"){ts = FR_data_raw$ts_hour}
    if (input$data == "Day"){ts = FR_data_raw$ts_day}
    
    df = ts[[6]]
    df$na_count <- rowSums(is.na(df))
    df$row_count <- length(colnames(df))-2-df$na_count
    df_n = df[c("Date", "row_count")]
    
    ts1 = xts(df_n$row_count, order.by = df_n$Date)
    dygraph(ts1) %>% dyRangeSelector()
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)