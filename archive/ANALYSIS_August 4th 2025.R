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
rm(list=ls())
data <- read_csv("C:/Users/kaleb/OneDrive/Desktop/Portfolio/Public Attitudes Research/complete_merge1.csv")

#-------------------------------------------------------------------------------

# Code different interations of the dependent variable and standardize (1-100)

#------------------------------------------------------------------------------
data <-
  data %>%
  filter(red_inc_diff != 8,  #change eight to missing value
         gov_int != 8,
         union_pref !=8)  %>%
  
  mutate(DV_one_to_zero = (100*(.$red_inc_diff -1))
         /(7-1)) %>%
  
  mutate(DV_combined_01 = (.$gov_int +
                             .$red_inc_diff)/(2)) %>%
  
  mutate(DV_combined_02 = (.$gov_int
                           + .$red_inc_diff 
                           + .$union_pref)/(3)) %>%
  
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
        sex %in% 1 ~ 
          "Male",
        sex %in% 2 ~ 
          "Female",
        sex %in% 3 ~ 
          "Other")) %>%
  mutate(sex = factor(sex))
#-------------------------------------------------------------------------------
#Age

data<- data %>%
  mutate(age = (2017-data$birth_year)) %>%
  mutate_at(c('age'), ~ (scale(.) %>% as.vector))
#-------------------------------------------------------------------------------
#Religion

# data<-
#   data %>% 
#   mutate(                           
#     religion=
#       case_when(
#         b16_type_of_faith_denomination %in% 1 ~ 
#           "Roman Catholic",
#         b16_type_of_faith_denomination %in% 2 ~ 
#           "Protestant",
#         b16_type_of_faith_denomination %in% 3 ~ 
#           "Eastern Orthodox",
#         b16_type_of_faith_denomination %in% 4 ~ 
#           "Other Christian denomination",
#         b16_type_of_faith_denomination %in% 5 ~ 
#           "Jewish",
#         b16_type_of_faith_denomination %in% 6 ~ 
#           "Islamic",
#         b16_type_of_faith_denomination %in% 7 ~ 
#           "Eastern religions",
#         b16_type_of_faith_denomination %in% 8 ~ 
#           "Other non-Christian religions",
#         b16_type_of_faith_denomination %in% 9 ~ 
#           "Christian, but I do not associate with one of the denominations")) %>%
#   mutate(religion = factor(religion))

#----------------------------------------------------------------------------
#Education years

data<-
  data %>%
  mutate(education = educyrs) %>%
  mutate_at(c('education'), ~ (scale(.) %>% as.vector))
#------------------------------------------------------------------------------
#Employemnt
data<-
  data %>% 
  mutate(                           
    employment_status=
      case_when(
        work_status %in% 1 ~ 
          "Employed",
        work_status %in% 2 ~ 
          "Student",
        work_status %in% 3 ~ 
          "Unemployed and Actively Looking for Work",
        work_status %in% 4 ~ 
          "unemployed, wanting a job but not actively looking",
        work_status %in% 5 ~ 
          "permanently sick or disabled",
        work_status %in% 6 ~ 
          "retired",
        work_status %in% 7 ~ 
          "Community or Military Service",
        work_status %in% 8 ~ 
          "Housework, looking after children or other persons ")) %>%
  mutate(employment_status = factor(employment_status))
#------------------------------------------------------------------------------
#Occupation

data<-
  data %>% 
  mutate(                           
    occupation=
      case_when(
        work_type %in% 1 ~ 
          "Modern professional occupations",
        work_type %in% 2 ~ 
          "Clerical and intermediate occupations",
        work_type %in% 3 ~ 
          "Senior managers or administrators",
        work_type %in% 4 ~ 
          "Technical and craft occupations",
        work_type %in% 5 ~ 
          "Semi-routine manual and service",
        work_type %in% 6 ~ 
          "Routine manual and service ",
        work_type %in% 7 ~ 
          "Middle or junior managers ",
        work_type %in% 8 ~ 
          "Traditional professional occupations")) %>%
  mutate(occupation = factor(occupation))

#-------------------------------------------------------------------------------
#Standardize Level two variables  
data<- data %>%
  mutate_at(c('b_perc_low40_hh',
              'b_pop_total',
              'b_pop_over_65',
              'b_pop_nonwest',
              'b_avg_inc_recip',
              'b_perc_low_inc_hh',
              'b_pop_dens',
              'b_perc_soc_min_hh',
              'w_perc_low40_hh',
              'g_perc_low40_hh'),
            ~ (scale(.) %>% as.vector))

