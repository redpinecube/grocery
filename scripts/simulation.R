### simulate the variables :
### vendor, brand, egg size, month, and price. 

set.seed(123)
size <- sample(c("Medium", "Small", "Large", "Jumbo"), 100, replace = TRUE)
avg_price <- runif(100, min = 0, max = 15)
brand <- sample(c("a", "b", "c"), 100, replace = TRUE)
vendor <- sample(c("vendor1", "vendor2", "vendor3"), 100, replace = TRUE)
month <- sample(1:12, 100, replace = TRUE)

data.frame(avg_price, size, brand, month, vendor)

