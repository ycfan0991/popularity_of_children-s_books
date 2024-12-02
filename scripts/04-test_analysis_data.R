#### Preamble ####
# Purpose: Tests the analysis data for integrity and structure
# Author: Peter Fan
# Date: 21 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'arrow', testthat' packages are installed 

#### Workspace setup ####
library(arrow)
library(testthat)

# Load the cleaned data
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Test data ####

# Test that there are6 columns in the dataset
test_that("'6 columns in dataset", {
  expect_equal(ncol(analysis_data), 6)
})

# Test that there are less than 10 types of book covers in the dataset 
test_that("dataset has 10 types of book covers", {
  expect_lt(length(unique(analysis_data$cover)), 10)
})

# Test that the 'cover' column is character type
test_that("'cover' is character", {
  expect_type(analysis_data$cover, "character")
})


# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})
