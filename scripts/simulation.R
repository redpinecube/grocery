### simulate the variables :
### vendor, brand, egg size, time, price, type, and sale. 
library(lubridate)

set.seed(123)

size <- sample(c("Medium", "Large", "Extra Large"), 100, replace = TRUE)
price <- runif(100, min = 0, max = 10)
brand <- sample(c("BrandA", "BrandB", "BrandC"), 100, replace = TRUE)
vendor <- sample(c("Vendor1", "Vendor2", "Vendor3"), 100, replace = TRUE)
sale <- sample(c("Sale", "No Sale"), 100, replace = TRUE)
type <- sample(c("Organic", "Free Range", "None"), 100, replace = TRUE)


start_date <- as.Date("2024-01-01")
end_date <- as.Date("2024-12-31")
random_dates <- sample(seq(start_date, end_date, by = "day"), 100, replace = TRUE)

egg_data <- data.frame(
  price = price,
  size = size,
  brand = brand,
  vendor = vendor,
  time = random_dates,
  sale = sale,
  type = type
)

head(egg_data)

