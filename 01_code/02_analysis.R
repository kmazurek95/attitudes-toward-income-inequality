require(plm)
require(sandwich)
require(lmtest)    
require(ggplot2)
library(tidyverse)
library(corrr)
library(lmtest)
library(dplyr)
library(psych)
library(lme4)
library(performance)
library(jtools)
library(lmerTest)
require(lubridate)
library(eeptools)
library(ggplot2)

getwd()
data <- read_csv("./03_data_final/complete_merge.csv")

#-------------------------------------------------------------------------------

# Code different interations of the dependent variable and standardize (1-100)

#------------------------------------------------------------------------------
data <-
  data %>%
  filter(a27_2_reduce_differences_in_income_levels != 8, 
         a27_1_government_intervention_into_the_economy != 8,
         a27_3_Employees_need_strong_trade_unions !=8)  %>%
  
  mutate(DV_one_to_zero = (100*(.$a27_2_reduce_differences_in_income_levels -1))
         /(7-1)) %>%
  
  mutate(DV_combined_01 = (.$a27_1_government_intervention_into_the_economy +
        .$a27_2_reduce_differences_in_income_levels)/(2)) %>%
  
  mutate(DV_combined_02 = (.$a27_1_government_intervention_into_the_economy
         + .$a27_2_reduce_differences_in_income_levels 
         + .$a27_3_Employees_need_strong_trade_unions)/(3)) %>%
  
  mutate(DV_combined_01_one_to_zero = (100*(.$DV_combined_01 -1)/(7-1))) %>%
  
  mutate(DV_combined_02_one_to_zero = (100*(.$DV_combined_02 -1))/(7-1)) 
  

#-------------------------------------------------------------------------------

#       Re-code Level one variable and standardize in terms of SD

#-------------------------------------------------------------------------------
#Sex
data<-
  data %>% 
  mutate(                          
    sex=
      case_when(
        b01_sex %in% 1 ~ 
          "Male",
        b01_sex %in% 2 ~ 
          "Female",
        b01_sex %in% 3 ~ 
          "Other")) %>%
  mutate(sex = factor(sex))
#-------------------------------------------------------------------------------
#Age

data<- data %>%
  mutate(age = (2017-data$b02_birth_year)) %>%
  mutate_at(c('age'), ~ (scale(.) %>% as.vector))
#-------------------------------------------------------------------------------
#Religion

data<-
  data %>% 
  mutate(                           
    religion=
      case_when(
        b16_type_of_faith_denomination %in% 1 ~ 
          "Roman Catholic",
        b16_type_of_faith_denomination %in% 2 ~ 
          "Protestant",
        b16_type_of_faith_denomination %in% 3 ~ 
          "Eastern Orthodox",
        b16_type_of_faith_denomination %in% 4 ~ 
          "Other Christian denomination",
        b16_type_of_faith_denomination %in% 5 ~ 
          "Jewish",
        b16_type_of_faith_denomination %in% 6 ~ 
          "Islamic",
        b16_type_of_faith_denomination %in% 7 ~ 
          "Eastern religions",
        b16_type_of_faith_denomination %in% 8 ~ 
          "Other non-Christian religions",
        b16_type_of_faith_denomination %in% 9 ~ 
          "Christian, but I do not associate with one of the denominations")) %>%
  mutate(religion = factor(religion))
#----------------------------------------------------------------------------
#Education

data<-
  data %>%
  mutate(education = b03_highest_level_of_education) %>%
  mutate_at(c('education'), ~ (scale(.) %>% as.vector))
#------------------------------------------------------------------------------
#Employemnt
data<-
  data %>% 
  mutate(                           
    employment_status=
      case_when(
        b16_type_of_faith_denomination %in% 1 ~ 
          "Employed",
        b16_type_of_faith_denomination %in% 2 ~ 
          "Student",
        b16_type_of_faith_denomination %in% 3 ~ 
          "Unemployed and Actively Looking for Work",
        b16_type_of_faith_denomination %in% 4 ~ 
          "unemployed, wanting a job but not actively looking",
        b16_type_of_faith_denomination %in% 5 ~ 
          "permanently sick or disabled",
        b16_type_of_faith_denomination %in% 6 ~ 
          "retired",
        b16_type_of_faith_denomination %in% 7 ~ 
          "Community or Military Service",
        b16_type_of_faith_denomination %in% 8 ~ 
          "Housework, looking after children or other persons ")) %>%
  mutate(employment_status = factor(employment_status))
#------------------------------------------------------------------------------
#Occupation

