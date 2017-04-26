# Main script to extract and save the data of a country, selecting  component(s) and sample period(s).
# It saves the data in .Rdata and .csv files in the path_save_files directory, defined in CTT_FILES.R
# 
# Author: Joanna Rodríguez
# e-mail: jrodriguez@keedio.com


library(NCmisc)
library(parallel)
library(foreach)
library(doParallel)
library(readr)
require(Hmisc)
library(lubridate)
library(pryr)
library(zoo)

source("CTT_FILES.R") # constant variables

# Load functions
source("load_functions_day_hour_par.R") # Get raw day and hour data
source("function_extract_CT_data.R") # Extract data
source("function_chop_fill_CT_data.R") # Chop and fill/not fill data

# Move to source directory
setwd(path_root_files)

# Select country, component(s) and sample period(s)
x <- menu(c("BELGIUM", "SWITZERLAND", "CZECH REPUBLIC ", "GERMANY", "SPAIN",
            "FRANCE","ITALY","NETHERLANDS","POLAND","PORTUGAL"),
          title="Select a country (by number)")
sel_ct <- country[x]
sel_comp <- select.list(comp_common,
                        multiple = TRUE,
                        title = "Select component(s) (by number)")
sample_period <- select.list(c("hour", "day"),
                             multiple = TRUE,
                             title = "Select sample period(s) (by number)")
comp_index <- match(sel_comp,comp_common) 

# Extract data
CT_data_raw <- extract_CT_data(comp_common, comp_code, sel_ct, sel_comp, sample_period)

# Clean, chop and fill data sets 
fill <- 1 # 0 not to fill, 1 to fill

# List initializations
if (length(sample_period) == 1) {
  if (sample_period == "hour") {
    CT_ts_hour_comp <- list()
  }
  if (sample_period == "day") {
    CT_ts_day_comp <- list()
  }
} else {
  CT_ts_hour_comp <- list()
  CT_ts_day_comp <- list()
}

# Populate lists based on thresholds dateX_{h,d}
for (i in comp_index) {
  print(i)
  if (i == 1) {date_h = date1_h; date_d = date1_d}
  if (i == 2) {date_h = date2_h; date_d = date2_d}
  if (i == 3) {date_h = date3_h; date_d = date3_d}
  if (i == 4) {date_h = date4_h; date_d = date4_d}
  if (i == 5) {date_h = date5_h; date_d = date5_d}
  if (i == 6) {date_h = date6_h; date_d = date6_d}
  
  # Select sample period
  if (length(sample_period) == 1) {
    if (sample_period == "hour") {
      CT_ts_hour_comp[[i]] <- chop_fill_data(CT_data_raw$ts_hour[[i]], date_h, fill)
    }
    if (sample_period == "day") {
      CT_ts_day_comp[[i]] <- chop_fill_data(CT_data_raw$ts_day[[i]], date_d, fill)
    }
  } else {
    CT_ts_hour_comp[[i]] <- chop_fill_data(CT_data_raw$ts_hour[[i]], date_h, fill)
    CT_ts_day_comp[[i]] <- chop_fill_data(CT_data_raw$ts_day[[i]], date_d, fill)
  }
}

# Create country variables
country_name <- paste(sel_ct, "_data_raw", sep = "")

if (length(sample_period) == 1) {
  if (sample_period == "hour") {
    hour_comp_name <- paste(sel_ct, "_hour_comp", sep = "")
  }
  if (sample_period == "day") {
    day_comp_name <- paste(sel_ct, "_day_comp", sep = "")
  }
} else {
  hour_comp_name <- paste(sel_ct, "_hour_comp", sep = "")
  day_comp_name <- paste(sel_ct, "_day_comp", sep = "")
}

# Assign values to the country variables
assign(country_name, CT_data_raw)

if (length(sample_period) == 1) {
  if (sample_period == "hour") {
    assign(hour_comp_name, CT_ts_hour_comp)
  }
  if (sample_period == "day") {
    assign(day_comp_name, CT_ts_day_comp)
  }
} else {
  assign(hour_comp_name, CT_ts_hour_comp)
  assign(day_comp_name, CT_ts_day_comp)
}

# Move to destination directory
setwd(path_save_files)

#Save the country information into an identifying .Rdata
if (length(sample_period) == 1) {
  if (sample_period == "hour") {
    temp <- as.character(c(country_name, hour_comp_name))
  }
  if (sample_period == "day") {
    temp <- as.character(c(country_name, day_comp_name))
  }
} else {
  temp <- as.character(c(country_name, hour_comp_name, day_comp_name))
}

save(list = temp, file = paste(sel_ct, "_data.Rdata", sep = ""))

# Save hour and day information into an identifying .csv
for (i in comp_index){
  if (length(sample_period) == 1) {
    if (sample_period == "hour") {
      file <- paste(CT_ts_hour_comp, "_ts_", sample_period, "_C", i, ".csv", sep = "")
      write.table(CT_ts_hour_comp[[i]], file, sep = ",", row.names = F)
    }
    if (sample_period == "day") {
      file <- paste(sel_ct, "_ts_", sample_period, "_C", i, ".csv", sep = "")
      write.table(CT_ts_day_comp[[i]], file, sep = ",", row.names = F)
    }
  } else {
    file_h <- paste(sel_ct, "_ts_", sample_period[1], "_C", i, ".csv", sep = "")
    file_d <- paste(sel_ct, "_ts_", sample_period[2], "_C", i, ".csv", sep = "")
    write.table(CT_ts_hour_comp[[i]], file_h, sep = ",", row.names = F)
    write.table(CT_ts_day_comp[[i]], file_d, sep = ",", row.names = F)
  }
}

# Move to source directory
setwd(path_root_files)


