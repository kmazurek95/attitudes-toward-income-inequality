# Load required libraries
library(tidyverse)
library(haven)
library(car)

# Set working directory dynamically
data_dir <- here::here("data")
output_dir <- here::here("outputs")

# Load data
ess_data_raw <- read_stata(file.path(data_dir, "ESS9MDHe03.1.dta"))

# Select and clean variables
selected_vars <- c("cntry", "gincdif", "gndr", "agea", "hinctnta", 
                   "eduyrs", "sofrdst", "sofrwrk", "sofrpr", "ppldsrv")

data_cleaned <- ess_data_raw %>%
  select(all_of(selected_vars)) %>%
  rename(
    income = hinctnta,
    age = agea,
    education = eduyrs
  ) %>%
  mutate(
    country = recode(cntry, 
                     AT = "Austria", BE = "Belgium", BG = "Bulgaria", 
                     CH = "Switzerland", CY = "Cyprus", CZ = "Czechia", 
                     DE = "Germany", DK = "Denmark", EE = "Estonia", 
                     ES = "Spain", FI = "Finland", FR = "France", 
                     GB = "United Kingdom", HR = "Croatia", HU = "Hungary", 
                     IE = "Ireland", IS = "Iceland", IT = "Italy", 
                     LT = "Lithuania", LV = "Latvia", ME = "Montenegro", 
                     NL = "Netherlands", NO = "Norway", PL = "Poland", 
                     PT = "Portugal", RS = "Serbia", SE = "Sweden", 
                     SI = "Slovenia", SK = "Slovakia"),
    country = factor(country),
    Redistribution = car::recode(gincdif, "1=5; 2=4; 4=2; 5=1"),
    Meritocracy = (car::recode(ppldsrv, "1=5; 2=4; 4=2; 5=1") +
                     car::recode(sofrwrk, "1=5; 2=4; 4=2; 5=1")) / 2,
    Collectivism = (car::recode(sofrdst, "1=5; 2=4; 4=2; 5=1") +
                      car::recode(sofrpr, "1=5; 2=4; 4=2; 5=1")) / 2,
    gender = car::recode(gndr, "1=0; 2=1")
  ) %>%
  drop_na()

# Save cleaned data
write_csv(data_cleaned, file.path(output_dir, "cleaned_data.csv"))
