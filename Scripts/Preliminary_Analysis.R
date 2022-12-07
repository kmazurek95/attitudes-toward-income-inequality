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


data_all_levels <- read_csv("C:/Users/kaleb/OneDrive/Desktop/attitudes-toward-income-inequality/raw_data/processed_score_data/complete_merge.csv")
data_all_levels <- as.data.frame(`data_all_levels`)

data_all_levels <- data_all_levels[!is.na(data_all_levels$a27_2_reduce_differences_in_income_levels),]

describe(data_all_levels)

#QUESTIONS 
# (1) does it even make sense to do a correlation between a level one and level two variable

#---------------------------------------------------------------------------------------------------------
# SCATTER PLOT gemeente_40_Lowest_Income_Households VS a27_2_reduce_differences_in_income_levels

plot(data_all_levels$gemeente_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, main="Scatterplot Example",
     xlab="gemeente_40_Lowest_Income_People", ylab="reduce_differences_in_income", pch=19)

#---------------------------------------------------------------------------------------------------------
# Correlation between DV and 40_Lowest_Income_Households (Buurt)

describe(data_all_levels$buurt_40_Lowest_Income_Households) #Not numeric so we need to convert below 
data_all_levels$buurt_40_Lowest_Income_Households <- as.numeric(data_all_levels$buurt_40_Lowest_Income_Households)
describe(data_all_levels$buurt_40_Lowest_Income_Households) #check that it is now numeric



#WHY DOES THIS PRODUCE NA
cor(data_all_levels$buurt_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, method=c("pearson", "kendall", "spearman"))

#WHY DOES THIS ONE PRODUCE A CORRELATION
cor.test(data_all_levels$buurt_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, method=c("pearson", "kendall", "spearman"))

#---------------------------------------------------------------------------------------------------------
# Correlation between DV and 40_Lowest_Income_Households (wijk)

describe(data_all_levels$wijk_40_Lowest_Income_Households) #allready numeric, no need to convert 


#WHY DOES THIS PRODUCE NA
cor(data_all_levels$wijk_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, method=c("pearson", "kendall", "spearman"))

#WHY DOES THIS ONE PRODUCE A CORRELATION
cor.test(data_all_levels$wijk_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, method=c("pearson", "kendall", "spearman"))

#-----------------------------------------------------------------------------------------------------------
# Correlation between DV and 40_Lowest_Income_Households (Gemeente)

cor(data_all_levels$gemeente_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, method = c("pearson", "kendall", "spearman"))

cor.test(data_all_levels$gemeente_40_Lowest_Income_Households, data_all_levels$a27_2_reduce_differences_in_income_levels, method=c("pearson", "kendall", "spearman"))
