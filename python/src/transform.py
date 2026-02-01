# =============================================================================
# transform.py - Data Transformation Module
# =============================================================================
"""
Functions for creating geographic IDs, recoding variables, and standardization.

Functions:
    create_geo_ids: Create hierarchical geographic identifiers
    prepare_admin_by_level: Split admin data by geographic level
    recode_survey_variables: Create DVs and recode demographics
    standardize_context_vars: Z-score standardize neighborhood variables
"""

import pandas as pd
import numpy as np
from pathlib import Path
from typing import Dict

import sys
sys.path.insert(0, str(Path(__file__).parent.parent))
from config import SURVEY_YEAR


# =============================================================================
# Geographic ID Creation
# =============================================================================

def create_geo_ids(survey: pd.DataFrame) -> pd.DataFrame:
    """
    Create standardized geographic codes from Buurtcode.

    Dutch geographic hierarchy:
    - Buurt (neighborhood): 8-digit code
    - Wijk (district): first 6 digits
    - Gemeente (municipality): first 4 digits

    Parameters
    ----------
    survey : pd.DataFrame
        Survey data with Buurtcode column

    Returns
    -------
    pd.DataFrame
        Survey with buurt_id, wijk_id, gemeente_id columns
    """
    print("Creating geographic IDs...")

    df = survey.copy()

    # Ensure Buurtcode is string, pad to 8 digits
    df["buurt_id"] = (
        df["Buurtcode"]
        .astype(str)
        .str.replace(r"\.0$", "", regex=True)  # Remove decimal if present
        .str.zfill(8)
    )

    # Handle missing values
    df.loc[df["Buurtcode"].isna(), "buurt_id"] = np.nan

    # Create wijk (6 digits) and gemeente (4 digits) codes
    df["wijk_id"] = df["buurt_id"].str[:6]
    df["gemeente_id"] = df["buurt_id"].str[:4]

    # Set to NaN where buurt_id is NaN
    df.loc[df["buurt_id"].isna(), ["wijk_id", "gemeente_id"]] = np.nan

    # Report
    n_valid = df["buurt_id"].notna().sum()
    print(f"  Created geo IDs for {n_valid} respondents ({n_valid/len(df)*100:.1f}%)")
    print(f"  Unique buurten: {df['buurt_id'].nunique()}")
    print(f"  Unique wijken: {df['wijk_id'].nunique()}")
    print(f"  Unique gemeenten: {df['gemeente_id'].nunique()}")

    return df


# =============================================================================
# Admin Data Preparation
# =============================================================================

