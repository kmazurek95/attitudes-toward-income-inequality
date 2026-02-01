# =============================================================================
# 04_analysis.R - Statistical Analysis Functions
# =============================================================================
# Functions for multilevel modeling, diagnostics, and output generation.
# =============================================================================

#' Fit Two-Level Models
#'
#' Fits the sequence of two-level multilevel models (individuals in buurten).
#'
#' @param data Analysis dataset
#' @return A list of fitted lmer models
fit_two_level_models <- function(data) {

message("Fitting two-level multilevel models...")

# m0: Empty model
message("  Fitting m0 (empty model)...")
m0 <- lme4::lmer(
  DV_single ~ 1 + (1 | buurt_id),
  data = data,
  REML = TRUE
)

# m1: Add key predictor
message("  Fitting m1 (+ key predictor)...")
m1 <- lme4::lmer(
  DV_single ~ b_perc_low40_hh + (1 | buurt_id),
  data = data,
  REML = TRUE
)

# m2: Add individual controls
message("  Fitting m2 (+ individual controls)...")
m2 <- lme4::lmer(
  DV_single ~ b_perc_low40_hh + age + sex + education +
    employment_status + occupation + born_in_nl +
    (1 | buurt_id),
  data = data,
  REML = TRUE
)

# m3: Add buurt controls
message("  Fitting m3 (+ buurt controls)...")
m3 <- lme4::lmer(
  DV_single ~ b_perc_low40_hh + age + sex + education +
    employment_status + occupation + born_in_nl +
    b_pop_dens + b_pop_over_65 + b_pop_nonwest +
    b_perc_low_inc_hh + b_perc_soc_min_hh +
    (1 | buurt_id),
  data = data,
  REML = TRUE
)

models <- list(
  m0_empty = m0,
  m1_key_pred = m1,
  m2_ind_controls = m2,
  m3_buurt_controls = m3
)

message("  All models fitted successfully")

return(models)
}


#' Calculate ICC and Variance Decomposition
#'
#' Calculates intraclass correlation from empty model.
#'
#' @param models List of fitted models
#' @return A list with ICC and variance components
calculate_icc <- function(models) {

message("Calculating ICC and variance decomposition...")

m0 <- models$m0_empty

# Use performance package
icc_result <- performance::icc(m0)

# Extract variance components manually
vc <- as.data.frame(lme4::VarCorr(m0))
var_buurt <- vc$vcov[vc$grp == "buurt_id"]
var_residual <- vc$vcov[vc$grp == "Residual"]
total_var <- var_buurt + var_residual

variance_decomposition <- tibble::tibble(
  level = c("Buurt", "Residual", "Total"),
  variance = c(var_buurt, var_residual, total_var),
  pct_variance = c(
    100 * var_buurt / total_var,
    100 * var_residual / total_var,
    100
  )
)

message(glue::glue(
  "  ICC (buurt): {round(icc_result$ICC_adjusted, 4)} ({round(icc_result$ICC_adjusted * 100, 1)}% of variance between neighborhoods)"
))

return(list(
  icc = icc_result,
  variance_decomposition = variance_decomposition
))
}


#' Run Model Diagnostics
#'
#' Performs diagnostic checks on the final model.
#'
#' @param model A fitted lmer model
#' @param data The analysis dataset
#' @return A list with diagnostic results
run_diagnostics <- function(model, data) {

message("Running model diagnostics...")

# VIF (using OLS equivalent)
message("  Calculating VIF...")
ols_formula <- DV_single ~ b_perc_low40_hh + age + sex + education +
  b_pop_dens + b_pop_over_65 + b_pop_nonwest +
  b_perc_low_inc_hh + b_perc_soc_min_hh

ols_fit <- lm(ols_formula, data = data)
vif_values <- car::vif(ols_fit)

high_vif <- vif_values[vif_values > 5]
if (length(high_vif) > 0) {
  warning("High VIF detected: ", paste(names(high_vif), collapse = ", "))
}

# Residual statistics
message("  Analyzing residuals...")
resids <- residuals(model)
resid_stats <- tibble::tibble(
  mean = mean(resids),
  sd = sd(resids),
  skewness = moments::skewness(resids),
  kurtosis = moments::kurtosis(resids)
)

# Random effects
message("  Analyzing random effects...")
re <- lme4::ranef(model)$buurt_id[, 1]
re_stats <- tibble::tibble(
  mean = mean(re),
  sd = sd(re),
  min = min(re),
  max = max(re)
)

diagnostics <- list(
  vif = vif_values,
  high_vif = high_vif,
  residual_stats = resid_stats,
  random_effect_stats = re_stats,
  n_clusters = length(unique(data$buurt_id)),
  n_obs = nrow(data)
)

message("  Diagnostics complete")

return(diagnostics)
}


