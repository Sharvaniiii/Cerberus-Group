
# Load library
library(tidyverse)
library(readxl)
library(ggplot2)

# Import dataset
CO2_data <- read_excel("Data Set CO2 Cape Grim.xlsx")

# Plot CO2 concentration over time
ggplot(CO2_data, aes(x = Year, y = CO2)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Trend of Atmospheric CO2 Concentration Over 40 Years",
       x = "Year",
       y = "CO2 Concentration (ppm)") +
  theme_bw()
