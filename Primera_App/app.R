
# pkgs --------------------------------------------------------------------
# ctrl + shift + r

library(shiny)
library(tidyverse)
library(tidyquant)

# UI ----------------------------------------------------------------------

ui <- fluidPage(
    titlePanel("Descarga de datos desde Yahoo Finance"),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = 'ticker',
                label = 'Escoge la acción',
                choices = c(Apple = 'AAPL',
                            Amazon = 'AMZN',
                            Microsoft = 'MSFT'),
                selected = 'AAPL'
            ),
            dateInput(
                inputId = 'fecha',
                label = 'selecciona fecha de inicio:',
                value = today() - 365,
                max = today() - 1,
                format = "dd-mm-yyyy",
                startview = "year",
                language = "es"
            )
        ),
        mainPanel(
            plotOutput(outputId = "grafica")
        )
    )
    
)

# Server ------------------------------------------------------------------


server <- function(input, output, session) {
  output$grafica <- renderPlot({
      tq_get(
          x = input$ticker,
          get = "stock.prices",
          from = input$fecha,
          to = today() - 1
      ) |> 
          ggplot(aes(x = date)) + 
          geom_candlestick(aes(open = open,
                               high = high,
                               low = low,
                               close = close),
                           colour_up = "darkgreen",
                           colour_down = "firebrick",
                           fill_up = "darkgreen",
                           fill_down = "firebrick") + 
          theme_tq_dark()
  })
}

shinyApp(ui, server)