def prepare_admin_by_level(admin: pd.DataFrame) -> Dict[str, pd.DataFrame]:
    """
    Split admin data into separate DataFrames by geographic level.

    Adds level-specific prefixes to variable names:
    - Buurt: b_*
    - Wijk: w_*
    - Gemeente: g_*

    Parameters
    ----------
    admin : pd.DataFrame
        CBS administrative data with region_type and region_id columns

    Returns
    -------
    dict
        Dictionary with 'buurt', 'wijk', 'gemeente' DataFrames
    """
    print("Preparing admin data by geographic level...")

    admin = admin.copy()

    # Find the region code column
    region_col = None
    for col in ["region_code", "Codering_3", "WijkenEnBuurten"]:
        if col in admin.columns:
            region_col = col
            break

    if region_col is None:
        raise ValueError("Cannot identify region code column in admin data")

    # Create region_type from the code prefix (BU/WK/GM)
    admin["region_code_clean"] = admin[region_col].astype(str).str.strip()
    admin["region_type"] = admin["region_code_clean"].str[:2].map({
        "BU": "Buurt",
        "WK": "Wijk",
        "GM": "Gemeente"
    })
    admin["region_id"] = admin["region_code_clean"].str[2:].str.strip()

    # Map CBS column names to standard names
    # Based on actual CBS 84286NED column names (2018+)
    col_rename = {
        "AantalInwoners_5": "pop_total",
        "k_65JaarOfOuder_12": "pop_over_65",
        "WestersTotaal_17": "pop_west",
        "NietWestersTotaal_18": "pop_nonwest",
        "Bevolkingsdichtheid_33": "pop_dens",
        "GemiddeldeWoningwaarde_35": "avg_home_value",
        "GemiddeldInkomenPerInkomensontvanger_68": "avg_inc_recip",
        "GemiddeldInkomenPerInwoner_69": "avg_inc_pers",
        "k_40PersonenMetLaagsteInkomen_70": "perc_low40_pers",
        "k_20PersonenMetHoogsteInkomen_71": "perc_high20_pers",
        "k_40HuishoudensMetLaagsteInkomen_73": "perc_low40_hh",
        "k_20HuishoudensMetHoogsteInkomen_74": "perc_high20_hh",
        "HuishoudensMetEenLaagInkomen_75": "perc_low_inc_hh",
        "HuishoudensTot110VanSociaalMinimum_77": "perc_soc_min_hh",
    }

    # Rename columns that exist
    admin = admin.rename(columns={k: v for k, v in col_rename.items() if k in admin.columns})

    # Variables to keep (common indicators)
    indicator_vars = [
        "pop_total", "pop_over_65", "pop_west", "pop_nonwest", "pop_dens",
        "avg_home_value", "avg_inc_recip", "avg_inc_pers",
        "perc_low40_pers", "perc_high20_pers", "perc_low40_hh", "perc_high20_hh",
        "perc_low_inc_hh", "perc_soc_min_hh"
    ]

    # Filter to available indicators
    available_indicators = [v for v in indicator_vars if v in admin.columns]
    print(f"  Available indicators: {len(available_indicators)}")

    result = {}

    for level, prefix, id_length in [
        ("Buurt", "b_", 8),
        ("Wijk", "w_", 6),
        ("Gemeente", "g_", 4)
    ]:
        # Filter to this level
        level_data = admin[admin["region_type"] == level].copy()

        if len(level_data) == 0:
            print(f"  Warning: No {level} data found")
            result[level.lower()] = pd.DataFrame()
            continue

        # Create ID column with correct length
        id_col = f"{level.lower()}_id"
        level_data[id_col] = level_data["region_id"].str.zfill(id_length)

        # Select and rename columns with prefix
        cols_to_keep = [id_col]
        rename_dict = {}

        for var in available_indicators:
            if var in level_data.columns:
                new_name = f"{prefix}{var}"
                rename_dict[var] = new_name
                cols_to_keep.append(new_name)

        level_data = level_data.rename(columns=rename_dict)
        level_data = level_data[[id_col] + list(rename_dict.values())]

        # Drop duplicates
        level_data = level_data.drop_duplicates(subset=[id_col])

        result[level.lower()] = level_data
        print(f"  {level}: {len(level_data)} units")

    return result


# =============================================================================
# Variable Recoding
# =============================================================================

