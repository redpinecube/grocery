library(tidyverse)
data <- read_csv("./data/clean/preprocess.csv")
set.seed(45)

data <- data |>
  select(sale, voila, brown, 
         large, organic, price_per_unit)

shuffled_data <- data[sample(nrow(data)), ]
train_indices <- 1:floor(0.8 * nrow(shuffled_data))
train_data <- shuffled_data[train_indices, ]
test_data <- shuffled_data[-train_indices, ]

train_model <- lm(price_per_unit ~ ., data = train_data)
test_predictions <- predict(train_model, newdata = test_data)
actual_values <- test_data$price_per_unit
rmse <- sqrt(mean((actual_values - test_predictions)^2))
print(rmse)
saveRDS(train_model, file = "./model/model.rds")

