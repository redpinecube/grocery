library(tidyverse)
product <- read_csv("./data/raw/hammer-4-product.csv")
price <- read_csv("./data/raw/hammer-4-raw.csv")

product <- product |>
  select(id, vendor, product_name, units, brand)

price <- price |>
  select(nowtime, current_price, price_per_unit, other, product_id) |>
  rename(time = nowtime, price = current_price, id = product_id)

data <- merge(price, product, by = "id", all.x = TRUE)

voila_data <- data |>
  filter(vendor == "Voila") |>
  mutate(product_name = str_to_lower(product_name)) |>
  filter(grepl("egg ", product_name)) |>
  filter(grepl("white ", product_name) | grepl("brown ", product_name)) |>
  filter(grepl("large ", product_name) | grepl("medium", product_name)) |>
  mutate(price_per_unit = as.numeric(str_extract(price_per_unit, "\\d+\\.\\d+"))) |>
  mutate(color = case_when(
    grepl("white ", product_name) ~ "white",
    grepl("brown ", product_name) ~ "brown"
  )) |>
  mutate(size = case_when(
    grepl("extra large", product_name) ~ "extra large",
    grepl("large", product_name) ~ "large",
    grepl("medium", product_name) ~ "medium"
  )) |>
  mutate(type = case_when(
    grepl("organic ", product_name) ~ "organic",
    TRUE ~ "none"
  )) |>
  mutate(brand = case_when(
    grepl("gold", product_name) ~ "Gold Egg",
    grepl("gray", product_name) ~ "Gray Ridge"
  )) |>
  mutate(vendor = str_to_lower(vendor)) |>
  select(color, brand, size, type, price_per_unit, time, vendor, other)


problem_words <- c("Chocolate", "Eggo", "Frozen", "Egg White", "Egg-Shaped",
                   "Pasta", "Noodles", "Eggplant", "Cookies", "Duck", "Brownies",
                   "Cheese", "Egg Nog", "Liquid", "Bowl", "Candy", "Bagels",
                   "Pickled", "Easter", "Onion", "Loaf", "Scrambled", "Replacer",
                   "Eggnog", "Plant", "Almond", "Bento", "Quail", "Hard", "Noodle",
                   "Pizza", "Cake", "Breakfast", "Oatmeal", "Pain")

loblaws_data <- data |>
  filter(vendor == "Loblaws") |>
  filter(grepl("Eggs", product_name)) |>
  filter(!apply(sapply(problem_words, function(word) grepl(word, product_name)), 1, any)) |>
  filter(!(grepl("Egg Creations!", product_name) | grepl("Mini", product_name))) |>
  mutate(price_per_unit = as.numeric(gsub("\\$|/1ea|/un.|/100un.", "", price_per_unit))) |>
  mutate(size = case_when(
    grepl("Extra", product_name) ~ "extra large",
    grepl("Jumbo", product_name) ~ "extra large",
    grepl("Large", product_name) ~ "large",
    TRUE ~ "medium"
  )) |>
  mutate(type = case_when(
    grepl("Organic", product_name) ~ "organic",
    grepl("Free Run", product_name) ~ "free run",
    grepl("Free Range", product_name) ~ "free range", 
    TRUE ~ "none"
  )) |>
  mutate(color = case_when(
    grepl("White", product_name) ~ "white",
    grepl("Brown", product_name) ~ "brown"
  )) |>
  mutate(vendor = str_to_lower(vendor)) |>
  select(color, brand, size, type, price_per_unit, time, vendor, other)


metro_data <- data |>
  filter(vendor == "Metro") |>
  filter(grepl("Egg", product_name)) |>
  filter(!apply(sapply(problem_words, function(word) grepl(word, product_name)), 1, any)) |>
  mutate(size = case_when(
    grepl("Extra", product_name) ~ "extra large",
    grepl("Jumbo", product_name) ~ "extra large",
    grepl("Large", product_name) ~ "large",
    TRUE ~ "medium"
  )) |>
  mutate(type = case_when(
    grepl("Organic", product_name) ~ "organic",
    grepl("Free Run", product_name) ~ "free run",
    grepl("Free Range", product_name) ~ "free range", 
    TRUE ~ "none"
  )) |>
  mutate(color = case_when(
    grepl("White", product_name) ~ "white",
    grepl("Brown", product_name) ~ "brown"
  )) |>
  mutate(vendor = str_to_lower(vendor)) |>
  select(color, brand, size, type, price_per_unit, time, vendor, other) |>
  mutate(price_per_unit = case_when(
    grepl("/100un.", price_per_unit) ~ as.numeric(gsub("\\$|/100un.", "", price_per_unit)) / 100,
    grepl("/un.", price_per_unit) ~ as.numeric(gsub("\\$|/un.", "", price_per_unit))
  ))


data <- bind_rows(voila_data, loblaws_data, metro_data)


data <- data |>
  filter(other == "Out of Stock") |>
  mutate(
    other = case_when(
      grepl("sale", other) ~ "Sale",
      grepl("SALE", other) ~ "Sale",
      TRUE ~ "No Sale"
    )
  )

write_csv(data, "./data/clean/clean_data.csv")