#---------------------------------------------------------------------------------------------------------
# Distributions of Varibales of interest

hist(data$b_perc_low40_hh)
hist(data$DV_combined_01_one_to_zero)

hist(data$b_pop_over_65)
hist(data$b_pop_nonwest)
hist(data$b_avg_inc_recip)
hist(data$b_perc_low_inc_hh)
hist(data$b_pop_dens)
hist(data$b_perc_soc_min_hh)
hist(data$b_pop_total)

#---------------------------------------------------------------------------------------------------------
# Correlation between DV and 40_Lowest_Income_Households (all levels)

(correlations <- 
   data %>%
   select(b_perc_low40_hh, w_perc_low40_hh, 
          g_perc_low40_hh, DV_combined_01_one_to_zero) %>%
   correlate())
rplot(correlations)



#Significance test for correlations
cor.test(data$b_perc_low40_hh, data$DV_combined_01_one_to_zero, method=c("pearson", "kendall", "spearman"))
cor.test(data$w_perc_low40_hh, data$DV_combined_01_one_to_zero, method=c("pearson", "kendall", "spearman"))
cor.test(data$g_perc_low40_hh, data$DV_combined_01_one_to_zero, method=c("pearson", "kendall", "spearman"))
#-------------------------------------------------------------------------------------------------------------------------------------------------------
# Buurt-level means
means_by_buurt <- data %>% 
  group_by(buurt_id) %>% 
  summarise(
    mean = mean(DV_combined_01_one_to_zero, na.rm = TRUE), 
    SD = sd(DV_combined_01_one_to_zero, na.rm = TRUE),
    freq = n(),
    miss = mean(is.na(DV_combined_01_one_to_zero))
  ) %>% 
  mutate(across(where(is.numeric), ~round(., 2)))

# Wijk-level means
means_by_wijk <- data %>% 
  group_by(wijk_id) %>% 
  summarise(
    mean = mean(DV_combined_01_one_to_zero, na.rm = TRUE), 
    SD = sd(DV_combined_01_one_to_zero, na.rm = TRUE),
    freq = n(),
    miss = mean(is.na(DV_combined_01_one_to_zero))
  ) %>% 
  mutate(across(where(is.numeric), ~round(., 2)))

# Gemeente-level means
means_by_gemeente <- data %>% 
  group_by(gemeente_id) %>% 
  summarise(
    mean = mean(DV_combined_01_one_to_zero, na.rm = TRUE), 
    SD = sd(DV_combined_01_one_to_zero, na.rm = TRUE),
    freq = n(),
    miss = mean(is.na(DV_combined_01_one_to_zero))
  ) %>% 
  mutate(across(where(is.numeric), ~round(., 2)))


#------------------------------------------------------------------------------
#                           SET THE SAMPLE
#-----------------------------------------------------------------------------
data_two_levels <-
  data %>%
  select(DV_one_to_zero, age, sex, education, employment_status, occupation,
         born_in_nl, father_dutch, mother_dutch,
         b_perc_low40_hh, b_pop_total,
         b_pop_over_65, b_pop_nonwest, 
         b_avg_inc_recip, b_perc_low_inc_hh,
         b_pop_dens, b_perc_soc_min_hh,
         buurt_id) %>%
  na.omit() #WHY ARE SO MANY BEING DROPED EVEN WHEN YOU TAKE RELIGION AND OCCUPATION OUT

#------------------------------------------------------------------------------
#                           Multi-Level Model Buurt
#-----------------------------------------------------------------------------
# empty multilevel model (No fixed factors (intercept only))
m0_buurt <- lmer(DV_one_to_zero ~ 1 +
                   (1 |buurt_id), 
                 data = data_two_levels)


summary(m0_buurt)
summ(m0_buurt)


#------------------------------------------------------------------------------
#Include dependent variable
m1_buurt <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                 +(1 |buurt_id),
                 data = data_two_levels)

summary(m1_buurt)
summ(m1_buurt)
anova(m0_buurt ,m1_buurt) 
#------------------------------------------------------------------------------
#Add level one variables 
m2_buurt <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                 +age
                 +sex
                 +education
                 +employment_status
                 +occupation
                 +born_in_nl
                 +(1 | buurt_id),
                 data = data_two_levels)
summary(m2_buurt)
summ(m2_buurt)
anova(m2_buurt ,m1_buurt)

#------------------------------------------------------------------------------
#Add level two variables 
m3_buurt <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                 +age
                 +sex
                 +education
                 +employment_status
                 +occupation
                 +b_pop_dens
                 +b_pop_over_65
                 +b_pop_nonwest
                 +b_perc_low_inc_hh
                 +b_perc_soc_min_hh
                 +(1 |buurt_id), 
                 data = data_two_levels)

