## Preliminary Plot


library(tidyverse)

cape <- read_csv("Original Dataset.csv", skip = 24,show_col_types = FALSE)
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
ggplot(cape, aes(x = Decade, y = CO2, fill = Decade)) +
  geom_boxplot(color = "black", linewidth = 0.4) +
  scale_fill_brewer(palette = "GnBu") +
  labs(
    title = expression("Atmospheric CO"[2]*" Concentration by Decade at Cape Grim"),
    x = "Decade",
    y = expression("CO"[2]*" (Parts per million)")
  ) +
  theme_bw() 