data<-
  data %>% 
  mutate(                           
    occupation=
      case_when(
        b16_type_of_faith_denomination %in% 1 ~ 
          "Modern professional occupations",
        b16_type_of_faith_denomination %in% 2 ~ 
          "Clerical and intermediate occupations",
        b16_type_of_faith_denomination %in% 3 ~ 
          "Senior managers or administrators",
        b16_type_of_faith_denomination %in% 4 ~ 
          "Technical and craft occupations",
        b16_type_of_faith_denomination %in% 5 ~ 
          "Semi-routine manual and service",
        b16_type_of_faith_denomination %in% 6 ~ 
          "Routine manual and service ",
        b16_type_of_faith_denomination %in% 7 ~ 
          "Middle or junior managers ",
        b16_type_of_faith_denomination %in% 8 ~ 
          "Traditional professional occupations")) %>%
  mutate(occupation = factor(occupation))

#-------------------------------------------------------------------------------
#Standardize Level two variables  
data<- data %>%
     mutate_at(c('buurt_40_Lowest_Income_Households',
             'buurt_number_of_inhabitants',
             'buurt_n_Sixty_Five_Years_Or_Older',
             'buurt_Non_Western_Total',
             'buurt_Average_Income_Per_Inhabitant',
             'buurt_low_income_households',
             'buurt_Population_Density',
             'buurt_Household_Under_Or_Around_Social_Minimum',
             'wijk_40_Lowest_Income_Households',
             'gemeente_40_Lowest_Income_Households'),
             ~ (scale(.) %>% as.vector))
#---------------------------------------------------------------------------------------------------------
# Distributions of Varibales of interest

hist(data$buurt_40_Lowest_Income_Households)
hist(data$DV_combined_01_one_to_zero)

hist(data$buurt_n_Sixty_Five_Years_Or_Older)
hist(data$buurt_Non_Western_Total)
hist(data$buurt_Average_Income_Per_Inhabitant)
hist(data$buurt_low_income_households)
hist(data$buurt_Population_Density)
hist(data$buurt_Household_Under_Or_Around_Social_Minimum)
hist(data$buurt_number_of_inhabitants)

#---------------------------------------------------------------------------------------------------------
# Correlation between DV and 40_Lowest_Income_Households (all levels)

(correlations <- 
data %>%
  select(buurt_40_Lowest_Income_Households, wijk_40_Lowest_Income_Households, 
  gemeente_40_Lowest_Income_Households, DV_combined_01_one_to_zero) %>%
        correlate())
rplot(correlations)



#Significance test for correlations
cor.test(data$buurt_40_Lowest_Income_Households, data$DV_combined_01_one_to_zero, method=c("pearson", "kendall", "spearman"))
cor.test(data$wijk_40_Lowest_Income_Households, data$DV_combined_01_one_to_zero, method=c("pearson", "kendall", "spearman"))
cor.test(data$gemeente_40_Lowest_Income_Households, data$DV_combined_01_one_to_zero, method=c("pearson", "kendall", "spearman"))
#-------------------------------------------------------------------------------------------------------------------------------------------------------
means_by_buurt <-
data %>% 
  group_by(buurt_code) %>% 
  summarise(mean = mean(DV_combined_01_one_to_zero, na.rm = T), 
            SD = sd(DV_combined_01_one_to_zero, na.rm = T),
            freq = n(),
            miss = mean(is.na(DV_combined_01_one_to_zero))) %>% 
  mutate_if(is.numeric, ~round(., 2)) 

means_by_wijk <-
  data %>% 
  group_by(wijk_code) %>% 
  summarise(mean = mean(DV_combined_01_one_to_zero, na.rm = T), 
            SD = sd(DV_combined_01_one_to_zero, na.rm = T),
            freq = n(),
            miss = mean(is.na(DV_combined_01_one_to_zero))) %>% 
  mutate_if(is.numeric, ~round(., 2)) 

means_by_gemeente <-
  data %>% 
  group_by(gemeente_code) %>% 
  summarise(mean = mean(DV_combined_01_one_to_zero, na.rm = T), 
            SD = sd(DV_combined_01_one_to_zero, na.rm = T),
            freq = n(),
            miss = mean(is.na(DV_combined_01_one_to_zero))) %>% 
  mutate_if(is.numeric, ~round(., 2)) 

#------------------------------------------------------------------------------
#                           SET THE SAMPLE
#-----------------------------------------------------------------------------
data_two_levels <-
  data %>%
  select(DV_combined_01_one_to_zero, age, sex, education, employment_status, religion, occupation, 
         buurt_40_Lowest_Income_Households, buurt_number_of_inhabitants,
         buurt_n_Sixty_Five_Years_Or_Older, buurt_Non_Western_Total, 
         buurt_Average_Income_Per_Inhabitant, buurt_low_income_households,
         buurt_Population_Density, buurt_Household_Under_Or_Around_Social_Minimum,
         buurt_code_eight_digits) %>%
  na.omit() #WHY ARE SO MANY BEING DROPED EVEN WHEN YOU TAKE RELIGION AND OCCUPATION OUT

#------------------------------------------------------------------------------
#                           Multi-Level Model Buurt
#-----------------------------------------------------------------------------
# empty multilevel model (No fixed factors (intercept only))
m0_buurt <- lmer(DV_combined_01_one_to_zero ~ 1 +
                 (1 |buurt_code_eight_digits), 
                 data = data_two_levels)

