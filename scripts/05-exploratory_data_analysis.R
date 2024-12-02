#### Preamble ####
# Purpose: To explore the variables used for developing prredicting popularity of books =
# Author: Peter Fan
# Date: 21 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# Pre-requisites:
# - Ensure the 'tidyverse', janitor', 'here', 'arrow' packages are installed 


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(psych)
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Descriptive Analysis ####

## Histogram of continuous variables
hist(analysis_data$pages)
hist(analysis_data$rating)
hist(analysis_data$rating_count)
hist(analysis_data$publish_year)

## Descriptive statistics of numarical variables
describe(analysis_data[,2:6])

## Visualization: Rating Count by Cover
ggplot(analysis_data, aes(x = cover, y = rating_count)) +
  geom_boxplot(fill = "skyblue", color = "black", outlier.shape = NA) +
  labs(title = "Distribution of Rating Count by Cover Type Without Outliers", 
       x = "Cover Type", 
       y = "Rating Count") + ylim(0,1000) +
  theme_minimal()

## Visualization: Rating Count by Rating
ggplot(analysis_data, aes(x = rating, y = rating_count)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Scatter Plot of Rating vs. Rating Count up to 10000", 
    x = "Rating", 
    y = "Rating Count"
  ) +
  theme_minimal()+ ylim(0,10000)

## Visualization: Rating Count by Publish Year
ggplot(analysis_data, aes(x = publish_year, y = rating_count)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Scatter Plot of Publish year vs. Rating Count up to 10000", 
    x = "Publish Year", 
    y = "Rating Count"
  ) +
  theme_minimal()+ ylim(0,10000)

## Visualization: Rating Count by Pages
ggplot(analysis_data, aes(x = pages, y = rating_count)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Scatter Plot of Pages vs. Rating Count up to 10000", 
    x = "Pages", 
    y = "Rating Count"
  ) +
  theme_minimal()+ ylim(0,10000)

## Visualization: Rating Count by Pages
ggplot(analysis_data, aes(x = pages, y = rating_count)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Scatter Plot of Pages vs. Rating Count up to 10000", 
    x = "Pages", 
    y = "Rating Count"
  ) +
  theme_minimal()+ ylim(0,10000)

## Visualization: Rating Count by Republish Length
ggplot(analysis_data, aes(x = republish_length, y = rating_count)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Scatter Plot of Republish Length vs. Rating Count up to 10000", 
    x = "Republish Length", 
    y = "Rating Count"
  ) +
  theme_minimal()+ ylim(0,10000)



## Describing catagorical variable
janitor::tabyl(analysis_data$cover)%>%adorn_pct_formatting(digits = 2)
janitor::tabyl(analysis_data$publish_year)%>%adorn_pct_formatting(digits = 2)

## Correlation Analysis for numarical variables
cor_matrix<-round(cor(analysis_data[2:6]),2)
cor_matrix

