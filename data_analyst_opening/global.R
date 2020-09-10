# Load libraries
library(flexdashboard)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)
library(plotly)
library(glue)
library(tidyr)
library(stringr)

# package shiny
library(shiny)
library(shinydashboard)

# Load data
master_data <- read.csv('data/DataAnalyst.csv')
map_data = read.csv('data/uscities.csv')

# Data Cleansing
master_data_clean <- 
  master_data %>%
  select(-Headquarters, -Type.of.ownership, -Competitors, -X, -Easy.Apply) %>%
  mutate(
    Location = as.factor(Location),
    Size = ifelse(Size == '-1', 'Unknown', Size),
    Size = factor(Size, levels = c(
      'Unknown',
      '1 to 50 employees',
      '51 to 200 employees',
      '201 to 500 employees',
      '501 to 1000 employees',
      '1001 to 5000 employees',
      '5001 to 10000 employees',
      '10000+ employees'
    )),
    Sector = ifelse(Sector == '-1', 'Unknown', Sector),
    Sector = as.factor(Sector),
    Revenue = as.factor(Revenue)
  ) %>%
  mutate(
    Age = ifelse(Founded > 0, 2020 - Founded, -1),
    Min.Salary = as.numeric(str_extract(Salary.Estimate, '\\d+')),
    Max.Salary = as.numeric(gsub('-\\$', '', str_extract(Salary.Estimate, '-\\$\\d+'))),
    Avg.Salary = (Max.Salary + Min.Salary) / 2,
    title_lower = tolower(Job.Title)
  ) %>%
  mutate(
    Role.Level = case_when(
      grepl('senior', title_lower, fixed=T) | grepl('sr.', title_lower, fixed=T) ~ 'Senior',
      grepl('junior', title_lower, fixed=T) | grepl('jr.', title_lower, fixed=T)~ 'Junior',
      grepl('manager', title_lower, fixed=T) | grepl('mgr', title_lower, fixed=T) | grepl('lead', title_lower, fixed=T) ~ 'Lead',
      TRUE ~'Middle'
    ),
    Role.Level = factor(Role.Level, levels = c('Junior', 'Middle', 'Senior', 'Lead'))
  ) %>%
  select(-title_lower) %>%
  mutate(
    Revenue = case_when(
      Revenue == 'Less than $1 million (USD)' ~ 'Less than $10 million (USD)',
      Revenue == '$1 to $5 million (USD)' ~ 'Less than $10 million (USD)',
      Revenue == '$5 to $10 million (USD)' ~ 'Less than $10 million (USD)',
      Revenue == '$10 to $25 million (USD)' ~ '$10 to $100 million (USD)',
      Revenue == '$25 to $50 million (USD)' ~ '$10 to $100 million (USD)',
      Revenue == '$50 to $100 million (USD)' ~ '$10 to $100 million (USD)',
      Revenue == '$100 to $500 million (USD)' ~ '$100 million to $1 billion (USD)',
      Revenue == '$500 million to $1 billion (USD)' ~ '$100 million to $1 billion (USD)',
      Revenue == '$1 to $2 billion (USD)' ~ '$1 to $10 billion (USD)',
      Revenue == '$2 to $5 billion (USD)' ~ '$1 to $10 billion (USD)',
      Revenue == '$5 to $10 billion (USD)' ~ '$1 to $10 billion (USD)',
      Revenue == '$10+ billion (USD)' ~ 'More than 10 billion (USD)',
      TRUE ~ 'Unknown / Non-Applicable'
    ),
    Revenue = factor(Revenue, levels = c('Unknown / Non-Applicable',
                                         'Less than $10 million (USD)', 
                                         '$10 to $100 million (USD)', 
                                         '$100 million to $1 billion (USD)', 
                                         '$1 to $10 billion (USD)',
                                         'More than 10 billion (USD)'
    ))
  )

# Merge data to get latitude and longitude
master_data_map <- 
  master_data_clean %>%
  select(Location, Avg.Salary) %>%
  separate(Location,
           sep = ', ',
           into = c('city', 'state_id')
  )

map_opening <-  merge(master_data_map, map_data, by = c('city', 'state_id'))

