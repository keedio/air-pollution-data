extract_CT_data <- function(comp_common,comp_code,sel_ct,sel_comp,sample_period){
  
  # Extracts a country's rawdata, based on the selected components and sample periods
  #
  # Args:
  #   comp_common:  common components to all the countries.
  #   comp_code: common components codes based on the AirBase literature.
  #   sel_ct: country to which the data is to be extracted
  #   sel_comp: selected components to extract
  #   sample_period: selected sample period to extract
  #
  # Returns:
  #   List containing the selected components to extract and the data extracted:
  #     ts_day is a list of data frames, where each data frame corresponds to
  #     all the extracted time series data for the selected components. Analogously, ts_hour.
  #   That is,
  #   Returns:
  #   list(comp = sel_comp, ts_day = ts_day_comp, ts_hour = ts_hour_comp)
  # 
  # Author: Joanna Rodríguez
  # e-mail: jrodriguez@keedio.com
  
  comp_index <- match(sel_comp,comp_common)
  
  prefix1 <- "./AirBase_"
  prefix2 <- "_v6/AirBase_"
  prefix3 <- "_v6_statistics.csv"
  prefix4 <- "_v6_rawdata/"
  
  CT_file <- paste(prefix1, sel_ct, prefix2, sel_ct, prefix3, sep = "")
  CT_raw_files <- paste(prefix1, sel_ct, prefix2, sel_ct, prefix4, sep = "")
  CT_stat <- read_delim(CT_file, "\t", escape_double = FALSE,
                        trim_ws = TRUE, col_types = cols())
  
  CT_stat_p <- CT_stat[which(CT_stat$component_name %in% sel_comp), ] 
  CT_stat_p <- CT_stat_p[which(CT_stat_p$statistic_shortname %in% "P50"), ]
  
  setwd(CT_raw_files)
  file_names <- list.files()
  day_file_names <- file_names[grep("day",file_names)]
  hour_file_names <- file_names[which(substr(file_names, start = 18, stop = 22) == "hour.")]
  
  # Initilize lists
  if (length(sample_period) == 1) {
    if (sample_period == "hour") {
      ts_hour_comp <- list()
    }
    if (sample_period == "day") {
      ts_day_comp <- list()
    }
  } else {
    ts_hour_comp <- list()
    ts_day_comp <- list()
  }
  
  # Populate list component by component
  for (i in comp_index) {
    CT_stat_comp <- CT_stat_p[which(CT_stat_p$component_name %in% comp_common[i]), ]
    format_comp <- split.data.frame(CT_stat_comp, CT_stat_comp$statistics_average_group)
    
    stations_hour_comp <- unique(format_comp$hour[,1])
    stations_day_comp <- unique(format_comp$day[,1])
    
    if (length(sample_period) == 1) {
      if (sample_period == "hour") {
        if (is.null(stations_hour_comp) == TRUE) {
          ts_hour_comp[[i]] = NULL
        } else {
          hour_file_names_comp <- hour_file_names[
            which(substr(hour_file_names, start = 1, stop = 7)
                  %in%
                    stations_hour_comp[['station_european_code']])] #station name

          hour_file_names_comp <- hour_file_names_comp[
            which(substr(hour_file_names_comp, start = 8, stop = 12) == comp_code[i])] # component_code
          
          print(c(i,"h"))
          ts_hour_comp[[i]] <- get_hour_matrix(hour_file_names_comp)
        }
      }
      if (sample_period == "day") {
        if (is.null(stations_day_comp) == TRUE) {
          ts_day_comp[[i]] = NULL
        } else {
          day_file_names_comp <- day_file_names[
            which(substr(day_file_names, start = 1, stop = 7)
                  %in%
                    stations_day_comp[['station_european_code']])] #station name

          day_file_names_comp <- day_file_names_comp[
            which(substr(day_file_names_comp, start = 8, stop = 12) == comp_code[i])] # component_code
          
          print(c(i,"d"))
          ts_day_comp[[i]] <- get_day_matrix(day_file_names_comp)
        }
      }
    } else {
      if (is.null(stations_hour_comp) == TRUE) {
        ts_hour_comp[[i]] = NULL
      } else {
        hour_file_names_comp <- hour_file_names[
          which(substr(hour_file_names, start = 1, stop = 7)
                %in%
                  stations_hour_comp[['station_european_code']])] #station name

        hour_file_names_comp <- hour_file_names_comp[
          which(substr(hour_file_names_comp, start = 8, stop = 12) == comp_code[i])] # component_code
        
        print(c(i,"h"))
        ts_hour_comp[[i]] <- get_hour_matrix(hour_file_names_comp)
      }
      
      if (is.null(stations_day_comp) == TRUE) {
        ts_day_comp[[i]] = NULL
      } else {
        day_file_names_comp <- day_file_names[
          which(substr(day_file_names, start = 1, stop = 7)
                %in%
                  stations_day_comp[['station_european_code']])] #station name

        day_file_names_comp <- day_file_names_comp[
          which(substr(day_file_names_comp, start = 8, stop = 12) == comp_code[i])] # component_code
        
        print(c(i,"d"))
        ts_day_comp[[i]] <- get_day_matrix(day_file_names_comp)
      }
    }
  }
  
  if (length(sample_period) == 1) {
    if (sample_period == "hour") {
      ret <- list(comp = sel_comp, ts_hour = ts_hour_comp)
    }
    if (sample_period == "day"){
      ret <- list(comp = sel_comp, ts_day = ts_day_comp)
    }
  } else {
    ret <- list(comp = sel_comp, ts_day = ts_day_comp, ts_hour = ts_hour_comp)
  }
  return(ret)
}