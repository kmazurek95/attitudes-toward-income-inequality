# =============================================================================
# test_cbs_api.R - Test CBS API Data Collection
# =============================================================================
# Run this script in RStudio to verify the CBS API is working.
# =============================================================================

# Load the extraction functions
source("R/01_extract.R")

# -----------------------------------------------------------------------------
# Test 1: Check cbsodataR package
# -----------------------------------------------------------------------------
cat("=== Test 1: Checking cbsodataR package ===\n")

if (!requireNamespace("cbsodataR", quietly = TRUE)) {
  cat("cbsodataR not installed. Installing now...\n")
  install.packages("cbsodataR")
}

library(cbsodataR)
cat("cbsodataR loaded successfully. Version:", as.character(packageVersion("cbsodataR")), "\n\n")

# -----------------------------------------------------------------------------
# Test 2: Get table metadata
# -----------------------------------------------------------------------------
cat("=== Test 2: Fetching table metadata ===\n")

meta <- get_cbs_metadata("84286NED")
cat("Found", nrow(meta), "variables in table 84286NED\n")
cat("First 10 variables:\n")
print(head(meta, 10))
cat("\n")

# -----------------------------------------------------------------------------
# Test 3: Download data from API
# -----------------------------------------------------------------------------
cat("=== Test 3: Downloading data from CBS API ===\n")
cat("This may take 1-2 minutes for the full dataset...\n\n")

start_time <- Sys.time()
cbs_data <- download_cbs_data(table_id = "84286NED")
end_time <- Sys.time()

cat("\n=== RESULTS ===\n")
cat("Download time:", round(difftime(end_time, start_time, units = "secs"), 1), "seconds\n")
cat("Rows downloaded:", nrow(cbs_data), "\n")
cat("Columns:", ncol(cbs_data), "\n")
cat("Column names:", paste(names(cbs_data), collapse = ", "), "\n\n")

# Show counts by region type
cat("Counts by region type:\n")
print(table(cbs_data$region_type))

# Show sample data
cat("\nSample data (first 5 rows):\n")
print(head(cbs_data, 5))

cat("\n=== CBS API TEST COMPLETE ===\n")
cat("If you see data above, the API connection is working correctly.\n")
