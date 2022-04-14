library(shiny)
library(tidyverse)

WeatherEvents_Jan2016_Dec2021 <- read_csv("WeatherEvents_Jan2016-Dec2021.csv", 
                                          col_types = cols(ZipCode = col_character()))

