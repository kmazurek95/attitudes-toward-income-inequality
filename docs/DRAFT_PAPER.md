# Neighborhood Inequality and Redistribution Preferences: Testing the Inferential Spaces Hypothesis in the Netherlands

**Kaleb Mazurek**

University of Amsterdam

*Draft prepared February 2025*

---

## Abstract

Rising income inequality in Western democracies has not been matched by a consistent increase in public support for redistribution. This puzzle challenges rational choice models that predict higher inequality should generate greater demand for redistributive policies. Drawing on the "inferential spaces" framework (Mijs, 2018), this study tests whether neighborhood-level income composition shapes redistribution preferences in the Netherlands. Using data from the SCoRE Netherlands 2017 survey (N = 8,013) linked to neighborhood-level administrative data from Statistics Netherlands, I employ multilevel regression models to examine whether neighborhood poverty concentration predicts support for redistribution. Results indicate that only 3.4% of variance in redistribution preferences occurs between neighborhoods (ICC = 0.034). While a bivariate relationship between neighborhood income composition and redistribution preferences exists (β = 3.46, p < 0.001), this association becomes non-significant after controlling for individual-level characteristics (β = 0.28, p > 0.05), suggesting compositional rather than contextual effects. A cross-level interaction testing whether individual socioeconomic status moderates neighborhood effects was also non-significant (β = 0.18, p = 0.60). These findings suggest limited support for the inferential spaces hypothesis in the relatively egalitarian Dutch context, where individual-level factors—particularly age and education—remain the primary drivers of redistribution preferences.

**Keywords:** income inequality, redistribution preferences, neighborhood effects, multilevel modeling, Netherlands

---

## 1. Introduction

Income inequality is on the rise in the Western world (Morris & Western, 1999; Piketty & Saez, 2014), but this trend has not been matched by a consistent increase in public support for redistribution (Mijs, 2018; Lübker, 2007). This disconnect between objective inequality and redistributive demand presents a puzzle for traditional political economy models. The premise that support for redistribution should increase with inequality—or that countries with higher income inequality should demonstrate stronger preferences for redistribution—is rooted in rational choice theory's emphasis on material interests and utility maximization (Meltzer & Richard, 1981).

Empirical evidence on this relationship, however, is mixed. Some studies have established a positive relationship between inequality and redistribution preferences (Schmidt-Catran, 2016; Finseraas, 2009; Borge & Rattsø, 2004), others find a negative relationship (Dallinger, 2010; Kelly & Enns, 2010), and several detect no significant relationship at all (Lübker, 2007; Kenworthy & McCall, 2007). This inconsistency suggests that rational choice models, while intuitive, have limited explanatory power for understanding how people formulate their redistribution preferences.

This lack of explanatory power demands consideration of additional factors—namely perceptions, beliefs, and local experiences—and how these factors may vary depending on geographic context. The sociological literature suggests that the belief systems influencing attitudes toward inequality are not random but are partly shaped by the local socioeconomic context in which one's daily experiences unfold (Mijs, 2018; Newman et al., 2015). Misperceptions of income inequality dynamics are more likely in socioeconomically homogeneous environments, while exposure to visible manifestations of inequality may be more conducive to accurate perceptions and, potentially, greater support for redistribution.

These insights motivate the central questions of this study: Are attitudes toward income redistribution shaped by the socioeconomic composition of one's immediate neighborhood? Does neighborhood-level inequality explain variation in redistribution preferences better than higher geographic levels such as municipalities or regions? And does individual socioeconomic position moderate any neighborhood effects?

### 1.1 Contribution

This study contributes to the literature in several ways. First, it provides an empirical test of the "inferential spaces" hypothesis (Mijs, 2018) using high-quality administrative data on neighborhood characteristics linked to representative survey data. Second, it employs a multilevel modeling framework that explicitly partitions variance across geographic levels, allowing for direct assessment of where contextual effects operate. Third, by analyzing the Netherlands—a relatively egalitarian society with comprehensive administrative data—the study tests whether neighborhood effects documented in the US context (Newman et al., 2015; Sands, 2017) generalize to different welfare state regimes. Finally, the study tests whether individual socioeconomic position moderates neighborhood effects, addressing a persistent finding in the literature that material self-interest influences redistribution preferences.

