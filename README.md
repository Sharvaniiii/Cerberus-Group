# Trend Analysis of Atmospheric Carbon Dioxide Levels at Cape Grim (1980–2024)
## Project Overview
This project investigates long-term atmospheric carbon dioxide trends at Cape Grim, Tasmania, using data collected between 1980 and 2024. Statistical and exploratory data analysis techniques were used to identify trends, growth patterns, and changes in carbon dioxide concentration over time.
## Group Members
- Sharvani Nepal (A3190285)
- Rinnah Intac (A3198435)
- Sumudumalee Abeysundara (A3191197)
- Krich Thachaila (A3201612)
- Nishant Teli (A3011300)
- Hritik Patil (A3010755)
## Dataset Source
CSIRO Cape Grim Greenhouse Gas Data  
https://www.csiro.au/greenhouse-gases/
## Repository Structure
- `Dataset/` → Original dataset files
- `Code/` → R scripts used for cleaning and analysis
- `Outputs/` → Graphs and visualisations generated from the analysis
- `Report/` → Final project report
## Methods Used
- Data cleaning and filtering
- Scatter plot with regression analysis
- Side-by-side boxplot analysis by decade
- Bar chart analysis
## Software Used
- RStudio
- ggplot2
- GitHub
- tidyverse
## How to run the analysis
1. Download the dataset `Original Dataset.csv`.
2. Save the dataset in the `Dataset/` folder as:
   `Dataset/Original Dataset.csv`
3. Open `Code/main_analysis.R` in RStudio.
4. Make sure the working directory is set to the main project folder.
5. Run the script from top to bottom.
6. The figures and tables will be saved in the `Outputs/` folder.

The script reproduces all figures and tables used in the final report.

Optional: Run individual analysis files

The analysis can also be run one plot at a time using the individual R scripts in the `Code/` folder:
- `growth_rate_analysis.R` reproduces the annual and decadal CO₂ growth-rate plot.
- `regression_analysis.R` reproduces the long-term CO₂ trend and linear regression results.
- `boxplot_analysis.R` reproduces the side-by-side boxplot and decadal summary table.

To run an individual analysis file, open the relevant script in RStudio and run it from top to bottom. Make sure the dataset is stored in the Dataset/ folder before running the script.
