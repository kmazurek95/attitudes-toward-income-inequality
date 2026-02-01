# Local Income Inequality and Redistribution Preferences

A reproducible analysis examining how neighborhood-level income inequality shapes individual preferences for government redistribution in the Netherlands.

## Research Question

Does very local socioeconomic context (buurt/neighborhood-level low-income concentration) help explain redistribution preferences beyond individual covariates and higher-level geography?

## Data Sources

- **SCoRE Survey** (~8,000 Dutch respondents, 2017): Individual attitudes toward redistribution, demographics, and geocoded locations
- **CBS Administrative Indicators**: Neighborhood-level socioeconomic data at three geographic levels:
  - Buurt (neighborhood): ~13,000 units
  - Wijk (district): ~3,000 units
  - Gemeente (municipality): ~380 units

### CBS Data Collection

The neighborhood indicators are sourced from **CBS StatLine** (Statistics Netherlands' open data portal), specifically table **84286NED** ("Kerncijfers wijken en buurten").

The pipeline can either:
1. **Load local file** (default): Uses pre-downloaded `indicators_buurt_wijk_gemeente.csv`
2. **Download from API**: Fresh data from CBS using the `cbsodataR` package

To enable API download, set `USE_CBS_API <- TRUE` in `_targets.R`.

```r
# Download manually
source("R/01_extract.R")
cbs_data <- download_cbs_data(table_id = "84286NED")

# View available variables
cbs_meta <- get_cbs_metadata("84286NED")
```

## Project Structure

```
.
├── _targets.R           # Pipeline definition (run with targets::tar_make())
├── R/                   # Analysis functions
│   ├── 00_packages.R    # Package management
│   ├── 01_extract.R     # Data loading functions
│   ├── 02_transform.R   # Data transformation functions
│   ├── 03_merge.R       # Merging and validation functions
│   └── 04_analysis.R    # Modeling and diagnostics functions
├── data/
│   ├── raw/             # Original data files (not tracked in git)
│   │   ├── score.dta
│   │   └── indicators_buurt_wijk_gemeente.csv
│   └── processed/       # Generated analysis-ready data
├── outputs/
│   ├── figures/         # Generated plots
│   └── tables/          # Generated tables
└── _targets/            # Pipeline cache (not tracked in git)
```

## Quick Start

### 1. Install Dependencies

```r
source("R/00_packages.R")
```

### 2. Run the Pipeline

```r
library(targets)
tar_make()
```

### 3. View Results

```r
# Check pipeline status
tar_progress()

# Visualize pipeline
tar_visnetwork()

# Load results
tar_read(analysis_report)
tar_read(models_two_level)
```

## Pipeline Stages

| Stage | Target | Description |
|-------|--------|-------------|
| **Extract** | `survey_raw`, `admin_raw` | Load SCoRE and CBS data |
| **Transform** | `survey_with_geo`, `admin_by_level` | Create geo IDs, split by level |
| **Merge** | `merged_data` | Join survey with admin at 3 levels |
| **Validate** | `merge_validation`, `missingness_report` | Check merge quality |
| **Recode** | `data_recoded`, `data_final` | Recode variables, standardize |
| **Analyze** | `models_two_level`, `icc_results` | Fit multilevel models |
| **Diagnose** | `diagnostics`, `sensitivity_results` | VIF, residuals, robustness |
| **Report** | `analysis_report`, `model_table` | Generate outputs |

## Key Variables

### Dependent Variable
- `DV_single`: Support for redistribution (0-100 scale, from "government should reduce income differences")

### Key Independent Variable
- `b_perc_low40_hh`: Percentage of households in bottom 40% of income distribution (buurt-level, standardized)

### Controls
- **Individual**: age, sex, education, employment status, occupation, migration background
- **Neighborhood**: population density, % age 65+, % non-Western, % low-income households, % social minimum

## Model Specification

Two-level random intercept model (individuals nested in neighborhoods):

```
DV_single ~ b_perc_low40_hh + individual_controls + buurt_controls + (1 | buurt_id)
```

## Reproducibility

This project uses the [`targets`](https://docs.ropensci.org/targets/) package for pipeline orchestration:

- **Dependency tracking**: Only re-runs steps when inputs change
- **Caching**: Results are cached in `_targets/` directory
- **Parallel execution**: Can run independent targets in parallel

To rebuild from scratch:
```r
tar_destroy()
tar_make()
```

## License

MIT

## Citation

Mazurek, K. (2022). Preferences for Government Redistribution of Income: The Role of Income and the Values of Collectivism and Meritocracy.
