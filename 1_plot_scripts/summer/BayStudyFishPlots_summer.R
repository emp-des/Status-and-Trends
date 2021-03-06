# Summer 2018 Seasonal Monitoring Report
# Purpose: Create plots of Northern Anchovy CPUE from the Bay Study dataset
# Author: Dave Bosworth

# Load packages
library(readxl)
library(lubridate)
library(scales)


# 1. Import Data ----------------------------------------------------------
# Dataset is on SharePoint site for the Seasonal Monitoring Report

# Define path on SharePoint site for data
#sharepoint_path <- normalizePath(
#  file.path(
#    Sys.getenv("USERPROFILE"),
#    "California Department of Water Resources/IEP Synthesis Projects - Documents/Data"
#  )
#)  

# Import fish data
#load(file = file.path(sharepoint_path, "BayStudyFish.RData"))


#if that didin't work
load(file = file.path("data","BayStudyFish.RData"))


# 2. Clean Data and Calculate CPUE ----------------------------------------

# Clean and modify midwater_trawl_data df
noranc <- midwater_trawl_data %>% 
  select(Year:ChanShoal, TowVolume, NORANC) %>% 
  # Used Survey = 6, 7, 8 instead of month to include complete dataset
  filter(Survey >= 6 & Survey <= 8) %>% 
  # Remove data for years with partial surveys
  filter(!Year %in% c(1995, 2014, 2016, 2017)) %>% 
  # Only include series 1 stations in plots
  filter(Series == 1)

# Calculate CPUE values & average them for each year
noranc_cpue <- noranc %>% 
  mutate(cpue = (NORANC/TowVolume) * 10000) %>% 
  group_by(Year) %>% 
  summarize(ave_cpue = mean(cpue)) %>% 
  ungroup() 


# 3. Set up options for plots ---------------------------------------------

# Calculate long-term average of CPUE
lt_avg_cpue <- mean(noranc_cpue$ave_cpue)

# Create dataframes for text comments on plots
noranc_text_h <- tibble(
  Year = 1966,
  yValue = 40,
  label = "Data were not\ncollected until 1980"
)

# 4. Create Plots ---------------------------------------------------------

# Plot for all years
noranc_plot_all <- noranc_cpue %>% 
  ggplot(
    aes(
      x = Year,
      y = ave_cpue
    )
  ) +
  geom_col() +
  # apply custom theme
  smr_theme() +
  # customize axis labels
  ylab(expression(paste("Average CPUE (fish/10,000m"^{3}, ")"))) +
  # define y-axis breaks and add thousanths comma
smr_y_axis()+
  # add horizontal line for long-term average CPUE
  stat_lt_avg()+
  # standardize x-axis
  smr_x_axis(report_year, type = "all", season = "summer")+
  # add markers for missing data
 stat_missing() +
  # add horizontal text to plot
  geom_text(
    data = noranc_text_h,
    aes(
      x = Year,
      y = yValue,
      label = label
    ),
    inherit.aes = FALSE,
    hjust = "left",
    size = 1.9
  )

# Plot for recent years (15 years from report date)
noranc_plot_rec <- noranc_cpue %>%
  ggplot(
    aes(
      x = Year,
      y = ave_cpue
    )
  ) +
  geom_col() +
  # apply custom theme
  smr_theme() +
  # customize axis labels
  ylab(expression(paste("Average CPUE (fish/10,000m"^{3}, ")"))) +
  smr_x_axis(report_year, type = "recent", season = "summer")+
  # custom y-axis breaks
  scale_y_continuous(breaks = seq(0, 700, by = 100)) +
  # add horizontal line for long-term average CPUE
  stat_lt_avg()+
  stat_missing()


# Print Plots
  # Plot for all years
  ggsave(
    plot = noranc_plot_all,
    filename = file.path(fig_root_summer,"noranc_all_years.png"),
    dpi = 300,
    units = "cm",
    width = 9.3,
    height = 6.8
  )

  ggsave(
    plot = noranc_plot_all,
    filename = file.path(fig_root_summer,"noranc_all_years.png"),
    dpi = 300,
    units = "cm",
    width = 9.3,
    height = 6.8
  )
  
  
  # Plot for recent years
  ggsave(
    plot = noranc_plot_rec,
    filename = file.path(fig_root_summer,"noranc_rec_years.png"),
    dpi = 300,
    units = "cm",
    width = 9.3,
    height = 6.8
  )

