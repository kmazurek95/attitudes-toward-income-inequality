# Attitudes Toward Income Inequality

A multilevel analysis examining how neighborhood-level socioeconomic composition influences individual redistribution preferences in the Netherlands.

## Research Question

**What factors influence people's attitudes toward income redistribution, and at what contextual level do these preferences primarily form?**

Drawing on Mijs' (2018) "inferential spaces" framework, this study tests whether exposure to socioeconomic diversity at the neighborhood level shapes beliefs about inequality and redistribution.

### Hypotheses

- **H1**: Neighborhoods with higher income inequality → more support for redistribution
- **H2**: Neighborhood-level effects > municipality/regional effects
- **H3**: Individual income moderates the neighborhood effect

## Data Sources

- **SCoRE Survey (2017)**: Dutch nationally representative survey (N=8,013)
- **CBS StatLine**: Neighborhood-level administrative statistics via API

## Project Structure

```
attitudes-toward-income-inequality/
│
├── R/                          # R implementation (targets pipeline)
│   ├── 00_packages.R           # Package dependencies
│   ├── 01_extract.R            # Data loading (survey + CBS API)
│   ├── 02_transform.R          # Variable recoding, geo IDs
│   ├── 03_merge.R              # Multilevel merge
│   └── 04_analysis.R           # Multilevel models
│
├── python/                     # Python implementation
│   ├── src/                    # Source modules
│   │   ├── extract.py          # CBS API + survey loading
│   │   ├── transform.py        # Geographic ID creation
│   │   ├── merge.py            # Data merging
│   │   ├── analyze.py          # Multilevel models (statsmodels)
│   │   └── report.py           # Output generation
│   ├── run_pipeline.py         # Main entry point
│   ├── config.py               # Configuration settings
│   ├── analysis_report.ipynb   # EDA + analysis notebook
│   ├── analysis_extended.ipynb # Robustness checks (MI, weighting)
│   └── requirements.txt        # Python dependencies
│
├── _targets.R                  # R targets pipeline definition
│
├── docs/                       # Documentation & theory
│   └── Draft_Write_Up.docx     # Theoretical framework
│
├── legacy/                     # Old code from internship (archived)
│   ├── 01_code/                # Original analysis scripts
│   ├── 05_old/                 # Earlier iterations
│   ├── code/                   # Intermediate versions
│   ├── code1/                  # Additional scripts
│   ├── archive/                # Archived notebooks and scripts
│   └── 04_notes/               # Research notes
│
├── data/                       # Data files (not tracked in git)
│   ├── raw/                    # Original data (score.dta, CBS indicators)
│   └── processed/              # Analysis-ready datasets
│
├── outputs/                    # Generated outputs (not tracked)
│   ├── figures/
│   └── tables/
│
├── .gitignore
└── README.md
```

## Quick Start

### Python

```bash
cd python
pip install -r requirements.txt
python run_pipeline.py --use-api  # Downloads fresh CBS data
```

### R

```r
# In RStudio, open the project
install.packages(c("targets", "tidyverse", "lme4", "cbsodataR"))
targets::tar_make()
```

## Key Findings

| Metric | Value |
|--------|-------|
| ICC (Buurt level) | ~3.4% |
| N (analysis sample) | ~4,600 |
| Neighborhoods | ~1,500 |

- Only ~3-4% of variance in redistribution preferences is between neighborhoods
- Neighborhood income composition effect is weak/non-significant after controls
- Results are robust to multiple imputation and alternative inequality measures

## Methods

- **Multilevel models**: Random intercept models with individuals nested in neighborhoods (buurt)
- **Key predictor**: % households in bottom 40% of income distribution
- **Controls**: Age, sex, education, employment status, migration background, neighborhood demographics

## Dependencies

### Python
- pandas, numpy, scipy
- statsmodels (multilevel models)
- pyreadstat (Stata files)
- cbsodata (CBS API)

### R
- targets (pipeline)
- tidyverse
- lme4 (multilevel models)
- cbsodataR (CBS API)

## Author

Kaleb Mazurek

## License

MIT