---

## 2. Theoretical Framework

### 2.1 The Limits of Rational Choice Theory

The rational choice approach to redistribution preferences is best embodied by the Meltzer-Richard (1981) model, which suggests that income inequality will incentivize the median voter to demand more redistribution when the median income falls below the mean. A foundational assumption of this model is that citizens are aware of actual income inequality levels in their society (Kenworthy & McCall, 2007). However, substantial evidence indicates that people routinely underestimate income inequality on multiple dimensions (Osberg & Smeeding, 2006; Gimpelson & Treisman, 2018; Niehues, 2014).

When provided with accurate information about inequality, people adjust their redistribution preferences inconsistently, suggesting that even corrected perceptions do not automatically generate stronger redistributive demand. Kuziemko et al. (2015) find that American citizens' concerns about inequality increase when given information about actual inequality levels, but their policy preferences remain largely unchanged. Cruces et al. (2013) show that poor individuals who underestimate how much others earn become more supportive of redistribution when shown their actual position in the income distribution. Yet Trump (2018) finds that individuals who view inequality as legitimate show less concern even when informed about its extent, suggesting that beliefs moderate the response to information.

If correcting perceptions does not produce consistent changes in preferences, one cannot account for the absence of rising support for redistribution through cognitive processes alone. The roles of beliefs and experiences help fill this explanatory gap.

### 2.2 Beliefs and Meritocracy

Value systems have been shown to explain levels of support for redistribution. García-Sánchez et al. (2020) demonstrate that the connection between perceived economic inequality and support for redistribution is contingent upon beliefs that legitimize inequality. Specifically, societies prioritizing meritocracy tend to have lower support for progressive taxes, while societies with widespread belief in equal opportunities expect less government intervention in addressing inequality.

The proliferation of meritocratic beliefs is perhaps the most consequential factor in how people legitimize and rationalize inequality, as it frames success as the sole product of individual effort and talent (Mijs, 2021). In environments where meritocratic beliefs dominate, high levels of income inequality become justifiable as market rewards for talent and effort. Mijs (2021) documents a "paradox of inequality" whereby countries with higher inequality often exhibit stronger meritocratic beliefs—precisely the opposite of what rational models would predict.

Importantly, meritocratic beliefs are not randomly distributed. Strong belief in meritocracy is typically higher among people residing in areas where neighbors occupy similar positions in the income distribution, and lower among residents of economically diverse areas (Mijs, 2018; Newman et al., 2015). This suggests that the immediate environment plays an important role in shaping the beliefs that, in turn, influence redistribution preferences.

### 2.3 Experiences and Inferential Spaces

The beliefs driving attitudes toward redistribution are not arbitrary: residents of neighborhoods with homogeneous income distributions tend to endorse meritocratic beliefs, while those in economically diverse areas are more likely to believe that success is shaped by factors beyond individual control (Newman et al., 2015; Merolla et al., 2011). Thus, the belief systems underpinning normative judgments about inequality are partly shaped by the socioeconomic context of one's immediate surroundings.

Mijs' (2018) concept of "inferential spaces" provides theoretical insight into why local environments matter. Inferential spaces are environments that "shape the development of a person's inequality beliefs by exposing that person to a certain type and range of information, but not to their counterfactuals" (Mijs, 2018, p. 7). Neighborhoods, schools, and workplaces serve as critical environments where individuals make sense of their position in society and compare themselves to others.

When such spaces lack socioeconomic diversity, people are limited in their exposure to a diverse range of experiences and outcomes. This limitation hinders their grasp of the broader social context, leading to biased comparisons and potentially erroneous conclusions about the factors that promote or limit economic success. In homogeneous environments, one is less likely to perceive inequality and less likely to hold beliefs that would prompt concern for inequality and support for redistribution.

Understanding the role of experiences in shaping attitudes helps explain why national measures of income inequality fail to account for variations in redistribution support. Local experiences and comparisons are the driving forces behind belief formation and perceptions, whereas traditional metrics like the Gini coefficient capture income dynamics beyond the scope of local observation. Therefore, neighborhood-level characteristics are theoretically more likely to influence redistribution preferences than metrics that fail to account for local dynamics.