def recode_survey_variables(data: pd.DataFrame) -> pd.DataFrame:
    """
    Recode survey variables and create analysis-ready measures.

    Creates:
    - DV_single: Single item redistribution support (0-100 scale)
    - DV_2item, DV_3item: Composite measures
    - age, education: Standardized (z-score)
    - sex, employment_status, occupation: Categorical

    Parameters
    ----------
    data : pd.DataFrame
        Merged survey data

    Returns
    -------
    pd.DataFrame
        Data with recoded variables
    """
    print("Recoding survey variables...")

    df = data.copy()

    # -------------------------------------------------------------------------
    # Dependent Variables
    # -------------------------------------------------------------------------

    # Filter out missing/refused (coded as 8)
    dv_vars = ["gov_int", "red_inc_diff", "union_pref"]
    for var in dv_vars:
        if var in df.columns:
            df.loc[df[var] == 8, var] = np.nan

    # DV_single: Primary DV - redistribution support (red_inc_diff)
    # Scale from 1-7 to 0-100
    if "red_inc_diff" in df.columns:
        df["DV_single"] = (df["red_inc_diff"] - 1) / 6 * 100
        print(f"  DV_single: mean={df['DV_single'].mean():.1f}, "
              f"sd={df['DV_single'].std():.1f}")

    # DV_2item: Average of gov_int and red_inc_diff
    if "gov_int" in df.columns and "red_inc_diff" in df.columns:
        df["DV_2item"] = df[["gov_int", "red_inc_diff"]].mean(axis=1)
        df["DV_2item_scaled"] = (df["DV_2item"] - 1) / 6 * 100

    # DV_3item: Average of all three items
    if all(v in df.columns for v in dv_vars):
        df["DV_3item"] = df[dv_vars].mean(axis=1)
        df["DV_3item_scaled"] = (df["DV_3item"] - 1) / 6 * 100

    # -------------------------------------------------------------------------
    # Demographics
    # -------------------------------------------------------------------------

    # Sex (categorical)
    if "sex" in df.columns:
        df["sex"] = df["sex"].map({1: "Male", 2: "Female", 3: "Other"})
        df["sex"] = pd.Categorical(df["sex"], categories=["Male", "Female", "Other"])

    # Age (from birth year)
    if "birth_year" in df.columns:
        df["age_raw"] = SURVEY_YEAR - df["birth_year"]
        # Standardize
        df["age"] = (df["age_raw"] - df["age_raw"].mean()) / df["age_raw"].std()
        print(f"  Age: mean={df['age_raw'].mean():.1f}, range={df['age_raw'].min():.0f}-{df['age_raw'].max():.0f}")

    # Education (standardized years)
    if "educyrs" in df.columns:
        df["education"] = (df["educyrs"] - df["educyrs"].mean()) / df["educyrs"].std()

    # -------------------------------------------------------------------------
    # Employment
    # -------------------------------------------------------------------------

    if "work_status" in df.columns:
        employment_map = {
            1: "Employed",
            2: "Self-employed",
            3: "Unemployed",
            4: "Student",
            5: "Retired",
            6: "Homemaker",
            7: "Disabled",
            8: "Other"
        }
        df["employment_status"] = df["work_status"].map(employment_map)
        df["employment_status"] = pd.Categorical(df["employment_status"])

    if "work_type" in df.columns:
        occupation_map = {
            1: "Modern professional",
            2: "Clerical",
            3: "Senior manager",
            4: "Technical",
            5: "Semi-routine manual",
            6: "Routine manual",
            7: "Middle manager",
            8: "Traditional professional"
        }
        df["occupation"] = df["work_type"].map(occupation_map)
        df["occupation"] = pd.Categorical(df["occupation"])

    # -------------------------------------------------------------------------
    # Migration background
    # -------------------------------------------------------------------------

    if "born_in_nl" in df.columns:
        df["born_in_nl"] = df["born_in_nl"].astype(float)

    print(f"  Recoding complete. {len(df)} observations")
    return df


# =============================================================================
# Standardization
# =============================================================================

def standardize_context_vars(
    data: pd.DataFrame,
    prefixes: list = ["b_", "w_", "g_"]
) -> pd.DataFrame:
    """
    Z-score standardize neighborhood-level context variables.

    Parameters
    ----------
    data : pd.DataFrame
        Data with neighborhood variables
    prefixes : list
        Variable name prefixes to standardize (default: buurt, wijk, gemeente)

    Returns
    -------
    pd.DataFrame
        Data with standardized context variables
    """
    print("Standardizing context variables...")

    df = data.copy()

    standardized_count = 0
    for col in df.columns:
        if any(col.startswith(p) for p in prefixes):
            if df[col].dtype in [np.float64, np.int64, float, int]:
                mean_val = df[col].mean()
                std_val = df[col].std()
                if std_val > 0:
                    df[col] = (df[col] - mean_val) / std_val
                    standardized_count += 1

    print(f"  Standardized {standardized_count} context variables")
    return df
