# =============================================================================
# global.R - Shared data and functions for R Shiny Dashboard
# =============================================================================

library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(here)

# =============================================================================
# Demo Mode Detection
# =============================================================================

# Try to load from processed data
data_path <- here::here("data", "processed", "analysis_ready.csv")

DEMO_MODE <- !file.exists(data_path)

if (!DEMO_MODE) {
  analysis_data <- readr::read_csv(data_path, show_col_types = FALSE)
  message(paste("Loaded analysis data:", nrow(analysis_data), "rows"))
} else {
  analysis_data <- NULL
  message("Running in DEMO MODE - using precomputed results only")
}

# =============================================================================
# Precomputed Results (from last pipeline run)
# =============================================================================

# These are the key results that don't change with user interaction
# Updated from latest pipeline run (February 2025)
precomputed_results <- list(
  summary_stats = list(
    n_obs = 8013,
    n_complete = 4748,
    n_buurten = 1572,
    n_wijken = 869,
    n_gemeenten = 295,
    dv_mean = 70.79,
    dv_sd = 27.41
  ),
  two_level = list(
    icc = 0.0347,
    pct_between = 3.47,
    pct_within = 96.53,
    n_obs = 4748,
    n_clusters = 1572,
    models = list(
      m0 = list(name = "M0: Empty", coef = NA, se = NA),
      m1 = list(name = "M1: + Key Pred", coef = 3.459, se = 0.417),
      m2 = list(name = "M2: + Ind Ctrl", coef = 2.939, se = 0.405),
      m3 = list(name = "M3: + Buurt Ctrl", coef = 0.276, se = 0.947)
    )
  ),
  nested = list(
    icc_gemeente = 0.012,
    icc_wijk = 0.008,
    icc_buurt = 0.014,
    icc_residual = 0.966,
    note = "R-specific: True nested random effects (1|gemeente) + (1|wijk) + (1|buurt)"
  ),
  h3_test = list(
    main_effect_coef = 0.217,
    main_effect_se = 0.949,
    interaction_coef = 0.181,
    interaction_se = 0.343,
    significant = FALSE,
    interpretation = "H3 NOT SUPPORTED: No significant cross-level interaction"
  ),
  sensitivity = list(
    base = list(name = "Base (DV_single)", coef = 0.276, se = 0.947, sig = FALSE),
    two_item = list(name = "2-item composite", coef = 0.312, se = 0.891, sig = FALSE),
    three_item = list(name = "3-item composite", coef = 0.287, se = 0.823, sig = FALSE),
    dutch_only = list(name = "Dutch-born only", coef = 0.189, se = 1.012, sig = FALSE),
    income_ratio = list(name = "Income ratio", coef = -1.841, se = 0.892, sig = TRUE)
  ),
  hypotheses = list(
    h1 = list(
      name = "Neighborhood Inequality Effect",
      result = "NOT SUPPORTED",
      evidence = "Effect non-significant after controls (beta=0.28, p>0.05)"
    ),
    h2 = list(
      name = "Geographic Level Comparison",
      result = "INCONCLUSIVE",
      evidence = "Effects weak at all levels (ICC ~1-2% at each level)"
    ),
    h3 = list(
      name = "Income Moderation",
      result = "NOT SUPPORTED",
      evidence = "Interaction non-significant (beta=0.18, p=0.60)"
    )
  ),
  metadata = list(
    data_source = "SCoRE Netherlands 2017",
    admin_data = "CBS StatLine Table 84286NED (2018)",
    last_updated = "2025-02",
    pipeline_version = "1.0"
  )
)

# =============================================================================
# Color Scheme (matching Python dashboard)
# =============================================================================

COLORS <- list(
  primary = "#1f77b4",     # Blue - main/buurt
  secondary = "#ff7f0e",   # Orange - wijk
  tertiary = "#2ca02c",    # Green - gemeente
  quaternary = "#d62728",  # Red - warnings/highlights
  neutral = "#7f7f7f",     # Gray - non-significant
  background = "#f5f5f5"
)

LEVEL_COLORS <- list(
  buurt = "#1f77b4",

wijk = "#ff7f0e",
  gemeente = "#2ca02c"
)

# =============================================================================
# Dashboard URLs for Cross-Linking
# =============================================================================

# Local development URLs
PYTHON_DASHBOARD_URL_LOCAL <- "http://localhost:8501"
R_DASHBOARD_URL_LOCAL <- "http://localhost:3838"

# Production URLs (update after deployment)
PYTHON_DASHBOARD_URL_PROD <- "https://attitudes-inequality.streamlit.app"
R_DASHBOARD_URL_PROD <- "https://kmazurek.shinyapps.io/attitudes-inequality-r"

# Use production URLs if available, otherwise local
PYTHON_DASHBOARD_URL <- Sys.getenv("PYTHON_DASHBOARD_URL", PYTHON_DASHBOARD_URL_PROD)
R_DASHBOARD_URL <- Sys.getenv("R_DASHBOARD_URL", R_DASHBOARD_URL_PROD)

# =============================================================================
# Helper Functions
# =============================================================================

#' Get summary statistics for the dashboard
get_summary_stats <- function(data) {
  # If no data, use precomputed results
 if (is.null(data)) {
    return(precomputed_results$summary_stats)
  }

  list(
    n_obs = nrow(data),
    n_complete = sum(complete.cases(data[c("DV_single", "buurt_id", "b_perc_low40_hh")])),
    n_buurten = length(unique(data$buurt_id)),
    n_wijken = if ("wijk_id" %in% names(data)) length(unique(data$wijk_id)) else NA,
    n_gemeenten = if ("gemeente_id" %in% names(data)) length(unique(data$gemeente_id)) else NA,
    dv_mean = mean(data$DV_single, na.rm = TRUE),
    dv_sd = sd(data$DV_single, na.rm = TRUE)
  )
}

#' Check if running in demo mode
is_demo_mode <- function() {
  return(DEMO_MODE)
}

#' Get demo mode message
get_demo_mode_message <- function() {
  "Running in demo mode with precomputed results. Interactive data exploration is limited."
}

#' Create a value box with custom styling
create_metric_box <- function(value, subtitle, icon_name = "chart-bar", color = "blue") {
  valueBox(
    value = value,
    subtitle = subtitle,
    icon = icon(icon_name),
    color = color
  )
}

# Source utility functions
source("utils/charts.R")
