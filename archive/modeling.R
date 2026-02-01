# Load required libraries
library(broom)
library(sandwich)
library(lmtest)
library(stargazer)

# Load data
data_cleaned <- read_csv(file.path(output_dir, "cleaned_data.csv"))

# Define models
model_ols <- lm(Redistribution ~ income + Collectivism + Meritocracy + 
                  age + education + gender + country, data = data_cleaned)

# Robust standard errors
model_ols_robust <- coeftest(model_ols, vcov = vcovHC(model_ols, type = "HC"))

# GLS model
weights <- 1 / (fitted(model_ols)^2)
model_gls <- lm(Redistribution ~ income + Collectivism + Meritocracy + 
                  age + education + gender + country, 
                data = data_cleaned, weights = weights)

# Save results
stargazer(model_ols, model_ols_robust, model_gls, 
          type = "html", out = file.path(output_dir, "model_results.html"))
