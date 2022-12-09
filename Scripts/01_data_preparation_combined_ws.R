# Load packages
library(haven)
library(tidyverse) 

# clear working environment
rm(list=ls())

#-------------------------------------------------------------------------------
# PART 1 - SURVEY DATA (SCORE) PREPARATION
#-------------------------------------------------------------------------------

# Load data from the R Project folder

score <- read_dta("./Data/score.dta")
score <- as.data.frame(`score`)

# We add leading zeros to the existing neighborhood code variable ("Buurtcode")
# so it can be merged with administrative data (see below). We truncate the
# resulting variable to create codes for the district ("wijk") and municipality
# ("gemeente"), again to facilitate merging.

score <- score %>%
  mutate(buurt_code_eight_digits = case_when(
  Buurtcode > 9999 & Buurtcode < 100000 ~ paste0("000", Buurtcode),
  Buurtcode > 99999 & Buurtcode < 1000000 ~ paste0("00", Buurtcode),
  Buurtcode > 999999 & Buurtcode < 10000000 ~ paste0("0", Buurtcode),
  Buurtcode > 9999999 ~ paste0(Buurtcode)))

score$wijk_code_six_digits <- substr(score$buurt_code_eight_digits, 1, 6)
score$gemeente_code_four_digits <- substr(score$buurt_code_eight_digits, 1, 4)

# We only keep the variables we need for the analysis

score_final <- score %>%
  select(a27_1,a27_2, a27_3, b01, b02, b03, b04, b05, b06, b07, b08, b09, b10,
         b11, b12_1, b13, b14_1, b14_2, b14_3, b14_4, b14_5, b15, b16, b17, b18,
         b19, b20, b21, b22, GENDERID, weegfac, Buurtcode,
         buurt_code_eight_digits, wijk_code_six_digits,
         gemeente_code_four_digits, respnr)

# Change the names of the variables

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

#-------------------------------------------------------------------------------
# PART 2 - ADMINISTRATIVE DATA PREPARATION
#-------------------------------------------------------------------------------

# Load data

ind_bwg <- read_csv("./Data/indicators_buurt_wijk_gemeente.csv", na = ".")
ind_bwg <- as.data.frame(`ind_bwg`)

# Translate the variable names into English

names(ind_bwg)[1] <- "id"
names(ind_bwg)[2] <- "district_and_neighborhood"
names(ind_bwg)[3] <- "municipality"
names(ind_bwg)[4] <- "type_region"
names(ind_bwg)[5] <- "code"
names(ind_bwg)[6] <- "change_in_layout"
names(ind_bwg)[7] <- "number_of_inhabitants"
names(ind_bwg)[8] <- "n_Sixty_Five_Years_Or_Older"
names(ind_bwg)[9] <- "WesternTotal"
names(ind_bwg)[10] <- "Non_Western_Total"
names(ind_bwg)[11] <- "Morocco"
names(ind_bwg)[12] <- "Turkey"
names(ind_bwg)[13] <- "Population_Density"
names(ind_bwg)[14] <- "Average_Home_Value"
names(ind_bwg)[15] <- "Average_Income_Per_Income_Recipient"
names(ind_bwg)[16] <- "Average_Income_Per_Inhabitant"
names(ind_bwg)[17] <- "40_Lowest_Income_People"
names(ind_bwg)[18] <- "20_Persons_With_Highest_Income"
names(ind_bwg)[19] <- "40_Lowest_Income_Households"
names(ind_bwg)[20] <- "20_Households_With_Highest_Income"
names(ind_bwg)[21] <- "low_income_households" 
names(ind_bwg)[22] <- "Household_Under_Or_Around_Social_Minimum"

# Subset the indicators into their three levels (Buurt, Wijk, and Gemeente)

ind_bu <- ind_bwg[ind_bwg$type_region=="Buurt",]
ind_wi <- ind_bwg[ind_bwg$type_region=="Wijk",]
ind_ge <- ind_bwg[ind_bwg$type_region=="Gemeente",]

# Name the indicators so we know which region they are measured at

colnames(ind_bu) <- paste0("buurt_", colnames(ind_bu))
colnames(ind_wi) <- paste0("wijk_", colnames(ind_wi))
colnames(ind_ge) <- paste0("gemeente_", colnames(ind_ge))

# The buurt, wijk, and gemeente codes all start with two letters, which we
# remove to match them with the survey data

ind_bu$buurt_code_eight_digits <- substr(ind_bu$buurt_code, 3, 10)
ind_wi$wijk_code_six_digits <- substr(ind_wi$wijk_code, 3, 8)
ind_ge$gemeente_code_four_digits <- substr(ind_ge$gemeente_code, 3, 6)

#-------------------------------------------------------------------------------
# PART 3 - MERGING SURVEY AND ADMINISTRATIVE DATA
#-------------------------------------------------------------------------------

# Adding in neighborhood data
merge_temp1 <- merge(x = score_final, y = ind_bu,
                    by = "buurt_code_eight_digits", all.x = TRUE)

# Adding in district data
merge_temp2 <- merge(x = merge_temp1, y = ind_wi,
                    by = "wijk_code_six_digits", all.x = TRUE)

# Adding in municipality data
complete_merge <- merge(x = merge_temp2, y = ind_ge,
                        by = "gemeente_code_four_digits", all.x = TRUE)

# Removing temporary data frames
rm(list=ls()[! ls() %in% c("complete_merge")])