
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

co2_data <- read_csv(
  "CapeGrim_CO2_data_download.csv",
  skip = 24,
  n_max = 599,
  locale = locale(encoding = "Latin1"),
  show_col_types = FALSE
)

colnames(co2_data)
head(co2_data)

co2_data <- co2_data %>%
  mutate(Date_full = make_date(YYYY, MM, DD))

co2_filtered <- co2_data %>%
  filter(Date_full >= as.Date("1980-01-01"),
         Date_full <= as.Date("2024-12-31"))

head(co2_filtered)

ggplot(co2_filtered, aes(x = Date_full, y = `CO2(ppm)`)) +
  geom_point(size = 0.7) +
  geom_smooth(method = "loess", se = FALSE, linewidth = 0.9) +
  labs(
    title = "Scatter Plot of Atmospheric CO2 Concentration (1980–2024)",
    x = "Year",
    y = "CO2 (ppm)",
    caption = "Figure 1: Scatter plot showing monthly CO2 concentration at Cape Grim from 1980 to 2024 with a smoothed trend line."
  ) +
  theme_minimal()

co2_yearly <- co2_filtered %>%
  group_by(YYYY) %>%
  summarise(mean_CO2 = mean(`CO2(ppm)`, na.rm = TRUE))

ggplot(co2_yearly, aes(x = factor(YYYY), y = mean_CO2)) +
  geom_col() +
  labs(
    title = "Average Annual Atmospheric CO2 Concentration (1980–2024)",
    x = "Year",
    y = "Average CO2 (ppm)",
    caption = "Figure 1: Bar chart showing yearly average CO2 concentration at Cape Grim from 1980 to 2024."
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, size = 6)
  )

ggplot(co2_yearly, aes(x = factor(YYYY), y = mean_CO2)) +
  geom_col() +
  labs(
    title = "Trend Analysis of Atmospheric Carbon Dioxide Levels at Cape Grim (1980–2024)",
    x = "Year",
    y = "CO2 Concentration (ppm)",
    caption = "Figure 1: Bar chart showing yearly average CO2 concentration at Cape Grim from 1980 to 2024."
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, size = 6)
  )
