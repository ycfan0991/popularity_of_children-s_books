#### Preamble ####
# Purpose: Cleans the raw data for missing value or invalid records
# Author: Peter Fan
# Date: 21 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', 'janitor', 'here', 'arrow' packages are installed 

#### Workspace setup ####

if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
if (!requireNamespace("janitor", quietly = TRUE)) {
  install.packages("janitor")
}
if (!requireNamespace("arrow", quietly = TRUE)) {
  install.packages("here", repos = c("https://apache.r-universe.dev", "https://cloud.r-project.org"))
}

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

## Storing cleaned childrens books
write_csv(childrens.books.clean, "data/01-raw_data/childrens.books.clean.csv")

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

# Plot the histogram with annotations
ggplot(childrens.books, aes(x = rating_count)) +
  geom_histogram(fill = "skyblue", color = "black", bins = 20) +
  labs(title = "Figure 1: Distribution of Sample Sizes up to 10000 Rating Count",
    x = "Sample Size of Given Rating",
    y = "Frequency") + 
  theme_minimal() + 
  xlim(0, 10000) + 
  ylim(0, 2500) +
  geom_label(aes(x = 2500, y = 2500, 
                 label = paste0("min: ", round(min, 1))), 
             color = "black", fontface = "bold") +
  geom_label(aes(x = 2500, y = 2300, 
                 label = paste0("Q1: ", round(q1, 1))), 
             color = "black", fontface = "bold") +
  geom_label(aes(x = 2500, y = 2100, 
                 label = paste0("Median: ", round(q2, 1))), 
             color = "black", fontface = "bold") +
  geom_label(aes(x = 2500, y = 1900, 
                 label = paste0("Q3: ", round(q3, 1))), 
             color = "black", fontface = "bold") +
  geom_label(aes(x = 2500, y = 1700, 
                 label = paste0("max: ", round(max, 1))), 
             color = "black", fontface = "bold") +
  geom_label(aes(x = 2500, y = 1500, 
                 label = paste0("Mean: ", round(mean_val, 1))), 
             color = "black", fontface = "bold")

  

threshold <- quantile(childrens.books.clean$rating_count, 0.25)  # Lower 25% cutoff
filtered_books <- childrens.books[childrens.books.clean$rating_count >= threshold, ]



## Delete columns title, author, publisher
filtered_books <- filtered_books %>% select(-title, -author, -publisher)

## Delete columns rating_5, rating_4, rating_3, rating_2, rating_1
filtered_books <- filtered_books %>% select(-rating_5, -rating_4, -rating_3, 
                                            -rating_2, -rating_1)

#### Save data ####

write_parquet(filtered_books, "data/02-analysis_data/analysis_data.parquet")

