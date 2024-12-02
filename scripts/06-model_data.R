#### Preamble ####
# Purpose: Developing the predictive model for popularity of children's book 
# Author: Peter Fan
# Date: 24 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', janitor', 'broom', 'arrow' packages are installed 


#### Workspace setup ####

# Load Library
library(tidyverse)
library(janitor)
library(arrow)
library(broom)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####
glm_model <- glm(rating_count ~ publish_year + republish_length + pages + as.factor(cover) + rating,
                   family = poisson(link = "log"), data = analysis_data)
summary(glm_model)

lm_model <- glm(rating_count ~ publish_year + republish_length + pages + as.factor(cover) + rating,
                data = analysis_data)
summary(lm_model)

#### Save Model ####
saveRDS(glm_model, "models/glm_model.rds")

saveRDS(lm_model, "models/lm_model.rds")

#### Model Analysis ####
# Get a tidy summary of the linear model
model_summary <- tidy(glm_model)

# Print model summary to console
print(model_summary)

# Create a visual summary of the model coefficients
plot_model <- ggplot(model_summary, aes(x = term, y = estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = estimate - std.error, ymax = estimate + std.error), width = 0.2) +
  coord_flip(ylim = c(-10, 30)) +
  labs(
    title = "GLM Model Coefficients for Popularity (Rating Count) Children's Book",
    x = "Predictor",
    y = "Estimate"
  ) +
  theme_minimal()
plot_model


#### Model comparison and evaluation ####
# Split Data into Train and Test Sets 
set.seed(123)  # For reproducibility
train_indices <- sample(1:nrow(analysis_data), size = 0.8 * nrow(analysis_data))
train_data <- analysis_data[train_indices, ]
test_data <- analysis_data[-train_indices, ]

# Fit GLM model on training data
glm_model <- glm(rating_count ~ publish_year + republish_length + pages + as.factor(cover) + rating,
                 family = poisson(link = "log"), data = train_data)

# Fit LM model on training data
lm_model <- glm(rating_count ~ publish_year + republish_length + pages + as.factor(cover) + rating,
                data = train_data)

#### Model Analysis on Test Set ####
# Predicted values for the test set
glm_predictions <- predict(glm_model, newdata = test_data, type = "response")
lm_predictions <- predict(lm_model, newdata = test_data, type = "response")

# Observed values in the test set
observed_values <- test_data$rating_count

# MSE Calculation for the test set
glm_mse <- mean((observed_values - glm_predictions)^2)
lm_mse <- mean((observed_values - lm_predictions)^2)

# RMSE Calculation for the test set
glm_rmse <- sqrt(glm_mse)
lm_rmse <- sqrt(lm_mse)

# Output MSE and RMSE for test set
cat("GLM Model MSE (Test Set):", glm_mse, "\n")
cat("GLM Model RMSE (Test Set):", glm_rmse, "\n")
cat("LM Model MSE (Test Set):", lm_mse, "\n")
cat("LM Model RMSE (Test Set):", lm_rmse, "\n")



# Scatter plot: Predicted vs Observed
plot_model_analysis<-ggplot(analysis_data, aes(x = glm_predictions, y = observed_values)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(
    x = "Predicted Rating Count",
    y = "Observed Rating Count",
    title = "Predicted vs Observed Rating Count"
  ) +
  theme_minimal()
plot_model_analysis

