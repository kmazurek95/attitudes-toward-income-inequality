# Load libraries
library(ggplot2)

# Load data
data_cleaned <- read_csv(file.path(output_dir, "cleaned_data.csv"))

# Residual plot
data_cleaned <- data_cleaned %>%
  mutate(
    residuals = model_ols$residuals,
    fitted = model_ols$fitted.values
  )

ggplot(data_cleaned, aes(x = fitted, y = residuals)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Residual Plot", x = "Fitted Values", y = "Residuals")

# Save plot
ggsave(file.path(output_dir, "residual_plot.png"))
