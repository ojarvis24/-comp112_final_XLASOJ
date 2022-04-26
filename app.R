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
airquality <- read_csv("aqi_daily_1980_to_2021.csv")

states_map <- map_data("state")%>% 
  mutate(region = str_to_title(region))

airquality2 <- airquality %>% 
  mutate(Year = year(Date)) %>% 
  mutate("region" = `State Name`)

weather <- read_csv("weathersm.csv")

states_map <- map_data("state")%>% 
  mutate(region = str_to_title(region))

st_crosswalk <- tibble(state = state.name) %>%
  bind_cols(tibble(abb = state.abb)) %>% 
  bind_rows(tibble(state = "District of Columbia", abb = "DC")) 

weather2 <- weather %>% 
  left_join(st_crosswalk, by = c("state")) 

weatherarea <- read_csv("weatherarea.csv")

weathertemp <- read_csv("weathertemp.csv") %>% 
  mutate(date = ymd(Date.Full))

sev_weatherarea <- read_csv("sev_weatherarea.csv")

ui <- fluidPage(theme = bs_theme(bootswatch = "minty"), 
                titlePanel("Where do I want to live in the United States?"),
                h5("The United States is a large country with many states to live in. When choosing somewhere to move, weather can be an important factor in the decision. This app will allow users to learn about the weather in different US states and allow them to make an educated decision on where they would like to live."),
                h3("What is the temperature like in different US states?"),
                h6("Data from 2016"),
                selectInput(inputId = "Station.State", 
                            label = "State(s):", 
                            choices = unique(weathertemp$Station.State), 
                            multiple = TRUE), 
                plotOutput(outputId = "avgtempplot"),
                h3("How much precipitation do different states get?"),
                selectInput(inputId = "year", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                plotOutput(outputId = "precipplot"),
                h3("What types of weather do different states have?"),
                selectInput(inputId = "state", 
                            label = "State(s):", 
                            choices = unique(weather2$state), 
                            multiple = TRUE), 
                selectInput(inputId = "year", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                plotOutput(outputId = "typeplot"),
                h3("Which states have the most severe weather?"),
                selectInput(inputId = "year", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                plotOutput(outputId = "severeplot"),
                h3("What is the air quality like in different states?"),
                selectInput(inputId = "Year",
                            label = "Year:",
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")),
                submitButton("Submit"),
                plotOutput(outputId = "airplot")
                )#widgets
                
server <- function(input, output) {
  output$precipplot <- renderPlot(
    weatherarea %>%
      filter(year == input$year) %>%
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
    weather2 %>%
      filter(year == input$year) %>%
      filter(state %in% input$state) %>%
      group_by(state) %>%
      group_by(year) %>%
      ggplot() +
      geom_bar(aes(x = Type,
                   fill = state),
               position = position_dodge())+
      labs(fill = "State(s)")
    )
  output$severeplot <- renderPlot(
    sev_weatherarea %>%
      filter(year == input$year) %>%
      filter(Severity == "Severe") %>%
      ggplot() +
      geom_map(map = states_map,
               aes(map_id = state, fill = sev_area)) +
      expand_limits(x = states_map$long, y = states_map$lat) +
      scale_fill_viridis_c(option = "B",
                           direction = -1)+
      labs(fill = "Total Severe Weather (Days)") +
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
      airquality2 %>% 
        filter(Year == input$Year) %>% 
        filter(Year > 2015) %>% 
        group_by(region, Category) %>% 
        ggplot() +
        geom_map(map = states_map,
                 aes(map_id = region, fill = Category)) +
        expand_limits(x = states_map$long, y = states_map$lat) +
        scale_fill_brewer(palette = "OrRd", direction = -1) +
        labs(fill = "Air Quality") +
        theme_map() +
        theme(legend.background = element_blank()))
    
} #r code, generate graph, translate input into an output (graph)
shinyApp(ui = ui, server = server) 