#' Run Sensitivity Analyses
#'
#' Runs robustness checks with alternative specifications.
#'
#' @param data Full merged dataset
#' @return A tibble summarizing sensitivity results
run_sensitivity <- function(data) {

message("Running sensitivity analyses...")

results <- tibble::tibble(
  specification = character(),
  n = integer(),
  coefficient = numeric(),
  se = numeric(),
  significant = logical()
)

# Prepare analysis sample
analysis_vars <- c(
  "DV_single", "age", "sex", "education", "employment_status",
  "occupation", "born_in_nl", "b_perc_low40_hh", "b_pop_dens",
  "b_pop_over_65", "b_pop_nonwest", "b_perc_low_inc_hh",
  "b_perc_soc_min_hh", "buurt_id", "b_pop_total",
  "DV_2item_scaled", "DV_3item_scaled"
)

base_data <- data %>%
  dplyr::select(dplyr::any_of(analysis_vars)) %>%
  tidyr::drop_na()

# Base model
message("  Base model...")
m_base <- lme4::lmer(
  DV_single ~ b_perc_low40_hh + age + sex + education +
    employment_status + occupation +
    b_pop_dens + b_pop_over_65 + b_pop_nonwest +
    b_perc_low_inc_hh + b_perc_soc_min_hh +
    (1 | buurt_id),
  data = base_data
)

fe <- lme4::fixef(m_base)["b_perc_low40_hh"]
se <- sqrt(diag(vcov(m_base)))["b_perc_low40_hh"]

results <- results %>%
  dplyr::add_row(
    specification = "Base model",
    n = nrow(base_data),
    coefficient = fe,
    se = se,
    significant = abs(fe) > 1.96 * se
  )

# 2-item DV
if ("DV_2item_scaled" %in% names(base_data)) {
  message("  2-item composite DV...")
  m_2item <- lme4::lmer(
    DV_2item_scaled ~ b_perc_low40_hh + age + sex + education +
      employment_status + occupation +
      b_pop_dens + b_pop_over_65 + b_pop_nonwest +
      b_perc_low_inc_hh + b_perc_soc_min_hh +
      (1 | buurt_id),
    data = base_data
  )

  fe <- lme4::fixef(m_2item)["b_perc_low40_hh"]
  se <- sqrt(diag(vcov(m_2item)))["b_perc_low40_hh"]

  results <- results %>%
    dplyr::add_row(
      specification = "2-item composite DV",
      n = nrow(base_data),
      coefficient = fe,
      se = se,
      significant = abs(fe) > 1.96 * se
    )
}

# 3-item DV
if ("DV_3item_scaled" %in% names(base_data)) {
  message("  3-item composite DV...")
  m_3item <- lme4::lmer(
    DV_3item_scaled ~ b_perc_low40_hh + age + sex + education +
      employment_status + occupation +
      b_pop_dens + b_pop_over_65 + b_pop_nonwest +
      b_perc_low_inc_hh + b_perc_soc_min_hh +
      (1 | buurt_id),
    data = base_data
  )

  fe <- lme4::fixef(m_3item)["b_perc_low40_hh"]
  se <- sqrt(diag(vcov(m_3item)))["b_perc_low40_hh"]

  results <- results %>%
    dplyr::add_row(
      specification = "3-item composite DV",
      n = nrow(base_data),
      coefficient = fe,
      se = se,
      significant = abs(fe) > 1.96 * se
    )
}

# Dutch-born only
message("  Dutch-born only...")
dutch_data <- data %>%
  dplyr::filter(born_in_nl == 1) %>%
  dplyr::select(dplyr::any_of(analysis_vars)) %>%
  tidyr::drop_na()

if (nrow(dutch_data) > 100) {
  m_dutch <- lme4::lmer(
    DV_single ~ b_perc_low40_hh + age + sex + education +
      employment_status + occupation +
      b_pop_dens + b_pop_over_65 + b_pop_nonwest +
      b_perc_low_inc_hh + b_perc_soc_min_hh +
      (1 | buurt_id),
    data = dutch_data
  )

  fe <- lme4::fixef(m_dutch)["b_perc_low40_hh"]
  se <- sqrt(diag(vcov(m_dutch)))["b_perc_low40_hh"]

  results <- results %>%
    dplyr::add_row(
      specification = "Dutch-born only",
      n = nrow(dutch_data),
      coefficient = fe,
      se = se,
      significant = abs(fe) > 1.96 * se
    )
}

message("  Sensitivity analyses complete")

return(results)
}


