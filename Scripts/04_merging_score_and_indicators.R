
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

#--------------------------------------------------------------------------------------------------------------------------------------------------------
# CALL INDICATORS INTO ENVIRONMENT 
prepped_indicators_buurt <- read_csv("./Data/processed_indicators/prepped_indicators_buurt.csv")
prepped_indicators_buurt <- as.data.frame(`prepped_indicators_buurt`)

prepped_indicators_wijk <- read_csv("./Data/processed_indicators/prepped_indicators_wijk.csv")
prepped_indicators_wijk <- as.data.frame(`prepped_indicators_wijk`)

prepped_indicators_gemeente <- read_csv("./Data/processed_indicators/prepped_indicators_gemeente.csv")
prepped_indicators_gemeente <- as.data.frame(`prepped_indicators_gemeente`)

#--------------------------------------------------------------------------------------------------------------------------------------------------------
# CALL SCORE DATASET INTO ENVIRONMENT 
score_prepped <- read_csv("./Data/processed_score_data/score_prepped.csv")
score_prepped <- as.data.frame(`score_prepped`)


#--------------------------------------------------------------------------------------------------------------------------------------------------------
# MERGE THE SCORE DATA SET WITH EACH LEVEL OF INDICATOR TO CREATE THREE DATA SETS (ONE FOR EACH LEVEL OF INDICATOR)

#MERGE SERVEY DATA AND LEVEL 2 INDICATORS (BUURT)
merged_score_with__buurt_indicators_only <- merge(x = score_prepped, y = prepped_indicators_buurt, by = "buurt_code_eight_digits")

write.csv(merged_score_with__buurt_indicators_only,"./Data/merged_data/merged_buurt_only.csv")


#MERGE SERVEY DATA AND LEVEL 3 INDICATORS (WIJK)
merged_score_with_wijk_indicators_only <- merge(x = score_prepped, y = prepped_indicators_wijk, by= "wijk_code_six_digits") #merged wijk indicators with original data set 

write.csv(merged_score_with_wijk_indicators_only,"./Data/merged_data/merged_wijk_only.csv")


#MERGE SERVEY DATA AND LEVEL 4 INDICATORS (GEMEENTE)
merged_score_with_gemeente_indicators_only <- merge(x = score_prepped, y = prepped_indicators_gemeente, by= "gemeente_code_four_digits") #merged wijk indicators with original data set 

write.csv(merged_score_with_gemeente_indicators_only,"./Data/merged_data/merged_gemeente_only.csv")

#--------------------------------------------------------------------------------------------------------------------------------------------------------


#MERGE WIJK INDICATORS (LEVEL 3) WITH SCORE DATA CONTAINING LEVEL 2 INDICATORS (BUURT)
incomplete_merge <- merge(x = merged_score_with__buurt_indicators_only, y = prepped_indicators_wijk, by= "wijk_code_six_digits") #merge wijk indicators with the previous merge between score and buurt indicators

#MERGE GEMEENTE INDICATORS (LEVEL 4) WITH SCORE DATA CONTAINING LEVEL 2 & 3 INDICATORS (BUURT & WIJK) 
complete_merge <- merge(x = incomplete_merge, y = prepped_indicators_gemeente, by= "gemeente_code_four_digits", all.x = TRUE) #merge wijk indicators with the previous merge between score and buurt indicators

write.csv(complete_merge,"./Data/merged_data/complete_merge.csv")


#--------------------------------------------------------------------------------------------------------------------------------------------------------
