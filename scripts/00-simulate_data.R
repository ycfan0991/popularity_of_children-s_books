#### Preamble ####
# Purpose: Developing simulated dataset for children's books and their publication details
# Author: Peter Fan
# Date: 22 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', 'janitor', 'here', 'arrow' packages are installed 


#### Workspace setup ####
library(tidyverse)
set.seed(853)


#### Simulate data ####
# Book Cover Type
cover <- c(
  "Audiobook",
  "Board Book",
  "Ebook",
  "Hardcover",
  "Kindle Edition",
  "Paperback"
)


# Create a dataset by randomly assigning states and parties to divisions
simulated_data <- tibble(
  ID = paste0("Book-", sprintf("%04d", sample(1:9999, size = 500, replace = FALSE))),  # Generate unique random book IDs
  publish_year = sample(
    2024:2034,
    size = 500,
    replace = TRUE,
    prob = exp(seq(0, 1, length.out = 11))  # Exponential bias for 11 years (2024 to 2034)
  ),
  pages = round(rlnorm(500, meanlog = 5, sdlog = 0.5), 0),
  cover = sample(
    cover,
    size = 500,
    replace = TRUE,
    prob = c(0.02, 3.23, 0.54, 67.62, 0.88, 28.01)  # Rough state population distribution
  ),
  rating = pmin(pmax(rnorm(500, mean = 4.03, sd = 0.5), 1), 5),  # Generate ratings, bounded between 1 and 5
  republish_length = round(rlnorm(500, meanlog = 5.5, sdlog = 0.5), 0) 
  )
glm_model <- readRDS(here("models/glm_model.rds"))
simulated_data$predicted_rating_count <- predict(glm_model, newdata = simulated_data, type = "response")

#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")