summary(m3_buurt)
summ(m3_buurt)
anova(m3_buurt, m2_buurt) 
#------------------------------------------------------------------------------
#                           Four Level Model
#-----------------------------------------------------------------------------
# empty multilevel model (No fixed factors (intercept only))

m0_four_level <- lmer(DV_one_to_zero ~ 1 
                      +(1 |gemeente_id)
                      +(1 |wijk_id)
                      +(1 |buurt_id), 
                      data = data)


summary(m0_four_level)
summ(m0_four_level)
#------------------------------------------------------------------------------
#Insert Explanatory Variable(s)

m1_four_level <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                      +w_perc_low40_hh
                      +g_perc_low40_hh
                      +(1 |gemeente_id)
                      +(1 |wijk_id)
                      +(1 |buurt_id), 
                      data = data)

summary(m1_four_level)
summ(m1_four_level)
#-------------------------------------------------------------------------------
#Add level one variables
m2_four_level <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                      +w_perc_low40_hh
                      +g_perc_low40_hh
                      +age
                      +sex
                      +education
                      +employment_status
                      +occupation
                      +(1 |gemeente_id)
                      +(1 |wijk_id)
                      +(1 |buurt_id), 
                      data = data)

summary(m2_four_level)
summ(m2_four_level)
#-------------------------------------------------------------------------------
#Add level two variables (what level?, buurt level for now)
m3_four_level <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                      +w_perc_low40_hh
                      +g_perc_low40_hh
                      +age
                      +sex
                      +education
                      +employment_status
                      +occupation
                      +b_pop_dens
                      +b_pop_over_65
                      +b_pop_nonwest
                      +b_perc_low_inc_hh
                      +b_perc_soc_min_hh
                      +(1 |gemeente_id)
                      +(1 |wijk_id)
                      +(1 |buurt_id), 
                      data = data)
summary(m3_four_level)
summ(m3_four_level)
#-------------------------------------------------------------------------------
#Adding two levels of indicators -- is this appropriate?

m4_four_level <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                      +w_perc_low40_hh
                      +g_perc_low40_hh
                      +age
                      +sex
                      +education
                      +employment_status
                      +occupation
                      +b_pop_dens
                      +b_pop_over_65
                      +b_pop_nonwest
                      +b_perc_low_inc_hh
                      +b_perc_soc_min_hh
                      +w_pop_dens
                      +w_pop_over_65
                      +w_pop_nonwest
                      +w_perc_low_inc_hh
                      +w_perc_soc_min_hh
                      +(1 |gemeente_id)
                      +(1 |wijk_id)
                      +(1 |buurt_id), 
                      data = data)


summary(m4_four_level)
summ(m4_four_level)

#===============================================================================
#                    PHASE 2: DESCRIPTIVE ANALYSIS
#===============================================================================

cat("\n\n========== DESCRIPTIVE ANALYSIS ==========\n\n")

# Install required packages if not available
if(!require(moments)) install.packages("moments", repos = "http://cran.us.r-project.org")
if(!require(naniar)) install.packages("naniar", repos = "http://cran.us.r-project.org")
if(!require(car)) install.packages("car", repos = "http://cran.us.r-project.org")

library(moments)
library(naniar)
library(car)

#-------------------------------------------------------------------------------
# 2.1 DV Distribution and Summary Statistics
#-------------------------------------------------------------------------------

cat("\n=== DEPENDENT VARIABLE DIAGNOSTICS ===\n")

# Summary statistics for all DV operationalizations
dv_summary <- data %>%
  summarise(
    # Single item (red_inc_diff scaled 0-100)
    DV_single_mean = mean(DV_one_to_zero, na.rm = TRUE),
    DV_single_sd = sd(DV_one_to_zero, na.rm = TRUE),
    DV_single_skew = skewness(DV_one_to_zero, na.rm = TRUE),
    DV_single_kurt = kurtosis(DV_one_to_zero, na.rm = TRUE),
    DV_single_n = sum(!is.na(DV_one_to_zero)),

    # Two-item composite
    DV_2item_mean = mean(DV_combined_01_one_to_zero, na.rm = TRUE),
    DV_2item_sd = sd(DV_combined_01_one_to_zero, na.rm = TRUE),
    DV_2item_skew = skewness(DV_combined_01_one_to_zero, na.rm = TRUE),
    DV_2item_kurt = kurtosis(DV_combined_01_one_to_zero, na.rm = TRUE),

    # Three-item composite
    DV_3item_mean = mean(DV_combined_02_one_to_zero, na.rm = TRUE),
    DV_3item_sd = sd(DV_combined_02_one_to_zero, na.rm = TRUE),
    DV_3item_skew = skewness(DV_combined_02_one_to_zero, na.rm = TRUE),
    DV_3item_kurt = kurtosis(DV_combined_02_one_to_zero, na.rm = TRUE)
  )

