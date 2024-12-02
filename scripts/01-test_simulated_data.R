#### Preamble ####
# Purpose: Tests the simulated data for integrity and structure
# Author: Peter Fan
# Date: 21 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', testthat' packages are installed 

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the cleaned data
simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

#### Test data ####

# Test that there are 6 columns in the dataset
test_that("'6 columns in dataset", {
  expect_equal(ncol(simulated_data), 6)
})

# Test that there are less than 10 types of book covers in the dataset 
test_that("dataset has 10 types of book covers", {
  expect_lt(length(unique(simulated_data$cover)), 10)
})

# Test that the 'cover' column is character type
test_that("'cover' is character", {
  expect_type(simulated_data$cover, "character")
})


# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(simulated_data)))
})

