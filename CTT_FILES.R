# 
# Define the global constants that are to be user in the AirBase_CD_data.R script.
# These are: 
# 1. Directory paths: root path and where to save the files
# 2. Selected information variables: countries and common components
# 3. Time interval to chop the datasets
# 
# Author: Joanna Rodríguez
# e-mail: jrodriguez@keedio.com

# Directory paths
path_root_files = "/data"
path_save_files = "/data/DataSets/DataSetsFinal"

# Variables
comp_common = c("Sulphur dioxide (air)", "Particulate matter < 10 µm (aerosol)",
                "Nitrogen dioxide (air)", "Benzene (air)",
                "Carbon monoxide (air)", "Ozone (air)")
comp_code = c("00001", "00005", "00008", "00020", "00010", "00007")
country = c("BE","CH","CZ","DE","ES","FR","IT","NL","PL","PT")


# Previously selected hours
date1_h = as.POSIXct(paste("2005-01-01",'0:00'), tz="UTC")
date2_h = as.POSIXct(paste("2006-01-01",'1:00'), tz="UTC")
date3_h = as.POSIXct(paste("2003-01-01",'0:00'), tz="UTC")
date4_h = as.POSIXct(paste("2006-01-01",'0:00'), tz="UTC")
date5_h = as.POSIXct(paste("2002-01-01",'0:00'), tz="UTC")
date6_h = as.POSIXct(paste("2004-01-01",'0:00'), tz="UTC")

# Previously selected days
date1_d = as.Date("2004-01-01")
date2_d = as.Date("2005-01-01")
date3_d = as.Date("2003-01-01")
date4_d = as.Date("2005-01-01")
date5_d = as.Date("2002-01-01")
date6_d = as.Date("2003-01-01")

