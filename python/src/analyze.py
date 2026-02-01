# =============================================================================
# analyze.py - Statistical Analysis Module
# =============================================================================
"""
Functions for multilevel modeling, ICC calculation, and diagnostics.

Functions:
    fit_two_level_models: Fit sequence of random-intercept models
    calculate_icc: Calculate intraclass correlation
    run_diagnostics: VIF, residual stats, random effects
    run_sensitivity: Robustness checks with alternative specifications
"""

import pandas as pd
import numpy as np
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass
from scipy import stats
import warnings

import sys
sys.path.insert(0, str(Path(__file__).parent.parent))
from config import VIF_THRESHOLD, CONFIDENCE_LEVEL


# =============================================================================
# Model Results Dataclass
# =============================================================================

@dataclass
class TwoLevelModels:
    """Container for fitted multilevel models."""
    m0_empty: Any       # statsmodels MixedLMResults
    m1_key_pred: Any
    m2_ind_controls: Any
    m3_buurt_controls: Any


@dataclass
class ICCResult:
    """Intraclass correlation results."""
    icc: float
    var_buurt: float
    var_residual: float
    var_total: float
    pct_between: float
    pct_within: float


@dataclass
class DiagnosticsResult:
    """Model diagnostics results."""
    vif: pd.DataFrame
    high_vif: List[str]
    residual_stats: pd.DataFrame
    random_effect_stats: pd.DataFrame
    n_clusters: int
    n_obs: int


# =============================================================================
# Multilevel Model Fitting
# =============================================================================

def fit_two_level_models(data: pd.DataFrame) -> TwoLevelModels:
    """
    Fit sequence of two-level random intercept models.

    Models:
    - m0: Empty model (random intercept only) - for ICC
    - m1: + key predictor (b_perc_low40_hh)
    - m2: + individual controls
    - m3: + buurt-level controls

    Parameters
    ----------
    data : pd.DataFrame
        Analysis sample with required variables

    Returns
    -------
    TwoLevelModels
        Container with all fitted models
    """
    import statsmodels.formula.api as smf

    print("\nFitting two-level multilevel models...")

    # Ensure buurt_id is string for grouping
    df = data.copy()
    df["buurt_id"] = df["buurt_id"].astype(str)

    # Suppress convergence warnings for cleaner output
    warnings.filterwarnings("ignore", category=RuntimeWarning)

    # M0: Empty model (random intercept only)
    print("  Fitting m0 (empty model)...")
    m0 = smf.mixedlm(
        "DV_single ~ 1",
        data=df,
        groups="buurt_id"
    ).fit(reml=True)
    n_groups = df["buurt_id"].nunique()
    print(f"    N={int(m0.nobs)}, groups={n_groups}")

    # M1: Add key predictor
    print("  Fitting m1 (+ key predictor)...")
    m1 = smf.mixedlm(
        "DV_single ~ b_perc_low40_hh",
        data=df,
        groups="buurt_id"
    ).fit(reml=True)

    # M2: Add individual controls
    print("  Fitting m2 (+ individual controls)...")
    m2_formula = (
        "DV_single ~ b_perc_low40_hh + age + C(sex) + education + "
        "C(employment_status) + born_in_nl"
    )

    # Add occupation if available
    if "occupation" in df.columns and df["occupation"].notna().sum() > 100:
        m2_formula += " + C(occupation)"

    m2 = smf.mixedlm(
        m2_formula,
        data=df,
        groups="buurt_id"
    ).fit(reml=True)

    # M3: Add buurt-level controls
    print("  Fitting m3 (+ buurt controls)...")
    buurt_controls = []
    for var in ["b_pop_dens", "b_pop_over_65", "b_pop_nonwest",
                "b_perc_low_inc_hh", "b_perc_soc_min_hh"]:
        if var in df.columns and df[var].notna().sum() > 100:
            buurt_controls.append(var)

    m3_formula = m2_formula
    if buurt_controls:
        m3_formula += " + " + " + ".join(buurt_controls)

    m3 = smf.mixedlm(
        m3_formula,
        data=df,
        groups="buurt_id"
    ).fit(reml=True)

    print("  All models fitted successfully")

    # Print key coefficient
    if "b_perc_low40_hh" in m3.params.index:
        coef = m3.params["b_perc_low40_hh"]
        se = m3.bse["b_perc_low40_hh"]
        print(f"  Key predictor (m3): b_perc_low40_hh = {coef:.3f} (SE={se:.3f})")

    return TwoLevelModels(
        m0_empty=m0,
        m1_key_pred=m1,
        m2_ind_controls=m2,
        m3_buurt_controls=m3
    )