summary(m0_buurt)
summ(m0_buurt)


#------------------------------------------------------------------------------
#Include dependent variable
m1_buurt <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                 +(1 |buurt_code_eight_digits),
                 data = data_two_levels)

summary(m1_buurt)
#summ(m1_buurt)
anova(m0_buurt ,m1_buurt) 
#------------------------------------------------------------------------------
#Add level one variables 
m2_buurt <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                 +age
                 +sex
                 +education
                 +employment_status
                 +religion
                 +occupation
                 +(1 | buurt_code_eight_digits),
                 data = data_two_levels)
summary(m2_buurt)
#summ(m2_buurt)
anova(m2_buurt ,m1_buurt)

#------------------------------------------------------------------------------
#Add level two variables 
m3_buurt <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                 +age
                 +sex
                 +education
                 +religion
                 +employment_status
                 +occupation
                  +buurt_number_of_inhabitants
                  +buurt_n_Sixty_Five_Years_Or_Older
                  +buurt_Non_Western_Total
                  +buurt_Average_Income_Per_Inhabitant
                  +buurt_low_income_households
                  +buurt_Population_Density
                  +buurt_Household_Under_Or_Around_Social_Minimum
                  +(1 |buurt_code_eight_digits), 
                  data = data_two_levels)
summary(m3_buurt)
#summ(m3_buurt)
anova(m3_buurt, m2_buurt) 
#------------------------------------------------------------------------------
#                           Four Level Model
#-----------------------------------------------------------------------------
# empty multilevel model (No fixed factors (intercept only))

m0_four_level <- lmer(DV_combined_01_one_to_zero ~ 1 
                      +(1 |gemeente_code_four_digits)
                      +(1 |wijk_code_six_digits)
                      +(1 |buurt_code_eight_digits), 
                      data = data)


summary(m0_four_level)
#summ(m0_four_level)
#------------------------------------------------------------------------------
#Insert Explanatory Variable(s)

m1_four_level <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                      +wijk_40_Lowest_Income_Households
                      +gemeente_40_Lowest_Income_Households
                      +(1 |gemeente_code_four_digits)
                      +(1 |wijk_code_six_digits)
                      +(1 |buurt_code_eight_digits), 
                      data = data)
summary(m1_four_level)
#-------------------------------------------------------------------------------
#Add level one variables
m2_four_level <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                      +wijk_40_Lowest_Income_Households
                      +gemeente_40_Lowest_Income_Households
                      +age
                      +sex
                      +education
                      +employment_status
                      +religion
                      +occupation
                      +(1 |gemeente_code_four_digits)
                      +(1 |wijk_code_six_digits)
                      +(1 |buurt_code_eight_digits), 
                      data = data)
summary(m2_four_level)
#-------------------------------------------------------------------------------
#Add level two variables (what level?, buurt level for now)
m3_four_level <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                      +wijk_40_Lowest_Income_Households
                      +gemeente_40_Lowest_Income_Households
                      +age
                      +sex
                      +education
                      +employment_status
                      +religion
                      +occupation
                      +buurt_number_of_inhabitants
                      +buurt_n_Sixty_Five_Years_Or_Older
                      +buurt_Non_Western_Total
                      +buurt_Average_Income_Per_Inhabitant
                      +buurt_low_income_households
                      +buurt_Population_Density
                      +buurt_Household_Under_Or_Around_Social_Minimum
                      +(1 |gemeente_code_four_digits)
                      +(1 |wijk_code_six_digits)
                      +(1 |buurt_code_eight_digits), 
                      data = data)
summary(m3_four_level)
#-------------------------------------------------------------------------------
#Adding two levels of indicators -- is this appropriate?

m4_four_level <- lmer(DV_combined_01_one_to_zero ~ buurt_40_Lowest_Income_Households
                      +wijk_40_Lowest_Income_Households
                      +gemeente_40_Lowest_Income_Households
                      +age
                      +sex
                      +education
                      +employment_status
                      +religion
                      +occupation
                      +buurt_number_of_inhabitants
                      +buurt_n_Sixty_Five_Years_Or_Older
                      +buurt_Non_Western_Total
                      +buurt_Average_Income_Per_Inhabitant
                      +buurt_low_income_households
                      +buurt_Population_Density
                      +buurt_Household_Under_Or_Around_Social_Minimum
                      +wijk_number_of_inhabitants
                      +wijk_n_Sixty_Five_Years_Or_Older
                      +wijk_Non_Western_Total
                      +wijk_Average_Income_Per_Inhabitant
                      +wijk_low_income_households
                      +wijk_Population_Density
                      +wijk_Household_Under_Or_Around_Social_Minimum
                      +(1 |gemeente_code_four_digits)
                      +(1 |wijk_code_six_digits)
                      +(1 |buurt_code_eight_digits), 
                      data = data)
summary(m4_four_level)
