
require(haven)
require(stargazer)
require(ivreg)
require(plm)
require(sandwich)
require(lmtest)    
require(dplyr)
require(questionr)
require(ggplot2)
library(tidyverse) 
library(backports)
library(broom)
library(car)
library(zoo)
library(lmtest)
library(foreign)
library(readxl)


# CALL INDICATORS INTO ENVIRONMENT 
prepped_indicators_buurt <- read_csv("C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/processed_indicators/prepped_indicators_buurt.csv")
prepped_indicators_buurt <- as.data.frame(`prepped_indicators_buurt`)

prepped_indicators_wijk <- read_csv("C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/processed_indicators/prepped_indicators_wijk.csv")
prepped_indicators_wijk <- as.data.frame(`prepped_indicators_wijk`)

prepped_indicators_gemeente <- read_csv("C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/processed_indicators/prepped_indicators_gemeente.csv")
prepped_indicators_gemeente <- as.data.frame(`prepped_indicators_gemeente`)


# CALL SCORE DATASET INTO ENVIRONMENT 
score_prepped <- read_csv("C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/processed_score_data/score_prepped.csv")
score_prepped <- as.data.frame(`score_prepped`)


# MERGE THE SCORE DATA SET WITH EACH LEVEL OF INDICATOR TO CREATE THREE DATA SETS (ONE FOR EACH LEVEL OF INDICATOR)
merged_score_with__buurt_indicators_only <- merge(x = score_prepped, y = prepped_indicators_buurt, by = "buurt_code_eight_digits")
merged_score_with_wijk_indicators_only <- merge(x = score_prepped, y = prepped_indicators_wijk, by= "wijk_code_six_digits") #merged wijk indicators with original data set 
merged_score_with_gemeente_indicators_only <- merge(x = score_prepped, y = prepped_indicators_gemeente, by= "gemeente_code_four_digits") #merged wijk indicators with original data set 


#MERGE WIJK INDICATORS WITH WITH BUURT INDICATORS AND SCORE DATA 
INCOMPLETE_merged_score_with_buurt_and_wijk_indicators <- merge(x = merged_score_with__buurt_indicators_only, y = indicators_wijk, by= "wijk_code_six_digits") #merge wijk indicators with the previous merge between score and buurt indicators

#MERGE GEMEENTE INDICATORS WITH WITH BUURT AND WIJK INDICATORS AND SCORE DATA 
COMPLETE_merged_score_with_buurt_wijk_and_gementeee_indicators <- merge(x = INCOMPLETE_merged_score_with_buurt_and_wijk_indicators, y = indicators_gemeente, by= "gemeente_code_four_digits") #merge wijk indicators with the previous merge between score and buurt indicators