# =============================================================================
# ICC Calculation
# =============================================================================

def calculate_icc(models: TwoLevelModels) -> ICCResult:
    """
    Calculate intraclass correlation from empty model.

    ICC = sigma^2_buurt / (sigma^2_buurt + sigma^2_residual)

    Parameters
    ----------
    models : TwoLevelModels
        Fitted models (uses m0_empty)

    Returns
    -------
    ICCResult
        ICC and variance decomposition
    """
    print("\nCalculating ICC and variance decomposition...")

    m0 = models.m0_empty

    # Extract variance components from statsmodels MixedLM
    # Random effects variance: stored in cov_re
    # Residual variance: stored in scale
    var_buurt = float(m0.cov_re.iloc[0, 0])
    var_residual = float(m0.scale)
    var_total = var_buurt + var_residual

    icc = var_buurt / var_total
    pct_between = 100 * var_buurt / var_total
    pct_within = 100 * var_residual / var_total

    print(f"  Variance (buurt): {var_buurt:.2f} ({pct_between:.1f}%)")
    print(f"  Variance (residual): {var_residual:.2f} ({pct_within:.1f}%)")
    print(f"  ICC: {icc:.4f}")
    print(f"  Interpretation: {pct_between:.1f}% of variance is between neighborhoods")

    return ICCResult(
        icc=icc,
        var_buurt=var_buurt,
        var_residual=var_residual,
        var_total=var_total,
        pct_between=pct_between,
        pct_within=pct_within
    )


# =============================================================================
# Model Diagnostics
# =============================================================================

def run_diagnostics(
    models: TwoLevelModels,
    data: pd.DataFrame
) -> DiagnosticsResult:
    """
    Perform diagnostic checks on the final model.

    Includes:
    - VIF calculation (via OLS on predictors)
    - Residual statistics (mean, sd, skewness, kurtosis)
    - Random effects distribution

    Parameters
    ----------
    models : TwoLevelModels
        Fitted models (uses m3_buurt_controls)
    data : pd.DataFrame
        Analysis data

    Returns
    -------
    DiagnosticsResult
        Diagnostic results
    """
    from statsmodels.stats.outliers_influence import variance_inflation_factor

    print("\nRunning model diagnostics...")

    m3 = models.m3_buurt_controls

    # -------------------------------------------------------------------------
    # VIF Calculation
    # -------------------------------------------------------------------------
    print("  Calculating VIF...")

    # Select numeric predictors
    vif_vars = [
        "b_perc_low40_hh", "age", "education",
        "b_pop_dens", "b_pop_over_65", "b_pop_nonwest",
        "b_perc_low_inc_hh", "b_perc_soc_min_hh"
    ]
    vif_vars = [v for v in vif_vars if v in data.columns]

    # Create design matrix
    vif_data = data[vif_vars].dropna()

    vif_results = []
    if len(vif_data) > 0 and len(vif_vars) > 1:
        for i, col in enumerate(vif_vars):
            try:
                vif_value = variance_inflation_factor(vif_data.values, i)
                vif_results.append({"variable": col, "VIF": vif_value})
            except Exception as e:
                vif_results.append({"variable": col, "VIF": np.nan})

    vif_df = pd.DataFrame(vif_results)
    high_vif = []
    if len(vif_df) > 0:
        high_vif = vif_df[vif_df["VIF"] > VIF_THRESHOLD]["variable"].tolist()

    if high_vif:
        print(f"  Warning: High VIF (>{VIF_THRESHOLD}): {', '.join(high_vif)}")
    else:
        print(f"  VIF OK (all < {VIF_THRESHOLD})")

    # -------------------------------------------------------------------------
    # Residual Statistics
    # -------------------------------------------------------------------------
    print("  Analyzing residuals...")

    resids = m3.resid
    residual_stats = pd.DataFrame({
        "statistic": ["mean", "sd", "skewness", "kurtosis"],
        "value": [
            np.mean(resids),
            np.std(resids),
            stats.skew(resids),
            stats.kurtosis(resids)
        ]
    })

    print(f"    Mean: {np.mean(resids):.4f} (should be ~0)")
    print(f"    Skewness: {stats.skew(resids):.2f}")
    print(f"    Kurtosis: {stats.kurtosis(resids):.2f}")

    # -------------------------------------------------------------------------
    # Random Effects Distribution
    # -------------------------------------------------------------------------
    print("  Analyzing random effects...")

    re = m3.random_effects
    re_values = [float(v.iloc[0]) for v in re.values()]

    random_effect_stats = pd.DataFrame({
        "statistic": ["mean", "sd", "min", "max"],
        "value": [
            np.mean(re_values),
            np.std(re_values),
            np.min(re_values),
            np.max(re_values)
        ]
    })

    print(f"    N clusters: {len(re_values)}")
    print(f"    RE range: [{np.min(re_values):.2f}, {np.max(re_values):.2f}]")

    n_clusters = len(data["buurt_id"].unique())
    n_obs = len(data)

    return DiagnosticsResult(
        vif=vif_df,
        high_vif=high_vif,
        residual_stats=residual_stats,
        random_effect_stats=random_effect_stats,
        n_clusters=n_clusters,
        n_obs=n_obs
    )