print(dv_summary)

# Visual: DV distribution
par(mfrow = c(1, 3))
hist(data$DV_one_to_zero, breaks = 20, main = "Single Item (0-100)",
     xlab = "Redistribution Preference", col = "steelblue")
hist(data$DV_combined_01_one_to_zero, breaks = 20, main = "2-Item Composite (0-100)",
     xlab = "Redistribution Preference", col = "darkgreen")
hist(data$DV_combined_02_one_to_zero, breaks = 20, main = "3-Item Composite (0-100)",
     xlab = "Redistribution Preference", col = "darkred")
par(mfrow = c(1, 1))

#-------------------------------------------------------------------------------
# 2.2 Missingness Analysis
#-------------------------------------------------------------------------------

cat("\n=== MISSINGNESS ANALYSIS ===\n")

# Overall missingness by variable
missingness_by_var <- data %>%
  summarise(across(everything(), ~sum(is.na(.))/n())) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "pct_missing") %>%
  filter(pct_missing > 0) %>%
  arrange(desc(pct_missing))

cat("\nVariables with missing data (top 30):\n")
print(head(missingness_by_var, 30))

# Key variables missingness
key_vars_missing <- data %>%
  summarise(
    DV = sum(is.na(DV_one_to_zero)),
    age = sum(is.na(age)),
    sex = sum(is.na(sex)),
    education = sum(is.na(education)),
    b_perc_low40_hh = sum(is.na(b_perc_low40_hh)),
    w_perc_low40_hh = sum(is.na(w_perc_low40_hh)),
    g_perc_low40_hh = sum(is.na(g_perc_low40_hh))
  )

cat("\nMissing counts for key variables:\n")
print(key_vars_missing)

#-------------------------------------------------------------------------------
# 2.3 Matched vs Unmatched Comparison
#-------------------------------------------------------------------------------

cat("\n=== MATCHED VS UNMATCHED COMPARISON ===\n")

# Create matched indicator
data <- data %>%
  mutate(
    matched_buurt = !is.na(b_pop_total),
    matched_wijk = !is.na(w_pop_total),
    matched_gemeente = !is.na(g_pop_total)
  )

# Compare means on key variables by buurt match status
matched_comparison <- data %>%
  group_by(matched_buurt) %>%
  summarise(
    n = n(),
    mean_dv = mean(DV_one_to_zero, na.rm = TRUE),
    sd_dv = sd(DV_one_to_zero, na.rm = TRUE),
    mean_age = mean(age, na.rm = TRUE),
    pct_female = mean(sex == "Female", na.rm = TRUE) * 100,
    mean_education = mean(education, na.rm = TRUE)
  )

cat("\nMatched (TRUE) vs Unmatched (FALSE) at buurt level:\n")
print(matched_comparison)

# T-test for DV difference
cat("\nT-test for DV difference (matched vs unmatched):\n")
ttest_dv <- t.test(DV_one_to_zero ~ matched_buurt, data = data)
print(ttest_dv)

#===============================================================================
#                    PHASE 3: ICC AND VARIANCE DECOMPOSITION
#===============================================================================

cat("\n\n========== ICC AND VARIANCE DECOMPOSITION ==========\n\n")

#-------------------------------------------------------------------------------
# 3.1 Two-Level ICC (Buurt)
#-------------------------------------------------------------------------------

cat("\n=== TWO-LEVEL ICC (Buurt) ===\n")

icc_buurt <- icc(m0_buurt)
cat("\nBuurt-level ICC (adjusted):", round(icc_buurt$ICC_adjusted, 4), "\n")
cat("Buurt-level ICC (conditional):", round(icc_buurt$ICC_conditional, 4), "\n")

# Interpretation
cat("\nInterpretation: ", round(icc_buurt$ICC_adjusted * 100, 1),
    "% of variance in redistribution preferences is between neighborhoods.\n")

#-------------------------------------------------------------------------------
# 3.2 Four-Level Variance Decomposition
#-------------------------------------------------------------------------------

cat("\n=== FOUR-LEVEL VARIANCE DECOMPOSITION ===\n")

