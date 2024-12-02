#### Preamble ####
# Purpose: Cleans the raw data for missing value or invalid records
# Author: Peter Fan
# Date: 21 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', 'janitor', 'here', 'arrow' packages are installed 

#### Workspace setup ####

library(tidyverse)
library(janitor)
library(here)
library(arrow)

#### Clean data ####

childrens.books <- read_csv("data/01-raw_data/childrens.books.csv")

##Cleaning Column Names
childrens.books.clean<-clean_names(childrens.books)

##Cleaning missing data by column

colSums(is.na(childrens.books.clean))
childrens.books.clean<- childrens.books.clean %>% filter(!is.na(rating))
childrens.books.clean<- childrens.books.clean %>% filter(!is.na(cover))
childrens.books.clean<- childrens.books.clean %>% filter(!is.na(publish_year))
childrens.books.clean<- childrens.books.clean %>% filter(!is.na(pages))

## Remove duplicate ISBN or books
childrens.books.clean <- childrens.books.clean %>%
  distinct(isbn, .keep_all = TRUE)


## Replacing missing original publish year by publish year
childrens.books.clean$original_publish_year[is.na(childrens.books.clean$original_publish_year)] <-
  childrens.books.clean$publish_year [is.na(childrens.books.clean$original_publish_year)]
## Creating column to measure duration of republish year from original publish year
childrens.books.clean$republish_length<-childrens.books.clean$publish_year-childrens.books.clean$original_publish_year


## Store records with valid number of ratings
stats <- summary(childrens.books.clean$rating_count)
stats
q1 <- stats["1st Qu."]
q2 <- stats["Median"]
q3 <- stats["3rd Qu."]
min <- stats["Min."]
max <- stats["Max."]
mean_val <- mean(childrens.books$rating_count)
sd_val <- sd(childrens.books$rating_count)


threshold <- quantile(childrens.books.clean$rating_count, 0.25)  # Lower 25% cutoff
filtered_books <- childrens.books.clean[childrens.books.clean$rating_count >= threshold, ]


## Delete columns title, author, publisher
filtered_books <- filtered_books %>% select(-title, -author, -publisher)

## Delete columns rating_5, rating_4, rating_3, rating_2, rating_1
filtered_books <- filtered_books %>% select(-rating_5, -rating_4, -rating_3, 
                                            -rating_2, -rating_1, -original_publish_year, -isbn) %>% na.omit()

#### Save data ####
write_parquet(filtered_books, "data/02-analysis_data/analysis_data.parquet")

