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
# (1) rename variables in score and change the labels  (3) drop NA's
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

total$buurt_code_eight_digits

keeps <- c("a27_1","a27_2", "a27_3", "b01", "b02", "b03", "b04", "b05", "b06", "b07", "b08", "b09",
           "b10", "b11", "b12_1", "b13", "b14_1", "b14_2", "b14_3", "b14_4", "b14_5", "b15", "b16", "b17", "b18", "b19", "b20", "b21", "b22",
           "GENDERID", "weegfac", "Buurtcode", "buurt_code_eight_digits", "wijk_code_six_digits", "gemeente_code_four_digits")

# rm(keeps)

score_final <- total[keeps]

var_lab(score_final)[1]
names(score_final)[1] <- "government_intervention_into_the_economy" # 1-fully disagree  7-fully agree
names(score_final)[2] <- "reduce differences in income levels" # 1-fully disagree  7-fully agree
names(score_final)[3] <- "Employees need strong trade unions" # 1-fully disagree  7-fully agree
names(score_final)[4] <- "sex"
names(score_final)[5] <- "birthyear"
names(score_final)[6] <- "highest level of education "
names(score_final)[7] <- "years of education"
names(score_final)[8] <- "employment_status"
names(score_final)[9] <- "paid_work"
names(score_final)[10] <- "type_of_employee"
names(score_final)[11] <- "employment_organization_type"
names(score_final)[12] <- "responsibility for supervising"
names(score_final)[13] <- "numbeer_of_people_responsible_for"
names(score_final)[14] <- "prfession"
names(score_final)[15] <- "asset_ownership_type"
names(score_final)[16] <- 
names(score_final)[17] <-
names(score_final)[18] <-
names(score_final)[19] <-
names(score_final)[20] <-
names(score_final)[21] <-
names(score_final)[22] <-
names(score_final)[23] <-
names(score_final)[24] <-
names(score_final)[25] <-
names(score_final)[26] <-
names(score_final)[27] <-
names(score_final)[28] <-
names(score_final)[29] <-
names(score_final)[30] <-

names(score_final)[1] 
names(score_final)[2] 
names(score_final)[3] 
names(score_final)[4] 
names(score_final)[5] 
names(score_final)[6] 
names(score_final)[7] 
names(score_final)[8] 
names(score_final)[9] 
names(score_final)[10] 
names(score_final)[11] 
names(score_final)[12] 
names(score_final)[13] 
names(score_final)[14] 
names(score_final)[15] 
names(score_final)[16]
names(score_final)[17]
names(score_final)[18] 
names(score_final)[19] 
names(score_final)[20] 
names(score_final)[21] 
names(score_final)[22] 
names(score_final)[23] 
names(score_final)[24] 
names(score_final)[25] 
names(score_final)[26] 
names(score_final)[27] 
names(score_final)[28]
names(score_final)[29] 
names(score_final)[30]  
names(score_final)[31]
names(score_final)[32]
names(score_final)[33]
names(score_final)[34]
names(score_final)[35]
  
#score_final <- na.omit(score_final)
#score_final[complete.cases(score_final)[ , 1:2],]

hist(score_final$a27_2)



