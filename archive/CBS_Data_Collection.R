# ---------------------------------------------------------------
# Step 1: Load required packages
# ---------------------------------------------------------------
#install.packages("cbsodataR")  # Run only once
library(cbsodataR)

# Set API version to v4
options(cbsodataR.api_version = "v4")

# ---------------------------------------------------------------
# Step 2: Download the full dataset for 2018
# ---------------------------------------------------------------

# Download data
cbs_data_2018 <- cbs_get_data("84286NED", download = TRUE)

# View structure
str(cbs_data_2018)
head(cbs_data_2018)

# ---------------------------------------------------------------
# Step 3: Filter or rename relevant columns (example below)
# ---------------------------------------------------------------

library(dplyr)

# Example: Select a few relevant socioeconomic indicators
# (Use cbs_get_meta("84286NED") to find exact variable names)

cbs_2018_filtered <- cbs_data_2018 %>%
  select(RegioS, 
         Perioden,
         GemiddeldInkomenPerInwoner_39,        # Avg income per person
         PercentagePersonenMetLaagInkomen_66,  # % with low income
         Bevolkingsdichtheid_4,                # Population density
         NietWesterseAllochtonen_11,           # Non-Western migrants
         GemiddeldeWOZWaardeWoningen_44        # WOZ home value
  ) %>%
  rename(buurt_id = RegioS,
         average_income = GemiddeldInkomenPerInwoner_39,
         pct_low_income = PercentagePersonenMetLaagInkomen_66,
         density = Bevolkingsdichtheid_4,
         pct_non_western = NietWesterseAllochtonen_11,
         avg_home_value = GemiddeldeWOZWaardeWoningen_44)

# ---------------------------------------------------------------
# Step 4: Export or join with survey data
# ---------------------------------------------------------------

# Save to CSV
write.csv(cbs_2018_filtered, "cbs_key_indicators_2018.csv", row.names = FALSE)

# If your survey data has `buurt_id` codes:
# merged <- left_join(score_final, cbs_2018_filtered, by = "buurt_id")