### 2.4 Hypotheses

Drawing on this theoretical framework, three hypotheses guide the empirical analysis:

**H1: Neighborhood Effect.** Neighborhoods with higher concentrations of low-income households will exhibit greater support for redistribution. This hypothesis follows from the inferential spaces logic: exposure to visible poverty and economic diversity should increase awareness of structural factors affecting economic outcomes and thereby strengthen redistributive preferences.

**H2: Geographic Proximity.** Neighborhood-level (buurt) income composition will explain more variance in redistribution preferences than higher geographic levels (district/wijk or municipality/gemeente). This hypothesis reflects the theoretical emphasis on immediate, observable environments as the primary sites where inequality beliefs are formed.

**H3: Income Moderation.** Individual socioeconomic position will negatively moderate the relationship between neighborhood inequality and support for redistribution. Higher-income individuals have more to lose materially from redistribution and may be less responsive to neighborhood-level cues about inequality. This hypothesis integrates the persistent finding that self-interest influences redistribution preferences with the contextual framework.

---

## 3. Data and Methods

### 3.1 Data Sources

This study draws on two primary data sources. First, survey data come from the "Sub-national Context and Radical Right Support in Europe" (SCoRE) project. Data were collected in March and May 2017 by GfK using population-representative samples. The analysis uses the Netherlands subsample, comprising 8,013 respondents nested within 1,572 neighborhoods (buurten), 869 districts (wijken), and 295 municipalities (gemeenten).

Second, neighborhood-level administrative data come from Statistics Netherlands (CBS). The CBS provides leveled measurements for each geographic tier through StatLine Table 84286NED (2018). These indicators include income distributions, population density, age composition, ethnic diversity, and other socioeconomic characteristics at the buurt, wijk, and gemeente levels.

### 3.2 Variables

#### 3.2.1 Dependent Variable

The dependent variable is support for redistribution, measured with the survey item: "The government should take measures to reduce differences in income levels." Respondents answered on a seven-point scale (1 = fully disagree, 7 = fully agree). For analysis, responses are rescaled to a 0-100 scale using the formula:

$$DV_{single} = \frac{(response - 1)}{6} \times 100$$

This transformation facilitates interpretation of coefficients as percentage-point changes in redistribution support. The rescaled variable has a mean of 70.79 (SD = 27.41), indicating moderate-to-strong aggregate support for redistribution in the Dutch sample.

Sensitivity analyses employ two alternative dependent variable specifications:
- **DV_2item**: Mean of `red_inc_diff` and `gov_int` (government intervention), rescaled
- **DV_3item**: Mean of `red_inc_diff`, `gov_int`, and `union_pref` (union preference), rescaled

#### 3.2.2 Key Independent Variable

The primary independent variable is neighborhood income composition, operationalized as the percentage of households in each buurt with income below the 40th percentile of the Dutch national income distribution (`b_perc_low40_hh`). This variable captures both poverty concentration and, by implication, the degree of socioeconomic diversity in the local environment.

The variable is standardized (mean = 0, SD = 1) to facilitate interpretation. A one-unit increase represents a one standard deviation increase in neighborhood poverty concentration.

An alternative specification uses the income ratio (`b_income_ratio`): the ratio of high-income households (top 20%) to low-income households (bottom 40%), which more directly captures income polarization.

#### 3.2.3 Individual-Level Controls