# =============================================================================
# Sensitivity Analyses
# =============================================================================

def run_sensitivity(data: pd.DataFrame) -> pd.DataFrame:
    """
    Run robustness checks with alternative specifications.

    Specifications tested:
    1. Base model (DV_single)
    2. 2-item composite DV
    3. 3-item composite DV
    4. Dutch-born only subsample

    Parameters
    ----------
    data : pd.DataFrame
        Full analysis data

    Returns
    -------
    pd.DataFrame
        Sensitivity results
    """
    import statsmodels.formula.api as smf

    print("\nRunning sensitivity analyses...")

    df = data.copy()
    df["buurt_id"] = df["buurt_id"].astype(str)

    # Base formula
    base_controls = "age + C(sex) + education + C(employment_status) + born_in_nl"
    buurt_controls = []
    for var in ["b_pop_dens", "b_pop_over_65", "b_pop_nonwest",
                "b_perc_low_inc_hh", "b_perc_soc_min_hh"]:
        if var in df.columns:
            buurt_controls.append(var)

    if buurt_controls:
        base_controls += " + " + " + ".join(buurt_controls)

    results = []

    # Specification 1: Base model
    print("  1. Base model (DV_single)...")
    try:
        m_base = smf.mixedlm(
            f"DV_single ~ b_perc_low40_hh + {base_controls}",
            data=df,
            groups="buurt_id"
        ).fit(reml=True)
        results.append(_extract_key_coef(m_base, "Base (DV_single)"))
    except Exception as e:
        print(f"    Error: {e}")

    # Specification 2: 2-item composite
    if "DV_2item_scaled" in df.columns:
        print("  2. Two-item composite...")
        try:
            m_2item = smf.mixedlm(
                f"DV_2item_scaled ~ b_perc_low40_hh + {base_controls}",
                data=df.dropna(subset=["DV_2item_scaled"]),
                groups="buurt_id"
            ).fit(reml=True)
            results.append(_extract_key_coef(m_2item, "2-item composite"))
        except Exception as e:
            print(f"    Error: {e}")

    # Specification 3: 3-item composite
    if "DV_3item_scaled" in df.columns:
        print("  3. Three-item composite...")
        try:
            m_3item = smf.mixedlm(
                f"DV_3item_scaled ~ b_perc_low40_hh + {base_controls}",
                data=df.dropna(subset=["DV_3item_scaled"]),
                groups="buurt_id"
            ).fit(reml=True)
            results.append(_extract_key_coef(m_3item, "3-item composite"))
        except Exception as e:
            print(f"    Error: {e}")

    # Specification 4: Dutch-born only
    if "born_in_nl" in df.columns:
        print("  4. Dutch-born only...")
        df_dutch = df[df["born_in_nl"] == 1].copy()
        if len(df_dutch) > 100:
            try:
                m_dutch = smf.mixedlm(
                    f"DV_single ~ b_perc_low40_hh + {base_controls}",
                    data=df_dutch,
                    groups="buurt_id"
                ).fit(reml=True)
                results.append(_extract_key_coef(m_dutch, "Dutch-born only"))
            except Exception as e:
                print(f"    Error: {e}")

    results_df = pd.DataFrame(results)

    print("\n  Sensitivity Summary:")
    print(results_df.to_string(index=False))

    return results_df


def _extract_key_coef(model, spec_name: str) -> Dict[str, Any]:
    """Extract key predictor coefficient from model."""
    coef = model.params.get("b_perc_low40_hh", np.nan)
    se = model.bse.get("b_perc_low40_hh", np.nan)

    # Significance test
    significant = False
    if not np.isnan(coef) and not np.isnan(se) and se > 0:
        z = abs(coef / se)
        significant = z > 1.96

    return {
        "specification": spec_name,
        "N": int(model.nobs),
        "coefficient": coef,
        "SE": se,
        "significant": significant
    }
