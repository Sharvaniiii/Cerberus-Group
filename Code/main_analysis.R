# This is a file for all plots for the Reasearch Article Project
# Cerberus Group
# Group project - EDA

# Install package ----
library(tidyverse)

# Load data ----
co2 <- read_csv("Original Dataset.csv", skip = 24, show_col_types = FALSE)



# Clean and filter data ----
co2 <- co2 %>%
  slice(1:597) 
co2_clean <- co2 %>%
  rename(Year = YYYY,
         Month = MM,
         Day = DD,
         DateDecimal = DATE,
         CO2 = `CO2(ppm)`,
         SD = `SD(ppm)`,
         GrowthRate = `GR(ppm/yr)`
         )

co2_clean$Year <- as.numeric(co2_clean$Year)
co2_clean$Month <- as.numeric(co2_clean$Month)
co2_clean$CO2 <- as.numeric(co2_clean$CO2)

co2_clean <- co2_clean %>%
  filter(Year >= 1980 & Year <= 2024)

# Plot the data ----

# Scatter Plot ----
ggplot(co2_clean, aes(x = Year, y = `CO2`)) +
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
model <- lm(`CO2` ~ Year, data = co2_clean)
summary(model)

# Decadal Plot ----
co2_clean$Decade <- paste0(floor(co2_clean$Year/10)*10, "s")

decade_mean <- co2_clean %>%
  group_by(Decade) %>%
  summarise(mean_co2 = mean(`CO2`))

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
  summarise(mean_co2 = mean(`CO2`))

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
  summarise(growth_rate = mean(`GrowthRate`, na.rm = TRUE))

# Calculate Decadal Mean ----
decade_avg <- annual_growth %>%
  group_by(Decade) %>%
  summarise(avg_growth = mean(growth_rate))

# Plots ----
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

# Box Plot ----

# Create decade groups
co2_clean <- co2_clean %>%
  mutate(
    Decade = case_when(
      Year >= 1980 & Year < 1990 ~ "1980s",
      Year >= 1990 & Year < 2000 ~ "1990s",
      Year >= 2000 & Year < 2010 ~ "2000s",
      Year >= 2010 & Year < 2020 ~ "2010s",
      Year >= 2020 ~ "2020s"
    )
  )

# Set decade order
co2_clean$Decade <- factor(
  co2_clean$Decade,
  levels = c("1980s", "1990s", "2000s", "2010s", "2020s")
)

# Calculate medians
decade_medians <- co2_clean %>%
  group_by(Decade) %>%
  summarise(
    Median_CO2 = median(`CO2`, na.rm = TRUE),
    .groups = "drop"
  )

# Boxplot
ggplot(co2_clean,
       aes(x = Decade,
           y = `CO2`,
           fill = Decade)) +
  
  geom_boxplot(
    color = "black",
    linewidth = 0.5,
    width = 0.7,
    outlier.shape = 16,
    outlier.size = 1.5,
    alpha = 0.8
  ) +
  
  # Mean diamond
  stat_summary(
    fun = mean,
    geom = "point",
    shape = 23,
    size = 2,
    fill = "white",
    color = "black"
  ) +
  
  # Median labels
  geom_text(
    data = decade_medians,
    aes(
      x = Decade,
      y = Median_CO2 + 2,
      label = paste0(round(Median_CO2, 2), " ppm")
    ),
    size = 3,
    fontface = "bold"
  ) +
  
  scale_fill_brewer(palette = "GnBu") +
  
  labs(
    title = expression("Distribution of Atmospheric CO"[2]*" Concentration by Decade at Cape Grim"),
    x = "Decade",
    y = expression("Monthly CO"[2]*" concentration (ppm)"),
    caption = "Centre line = median; box = interquartile range (IQR); white diamond = mean."
  ) +
  
  theme_bw(base_size = 13) +
  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.caption = element_text(hjust = 0.5, size = 9),
    panel.grid.minor = element_blank()
  )

# Summary Median,IQR, Q1, Q3
decade_summary <- co2_clean %>%
  group_by(Decade) %>%
  summarise(
    `Median CO2 (ppm)` = round(median(CO2, na.rm = TRUE), 2),
    `Q1 CO2 (ppm)` = round(quantile(CO2, 0.25, na.rm = TRUE), 2),
    `Q3 CO2 (ppm)` = round(quantile(CO2, 0.75, na.rm = TRUE), 2),
    `IQR (ppm)` = round(IQR(CO2, na.rm = TRUE), 2),
    .groups = "drop"
  )

decade_summary
