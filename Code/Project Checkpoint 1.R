
# Load required library
library(ggplot2)

# Import dataset
data <- read.csv("CO2 data.csv", skip = 30, header = FALSE)

# Rename columns for clarity
colnames(data) <- c("Year", "Month", "Day", "DecimalDate", "CO2", "sd", "extra", "type")

#Filter data by year from 1980 to 2025
co2_filtered_data <- subset(data, Year >= 1980 & Year <= 2024)

# Remove rows where 'Year' is not purely numeric
# (This cleans out unwanted text/metadata rows from the dataset)
data <- data[grepl("^[0-9]+$", data$Year), ]

# Convert 'Year' column from character (text) to numeric
# Required for proper analysis and plotting
data$Year <- as.numeric(data$Year)

# Convert 'DecimalDate' to numeric
# Ensures smooth time-series plotting on the x-axis
data$DecimalDate <- as.numeric(data$DecimalDate)

# Convert 'CO2' values to numeric
# Needed because plotting functions require numeric data
data$CO2 <- as.numeric(data$CO2)

# View first few rows (optional check)
head(data)

# Plot CO2 trend over time
# Using DecimalDate for smooth continuous timeline
ggplot(co2_filtered_data, aes(x = DecimalDate, y = CO2)) +
  geom_line(color = "green") +
  labs(
    title = "Trend Analysis of Atmospheric Carbon Dioxide Levels at  
Cape Grim (1980–2024)",
    x = "Year",
    y = "Carbon Dioxide Concentration (ppm)"
  ) +
  theme_minimal()