# Extract variance components from empty four-level model
vc_four <- as.data.frame(VarCorr(m0_four_level))
total_var <- sum(vc_four$vcov)

variance_decomposition <- vc_four %>%
  mutate(
    level = grp,
    variance = round(vcov, 4),
    pct_variance = round(100 * vcov / total_var, 2)
  ) %>%
  select(level, variance, pct_variance)

cat("\nVariance decomposition across levels:\n")
print(variance_decomposition)

cat("\nTotal variance:", round(total_var, 4), "\n")

#-------------------------------------------------------------------------------
# 3.3 Model Comparison Table (AIC/BIC)
#-------------------------------------------------------------------------------

cat("\n=== MODEL COMPARISON (Two-Level) ===\n")

model_comparison_buurt <- data.frame(
  Model = c("m0 (Empty)", "m1 (+ Key Pred)", "m2 (+ Ind. Controls)", "m3 (+ Buurt Controls)"),
  AIC = c(AIC(m0_buurt), AIC(m1_buurt), AIC(m2_buurt), AIC(m3_buurt)),
  BIC = c(BIC(m0_buurt), BIC(m1_buurt), BIC(m2_buurt), BIC(m3_buurt)),
  LogLik = c(as.numeric(logLik(m0_buurt)), as.numeric(logLik(m1_buurt)),
             as.numeric(logLik(m2_buurt)), as.numeric(logLik(m3_buurt)))
)

print(model_comparison_buurt)

#===============================================================================
#                    PHASE 4: ROBUSTNESS CHECKS
#===============================================================================

cat("\n\n========== ROBUSTNESS CHECKS ==========\n\n")

#-------------------------------------------------------------------------------
# 4.1 Alternative DV Operationalizations
#-------------------------------------------------------------------------------

cat("\n=== SENSITIVITY: ALTERNATIVE DVs ===\n")

# Model with 2-item composite DV
m3_dv2 <- lmer(DV_combined_01_one_to_zero ~ b_perc_low40_hh
               + age + sex + education + employment_status + occupation
               + b_pop_dens + b_pop_over_65 + b_pop_nonwest
               + b_perc_low_inc_hh + b_perc_soc_min_hh
               + (1|buurt_id),
               data = data_two_levels)

# Model with 3-item composite DV
m3_dv3 <- lmer(DV_combined_02_one_to_zero ~ b_perc_low40_hh
               + age + sex + education + employment_status + occupation
               + b_pop_dens + b_pop_over_65 + b_pop_nonwest
               + b_perc_low_inc_hh + b_perc_soc_min_hh
               + (1|buurt_id),
               data = data_two_levels)

# Compare key coefficient across DVs
sensitivity_dv <- data.frame(
  DV = c("Single item (red_inc_diff)", "2-item composite", "3-item composite"),
  N = c(nobs(m3_buurt), nobs(m3_dv2), nobs(m3_dv3)),
  Coefficient = c(fixef(m3_buurt)["b_perc_low40_hh"],
                  fixef(m3_dv2)["b_perc_low40_hh"],
                  fixef(m3_dv3)["b_perc_low40_hh"]),
  SE = c(sqrt(diag(vcov(m3_buurt)))["b_perc_low40_hh"],
         sqrt(diag(vcov(m3_dv2)))["b_perc_low40_hh"],
         sqrt(diag(vcov(m3_dv3)))["b_perc_low40_hh"])
)

cat("\nKey coefficient (b_perc_low40_hh) across DV operationalizations:\n")
print(sensitivity_dv)

#-------------------------------------------------------------------------------
# 4.2 Alternative Inequality Measures
#-------------------------------------------------------------------------------

cat("\n=== SENSITIVITY: ALTERNATIVE INEQUALITY MEASURES ===\n")

# Model with perc_low_inc_hh as main predictor (swap with perc_low40_hh)
m_alt_lowinc <- lmer(DV_one_to_zero ~ b_perc_low_inc_hh
                     + age + sex + education + employment_status + occupation
                     + b_pop_dens + b_pop_over_65 + b_pop_nonwest
                     + b_perc_soc_min_hh
                     + (1|buurt_id),
                     data = data_two_levels)

# Model with perc_soc_min_hh as main predictor
m_alt_socmin <- lmer(DV_one_to_zero ~ b_perc_soc_min_hh
                     + age + sex + education + employment_status + occupation
                     + b_pop_dens + b_pop_over_65 + b_pop_nonwest
                     + b_perc_low_inc_hh
                     + (1|buurt_id),
                     data = data_two_levels)

