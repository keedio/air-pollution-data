# air-pollution-data
Scripts to process the Air Pollution Database of the European Environment Agency

Author: Joanna Rodríguez

List of files:

* CTT_FILES.R -- define the global constants that are to be used in the AirBase_CT_data.R script.
* AirBase_CE_data.R -- main script to extract and save the data of a country, selecting  component(s) and sample period(s).
* fuction_extract_CT_data.R -- extracts the time series rawdata of a country, from the selected information. This function is included in the main script AirBase_CE_data.R.
* load_functions_day_hour_par.R -- extracts day and hour rawdata of a country. This function is included in the fuction_extract_CT_data.R script.
* function_chop_fill_CT_data.R -- this function chops and fills (or not) the extracted datasets from a selected time period.

* shiny-per-country:
  app_BE.R, app_CH.R, app_CZ.R, app_DE.R, app_ES.R, app_FR.R, app_IT.R, app_NL.R, app_PL.R, app_PT.R -- shiny app with dygraph plots for each country, number of observations vs. time period plots.
  
Please send any comments or bug to: 
jrodriguez@keedio.com or joanna.rodriguezcesar@gmail.com
