# This is a file for all plots for the Reasearch Article Project
# Cerberus Group
# Group project - EDA

# Install package ----
library(tidyverse)

# Load data ----
co2 <- read.csv(
  "cape_grim_co2.csv",
  fileEncoding = "latin1",
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Clean and filter data ----
co2_clean <- co2 %>%
  mutate(
    Year = as.numeric(Year),
    `CO2(ppm)` = as.numeric(`CO2(ppm)`)
  ) %>%
  filter(Year >= 1980, Year <= 2024) %>%
  drop_na(Year, `CO2(ppm)`)

# Plot the data ----

# Scatter Plot ----
ggplot(co2_clean, aes(x = Year, y = `CO2(ppm)`)) +
  geom_point(color = "black", alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  scale_x_continuous(breaks = seq(1980, 2024, by = 5)) +
  labs(
    title = "Trend Analysis of Atmospheric CO2 Levels at Cape Grim (1980–2024)",
    x = "Year",
    y = "CO2 Concentration (ppm)"
  ) +
  theme_minimal()

# Linear regression ----
model <- lm(`CO2(ppm)` ~ Year, data = co2_clean)
summary(model)

# Decadal Plot ----
co2_clean$Decade <- paste0(floor(co2_clean$Year/10)*10, "s")

decade_mean <- co2_clean %>%
  group_by(Decade) %>%
  summarise(mean_co2 = mean(`CO2(ppm)`))

ggplot(decade_mean, aes(x = Decade, y = mean_co2, fill = Decade)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Average Atmospheric CO2 by Decade",
    x = "Decade",
    y = "Average CO2 (ppm)"
  ) +
  theme_minimal()

# Annual Average Plot ----
annual_co2 <- co2_clean %>%
  group_by(Year) %>%
  summarise(mean_co2 = mean(`CO2(ppm)`))

ggplot(annual_co2, aes(x = Year, y = mean_co2)) +
  geom_line() +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(
    title = "Annual Average Atmospheric CO2 Concentration",
    x = "Year",
    y = "Average CO2 (ppm)"
  ) +
  theme_minimal()

# Annual and decadal growth rate plot ----
co2_clean$Decade <- floor(co2_clean$Year / 10) * 10

# Calculate Annual Growth Rate Mean ----
annual_growth <- co2_clean %>%
  group_by(Year, Decade) %>%
  summarise(growth_rate = mean(`GR(ppm/yr)`, na.rm = TRUE))

# Calculate Decadal Mean ----
decade_avg <- annual_growth %>%
  group_by(Decade) %>%
  summarise(avg_growth = mean(growth_rate))

# Plot ----
library(ggplot2)

ggplot(annual_growth, aes(x = Year, y = growth_rate)) +
  
# Bar chart
  geom_col(fill = "#11A9CC") +
  
# Red horizontal average lines
  geom_segment(
    data = decade_avg,
    aes(
      x = Decade,
      xend = Decade + 9,
      y = avg_growth,
      yend = avg_growth
    ),
    color = "red",
    linewidth = 1.2
  ) +
  
# Red ppm labels
  geom_text(
    data = decade_avg,
    aes(
      x = Decade + 4.5,
      y = avg_growth + 0.08,
      label = paste0(round(avg_growth, 2), " ppm")
    ),
    color = "black",
    fontface = "bold",
    size = 4,
    bg.color = "red"
  ) +
  
  labs(
    title = "Annual and Decadal Growth Rates for Carbon Dioxide (CO2)",
    x = "Year",
    y = "Parts per million per year"
  ) +
  
  theme_minimal(base_size = 14)


