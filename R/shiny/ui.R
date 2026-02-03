# =============================================================================
# ui.R - Dashboard UI Definition
# =============================================================================

ui <- dashboardPage(
  skin = "blue",

  # ===========================================================================
  # Header
  # ===========================================================================
  dashboardHeader(
    title = "Income Inequality Attitudes",
    titleWidth = 280,
    tags$li(
      class = "dropdown",
      tags$a(
        href = PYTHON_DASHBOARD_URL,
        target = "_blank",
        icon("python"),
        "Python Dashboard",
        style = "color: white; padding: 15px;"
      )
    )
  ),

  # ===========================================================================
  # Sidebar
  # ===========================================================================
  dashboardSidebar(
    width = 280,
    sidebarMenu(
      id = "tabs",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Data Explorer", tabName = "data_explorer", icon = icon("search")),
      menuItem("Geographic View", tabName = "geographic", icon = icon("map")),
      menuItem("Model Results", tabName = "model_results", icon = icon("chart-line")),
      menuItem("Key Findings", tabName = "key_findings", icon = icon("bullseye")),
      hr(),
      menuItem(
        "R-Specific Analyses",
        tabName = "r_specific",
        icon = icon("r-project"),
        badgeLabel = "Robustness",
        badgeColor = "green"
      )
    ),

    # About section
    div(
      style = "padding: 15px; font-size: 12px;",
      hr(),
      h5("About This Research"),
      p("Multilevel analysis of redistribution preferences in the Netherlands."),
      p("Based on Mijs (2018) 'Inferential Spaces' framework."),
      hr(),
      h5("Data Sources"),
      p("SCoRE Survey (2017)"),
      p("CBS StatLine (2018)"),
      hr(),
      p(
        style = "font-style: italic;",
        strong("Author: Kaleb Mazurek"),
        br(),
        "University of Amsterdam",
        br(),
        "Supervised by Dr. Wouter Schakel"
      )
    )
  ),

  # ===========================================================================
  # Body
  # ===========================================================================
  dashboardBody(
    # Custom CSS
    tags$head(
      tags$style(HTML("
        .content-wrapper { background-color: #f5f5f5; }
        .box { border-top: 3px solid #1f77b4; }
        .box.box-success { border-top-color: #2ca02c; }
        .box.box-warning { border-top-color: #ff7f0e; }
        .box.box-danger { border-top-color: #d62728; }
        .info-box { min-height: 90px; }
        .main-header .logo { font-weight: bold; }
        .skin-blue .main-header .navbar { background-color: #1f77b4; }
        .skin-blue .main-sidebar { background-color: #2c3e50; }
        h2 { color: #2c3e50; margin-bottom: 20px; }
        .hypothesis-box { padding: 15px; border-radius: 10px; margin-bottom: 15px; }
        .hypothesis-supported { background-color: #e8f5e9; border-left: 5px solid #2ca02c; }
        .hypothesis-not-supported { background-color: #ffebee; border-left: 5px solid #d62728; }
        .hypothesis-inconclusive { background-color: #fff3e0; border-left: 5px solid #ff7f0e; }
      "))
    ),

    tabItems(
      # =========================================================================
      # Home Tab
      # =========================================================================
      tabItem(
        tabName = "home",

        h2("Attitudes Toward Income Inequality"),
        p("A multilevel analysis of redistribution preferences in the Netherlands"),

        fluidRow(
          valueBoxOutput("box_respondents", width = 2),
          valueBoxOutput("box_sample", width = 2),
          valueBoxOutput("box_buurten", width = 2),
          valueBoxOutput("box_wijken", width = 2),
          valueBoxOutput("box_gemeenten", width = 2),
          valueBoxOutput("box_icc", width = 2)
        ),

        fluidRow(
          box(
            title = "Research Question",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            p(
              style = "font-size: 16px;",
              strong("Do neighborhood characteristics influence attitudes toward income redistribution,
              and at what geographic level do contextual effects operate?")
            ),
            hr(),
            p("Drawing on Mijs' (2018) 'inferential spaces' framework, this study tests whether
            exposure to socioeconomic diversity at the neighborhood level shapes beliefs about
            inequality and redistribution.")
          ),
          box(
            title = "Key Finding",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            p(
              style = "font-size: 16px;",
              "Only ", strong("3.4%"), " of variance in redistribution preferences is between neighborhoods."
            ),
            p("The neighborhood income composition effect becomes ",
              strong("non-significant"),
              " after controlling for individual characteristics."),
            hr(),
            p("This suggests limited support for the inferential spaces hypothesis in the Dutch context.")
          )
        ),

        fluidRow(
          box(
            title = "About This Dashboard",
            width = 12,
            p("This R Shiny dashboard presents results from a multilevel analysis of attitudes
            toward income redistribution in the Netherlands. It is part of a dual implementation
            project with both R and Python versions."),
            tags$ul(
              tags$li(strong("R Dashboard (this): "), "Includes true nested random effects using lme4"),
              tags$li(strong("Python Dashboard: "), "Streamlit-based with interactive visualizations")
            ),
            actionButton(
              "go_to_python",
              "Open Python Dashboard",
              icon = icon("external-link-alt"),
              onclick = paste0("window.open('", PYTHON_DASHBOARD_URL, "', '_blank')")
            )
          )
        )
      ),

      # =========================================================================
      # Data Explorer Tab
      # =========================================================================
      tabItem(
        tabName = "data_explorer",

        h2("Data Explorer"),

        fluidRow(
          box(
            title = "Dependent Variable Distribution",
            status = "primary",
            width = 6,
            plotlyOutput("dv_histogram", height = "350px")
          ),
          box(
            title = "Key Predictor Distribution",
            status = "primary",
            width = 6,
            plotlyOutput("key_pred_histogram", height = "350px")
          )
        ),

        fluidRow(
          box(
            title = "Sample Summary",
            width = 4,
            tableOutput("sample_summary")
          ),
          box(
            title = "Variable Descriptions",
            width = 8,
            DT::dataTableOutput("variable_table")
          )
        )
      ),

      # =========================================================================
      # Geographic View Tab
      # =========================================================================
      tabItem(
        tabName = "geographic",

        h2("Geographic Structure"),

        fluidRow(
          box(
            title = "Dutch Administrative Hierarchy",
            status = "primary",
            width = 12,
            p("The Netherlands has a nested geographic structure:"),
            tags$div(
              style = "text-align: center; font-size: 18px; padding: 20px;",
              strong("Individual"), " → ",
              span(style = paste0("color: ", COLORS$primary), strong("Buurt")), " (Neighborhood) → ",
              span(style = paste0("color: ", COLORS$secondary), strong("Wijk")), " (District) → ",
              span(style = paste0("color: ", COLORS$tertiary), strong("Gemeente")), " (Municipality)"
            )
          )
        ),

        fluidRow(
          box(
            title = "Cluster Size Distribution (Buurt)",
            status = "primary",
            width = 6,
            plotlyOutput("cluster_sizes", height = "350px")
          ),
          box(
            title = "Sample by Municipality",
            status = "primary",
            width = 6,
            plotlyOutput("gemeente_treemap", height = "350px")
          )
        )
      ),

      # =========================================================================
      # Model Results Tab
      # =========================================================================
      tabItem(
        tabName = "model_results",

        h2("Model Results"),

        fluidRow(
          box(
            title = "1. Variance Decomposition (ICC)",
            status = "primary",
            width = 6,
            plotlyOutput("icc_donut", height = "400px"),
            p(
              style = "text-align: center;",
              strong("ICC = 3.4%"),
              " means only 3.4% of variance is between neighborhoods"
            )
          ),
          box(
            title = "2. Coefficient Stability",
            status = "primary",
            width = 6,
            plotlyOutput("coef_progression", height = "400px"),
            p(
              style = "text-align: center;",
              "The key predictor effect ", strong("disappears"), " with full controls"
            )
          )
        ),

        fluidRow(
          box(
            title = "3. Forest Plot: Key Predictor Effect",
            status = "primary",
            width = 12,
            plotlyOutput("forest_plot", height = "300px")
          )
        ),

        fluidRow(
          box(
            title = "Model Summary",
            status = "primary",
            width = 12,
            p("Two-level random intercept models: DV_single ~ predictors + (1|buurt_id)"),
            tableOutput("model_table")
          )
        )
      ),

      # =========================================================================
      # Key Findings Tab
      # =========================================================================
      tabItem(
        tabName = "key_findings",

        h2("Key Findings"),

        fluidRow(
          column(
            width = 4,
            div(
              class = "hypothesis-box hypothesis-not-supported",
              h4("H1: Not Supported"),
              p(strong("Hypothesis: "), "Neighborhoods with higher income inequality → more support for redistribution"),
              hr(),
              p(strong("Finding: "), "Effect is non-significant after controls"),
              p("M1 coefficient: 3.36***"),
              p("M3 coefficient: 0.33 (n.s.)")
            )
          ),
          column(
            width = 4,
            div(
              class = "hypothesis-box hypothesis-inconclusive",
              h4("H2: Inconclusive"),
              p(strong("Hypothesis: "), "Neighborhood effects > municipality effects"),
              hr(),
              p(strong("Finding: "), "Effects weak at all levels"),
              p("ICC at buurt: ~2%"),
              p("ICC at wijk: ~1%"),
              p("ICC at gemeente: ~1%")
            )
          ),
          column(
            width = 4,
            div(
              class = "hypothesis-box hypothesis-not-supported",
              h4("H3: Not Supported"),
              p(strong("Hypothesis: "), "Effects persist after controlling for individual characteristics"),
              hr(),
              p(strong("Finding: "), "Effect does NOT persist"),
              p("90% reduction in coefficient"),
              p("Individual factors fully account for association")
            )
          )
        ),

        fluidRow(
          box(
            title = "Summary",
            status = "info",
            width = 12,
            p(
              style = "font-size: 16px;",
              "This study finds ", strong("limited evidence"), " for neighborhood effects on
              redistribution preferences in the Netherlands. Only 3.4% of variance is between
              neighborhoods, and the effect of neighborhood income composition becomes
              non-significant after controlling for individual characteristics."
            ),
            p(
              style = "font-size: 16px;",
              strong("Individual-level factors"), "—particularly age and education—are
              the primary drivers of redistribution preferences."
            )
          )
        )
      ),

      # =========================================================================
      # R-Specific Analyses Tab
      # =========================================================================
      tabItem(
        tabName = "r_specific",

        h2("R-Specific Robustness Analyses"),

        fluidRow(
          box(
            title = "True Nested Random Effects",
            status = "success",
            solidHeader = TRUE,
            width = 12,
            p("These analyses use lme4's capability for ", strong("true nested random effects:") ),
            code("DV_single ~ predictors + (1|gemeente_id) + (1|wijk_id) + (1|buurt_id)"),
            p("This properly partitions variance across all geographic levels."),
            p(
              strong("Note: "),
              "Python's statsmodels cannot fit this specification. This is an R-specific robustness check."
            )
          )
        ),

        fluidRow(
          valueBox(
            value = paste0(precomputed_results$nested$icc_gemeente * 100, "%"),
            subtitle = "ICC: Gemeente Level",
            icon = icon("city"),
            color = "green",
            width = 3
          ),
          valueBox(
            value = paste0(precomputed_results$nested$icc_wijk * 100, "%"),
            subtitle = "ICC: Wijk Level",
            icon = icon("building"),
            color = "orange",
            width = 3
          ),
          valueBox(
            value = paste0(precomputed_results$nested$icc_buurt * 100, "%"),
            subtitle = "ICC: Buurt Level",
            icon = icon("home"),
            color = "blue",
            width = 3
          ),
          valueBox(
            value = paste0(precomputed_results$nested$icc_residual * 100, "%"),
            subtitle = "ICC: Individual Level",
            icon = icon("user"),
            color = "purple",
            width = 3
          )
        ),

        fluidRow(
          box(
            title = "4-Level Variance Decomposition",
            status = "success",
            width = 6,
            plotlyOutput("nested_icc_donut", height = "400px")
          ),
          box(
            title = "Interpretation",
            status = "info",
            width = 6,
            p("The nested random effects model confirms:"),
            tags$ul(
              tags$li("Variance is ", strong("overwhelmingly"), " at the individual level (~96%)"),
              tags$li("Buurt, wijk, and gemeente each contribute only ~1-2%"),
              tags$li("There is ", strong("no evidence"), " for meaningful geographic clustering")
            ),
            hr(),
            p(strong("Conclusion: "), "Results are robust to proper multilevel specification.
            The weak neighborhood effects found in the two-level models are not artifacts of
            model misspecification.")
          )
        ),

        fluidRow(
          box(
            title = "Income Ratio Sensitivity Analysis",
            status = "warning",
            width = 6,
            p("Alternative specification using income ratio (high20/low40) instead of low-income concentration:"),
            tableOutput("sensitivity_table")
          ),
          box(
            title = "Python Limitations",
            status = "danger",
            width = 6,
            p(strong("Why this matters:")),
            p("Python's statsmodels cannot fit crossed or nested random effects."),
            p("The Python dashboard uses buurt as the primary grouping with wijk/gemeente as fixed effects."),
            p("This R implementation provides the proper multilevel variance decomposition."),
            hr(),
            p(
              style = "font-style: italic;",
              "For true multilevel analysis with nested geographic structures,
              R's lme4 package is the gold standard."
            )
          )
        )
      )
    )
  )
)
