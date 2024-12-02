library(plumber)
library(tidyverse)

# Load the model
model <- readRDS("glm_model.rds")

# Define the model version
version_number <- "0.0.1"

# Define the variables
variables <- list(
  publish_year = "The year the book was published, numeric value.",
  republish_length = "The number of years since the book was republished, numeric value.",
  pages = "The number of pages in the book, numeric value.",
  cover = "The cover type of the book, character value. Choose from Board Book, Ebook, Hardcover, Kindle Edition, Paperback.",
  rating = "The average rating of the book, numeric value between 1 and 5."
)

#* Predict the rating count based on book attributes
#* @param publish_year The year the book was published (numeric).
#* @param republish_length The number of years since the book was republished (numeric).
#* @param pages The number of pages in the book (numeric).
#* @param cover The cover type of the book (character). Options: Board Book, Ebook, Hardcover, Kindle Edition, Paperback.
#* @param rating The average rating of the book (numeric, between 1 and 5).
#* @get /predict_rating_count
predict_rating_count <- function(publish_year = 2020, 
                                 republish_length = 10, 
                                 pages = 200, 
                                 cover = "Paperback", 
                                 rating = 4.5) {
  # Convert inputs to appropriate types
  input_data <- data.frame(
    publish_year = as.numeric(publish_year),
    republish_length = as.numeric(republish_length),
    pages = as.numeric(pages),
    cover = as.character(cover),
    rating = as.numeric(rating)
  )
  
  # Use the predict function with the pre-trained model
  predicted_log_rating_count <- predict(model, newdata = input_data, type = "link")
  predicted_rating_count <- exp(predicted_log_rating_count)
  
  # Store results
  result <- list(
    "Predicted Rating Count:" = round(predicted_rating_count)
  )
  
  return(result)
}

