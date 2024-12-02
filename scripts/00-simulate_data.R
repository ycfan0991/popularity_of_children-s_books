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
library(tibble)

set.seed(123)  # For reproducibility

# Define the covers and their probabilities
cover <- c("Hardcover", "Paperback", "Spiral-bound", "eBook", "Board Book", "Audiobook")

# Simulated dataset with dependencies
simulated_data <- tibble(
  publish_year = sample(
    2024:2034,
    size = 500,
    replace = TRUE,
    prob = exp(seq(0, 1, length.out = 11))  # Exponential bias for years (newer books more likely)
  ),
  pages = round(rlnorm(500, meanlog = 5, sdlog = 0.5), 0),  # Log-normal distribution for pages
  cover = sample(
    cover,
    size = 500,
    replace = TRUE,
    prob = c(0.02, 3.23, 0.54, 67.62, 0.88, 28.01)  # Example cover distribution
  ),
  # Ratings depend on pages (longer books may get higher ratings) and cover type
  rating = pmin(
    pmax(
      rnorm(500, mean = 4.03 + 0.001 * pages + ifelse(cover == "Hardcover", 0.5, 0), sd = 0.5),  # Dependency
      1
    ),
    5
  ),
  rating_count = rpois(500, 1000000),
  # Republish length depends on publish year (older books have longer republish lengths)
  republish_length = round(rlnorm(500, meanlog = 5.5 - 0.1 * (publish_year - 2024), sdlog = 0.5), 0)
) %>% select(cover, pages, publish_year, rating, rating_count, republish_length)

# Check the first few rows
head(simulated_data)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")