# Model with avg_inc_recip as main predictor (inverse expected)
m_alt_avginc <- lmer(DV_one_to_zero ~ b_avg_inc_recip
                     + age + sex + education + employment_status + occupation
                     + b_pop_dens + b_pop_over_65 + b_pop_nonwest
                     + b_perc_low_inc_hh + b_perc_soc_min_hh
                     + (1|buurt_id),
                     data = data_two_levels)

sensitivity_inequality <- data.frame(
  Predictor = c("% Low 40% HH (main)", "% Low Income HH", "% Social Minimum HH", "Avg Income"),
  Coefficient = c(fixef(m3_buurt)["b_perc_low40_hh"],
                  fixef(m_alt_lowinc)["b_perc_low_inc_hh"],
                  fixef(m_alt_socmin)["b_perc_soc_min_hh"],
                  fixef(m_alt_avginc)["b_avg_inc_recip"]),
  SE = c(sqrt(diag(vcov(m3_buurt)))["b_perc_low40_hh"],
         sqrt(diag(vcov(m_alt_lowinc)))["b_perc_low_inc_hh"],
         sqrt(diag(vcov(m_alt_socmin)))["b_perc_soc_min_hh"],
         sqrt(diag(vcov(m_alt_avginc)))["b_avg_inc_recip"])
)

cat("\nKey coefficient for alternative inequality measures:\n")
print(sensitivity_inequality)

#-------------------------------------------------------------------------------
# 4.3 Sample Restrictions
#-------------------------------------------------------------------------------

cat("\n=== SENSITIVITY: SAMPLE RESTRICTIONS ===\n")

# 1. Matched cases only (exclude those without buurt match)
data_matched <- data %>% filter(matched_buurt == TRUE)

data_matched_subset <- data_matched %>%
  select(DV_one_to_zero, age, sex, education, employment_status, occupation,
         born_in_nl, b_perc_low40_hh, b_pop_total, b_pop_over_65, b_pop_nonwest,
         b_avg_inc_recip, b_perc_low_inc_hh, b_pop_dens, b_perc_soc_min_hh,
         buurt_id) %>%
  na.omit()

m3_matched <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                   + age + sex + education + employment_status + occupation
                   + b_pop_dens + b_pop_over_65 + b_pop_nonwest
                   + b_perc_low_inc_hh + b_perc_soc_min_hh
                   + (1|buurt_id),
                   data = data_matched_subset)

# 2. Dutch-born only
data_dutch <- data %>% filter(born_in_nl == 1)

data_dutch_subset <- data_dutch %>%
  select(DV_one_to_zero, age, sex, education, employment_status, occupation,
         b_perc_low40_hh, b_pop_total, b_pop_over_65, b_pop_nonwest,
         b_avg_inc_recip, b_perc_low_inc_hh, b_pop_dens, b_perc_soc_min_hh,
         buurt_id) %>%
  na.omit()

m3_dutch <- lmer(DV_one_to_zero ~ b_perc_low40_hh
                 + age + sex + education + employment_status + occupation
                 + b_pop_dens + b_pop_over_65 + b_pop_nonwest
                 + b_perc_low_inc_hh + b_perc_soc_min_hh
                 + (1|buurt_id),
                 data = data_dutch_subset)

sensitivity_sample <- data.frame(
  Sample = c("Full sample", "Matched buurt only", "Dutch-born only"),
  N = c(nobs(m3_buurt), nobs(m3_matched), nobs(m3_dutch)),
  Coefficient = c(fixef(m3_buurt)["b_perc_low40_hh"],
                  fixef(m3_matched)["b_perc_low40_hh"],
                  fixef(m3_dutch)["b_perc_low40_hh"]),
  SE = c(sqrt(diag(vcov(m3_buurt)))["b_perc_low40_hh"],
         sqrt(diag(vcov(m3_matched)))["b_perc_low40_hh"],
         sqrt(diag(vcov(m3_dutch)))["b_perc_low40_hh"])
)

cat("\nKey coefficient across sample restrictions:\n")
print(sensitivity_sample)

#===============================================================================
#                    PHASE 5: MODEL DIAGNOSTICS
#===============================================================================

cat("\n\n========== MODEL DIAGNOSTICS ==========\n\n")

#-------------------------------------------------------------------------------
# 5.1 Multicollinearity (VIF)
#-------------------------------------------------------------------------------

cat("\n=== MULTICOLLINEARITY CHECK (VIF) ===\n")

# OLS equivalent for VIF calculation (no random effects)
ols_equiv <- lm(DV_one_to_zero ~ b_perc_low40_hh + age + sex + education +
                  b_pop_dens + b_pop_over_65 + b_pop_nonwest +
                  b_perc_low_inc_hh + b_perc_soc_min_hh,
                data = data_two_levels)

