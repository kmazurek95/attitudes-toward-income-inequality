


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

rm(list=ls())

setwd("C:/Users/kaleb/OneDrive/Documents")



score <- read_dta("C:/Users/kaleb/OneDrive/Documents/score.dta")

#write.csv(score,"C:/Users/kaleb/OneDrive/Documents/score.csv", row.names = FALSE)


#------------------------------------------------------------------------------

#Subset data based on how long the codes are (maybe delete NAs)
#------------------------------------------------------------------------------

score1000 <- score[score$Buurtcode > 1000 & score$Buurtcode < 10000,] #these have four digits but all are NA 

#------------------------------------------------------------------------------

score10000 <- score[score$Buurtcode > 10000 & score$Buurtcode < 100000,] #these have five digits
score10000$buurt_code_eight_digits <- paste0("000", score10000$Buurtcode) #put three zeros in front of the code in order for it to be eight digits (buurtcode)

score10000$wijk_code_six_digits <- substr(score10000$buurt_code_eight_digits,1,nchar(score10000$buurt_code_eight_digits)-2)
score10000$gemeente_code_four_digits <- substr(score10000$buurt_code_eight_digits,1,nchar(score10000$buurt_code_eight_digits)-4)

#These Buurtcodes are now eight digits and can be brocken down into their respecive smaller parts

#write.csv(score10000,"C:/Users/kaleb/OneDrive/Documents/score_buurt_five_digits.csv", row.names = FALSE)

#------------------------------------------------------------------------------
#SIX DIGITS

score100000 <- score[score$Buurtcode > 100000 & score$Buurtcode < 1000000,] #these have six digits
score100000$buurt_code_eight_digits <- paste0("00", score100000$Buurtcode) #put two zeros in front of the code in order for it to be eight digits (buurtcode)

score100000$wijk_code_six_digits <- substr(score100000$buurt_code_eight_digits,1,nchar(score100000$buurt_code_eight_digits)-2)
score100000$gemeente_code_four_digits <- substr(score100000$buurt_code_eight_digits,1,nchar(score100000$buurt_code_eight_digits)-4)

#write.csv(score100000,"C:/Users/kaleb/OneDrive/Documents/score_buurt_six_digits.csv", row.names = FALSE)

#WAIT ON TURNING THEM INTO WIJKS, GET THEM INTO BUURT FIRST


#score100000$Buurtcode_eight <- as.character(score100000$Buurtcode) #turn the buurtcode into a character 
#score100000$Buurtcode_eight <- substr(score100000$Buurtcode_eight,1,nchar(score100000$Buurtcode_eight)-2) #remove the last digit from the code in order to get a six digit wijk 
#score100000$Buurtcode_eight <- as.numeric(score100000$Buurtcode_eight) #turn it back into a number
#score100000$Buurtcode_eight <- paste0("00", score100000$Buurtcode_eight) #put three zeros in front of the code in order for it to be eight digits (buurtcode)


#------------------------------------------------------------------------------
#SEVEN DIGITS

score1000000 <- score[score$Buurtcode > 1000000 & score$Buurtcode < 10000000,] #these have seven digits
score1000000$buurt_code_eight_digits <- paste0("0", score1000000$Buurtcode) #put one zero in front of the code in order for it to be eight digits (buurtcode)

score1000000$wijk_code_six_digits <- substr(score1000000$buurt_code_eight_digits,1,nchar(score1000000$buurt_code_eight_digits)-2)
score1000000$gemeente_code_four_digits <- substr(score1000000$buurt_code_eight_digits,1,nchar(score1000000$buurt_code_eight_digits)-4)
#WAIT ON TURNING THEM INTO WIJKS, GET THEM INTO BUURT FIRST

#score1000000$Buurtcode_five <- as.character(score1000000$Buurtcode) #turn the buurtcode into a character 
#score1000000$Buurtcode_five <- substr(score1000000$Buurtcode_five,1,nchar(score1000000$Buurtcode_five)-1) #remove the last digit from the code in order to get a six digit wijk 
#score1000000$Buurtcode_five <- as.numeric(score1000000$Buurtcode_five) #turn it back into a number

#-----------------------------------------------------------------------------------------------------
score10000000 <- score[score$Buurtcode > 10000000 & score$Buurtcode < 100000000,] #eight digits and fine the way they are
score10000000$buurt_code_eight_digits <- paste0("", score10000000$Buurtcode) #put one zero in front of the code in order for it to be eight digits (buurtcode)

score10000000$wijk_code_six_digits <- substr(score10000000$buurt_code_eight_digits,1,nchar(score10000000$buurt_code_eight_digits)-2)
score10000000$gemeente_code_four_digits <- substr(score10000000$buurt_code_eight_digits,1,nchar(score10000000$buurt_code_eight_digits)-4)

#WAIT ON TURNING THEM INTO WIJKS, GET THEM INTO BUURT FIRST
#score10000000$Buurtcode_five <- as.character(score10000000$Buurtcode) #turn the buurtcode into a character 
#score10000000$Buurtcode_five <- substr(score10000000$Buurtcode_five,1,nchar(score10000000$Buurtcode_five)-3) #remove the last digit from the code in order to get a wijk 
#score10000000$Buurtcode_five <- as.numeric(score10000000$Buurtcode_five) #turn it back into a number

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

hist(score_final$a27_2)

#-------------------------------------------
#------------------NEXT STEPS---------------
# (1) rename variables in score and change the labels (2) import indicators into r and break it up and proccess it in r instead of in Excel (3) drop NA's
# (4) figure out which obervations are being dropped and why (5) Try Merging in STATA in order to see which observations are not merging




# what you need to do is add a zero(s) to the front of burtcodes that are less than six digits, so we need to add. To get the wijk code from the beert, takeoff
# the last two digits of the beert code. To get the the Gemeentecode (city), drop the last four numbers
#Wijk code is six numbers not 5
#Buurtcode = Gemeentecode (4) + wijkcode (2) + buurtcode (2) 

#https://www.cbs.nl/nl-nl/longread/aanvullende-statistische-diensten/2021/toelichting-wijk-en-buurtkaart-2021?onepage=true 

