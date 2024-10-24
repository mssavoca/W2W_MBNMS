## Util file for pre-load for all analyses


#Load packages
library(tidyverse)
library(readxl)


# Define a custom color palette
custom_palette <- c(
  "fiber" = "#E69F00",      # Orange
  "fragment" = "#56B4E9",   # Light Blue
  "film" = "#009E73",       # Green
  "nurdle" = "#F0E442",     # Yellow
  "foam" = "#0072B2",       # Dark Blue
  "other" = "#D55E00"       # Red (for any unexpected categories)
)

custom_color_palette <- c(
  "blue" = "blue",
  "clear" = "#e0e0e0", 
  "black" = "#000000",
  "red" = "#ff0000",
  "brown" = "#8b4513",
  "white" = "#ffffff",
  "green" = "green4"
)

# read in and combine optical microscopy data----

Opt_micro_river_summ <- read_xlsx("5,000-500 um river sample data_10.19.24.xlsx")
Opt_micro_river_dets <- read_xlsx("5,000-500 um river sample data_10.19.24.xlsx", sheet = 2)

Opt_micro_beach_summ <- read_xlsx("5,000-500 um beach sample data_10.19.24.xlsx")
Opt_micro_beach_dets <- read_xlsx("5,000-500 um beach sample data_10.19.24.xlsx", sheet = 2)

Opt_micro_ocean_summ <- read_xlsx("5,000-500 um seawater sample data_10.19.24.xlsx")
Opt_micro_ocean_dets <- read_xlsx("5,000-500 um seawater sample data_10.19.24.xlsx", sheet = 2)

Opt_micro_lab_blanks_summ <- read_xlsx("LabBlanks_10.19.24.xlsx")
Opt_micro_lab_blanks_dets <- read_xlsx("LabBlanks_10.19.24.xlsx", sheet = 2)


# read in and combine FTIR data----

# Set the folder path
folder_path_part_dets <- "Particle details from MIPPR_10.19.24/"

# List all CSV files in the folder
csv_files <- list.files(path = folder_path_part_dets, pattern = "*.csv", full.names = TRUE)

# Loop through and read all CSVs, then combine them into one dataframe
combined_data_part_dets <- do.call(rbind, lapply(csv_files, function(file) {
  read.csv(file, stringsAsFactors = FALSE)  # Read each CSV
}))

combined_data_part_dets <- combined_data_part_dets %>%
  mutate(sample_num = substr(sample_id, 6,7), 
         sample_num = ifelse(sample_num == "2_", "02", sample_num),
           mutate(material_simple = case_when(
    material_class == "other plastic" ~ "plastic",  # Rename "other plastic" to "plastic"
    str_detect(material_class, "poly") ~ "plastic",  # Any material class containing "poly" gets renamed to "plastic"
    TRUE ~ material_class  # Keep other levels the same
  )))


# Set the folder path
folder_path_part_summ <- "Particle summary from MIPPR_10.19.24/"

# List all CSV files in the folder
csv_files <- list.files(path = folder_path_part_summ, pattern = "*.csv", full.names = TRUE)

# Loop through and read all CSVs, then combine them into one dataframe
combined_data_part_summ <- do.call(rbind, lapply(csv_files, function(file) {
  read.csv(file, stringsAsFactors = FALSE)  # Read each CSV
}))

combined_data_part_summ <- combined_data_part_summ %>%
  mutate(sample_num = substr(sample_id, 6,7), 
  sample_num = ifelse(sample_num == "2_", "02", sample_num)) %>% 
  mutate(material_simple = case_when(
    material_class == "other plastic" ~ "plastic",  # Rename "other plastic" to "plastic"
    str_detect(material_class, "poly") ~ "plastic",  # Any material class containing "poly" gets renamed to "plastic"
    TRUE ~ material_class  # Keep other levels the same
  ))
