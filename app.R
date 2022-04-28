library(shiny)
library(tidyverse)
library(maps)
library(ggmap) 
library(ggthemes)
library(lubridate)
library(sf)  
library(RColorBrewer)
library(bslib)
library(readr)

states_map <- map_data("state")%>% 
  mutate(region = str_to_title(region))

airquality_f <- read_csv("airquality_f.csv")

weathertype <- read_csv("weathertype.csv")

states_map <- map_data("state")%>% 
  mutate(region = str_to_title(region))

st_crosswalk <- tibble(state = state.name) %>%
  bind_cols(tibble(abb = state.abb)) %>% 
  bind_rows(tibble(state = "District of Columbia", abb = "DC")) 

weathertype2 <- weathertype %>% 
  left_join(st_crosswalk, by = c("state")) 

weatherarea <- read_csv("weatherarea.csv")

weathertemp <- read_csv("weathertemp.csv") %>% 
  mutate(date = ymd(Date.Full))

sev_weatherarea <- read_csv("sev_weatherarea.csv")

ui <- fluidPage(theme = bs_theme(bootswatch = "minty"), 
                titlePanel("Where do I want to live in the United States?"),
                h5("The United States is a large country with many states to live in. When choosing somewhere to move, weather can be an important factor in the decision. This app will allow users to learn about the weather in different US states and allow them to make an educated decision on where they would like to live."),
                h6("Data collected from US Weather Events on Kaggle, the CORGIS Weather Data, and Air Quality Data on Kaggle."),
                h3("What is the temperature like in different US states?"),
                h6("Data from 2016"),
                selectInput(inputId = "Station.State", 
                            label = "State(s):", 
                            choices = unique(weathertemp$Station.State), 
                            multiple = TRUE), 
                submitButton("Submit"),
                plotOutput(outputId = "avgtempplot"),
                h3("How much precipitation do different states get?"),
                selectInput(inputId = "yearprecip", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                submitButton("Submit"),
                plotOutput(outputId = "precipplot"),
                h3("What types of weather do different states have?"),
                selectInput(inputId = "state", 
                            label = "State(s):", 
                            choices = unique(weathertype2$state), 
                            multiple = TRUE), 
                submitButton("Submit"),
                plotOutput(outputId = "typeplot"),
                h3("Which states have the most severe weather?"),
                selectInput(inputId = "yearsev", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                submitButton("Submit"),
                plotOutput(outputId = "severeplot"),
                h3("What is the air quality like in different states?"),
                h6("Data from 2016"),
                selectInput(inputId = "yearair",
                            label = "Year:",
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")),
                submitButton("Submit"),
                plotOutput(outputId = "airplot")
                )#widgets
                
server <- function(input, output) {
  output$precipplot <- renderPlot(
    weatherarea %>%
      filter(year == input$yearprecip) %>%
      ggplot() +
      geom_map(map = states_map,
               aes(map_id = state, fill = preciparea)) +
      expand_limits(x = states_map$long, y = states_map$lat) +
      labs(fill = "Total Precipitation Per Square Mile (inches/miles^2)") +
      theme_map() +
      theme(legend.background = element_blank()) +
      scale_fill_distiller(palette = "Blues", direction = 1)
    )
  output$typeplot <- renderPlot(
    weathertype2 %>%
      filter(state %in% input$state) %>%
      ggplot() +
      geom_col(aes(x = Type,
                   y = `n()`,
                   fill = state),
               position = position_dodge())+
      labs(y = "", 
           fill = "State(s)")
    )
  output$severeplot <- renderPlot(
    sev_weatherarea %>%
      filter(year == input$yearsev) %>%
      ggplot() +
      geom_map(map = states_map,
               aes(map_id = state, fill = sev_area)) +
      expand_limits(x = states_map$long, y = states_map$lat) +
      scale_fill_viridis_c(option = "B",
                           direction = -1)+
      labs(fill = "Total Severe Weather per Square Mile (days/miles^2)") +
      theme_map() +
      theme(legend.background = element_blank())
    )
    output$avgtempplot <- renderPlot(
      weathertemp %>% 
        group_by(Station.State,Date.Full) %>% 
        filter(Station.State %in% input$Station.State) %>% 
        summarise(avg_temp=sum(`Data.Temperature.Avg Temp`)/n()) %>% 
        ggplot(aes(x=Date.Full, 
                   y=avg_temp,
                   color = Station.State))+
        geom_line()+ 
        labs(x = "Date",
             y = "Temperature (F)",
             color = "State(s)")+
        theme_bw()+
        theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
    )
    output$airplot <- renderPlot( 
      airquality_f %>% 
        filter(Year == input$yearair) %>% 
        group_by(region, mean_AQI) %>% 
        ggplot() +
        geom_map(map = states_map,
                 aes(map_id = region, fill = mean_AQI)) +
        expand_limits(x = states_map$long, y = states_map$lat) +
        scale_fill_viridis_c(
                             direction = -1) +
        labs(fill = "Air Quality") +
        theme_map() +
        theme(legend.background = element_blank()))
    
} #r code, generate graph, translate input into an output (graph)
shinyApp(ui = ui, server = server) 

