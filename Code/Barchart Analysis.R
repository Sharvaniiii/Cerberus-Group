
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

co2_data <- read_csv(
  "Original Dataset.csv",
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
co2_filtered$YYYY <- as.numeric(co2_filtered$YYYY)
head(co2_filtered)

# Decadal Plot ----
co2_filtered$Decade <- paste0(floor(co2_filtered$YYYY/10)*10, "s")


# Calculate Annual Growth Rate Mean ----
co2_yearly <- co2_filtered %>%
  group_by(YYYY, Decade) %>%
  summarise(growth_rate = mean(`GR(ppm/yr)`, na.rm = TRUE))

# Calculate Decadal Mean ----
decade_avg <- co2_yearly %>%
  group_by(Decade) %>%
  summarise(avg_growth = mean(growth_rate))

# Plots ----
decade_avg <- decade_avg %>%
  mutate(
    Decade = as.numeric(str_sub(Decade, 1, 4))
  ) 
ggplot(co2_yearly, aes(x = YYYY, y = growth_rate)) +
  
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
