#### Preamble ####
# Purpose: Tests the simulated data for integrity and structure
# Author: Peter Fan
# Date: 21 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', 'arrow', testthat' packages are installed 

#### Workspace setup ####
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
if (!requireNamespace("testthat", quietly = TRUE)) {
  install.packages("testthat")
}
if (!requireNamespace("arrow", quietly = TRUE)) {
  install.packages("arrow", repos = c("https://apache.r-universe.dev", "https://cloud.r-project.org"))
}
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}

library(tidyverse)
library(testthat)
library(arrow)
library(here)


# Load the cleaned data
simulated_data <- read_csv(here("data/00-simulated_data/simulated_data.csv"))

#### Test data ####
# Test that the dataset has unique ISBN in each record or row no duplicate
test_that("the dataset has unique ISBNs", {
  expect_equal(length(unique(simulated_data$isbn)), nrow(simulated_data))
})

# Test that there are 8 columns in the dataset
test_that("'8 columns in dataset", {
  expect_equal(ncol(simulated_data), 8)
})

# Test that there are less than 10 types of book covers in the dataset 
test_that("dataset has 10 types of book covers", {
  expect_lt(length(unique(simulated_data$cover)), 10)
})

# Test that the 'cover' column is character type
test_that("'cover' is character", {
  expect_type(simulated_data$cover, "character")
})


# Test that all remaining columns except isbn and cover are numaric
test_that("all columns except 'isbn' and 'cover' are numeric", {
  columns_to_check <- simulated_data[,3:8]
  expect_true(all(sapply(columns_to_check, is.numeric)))
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(simulated_data)))
})
