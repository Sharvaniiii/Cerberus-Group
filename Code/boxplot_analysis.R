#Prelim plot

library(tidyverse)

cape <- read_csv("Original Dataset.csv", skip = 24, show_col_types = FALSE)

cape <- cape %>%
  slice(1:597) 

cape <- cape %>%
  rename(
    
    Year = YYYY,
    Month = MM,
    Day = DD,
    DateDecimal = DATE,
    CO2 = `CO2(ppm)`,
    SD = `SD(ppm)`,
    GrowthRate = `GR(ppm/yr)`
    
  )

cape$Year <- as.numeric(cape$Year)
cape$Month <- as.numeric(cape$Month)
cape$CO2 <- as.numeric(cape$CO2)

cape <- cape %>%
  
  filter(Year >= 1980 & Year <= 2024)

cape <- cape %>%
  mutate(
    Time = Year + (Month - 1) / 12,
    Decade = paste0(floor(Year / 10) * 10, "s")
  )

# Calculate median CO2 for each decade
decade_medians <- cape %>%
  group_by(Decade) %>%
  summarise(
    Median_CO2 = median(CO2, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(cape, aes(x = Decade, y = CO2, fill = Decade)) +
  geom_boxplot(
    color = "black",
    linewidth = 0.4,
    outlier.shape = 16,
    outlier.size = 1.5,
    alpha = 0.8
  ) +
  stat_summary(
    fun = mean,
    geom = "point",
    shape = 23,
    size = 1.5,
    fill = "white",
    color = "black"
  ) +
  geom_text(
    data = decade_medians,
    aes(
      x = Decade,
      y = Median_CO2,
      label = paste0(round(Median_CO2, 2), " ppm")
    ),
    vjust = -0.7,
    size = 2.2,
    fontface = "bold"
  ) +
  scale_fill_brewer(palette = "GnBu") +
  labs(
    title = expression("Distribution of Atmospheric CO"[2]*" Concentration by Decade at Cape Grim"),
    x = "Decade",
    y = expression("Monthly CO"[2]*" concentration (ppm)"),
    caption = "Centre line = median; box = interquartile range (IQR); white diamond = mean."
  ) +
  theme_bw() 

decade_summary <- cape %>%
  group_by(Decade) %>%
  summarise(
    `Median CO2 (ppm)` = round(median(CO2, na.rm = TRUE), 2),
    `Q1 CO2 (ppm)` = round(quantile(CO2, 0.25, na.rm = TRUE), 2),
    `Q3 CO2 (ppm)` = round(quantile(CO2, 0.75, na.rm = TRUE), 2),
    `IQR (ppm)` = round(IQR(CO2, na.rm = TRUE), 2),
    .groups = "drop"
  )

decade_summary
