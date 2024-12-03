library(tidyverse)
library(lubridate)
data <- read_csv("./data/clean/clean_data.csv")

data <- data |>
  mutate(
    price_per_unit = if_else(price_per_unit > 3, price_per_unit / 12, price_per_unit)
  )

data <- data |>
  mutate(
    voila = case_when(vendor == "Voila" ~ 1, TRUE ~ 0),
    loblaws = case_when(vendor == "Loblaws" ~ 1, TRUE ~ 0),
    metro = case_when(vendor == "Metro" ~ 1, TRUE ~ 0)
  )

data <- data |>
  mutate(
    brown = case_when(color == "Brown" ~ 1, TRUE ~ 0),
    white = case_when(color == "White" ~ 1, TRUE ~ 0)
  )

data <- data |>
  mutate(
    goldegg = case_when(brand == "Gold Egg" ~ 1, TRUE ~ 0),
    bluemenu = case_when(brand == "Blue Menu" ~ 1, TRUE ~ 0),
    compliments = case_when(brand == "Compliments" ~ 1, TRUE ~ 0),
    conestoga = case_when(brand == "Conestoga Eggs" ~ 1, TRUE ~ 0),
    grayridge = case_when(brand == "Gray Ridge" ~ 1, TRUE ~ 0),
    longos = case_when(brand == "Longo's" ~ 1, TRUE ~ 0),
    presidents = case_when(brand == "President's Choice" ~ 1, TRUE ~ 0)
  )

data <- data |>
  mutate(
    large = case_when(size == "Large" ~ 1, TRUE ~ 0),
    medium = case_when(size == "Medium" ~ 1, TRUE ~ 0),
    extra = case_when(size == "Extra Large" ~ 1, TRUE ~ 0)
  )

data <- data |>
  mutate(
    none = case_when(type == "none" ~ 1, TRUE ~ 0),
    organic = case_when(type == "organic" ~ 1, TRUE ~ 0),
    freerange = case_when(type == "free range" ~ 1, TRUE ~ 0),
    freerun = case_when(type == "free range" ~ 1, TRUE ~ 0)
  )

data <- data |>
  mutate(
    sale = case_when(sale == "Sale" ~ 1, TRUE ~ 0),
    nosale = case_when(sale == "No Sale" ~ 1, TRUE ~ 0)
  )

data <- data |>
  mutate(month = month(time))

data <- data |>
  select(price_per_unit, sale, voila, loblaws, metro, brown, white,
         goldegg, bluemenu, compliments, conestoga, longos, grayridge,
         presidents, large, medium, extra, none, organic, freerange,
         freerun, nosale, month)

write_csv(data, "./data/clean/preprocess.csv")