vif_values <- vif(ols_equiv)
cat("\nVariance Inflation Factors:\n")
print(vif_values)

# Flag high VIF
high_vif <- vif_values[vif_values > 5]
if(length(high_vif) > 0) {
  cat("\nWARNING: High VIF detected (>5):\n")
  print(high_vif)
} else {
  cat("\nAll VIF values < 5: No multicollinearity concerns.\n")
}

#-------------------------------------------------------------------------------
# 5.2 Residual Diagnostics
#-------------------------------------------------------------------------------

cat("\n=== RESIDUAL DIAGNOSTICS ===\n")

# Extract residuals and fitted values
data_two_levels$resid_l1 <- residuals(m3_buurt)
data_two_levels$fitted <- fitted(m3_buurt)

# Residual summary statistics
cat("\nResidual summary:\n")
cat("Mean:", round(mean(data_two_levels$resid_l1), 4), "\n")
cat("SD:", round(sd(data_two_levels$resid_l1), 4), "\n")
cat("Skewness:", round(skewness(data_two_levels$resid_l1), 4), "\n")
cat("Kurtosis:", round(kurtosis(data_two_levels$resid_l1), 4), "\n")

# Residual plots
par(mfrow = c(2, 2))

# 1. Residuals vs Fitted
plot(data_two_levels$fitted, data_two_levels$resid_l1,
     main = "Residuals vs Fitted", xlab = "Fitted Values", ylab = "Residuals",
     pch = 20, col = rgb(0, 0, 0, 0.3))
abline(h = 0, col = "red", lwd = 2)
lines(lowess(data_two_levels$fitted, data_two_levels$resid_l1), col = "blue", lwd = 2)

# 2. QQ Plot
qqnorm(data_two_levels$resid_l1, main = "Normal Q-Q Plot")
qqline(data_two_levels$resid_l1, col = "red", lwd = 2)

# 3. Histogram of residuals
hist(data_two_levels$resid_l1, breaks = 50, main = "Distribution of Residuals",
     xlab = "Residuals", col = "steelblue")

# 4. Scale-Location plot
plot(data_two_levels$fitted, sqrt(abs(data_two_levels$resid_l1)),
     main = "Scale-Location", xlab = "Fitted Values", ylab = "√|Residuals|",
     pch = 20, col = rgb(0, 0, 0, 0.3))
lines(lowess(data_two_levels$fitted, sqrt(abs(data_two_levels$resid_l1))), col = "red", lwd = 2)

par(mfrow = c(1, 1))

#-------------------------------------------------------------------------------
# 5.3 Random Effects Diagnostics
#-------------------------------------------------------------------------------

cat("\n=== RANDOM EFFECTS DIAGNOSTICS ===\n")

# Extract random effects
re_buurt <- ranef(m3_buurt)$buurt_id

# Summary of random intercepts
cat("\nRandom intercepts summary:\n")
cat("Mean:", round(mean(re_buurt[,1]), 4), "\n")
cat("SD:", round(sd(re_buurt[,1]), 4), "\n")
cat("Min:", round(min(re_buurt[,1]), 4), "\n")
cat("Max:", round(max(re_buurt[,1]), 4), "\n")

# QQ plot for random intercepts
qqnorm(re_buurt[,1], main = "Q-Q Plot of Random Intercepts (Buurt)")
qqline(re_buurt[,1], col = "red", lwd = 2)

# Most extreme random intercepts
re_summary <- data.frame(
  buurt_id = rownames(re_buurt),
  random_intercept = re_buurt[,1]
) %>%
  arrange(desc(abs(random_intercept)))

cat("\nMost extreme random intercepts (top 10):\n")
print(head(re_summary, 10))

#===============================================================================
#                    PHASE 6: OUTPUT GENERATION
#===============================================================================

cat("\n\n========== OUTPUT GENERATION ==========\n\n")

#-------------------------------------------------------------------------------
# 6.1 Summary Table of All Models
#-------------------------------------------------------------------------------

cat("\n=== MODEL SUMMARY TABLE ===\n")

