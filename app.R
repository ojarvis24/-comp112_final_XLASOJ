library(shiny)
library(tidyverse)
library(maps)
library(ggmap) 
library(ggthemes)
library(lubridate)
library(sf)  
library(RColorBrewer)

weather <- read_csv("WeatherEvents_Jan2016-Dec2021.csv", 
                    col_types = cols(ZipCode = col_character()))

states_map <- map_data("state")%>% 
  mutate(region = str_to_title(region))

st_crosswalk <- tibble(state = state.name) %>%
  bind_cols(tibble(abb = state.abb)) %>% 
  bind_rows(tibble(state = "District of Columbia", abb = "DC")) 

weather2 <- weather %>% 
  left_join(st_crosswalk, by = c("State" = "abb")) %>% 
  mutate(abb = State) %>% 
  mutate(lower = tolower(state)) %>% 
  rename(start = `StartTime(UTC)`) %>% 
  rename(end = `EndTime(UTC)`) %>% 
  rename(precip = `Precipitation(in)`) %>% 
  mutate(year = year(start)) 


ui <- fluidPage(h2("Precipitation in the United States"),
                selectInput(inputId = "year", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                plotOutput(outputId = "precipplot"), 
                h2("What Types of Weather Do Different States Have?"),
                selectInput(inputId = "state", 
                            label = "State(s):", 
                            choices = unique(weather2$state), 
                            multiple = TRUE), 
                selectInput(inputId = "year", 
                            label = "Year:", 
                            choices = c("2016", "2017", "2018", "2019", "2020", "2021")), 
                plotOutput(outputId = "typeplot"))#widgets

server <- function(input, output) {
  output$precipplot <- renderPlot(
    weather2 %>% 
      filter(year == input$year) %>% 
      group_by(state) %>% 
      summarise(totalprecip = sum(precip)) %>%
      ggplot() +
      geom_map(map = states_map,
               aes(map_id = state, fill = totalprecip)) +
      expand_limits(x = states_map$long, y = states_map$lat) +
      labs(fill = "Total Precipitation (inches)") +
      theme_map() +
      theme(legend.background = element_blank()) +
      scale_fill_distiller(palette = "Blues", direction = 1))
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
      labs(fill = "State(s)"))
    
} #r code, generate graph, translate input into an output (graph)
shinyApp(ui = ui, server = server) 

