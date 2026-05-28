# Load library
library(tidyverse)
library(readxl)
library(ggplot2)

# Import dataset
CO2_data <- read_csv("Original Dataset.csv", skip = 24, show_col_types = FALSE)

CO2_data <- CO2_data %>%
  slice(1:597) %>%
  rename(
    Year = YYYY,
    CO2 = `CO2(ppm)`
  ) %>%
  filter(Year >= 1980 & Year <= 2024) %>%
  mutate(
    Year = as.numeric(Year),
    CO2 = as.numeric(CO2)
  )

# Plot CO2 concentration over time
ggplot(CO2_data, aes(x = Year, y = CO2)) +
  geom_point(color = "black", alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  scale_x_continuous(breaks = seq(1980, 2024, by = 5)) +
  labs(title = "Trend Analysis of Atmospheric CO2 Levels at Cape Grim (1980–2024)",
       x = "Year",
       y = "CO2 Concentration (ppm)") +
  theme_bw()




# Linear regression ----
model <- lm(`CO2` ~ Year, data = CO2_data)
summary(model)