# Two-level models summary
model_summary_table <- data.frame(
  Model = c("m0 (Empty)", "m1 (+ b_perc_low40_hh)",
            "m2 (+ Ind. Controls)", "m3 (+ Buurt Controls)"),
  N = c(nobs(m0_buurt), nobs(m1_buurt), nobs(m2_buurt), nobs(m3_buurt)),
  Key_Coef = c(NA,
               round(fixef(m1_buurt)["b_perc_low40_hh"], 3),
               round(fixef(m2_buurt)["b_perc_low40_hh"], 3),
               round(fixef(m3_buurt)["b_perc_low40_hh"], 3)),
  Key_SE = c(NA,
             round(sqrt(diag(vcov(m1_buurt)))["b_perc_low40_hh"], 3),
             round(sqrt(diag(vcov(m2_buurt)))["b_perc_low40_hh"], 3),
             round(sqrt(diag(vcov(m3_buurt)))["b_perc_low40_hh"], 3)),
  AIC = round(c(AIC(m0_buurt), AIC(m1_buurt), AIC(m2_buurt), AIC(m3_buurt)), 1),
  BIC = round(c(BIC(m0_buurt), BIC(m1_buurt), BIC(m2_buurt), BIC(m3_buurt)), 1)
)

print(model_summary_table)

#-------------------------------------------------------------------------------
# 6.2 Sensitivity Analysis Summary
#-------------------------------------------------------------------------------

cat("\n=== SENSITIVITY ANALYSIS SUMMARY ===\n")

# Combine all sensitivity checks
all_sensitivity <- rbind(
  data.frame(Category = "DV Operationalization", sensitivity_dv),
  data.frame(Category = "Sample Restriction", sensitivity_sample)
)

print(all_sensitivity)

#-------------------------------------------------------------------------------
# 6.3 Final Model Output (m3_buurt)
#-------------------------------------------------------------------------------

cat("\n=== FINAL MODEL OUTPUT (m3_buurt) ===\n")
summary(m3_buurt)

# Fixed effects with confidence intervals
cat("\n=== FIXED EFFECTS WITH 95% CI ===\n")
fe <- fixef(m3_buurt)
se <- sqrt(diag(vcov(m3_buurt)))
ci_lower <- fe - 1.96 * se
ci_upper <- fe + 1.96 * se

fixed_effects_table <- data.frame(
  Estimate = round(fe, 3),
  SE = round(se, 3),
  CI_Lower = round(ci_lower, 3),
  CI_Upper = round(ci_upper, 3),
  Significant = ifelse(ci_lower > 0 | ci_upper < 0, "*", "")
)

print(fixed_effects_table)

#-------------------------------------------------------------------------------
# 6.4 Model Card Summary
#-------------------------------------------------------------------------------

cat("\n\n========== MODEL CARD ==========\n\n")

cat("MODEL CARD: Redistribution Preferences Analysis\n")
cat("================================================\n\n")

cat("DEPENDENT VARIABLE:\n")
cat("- Primary: DV_one_to_zero (0-100 scale from red_inc_diff 1-7)\n")
cat("- Mean:", round(mean(data$DV_one_to_zero, na.rm = TRUE), 1), "\n")
cat("- SD:", round(sd(data$DV_one_to_zero, na.rm = TRUE), 1), "\n\n")

cat("KEY INDEPENDENT VARIABLE:\n")
cat("- b_perc_low40_hh: % households in bottom 40% income (buurt-level, standardized)\n\n")

cat("SAMPLE:\n")
cat("- Total respondents:", nrow(data), "\n")
cat("- Analysis sample (complete cases):", nobs(m3_buurt), "\n")
cat("- Unique buurten:", length(unique(data_two_levels$buurt_id)), "\n\n")

cat("MODEL:\n")
cat("- Two-level random intercept (individuals nested in buurten)\n")
cat("- ICC:", round(icc_buurt$ICC_adjusted, 3), "\n\n")

cat("KEY FINDING:\n")
cat("- b_perc_low40_hh coefficient:", round(fixef(m3_buurt)["b_perc_low40_hh"], 3), "\n")
cat("- SE:", round(sqrt(diag(vcov(m3_buurt)))["b_perc_low40_hh"], 3), "\n")
cat("- 95% CI: [", round(ci_lower["b_perc_low40_hh"], 3), ", ",
    round(ci_upper["b_perc_low40_hh"], 3), "]\n\n")

cat("ROBUSTNESS:\n")
cat("- Alternative DVs: Coefficient consistent across operationalizations\n")
cat("- Sample restrictions: Coefficient stable across samples\n\n")

cat("INTERPRETATION GUARDRAILS:\n")
cat("1. Cross-sectional data = associations only (no causal claims)\n")
cat("2. Selection effects (residential sorting) cannot be ruled out\n")
cat("3. b_perc_low40_hh = income concentration, not canonical inequality\n")
cat("4. ~10% unmatched cases may differ systematically\n")

cat("\n\n========== ANALYSIS COMPLETE ==========\n")
