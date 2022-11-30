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

install.packages(expss)
#------------------------------------------------------------------------------
#rm(list=ls())

setwd("C:/Users/kaleb/OneDrive/Documents")

score <- read_dta("C:/Users/kaleb/OneDrive/Documents/score.dta")

# write.csv(score,"C:/Users/kaleb/OneDrive/Documents/score.csv", row.names = FALSE), examine in excel 


#------------------------------------------------------------------------------

#CORRECT BUURTCODES SO INDICATORS CAN BE MERGED ON BEERT, WIJK, and GEMEENTE 



#The issue with the score dataset is that the buurtcodes are not all eight-digits (this is happening because some of the buurtcodes do not have the leading zeros
# and this is necessary in order to create a eight digit buurtcode). To achieve this, we subset the score dataset by the number of digits in the incomplete buurtcodes.
# All the buurtcodes with five digits are NAs so we do not do anything with them. The buurtcodes with five digits get three leading zeros. The buurtcodes with siz digits 
# get two leading zeros. The buurtcodes with seven digits get get one leading zero. The buurtcodes with eight digits get no leading zeros because they are alreeady eight
# digits. Once all buurtcodes have eight digits, we subtract the last two digits from each buurtcode to get the wijk code and we subtract the last four digits to get the 
# gemeente code. Once all leading zeros are added and wijk and gemeente codes are generated, we add four sub data frames back together to re-create a complete dataset with
# all observations.

#Buurtcode = Gemeentecode (4) + wijkcode (2) + buurtcode (2)

#https://www.cbs.nl/nl-nl/longread/aanvullende-statistische-diensten/2021/toelichting-wijk-en-buurtkaart-2021?onepage=true 


#-------------------------------------------
#------------------NEXT STEPS---------------
# (1) change the labels  (3) drop NA's
# (4) figure out which observations are being dropped and why (5) Try Merging in STATA in order to see which observations are not merging


#------------------------------------------------------------------------------

score1000 <- score[score$Buurtcode > 1000 & score$Buurtcode < 10000,] #these have four digits but all are NA 

#------------------------------------------------------------------------------

score10000 <- score[score$Buurtcode > 10000 & score$Buurtcode < 100000,] #these have five digits
score10000$buurt_code_eight_digits <- paste0("000", score10000$Buurtcode) #put three zeros in front of the code in order for it to be eight digits (buurtcode)

score10000$wijk_code_six_digits <- substr(score10000$buurt_code_eight_digits,1,nchar(score10000$buurt_code_eight_digits)-2)
score10000$gemeente_code_four_digits <- substr(score10000$buurt_code_eight_digits,1,nchar(score10000$buurt_code_eight_digits)-4)

#------------------------------------------------------------------------------
#SIX DIGITS

score100000 <- score[score$Buurtcode > 100000 & score$Buurtcode < 1000000,] #these have six digits
score100000$buurt_code_eight_digits <- paste0("00", score100000$Buurtcode) #put two zeros in front of the code in order for it to be eight digits (buurtcode)

score100000$wijk_code_six_digits <- substr(score100000$buurt_code_eight_digits,1,nchar(score100000$buurt_code_eight_digits)-2)
score100000$gemeente_code_four_digits <- substr(score100000$buurt_code_eight_digits,1,nchar(score100000$buurt_code_eight_digits)-4)


#------------------------------------------------------------------------------
#SEVEN DIGITS

score1000000 <- score[score$Buurtcode > 1000000 & score$Buurtcode < 10000000,] #these have seven digits
score1000000$buurt_code_eight_digits <- paste0("0", score1000000$Buurtcode) #put one zero in front of the code in order for it to be eight digits (buurtcode)

score1000000$wijk_code_six_digits <- substr(score1000000$buurt_code_eight_digits,1,nchar(score1000000$buurt_code_eight_digits)-2)
score1000000$gemeente_code_four_digits <- substr(score1000000$buurt_code_eight_digits,1,nchar(score1000000$buurt_code_eight_digits)-4)


#-----------------------------------------------------------------------------------------------------
#EIGHT DIGITS