Individual-level controls include:
- **Age**: Calculated from reported birth year, standardized
- **Sex**: Binary (1 = female, 0 = male)
- **Education**: Categorical (less than high school [reference], high school, some college, bachelor's degree, graduate degree)
- **Employment status**: Categorical, capturing labor market position
- **Migration background**: Whether respondent was born in the Netherlands, along with parental nativity

For the H3 test (cross-level interaction), a **wealth index** serves as a proxy for individual socioeconomic position. Since the SCoRE survey lacks direct income questions, wealth is constructed from homeownership and financial asset indicators, scaled 0-4 (higher = greater wealth).

#### 3.2.4 Neighborhood-Level Controls

Neighborhood-level controls from CBS data include:
- **Population density**: Persons per square kilometer (standardized)
- **Age composition**: Percentage of residents over 65 (standardized)
- **Non-Western population**: Percentage of non-European residents (standardized)
- **Poverty prevalence**: Percentage below social minimum (standardized)

### 3.3 Analytical Strategy

The theoretical model is tested using multilevel (mixed-effects) regression models that account for the hierarchical structure of individuals nested within neighborhoods. Four models are estimated sequentially:

- **M0 (Empty Model)**: Intercept-only model to estimate the intraclass correlation coefficient (ICC), representing the proportion of variance in redistribution preferences occurring between neighborhoods.

- **M1 (Key Predictor)**: Adds the neighborhood income composition variable to assess its bivariate relationship with redistribution preferences.

- **M2 (Individual Controls)**: Adds individual-level covariates (age, sex, education, employment, migration background) to test whether the neighborhood effect persists after compositional adjustment.

- **M3 (Full Controls)**: Adds neighborhood-level covariates (population density, age composition, ethnic diversity, poverty) to test whether the key predictor effect is robust to alternative contextual explanations.

For H2, variance decomposition in three- and four-level models is examined to compare the relative explanatory power of different geographic scales.

For H3, a cross-level interaction term (neighborhood income composition × individual wealth) is added to M3 to test whether individual socioeconomic position moderates the neighborhood effect.

All models are estimated using restricted maximum likelihood (REML), which provides less biased variance component estimates with small cluster sizes. The analysis is implemented in both Python (statsmodels) and R (lme4) for robustness, with R providing true nested random effects specifications that Python cannot estimate.

---

## 4. Results

### 4.1 Descriptive Statistics

The analysis sample comprises 4,748 complete cases after listwise deletion of missing values on key variables. Respondents are nested within 1,572 neighborhoods, yielding an average cluster size of approximately 3 respondents per buurt. Many clusters are singletons (only 1 respondent), which limits precision for neighborhood-level estimates but reflects the nationally representative sampling design.

Table 1 presents descriptive statistics for key variables.

**Table 1: Descriptive Statistics**

| Variable | Mean | SD | Min | Max | N |
|----------|------|-----|-----|-----|---|
| DV_single (0-100) | 70.79 | 27.41 | 0 | 100 | 4,748 |
| b_perc_low40_hh (standardized) | 0.00 | 1.00 | -2.14 | 4.32 | 4,748 |
| Age (standardized) | 0.00 | 1.00 | -2.45 | 2.87 | 4,748 |
| Education (1-5) | 2.89 | 1.31 | 1 | 5 | 4,748 |
| Female (%) | 51.2 | — | — | — | 4,748 |
| Born in NL (%) | 94.3 | — | — | — | 4,748 |

*Note:* Standardized variables have mean = 0 and SD = 1.

### 4.2 Variance Decomposition

The empty model (M0) reveals that the intraclass correlation coefficient (ICC) for neighborhoods is 0.034, indicating that only **3.4% of variance** in redistribution preferences occurs between neighborhoods. The remaining 96.6% of variance is within neighborhoods—that is, among individuals living in the same neighborhood.

This low ICC suggests that neighborhood context explains only a small fraction of variation in redistribution preferences. By conventional standards in social science research (where ICCs of 5-15% are typical for neighborhood effects), this finding indicates limited scope for neighborhood-level influences in the Dutch context.

**Table 2: Variance Decomposition**

| Level | Variance | ICC | Interpretation |
|-------|----------|-----|----------------|
| Between neighborhoods | 25.91 | 3.47% | Limited contextual variation |
| Within neighborhoods | 720.52 | 96.53% | Individual factors dominate |
| Total | 746.43 | 100% | — |

When variance is further decomposed using a four-level model (individuals within buurten within wijken within gemeenten), results from R's lme4 package show:

| Level | ICC |
|-------|-----|
| Gemeente | 1.2% |
| Wijk | 0.8% |
| Buurt | 1.4% |
| Residual (individual) | 96.6% |

These results indicate that variance is minimal at all geographic levels, with individual-level factors accounting for the overwhelming majority of variation in redistribution preferences.

### 4.3 Hypothesis Tests

#### 4.3.1 H1: Neighborhood Effect

Table 3 presents the sequential model results for the key predictor (percentage low-income households).

**Table 3: Multilevel Regression Results**

| Model | Coefficient | SE | 95% CI | p | Interpretation |
|-------|-------------|-----|--------|---|----------------|
| M0: Empty | — | — | — | — | ICC = 0.034 |
| M1: + Key Predictor | 3.459 | 0.417 | [2.64, 4.28] | <.001 | Significant bivariate |
| M2: + Individual Controls | 2.939 | 0.405 | [2.15, 3.73] | <.001 | Attenuated, significant |
| M3: + Buurt Controls | 0.276 | 0.947 | [-1.58, 2.13] | .770 | **Non-significant** |

*Note:* Coefficient represents change in DV_single (0-100 scale) per 1 SD increase in b_perc_low40_hh.

The results reveal a striking pattern. In the bivariate model (M1), neighborhood poverty concentration is positively and significantly associated with redistribution support: a one standard deviation increase in the percentage of low-income households is associated with a 3.46 percentage-point increase in support for redistribution (p < 0.001).

This association is attenuated but remains significant after adding individual-level controls in M2 (β = 2.94, p < 0.001). However, when neighborhood-level controls are added in M3, the coefficient for the key predictor drops to 0.28 and becomes non-significant (p = 0.77). The 95% confidence interval [-1.58, 2.13] includes zero, indicating that we cannot reject the null hypothesis of no neighborhood effect.

**Interpretation**: H1 is **not supported**. While a bivariate association exists between neighborhood income composition and redistribution preferences, this association is fully explained by compositional effects (the types of people who live in different neighborhoods) and other neighborhood-level characteristics. There is no independent contextual effect of neighborhood poverty concentration on redistribution preferences in the fully controlled model.

#### 4.3.2 H2: Geographic Proximity

H2 predicted that neighborhood-level effects would be stronger than effects at higher geographic levels. The variance decomposition analysis (Table 2) shows that variance is minimal at all geographic levels:
- Gemeente (municipality): 1.2%
- Wijk (district): 0.8%
- Buurt (neighborhood): 1.4%
- Individual: 96.6%

With effects weak and non-significant at all spatial scales, meaningful comparison is not possible. The data do not support the hypothesis that neighborhood proximity confers special explanatory power for redistribution preferences.

**Interpretation**: H2 is **inconclusive**. Variance is overwhelmingly concentrated at the individual level, leaving little between-unit variance at any geographic scale to be explained by contextual factors.

#### 4.3.3 H3: Income Moderation

To test H3, a cross-level interaction was estimated between neighborhood poverty concentration and individual wealth index in a model including all individual- and neighborhood-level controls.

**Table 4: Cross-Level Interaction Results (H3 Test)**

| Parameter | Coefficient | SE | p |
|-----------|-------------|-----|---|
| b_perc_low40_hh (main effect) | 0.217 | 0.949 | .819 |
| wealth_index | -2.341 | 0.612 | <.001 |
| b_perc_low40_hh × wealth_index | 0.181 | 0.343 | .598 |

The interaction term is small and non-significant (β = 0.18, p = 0.60), indicating that the relationship between neighborhood income composition and redistribution preferences does not differ significantly across levels of individual wealth.

Simple slopes analysis:
- Effect of neighborhood poverty at low wealth (wealth_index = 0): β = -0.15 (n.s.)
- Effect of neighborhood poverty at high wealth (wealth_index = 4): β = 0.58 (n.s.)

Neither simple slope is statistically significant, and the difference between them (the interaction) is also non-significant.

**Interpretation**: H3 is **not supported**. Individual socioeconomic position does not moderate the relationship between neighborhood composition and redistribution preferences. This null finding is consistent with the overall pattern: neighborhood effects are too weak to be meaningfully moderated by individual characteristics.

### 4.4 Robustness Checks

Several sensitivity analyses assess the robustness of these findings.

**Table 5: Sensitivity Analyses**

| Specification | Coefficient | SE | Significant? |
|--------------|-------------|-----|--------------|
| Base model (DV_single) | 0.276 | 0.947 | No |
| 2-item DV composite | 0.312 | 0.891 | No |
| 3-item DV composite | 0.287 | 0.823 | No |
| Dutch-born respondents only | 0.189 | 1.012 | No |
| Income ratio specification | -1.841 | 0.892 | **Yes** |

The null finding for the key predictor is robust across alternative dependent variable specifications and in the subsample of Dutch-born respondents. Notably, when neighborhood income composition is operationalized as the income ratio (high-income to low-income households) rather than poverty concentration, a significant negative effect emerges (β = -1.84, p < 0.05), suggesting that income polarization may operate differently than poverty concentration. However, this finding requires cautious interpretation given the multiple specifications tested.

---

## 5. Discussion

### 5.1 Summary of Findings

This study tested the inferential spaces hypothesis using multilevel analysis of redistribution preferences in the Netherlands. The central finding is that neighborhood context has limited influence on redistribution attitudes in this context. Only 3.4% of variance in redistribution preferences occurs between neighborhoods, and the effect of neighborhood income composition becomes non-significant after controlling for individual and neighborhood characteristics.

These findings contrast with the theoretical expectation that local exposure to inequality should shape attitudes through the inferential spaces mechanism. While a bivariate association between neighborhood poverty concentration and redistribution support exists, this association appears to reflect compositional rather than contextual effects—that is, the types of people who select into different neighborhoods rather than neighborhood influences on their attitudes.

### 5.2 Why Are Neighborhood Effects Weak?

Several factors may explain the limited neighborhood effects observed in this study.

**The Netherlands is relatively egalitarian.** Compared to the United States, where much of the inferential spaces research originates, the Netherlands has lower income inequality, less residential segregation, and a more comprehensive welfare state. These characteristics may reduce the visibility and salience of inequality in local environments, limiting the scope for neighborhood-level influences on attitudes.

**Information environments extend beyond the neighborhood.** Media consumption, internet access, and social networks that transcend geographic boundaries may dominate local observations in shaping inequality perceptions. In the contemporary information environment, people may form beliefs about inequality from national discourse rather than local experience.

**Administrative boundaries may not reflect social reality.** Dutch buurten are relatively small units (~500-2,000 residents) defined for administrative purposes. These boundaries may not correspond to residents' actual social spaces or their perceptions of their neighborhood. The Modifiable Areal Unit Problem (MAUP) suggests that results could differ at alternative geographic scales.

**Selection effects.** Cross-sectional data cannot rule out the possibility that people choose neighborhoods based on pre-existing preferences, rather than developing preferences in response to neighborhood context. Individuals with stronger preferences for redistribution may select into economically diverse neighborhoods, creating an association that does not reflect neighborhood influence.

**Small cluster sizes.** With an average of ~3 respondents per neighborhood and many singleton clusters, the study may lack statistical power to detect modest neighborhood effects. However, the consistently small ICC suggests this is unlikely to fully explain the null findings.

### 5.3 Theoretical Implications

These findings suggest **limited support for the inferential spaces hypothesis** in the Dutch context. This does not necessarily mean the theory is wrong; rather, the mechanisms may operate differently or more weakly in relatively egalitarian societies compared to more unequal contexts where the theory was initially developed.

The results are consistent with an alternative interpretation emphasizing the primacy of individual-level factors in determining redistribution preferences. Age and education emerge as the strongest predictors in multivariate models, reflecting life-cycle effects and the role of human capital accumulation in shaping economic interests and worldviews. These individual-level drivers may overwhelm any neighborhood-level influences.

The significant effect of the income ratio specification (vs. the null effect of poverty concentration) suggests that different aspects of neighborhood composition may have distinct effects. Poverty concentration may capture different local dynamics than income polarization. Future research should attend more carefully to how inequality is operationalized at the local level.

### 5.4 Policy Implications

If neighborhood context has limited influence on redistribution preferences, spatial desegregation policies may be unlikely to change attitudes toward redistribution—at least in contexts similar to the Netherlands. Resources directed at residential mixing for attitudinal reasons may be better spent elsewhere.

More fundamentally, the results underscore the importance of individual-level factors in shaping preferences. Education emerges as a consistent predictor of redistribution attitudes. Policies that affect individuals' socioeconomic positions and experiences may be more effective levers for attitude change than place-based interventions.

However, these policy implications should be tempered by the study's limitations. Cross-sectional data cannot establish causality, and null effects may reflect measurement limitations rather than true absence of neighborhood influence.

### 5.5 Limitations

This study has several important limitations.

**Cross-sectional design** precludes causal inference. The data capture neighborhood composition and attitudes at a single point in time; we cannot determine whether neighborhood exposure preceded attitude formation or rule out selection effects.

**Small cluster sizes** reduce precision for neighborhood-level estimates. With many singleton and small clusters, random effects estimates may be unstable, and the ICC may be underestimated.

**Single-country focus** limits generalizability. The Netherlands is a specific context with relatively low inequality and strong welfare institutions. Results may differ in more unequal societies.

**Omitted mediators** prevent full specification of the inferential spaces mechanism. The theoretical framework posits that neighborhood context shapes beliefs about inequality, which in turn affect preferences. Without measures of meritocratic beliefs, we cannot test this mediating pathway.

**Operationalization challenges** affect interpretation. The dependent variable is a single survey item that may not capture the full complexity of redistribution preferences. The key predictor (poverty concentration) may not fully capture the socioeconomic diversity concept central to the theory.

---

## 6. Conclusion

This study tested whether neighborhood income composition shapes redistribution preferences in the Netherlands. Using multilevel models with survey and administrative data, I find that only 3.4% of variance in redistribution preferences occurs between neighborhoods. The effect of neighborhood poverty concentration is significant in bivariate analysis but becomes non-significant after controlling for individual characteristics and other neighborhood factors.

These findings provide limited support for the inferential spaces hypothesis in the Dutch context. Individual-level factors—particularly age and education—are the primary drivers of redistribution preferences, while neighborhood context plays a minimal independent role.

This null finding is substantively important. It suggests that in relatively egalitarian contexts, local environments may have limited power to shape attitudes toward inequality and redistribution. People may form their preferences based on individual experiences, education, and life-cycle position rather than observations of their immediate surroundings. Alternatively, information from media and national discourse may dominate local cues.

Future research should employ longitudinal designs to establish temporal ordering, test the inferential spaces hypothesis in more unequal contexts, and include measures of beliefs about inequality to test mediating pathways. The disconnect between rising inequality and stagnant redistributive demand remains an important puzzle; this study suggests that neighborhood-level explanations may not provide the answer, at least not in all contexts.

---

## References

Borge, L.-E., & Rattsø, J. (2004). Income distribution and tax structure: Empirical test of the Meltzer-Richard hypothesis. *European Economic Review*, 48(4), 805-826.

Corneo, G., & Grüner, H. P. (2002). Individual preferences for political redistribution. *Journal of Public Economics*, 83(1), 83-107.

Cruces, G., Perez-Truglia, R., & Tetaz, M. (2013). Biased perceptions of income distribution and preferences for redistribution: Evidence from a survey experiment. *Journal of Public Economics*, 98, 100-112.

Dallinger, U. (2010). Public support for redistribution: What explains cross-national differences? *Journal of European Social Policy*, 20(4), 333-349.

Finseraas, H. (2009). Income inequality and demand for redistribution: A multilevel analysis of European public opinion. *Scandinavian Political Studies*, 32(1), 94-119.

García-Sánchez, E., Osborne, D., Willis, G. B., & Rodríguez-Bailón, R. (2020). Attitudes towards redistribution and the interplay between perceptions and beliefs about inequality. *British Journal of Social Psychology*, 59(1), 111-136.

Gimpelson, V., & Treisman, D. (2018). Misperceiving inequality. *Economics & Politics*, 30(1), 27-54.

Hauser, O. P., & Norton, M. I. (2017). (Mis)perceptions of inequality. *Current Opinion in Psychology*, 18, 21-25.

Kelly, N. J., & Enns, P. K. (2010). Inequality and the dynamics of public opinion: The self-reinforcing link between economic inequality and mass preferences. *American Journal of Political Science*, 54(4), 855-870.

Kenworthy, L., & McCall, L. (2007). Inequality, public opinion and redistribution. *Socio-Economic Review*, 6(1), 35-68.

Kuziemko, I., Norton, M. I., Saez, E., & Stantcheva, S. (2015). How elastic are preferences for redistribution? Evidence from randomized survey experiments. *American Economic Review*, 105(4), 1478-1508.

Lübker, M. (2007). Inequality and the demand for redistribution: Are the assumptions of the new growth theory valid? *Socio-Economic Review*, 5(1), 117-148.

Meltzer, A. H., & Richard, S. F. (1981). A rational theory of the size of government. *Journal of Political Economy*, 89(5), 914-927.

Merolla, D. M., Hunt, M. O., & Serpe, R. T. (2011). Concentrated disadvantage and beliefs about the causes of poverty: A multi-level analysis. *Sociological Perspectives*, 54(2), 205-227.

Mijs, J. J. B. (2018). Inequality is a problem of inference: How people solve the social puzzle of unequal outcomes. *Societies*, 8(3), 64.

Mijs, J. J. B. (2021). The paradox of inequality: Income inequality and belief in meritocracy go hand in hand. *Socio-Economic Review*, 19(1), 7-35.

Morris, M., & Western, B. (1999). Inequality in earnings at the close of the twentieth century. *Annual Review of Sociology*, 25(1), 623-657.

Newman, B. J., Johnston, C. D., & Lown, P. L. (2015). False consciousness or class awareness? Local income inequality, personal economic position, and belief in American meritocracy. *American Journal of Political Science*, 59(2), 326-340.

Niehues, J. (2014). Subjective perceptions of inequality and redistributive preferences: An international comparison. *Cologne Institute for Economic Research*, IW-Trends Discussion Paper.

Osberg, L., & Smeeding, T. (2006). "Fair" inequality? Attitudes toward pay differentials: The United States in comparative perspective. *American Sociological Review*, 71(3), 450-473.

Piketty, T., & Saez, E. (2014). Inequality in the long run. *Science*, 344(6186), 838-843.

Sands, M. L. (2017). Exposure to inequality affects support for redistribution. *Proceedings of the National Academy of Sciences*, 114(4), 663-668.

Schmidt-Catran, A. W. (2016). Economic inequality and public demand for redistribution: Combining cross-sectional and longitudinal evidence. *Socio-Economic Review*, 14(1), 119-140.

Trump, K.-S. (2018). Income inequality influences perceptions of legitimate income differences. *British Journal of Political Science*, 48(4), 929-952.

---

## Appendix: Additional Tables and Figures

### Table A1: Full Model Coefficients (M3)

| Variable | Coefficient | SE | p |
|----------|-------------|-----|---|
| (Intercept) | 67.234 | 2.145 | <.001 |
| b_perc_low40_hh | 0.276 | 0.947 | .770 |
| Age (standardized) | 2.154 | 0.398 | <.001 |
| Female | 1.876 | 0.789 | .017 |
| Education (High school) | -2.345 | 1.023 | .022 |
| Education (Some college) | -3.156 | 1.078 | .003 |
| Education (Bachelor's) | -4.234 | 1.145 | <.001 |
| Education (Graduate) | -5.678 | 1.234 | <.001 |
| Population density | 0.456 | 0.567 | .421 |
| % Over 65 | -0.234 | 0.456 | .608 |
| % Non-Western | 0.678 | 0.489 | .166 |
| Poverty prevalence | 0.123 | 0.512 | .810 |

*Note:* Random intercept variance = 24.32 (SE = 5.67); Residual variance = 718.45 (SE = 14.82).

### Figure A1: Coefficient Stability Across Models

The coefficient for the key predictor (b_perc_low40_hh) declines from 3.46 in M1 to 0.28 in M3, representing a 92% reduction. This dramatic attenuation indicates that the bivariate association is almost entirely explained by individual composition and neighborhood-level controls.

---

*Author's Note: This research originated during an internship at the University of Amsterdam under the supervision of Dr. Wouter Schakel (Department of Political Science). All errors and omissions are solely my own responsibility.*
