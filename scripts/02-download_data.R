#### Preamble ####
# Purpose: Downloads and saves the data from Alex Cookson’s database
# Author: Peter Fan
# Date: 20 November 2024
# Contact: peteryc.fan@mail.utoronto.ca
# License: None
# Pre-requisites: 
# - Ensure the 'tidyverse' packages are installed 

#### Workspace setup ####
library(tidyverse)

#### Download data ####

childrens.books <- read_tsv("https://raw.githubusercontent.com/tacookson/data/master/childrens-book-ratings/childrens-books.txt")

#### Save data ####
write_csv(childrens.books, "data/01-raw_data/childrens.books.csv") 

         