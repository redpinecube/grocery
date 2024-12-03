
library(tidyverse)
product <- read_csv("./data/raw/hammer-4-product.csv")

product <- product |>
  filter(vendor %in% c("Loblaws", "Metro", "Voila")) |>
  filter(grepl("Eggs ", product_name)) |>
  filter(grepl("White ", product_name) | grepl("Brown ", product_name)) |> 
  mutate(color = case_when(
    grepl("White ", product_name) ~ "White",
    grepl("Brown ", product_name) ~ "Brown"
  )) |>
  mutate(size = case_when(
    grepl("Extra Large ", product_name) ~ "Extra Large",
    grepl("Jumbo ", product_name) ~ "Extra Large",
    grepl("Large ", product_name) ~ "Large",
    TRUE ~ "Medium"
  )) |>
  rename(product_id = id)

price <- read_csv("./data/raw/hammer-4-raw.csv")


data <- merge(price, product, by = "product_id", all.y = TRUE)

data <- data |>
  select(price_per_unit, vendor, nowtime, color, size, product_name, brand, other) |>
  mutate(type = case_when(
    grepl("Organic", product_name) ~ "organic",
    grepl("Free Run", product_name) ~ "free run",
    grepl("Free Range", product_name) ~ "free range", 
    TRUE ~ "none"
  )) |>
  filter(!(grepl("Oatmeal", product_name))) |>
  mutate(brand = case_when(
    grepl("Gold Egg", product_name) ~ "Gold Egg",
    grepl("Compliments", product_name) ~ "Compliments",
    grepl("Gray Ridge", product_name) ~ "Gray Ridge",
    grepl("Conestoga", product_name) ~ "Conestoga Eggs", 
    grepl("Longo's", product_name) ~ "Longo's",
    grepl("Blue Menu", product_name) ~ "Blue Menu",
    TRUE ~ brand
  )) |>
  filter(!(grepl("100g", product_name))) |>
  mutate(price_per_unit = case_when(
    grepl("/un.", price_per_unit) ~ as.numeric(gsub("\\$|/un.|\\s", "", price_per_unit)),
    grepl("/1ea", price_per_unit) ~ as.numeric(gsub("\\$|/1ea|\\s", "", price_per_unit)),    
    grepl("/item", price_per_unit) ~ as.numeric(gsub("\\$|/item|\\s", "", price_per_unit)),
    grepl("fop.price.per.each", price_per_unit) ~ as.numeric(str_extract(price_per_unit, "\\d+\\.\\d+"))
  )) |>
  mutate(sale = case_when(
    other == "SALE" ~ "Sale",
    other == "sale\n$6.49" ~ "Sale",
    TRUE ~ "No Sale"
  )) |>
  select(!other) |>
  rename(time = nowtime) |>
  filter(!(brand == "Life Smart")) |>
  mutate(brand = case_when(
    brand == "GoldEgg" ~ "Gold Egg",
    TRUE ~ brand
  )) |>
  select(!product_name)

write_csv(data, "./data/clean/clean_data.csv")