#' Create Model Summary Table
#'
#' Creates a publication-ready regression table.
#'
#' @param models List of fitted models
#' @param output_path Path to save the table
#' @return A gt or modelsummary table object
create_model_table <- function(models, output_path = NULL) {

message("Creating model summary table...")

# Use modelsummary
table <- modelsummary::modelsummary(
  models,
  stars = c('*' = .05, '**' = .01, '***' = .001),
  coef_rename = c(
    "b_perc_low40_hh" = "% Low-income HH (buurt)",
    "age" = "Age (std)",
    "sexFemale" = "Female",
    "sexOther" = "Other gender",
    "education" = "Education (std)",
    "b_pop_dens" = "Population density",
    "b_pop_over_65" = "% Age 65+",
    "b_pop_nonwest" = "% Non-Western",
    "b_perc_low_inc_hh" = "% Low income HH",
    "b_perc_soc_min_hh" = "% Social minimum HH"
  ),
  gof_map = c("nobs", "aic", "bic"),
  output = if (!is.null(output_path)) output_path else "gt"
)

if (!is.null(output_path)) {
  message(glue::glue("  Table saved to: {output_path}"))
}

return(table)
}


#' Generate Analysis Report
#'
#' Creates a comprehensive summary of all analysis results.
#'
#' @param models List of fitted models
#' @param icc_results ICC and variance decomposition
#' @param diagnostics Diagnostic results
#' @param sensitivity Sensitivity analysis results
#' @param merge_validation Merge validation results
#' @return A list with all results formatted for reporting
generate_report <- function(models, icc_results, diagnostics, sensitivity, merge_validation) {

message("Generating analysis report...")

# Extract final model results
m3 <- models$m3_buurt_controls
fe <- lme4::fixef(m3)
se <- sqrt(diag(vcov(m3)))
ci_lower <- fe - 1.96 * se
ci_upper <- fe + 1.96 * se

fixed_effects <- tibble::tibble(
  term = names(fe),
  estimate = fe,
  se = se,
  ci_lower = ci_lower,
  ci_upper = ci_upper,
  significant = ci_lower > 0 | ci_upper < 0
)

# Model comparison
model_comparison <- tibble::tibble(
  model = names(models),
  n = sapply(models, function(m) nrow(m@frame)),
  aic = sapply(models, AIC),
  bic = sapply(models, BIC),
  loglik = sapply(models, function(m) as.numeric(logLik(m)))
)

report <- list(
  # Data summary
  n_obs = diagnostics$n_obs,
  n_clusters = diagnostics$n_clusters,

  # Merge quality
  merge_validation = merge_validation,

  # ICC
  icc = icc_results$icc$ICC_adjusted,
  variance_decomposition = icc_results$variance_decomposition,

  # Model results
  model_comparison = model_comparison,
  fixed_effects = fixed_effects,

  # Key finding
  key_coef = fe["b_perc_low40_hh"],
  key_se = se["b_perc_low40_hh"],
  key_ci = c(ci_lower["b_perc_low40_hh"], ci_upper["b_perc_low40_hh"]),

  # Diagnostics
  vif = diagnostics$vif,
  residual_stats = diagnostics$residual_stats,

  # Sensitivity
  sensitivity = sensitivity
)

message("  Report generated")

return(report)
}