score10000000 <- score[score$Buurtcode > 10000000 & score$Buurtcode < 100000000,] #eight digits and fine the way they are
score10000000$buurt_code_eight_digits <- paste0("", score10000000$Buurtcode) #put one zero in front of the code in order for it to be eight digits (buurtcode)

score10000000$wijk_code_six_digits <- substr(score10000000$buurt_code_eight_digits,1,nchar(score10000000$buurt_code_eight_digits)-2)
score10000000$gemeente_code_four_digits <- substr(score10000000$buurt_code_eight_digits,1,nchar(score10000000$buurt_code_eight_digits)-4)



#------------------------------------------------------------------------------------------------------

score100000000 <- score[score$Buurtcode > 100000000 & score$Buurtcode < 1000000000,] #no values

#------------------------------------------------------------------------------------------------------

total <- rbind(score10000, score100000, score1000000, score10000000) #why is the total more? (because of NAs)


keeps <- c("a27_1","a27_2", "a27_3", "b01", "b02", "b03", "b04", "b05", "b06", "b07", "b08", "b09",
           "b10", "b11", "b12_1", "b13", "b14_1", "b14_2", "b14_3", "b14_4", "b14_5", "b15", "b16", "b17", "b18", "b19", "b20", "b21", "b22",
           "GENDERID", "weegfac", "Buurtcode", "buurt_code_eight_digits", "wijk_code_six_digits", "gemeente_code_four_digits", "respnr")

# rm(keeps)

score_final <- total[keeps]

describe(score_final)

names(score_final)[1] <- "a27_1_government_intervention_into_the_economy" # 1-fully disagree  7-fully agree
names(score_final)[2] <- "a27_2_reduce_differences_in_income_levels" # 1-fully disagree  7-fully agree
names(score_final)[3] <- "a27_3_Employees_need_strong_trade_unions" # 1-fully disagree  7-fully agree
names(score_final)[4] <- "b01_sex"
names(score_final)[5] <- "b02_birth_year"
names(score_final)[6] <- "b03_highest_level_of_education "
names(score_final)[7] <- "b04_years_of_education"
names(score_final)[8] <- "b05_vote_in_the_last_parliamentary_elections_2017?"
names(score_final)[9] <- "b06_party_voted_for"
names(score_final)[10] <- "b07_employment_status"
names(score_final)[11] <- "b08_completed_paid_work_ever"
names(score_final)[12] <- "b09_salaried_or_self_employed_or_family_business"
names(score_final)[13] <- "b10_type_of_organization"
names(score_final)[14] <- "b11_leadership_responsability"
names(score_final)[15] <- "b12_1_how_many_people_responsible_for"
names(score_final)[16] <- "b13_description_current_previous_job?"
names(score_final)[17] <- "b14_1_home_ownership"
names(score_final)[18] <- "b14_2_other_realestate_ownership"
names(score_final)[19] <- "b14_3_savings_account_ownership"
names(score_final)[20] <- "b14_4_stock_or_bonds_ownership"
names(score_final)[21] <- "b14_5_no_ownership"
names(score_final)[22] <- "b15_member_of_a_faith_denomination"
names(score_final)[23] <- "b16_type_of_faith_denomination"
names(score_final)[24] <- "b17_religiosity"
names(score_final)[25] <- "b18_frequency_of_attendance_religious_service"
names(score_final)[26] <- "b19_apart_religious_services_frequency_of_prayer"
names(score_final)[27] <- "b20_born_in_netherlands"
names(score_final)[28] <- "b21_father_born_in_netherlands"
names(score_final)[29] <- "b22_mother_born_in_netherlands"
names(score_final)[30] <- "GENDERID"
names(score_final)[31] <- "Weegfactor"
names(score_final)[32] <- "Buurtcode"
names(score_final)[33] <- "buurt_code_eight_digits"
names(score_final)[34] <- "wijk_code_six_digits"
names(score_final)[35] <- "gemeente_code_four_digits"
names(score_final)[36] <- "respondent_number"



hist(score_final$a27_1_government_intervention_into_the_economy)



