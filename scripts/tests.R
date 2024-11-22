library(DBI)
library(RSQLite)
library(tidyverse)
library(lubridate)

connection <- dbConnect(RSQLite::SQLite(), "./data/data.sqlite")
script <- readLines("egg_data.sql")
script <- paste(script, collapse = "\n")
data <- dbGetQuery(connection, script)
data$nowtime <- ymd_hms(data$nowtime)
data$current_price <- as.numeric(data$current_price)

# check if year is 2024
data$year <- lubridate::year(data$nowtime)
test1 <- all(data$year == 2024)

# check if avg_price is numeric
test2 <- is.numeric(data$current_price) | is.na(data$current_price)


# check if price is greater than 0 or NA
test3 <- all(is.na(data$current_price) | data$current_price > 0)

# all tests must return true
test1
test2
test3

