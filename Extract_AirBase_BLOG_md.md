IN THIS [POST](https://www.keedio.org/air-pollution-data/) WE ANALIZE A WAY TO GENERATE A DATASET IN A FORMAT THAT FACILITATES THE TEMPORAL REPRESENTATION OF THE AIR QUALITY / AIR POLLUTION IN A REGION.

When local authorities release warnings or alerts on pollution levels, media highlights the inefficient local policies on this regard or how many times it has happened recently. One will surely remember the fact that one's car was diverted and could not enter a certain area, but after a few days, everyone will forget about the pollution levels attained, the pollutants responsible for it and where were the concentration areas.

See for example Beijing, an average day in the city, whose air quality index (AQI) is about 160/500, which is not good and rated as unhealthy. In 2015, authorities [banned](http://www.upworthy.com/beijing-banned-cars-for-2-weeks-and-the-sky-turned-perfectly-blue-guess-what-happened-the-next-day) 2.5 million cars for two weeks prior to the 70th anniversary of Japan's defeat in WWII. By the day of the celebrations, the AQI in the city of Beijing had dramatically improved, dropping to a whopping 17/500. The day after the celebrations, the AQI skyrocketed back to 160: it only took one day to have back its day-to-day unhealthy environment. This is an excellent example of how somber the situation is, yet how easily it can be changed and transformed into healthy conditions.

In KEEDIO, we thought that displaying the data available in this regard might be quite informative to the extent it was worth a blog post and it happens that the data was available out there in the [Air Pollution Database of the European Environment Agency](http://www.eea.europa.eu/data-and-maps/data/airbase-the-european-air-quality-database-6). No surprise is that the data had to go through an intense cleansing cicle since they came from different national agencies around Europe that had kept to different measuring protocols for 25 years. In this [blog post](https://www.keedio.org/air-pollution-data/), we display the air pollution maps of a number of chemical components in Europe with a particular focus on Spain. The overall process to get the data ready for plotting is also described since some decisions were made to ease visualization.

Achieving air quality levels that do not harm human health and the environment is one of the European Union's long-term objective. This objective is aimed through legislation, cooperation with sectors responsible for air pollution, as well as international, national and regional authorities and non-governmental organisations; and research.

#### **Data description.**

Let us summarize the **most relevant characteristics** of the data set:

-   197 components that measure/monitor the air quality in 38 european countries.
-   Sample periods: hour, hour8, week, 2week, 4week, day, dymax, month, 2month, 3month, year.
-   Time period: 1976 - 2010.
-   Important: the name, latitud and longitud of each station is available, they are unique and distinguishable.
-   Directory Hierarchy in each country dataset: &lt;country&gt;/&lt;stations-statistics-measurement configuration&gt;/rawdata.
    *rawdata: text files, each one representing 1 time series of data*

A results framework is designed for achieving results in a reproducible way. That is, the steps we will follow to obtain a usable data set. The framework is as follows,

1.  Information-crossing process to select:
    -   Countries.
    -   Component(s).
    -   Sample Period(s).

2.  Extract the rawdata for the previous selection, per country.
3.  For each component and sample period, find the best time interval overlap, that is, select the data with the most observations.
4.  Chop the data based on the time intervals previously selected and give the option to fill the missing time series data.
5.  Save the obtained data in the next format: <span style="color:red">&lt;CT&gt;</span>\_ ts \_<span style="color:red">&lt;SP&gt;</span>\_C<span style="color:red">&lt;X&gt;</span>.csv
    -   <span style="color:red"> &lt;CT&gt; </span> = country initials.
    -   <span style="color:red"> &lt;SP&gt; </span> = sample period.
    -   <span style="color:red"> &lt;X&gt; </span> = component ID number.

#### **Getting the data ready for visualization.**

Let's see the **selected information** after crossing the available information.

In order to be able to represent a relevant region that collects around 60% of the air pollution data, we selected the following countries: **Germany, Italy, France, Spain, Poland, Belgium, Czech Republic, Netherlands, Portugal, Switzerland**. See Table 1.

------------------------------------------------------------------------

``` r
AB_countrycode <- read_excel("./country_codes.xls")
AB_countrycode$country_name <- toupper(AB_countrycode$country_name)
AB_countrycode$"%data" <- as.numeric(AB_countrycode$"%data")
kable(AB_countrycode[rev(order(AB_countrycode$`%data`)),][c("country_name", "%data", "#components")][1:15, ], align = c('l', 'c', 'c'), caption = "Table 1")
```

| country\_name  | %data | \#components |
|:---------------|:-----:|:------------:|
| GERMANY        | 23.36 |      55      |
| SPAIN          | 13.95 |      67      |
| ITALY          | 11.01 |      35      |
| FRANCE         | 10.75 |      17      |
| AUSTRIA        |  7.53 |      32      |
| UNITED KINGDOM |  6.60 |      105     |
| BELGIUM        |  3.80 |      67      |
| CZECH REPUBLIC |  3.45 |      15      |
| NETHERLANDS    |  3.09 |      85      |
| POLAND         |  2.94 |      60      |
| SWITZERLAND    |  1.90 |      19      |
| PORTUGAL       |  1.88 |      21      |
| ROMANIA        |  1.12 |      22      |
| GREECE         |  0.91 |      15      |
| FINLAND        |  0.85 |      48      |
| \*\*\*         |       |              |

The selected components gather around 72% of the air pollution data, these are: **Sulphur dioxide, Particulate matter &lt; 10 µm, Nitrogen dioxide, Benzene, Carbon monoxide** and **Ozone** (See Table 2.)

Let's provide a brief description of their health consequences,

-   Ozone (O**<sub>3</sub>). At ground level is one of the major constituents of photochemical smog. It irritates the airways of the lungs, increasing the symptoms of those suffering from asthma and lung diseases.
-   Sulphur dioxide (SO**<sub>2</sub>). Its emissions cause acid rain and generate fine dust. This dust is dangerous for human health, causing respiratory and cardiovascular diseases and reducing life expectancy in the EU by up to two years.
-   Nitrogen dioxide (NO**<sub>2</sub>). It can irritate the lungs and lower resistance to respiratory infections.
-   Particulate matter &lt; 10 µm (PM**<sub>10</sub>). It affects more people than any other pollutant. The fine particles can be carried deep into the lungs where they can cause inflammation and a worsening of the condition of people with heart and lung diseases.
-   Carbon monoxide (CO). High levels of carbon monoxide are poisonous to human. This gas prevents the normal transport of oxygen by the blood. This can lead to a significant reduction in the supply of oxygen to the heart, particularly in people suffering from heart disease.
-   Benzene (C**<sub>6</sub>H**<sub>6</sub>). Possible chronic health effects include cancer, central nervous system disorders, liver and kidney damage, reproductive disorders, and birth defects.

------------------------------------------------------------------------

``` r
# BELGIUM
BE_stat <- read_delim("./AirBase_BE_v6/AirBase_BE_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())

# CZECH REPUBLIC 
CZ_stat <- read_delim("./AirBase_CZ_v6/AirBase_CZ_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())

# FRANCE
FR_stat <- read_delim("./AirBase_FR_v6/AirBase_FR_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
  
# GERMANY
DE_stat <- read_delim("./AirBase_DE_v6/AirBase_DE_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
  
# ITALY
IT_stat <- read_delim("./AirBase_IT_v6/AirBase_IT_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
  
# NETHERLANDS
NL_stat <- read_delim("./AirBase_NL_v6/AirBase_NL_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
   
# POLAND
PL_stat <- read_delim("./AirBase_PL_v6/AirBase_PL_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
  
# PORTUGAL
PT_stat <- read_delim("./AirBase_PT_v6/AirBase_PT_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
  
# SPAIN
ES_stat <- read_delim("./AirBase_ES_v6/AirBase_ES_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())
  
# SWITZERLAND 
CH_stat <- read_delim("./AirBase_CH_v6/AirBase_CH_v6_statistics.csv", 
    "\t", escape_double = FALSE, trim_ws = TRUE, col_types = cols())

comp_BE <- unique(BE_stat$component_name)
comp_CZ <- unique(CZ_stat$component_name)
comp_FR <- unique(FR_stat$component_name)
comp_DE <- unique(DE_stat$component_name)
comp_IT <- unique(IT_stat$component_name)
comp_NL <- unique(NL_stat$component_name)
comp_PL <- unique(PL_stat$component_name)
comp_PT <- unique(PT_stat$component_name)
comp_ES <- unique(ES_stat$component_name)
comp_CH <- unique(CH_stat$component_name)

comp_common <- Reduce(intersect, list(comp_BE, comp_CZ, comp_FR, comp_DE, comp_IT, comp_NL, comp_PL, comp_PT, comp_ES, comp_CH))

AB_compcode <- read_csv("./AB_compcode.csv", col_types = cols())
AB_compcode$"%data" = as.numeric(AB_compcode$"%data")
AB_compcode$component_name <- gsub(" $","", AB_compcode$component_name, perl=T)

comp_data = AB_compcode[which(AB_compcode$component_name %in% comp_common),][c("component_name", "%data")]

#Filtrar
kable(comp_data[rev(order(comp_data$`%data`)),][c("component_name", "%data")], align = c('l', 'c'), caption = "Table 2")
```

| component\_name                          | %data |
|:-----------------------------------------|:-----:|
| Ozone (air)                              |  19.9 |
| Sulphur dioxide (air)                    |  16.9 |
| Nitrogen dioxide (air)                   |  16.5 |
| Particulate matter &lt; 10 µm (aerosol)  |  9.3  |
| Nitrogen oxides (air)                    |  8.4  |
| Carbon monoxide (air)                    |  8.2  |
| Benzene (air)                            |  1.4  |
| Particulate matter &lt; 2.5 µm (aerosol) |  1.0  |

------------------------------------------------------------------------

The selected sample periods are: **hour** and **day**, since they are the common sample periods for all the selected previous information.

In order to proceed with the following steps, which are

-   extracting the rawdata based on the previous selection,
-   find the best interval overlap,
-   chop the data based on the intervals,

we direct the reader to the ***AirBase\_CT\_data.R*** script. But first, we make reference to the *CTT\_FILES.R* file that it is at the beginning of the previously mentioned script.

In the *CTT\_FILES.R* file we define the global constants that are to be used in the ***AirBase\_CT\_data.R*** script. These are:

1.  Directory paths: root path and the save the files path.
2.  Selected information variables: countries and common components.
3.  Time interval to chop the datasets.

Let's continue with the next step from the results framework.

To extract the rawdata for the previous selection per country, a function called *function\_extract\_CT\_data.R* extracts a country's rawdata based on the selected components and sample periods. This function is incorporated in the ***AirBase\_CT\_data.R*** script.

Next, for each component and sample period, we find the best time interval overlap, that is, we select the data with the most observations, so a representative sample is obtained. To obtain the best overlap that is common to all the components per sample period for all the countries, we do a visual analysis with the dygraph package (see *app\_BE.R*, *app\_FR.R*,...) and select the timestamps that accomodate our needs.

See th following fugure for an example from the Spain data set, we selected Sulphur Dioxide component measured hourly (shaded area = selected data). To get information from the figure, you can zoom in by selecting a region and zoom out by double clicking on the figure. On the upper right corner, you can see the date, time and number of observations at that time point.

In order to be able to view the resulting dygraph plot, we redirect the reader to the file dygraph\_blog.html

After performing the analysis for all the countries, selected components and sample periods, the selected time interval is given by,

------------------------------------------------------------------------

|           Component           |        Hour       |     Day    |
|:-----------------------------:|:-----------------:|:----------:|
|        Sulphur dioxide        |  0:00, 01/01/2005 | 01/01/2004 |
| Particulate matter &lt; 10 µm | 01:00, 01/01/2006 | 01/01/2005 |
|        Nitrogen dioxide       |  0:00, 01/01/2003 | 01/01/2003 |
|            Benzene            |  0:00, 01/01/2006 | 01/01/2005 |
|        Carbon monoxide        |  0:00, 01/01/2002 | 01/01/2002 |
|             Ozone             |  0:00, 01/01/2004 | 01/01/2003 |

------------------------------------------------------------------------

Then, with the previous information, we chop/slice/trim the extracted datasets. A function called *function\_chop\_fill\_data.R* does this and fills NA values in the data (or not, the option is given). As before, this function is incorporated in the ***AirBase\_CT\_data.R*** script.

The structure of the data is shown next,

------------------------------------------------------------------------

|     |         Date        | ES0007R | ES0008R | ES0009R | ES0010R | ES0011R |
|-----|:-------------------:|:-------:|:-------:|:-------:|:-------:|:-------:|
| 2   | 2005-01-01 01:00:00 |   0.50  |   0.86  |   0.20  |   0.68  |   0.22  |
| 3   | 2005-01-01 02:00:00 |   0.31  |   0.97  |   0.19  |   0.50  |   0.25  |
| 4   | 2005-01-01 03:00:00 |   0.28  |   1.58  |   0.19  |   0.44  |   0.22  |
| 5   | 2005-01-01 04:00:00 |   0.29  |   1.38  |   0.18  |   0.42  |   0.19  |
| 6   | 2005-01-01 05:00:00 |   0.22  |   1.01  |   0.21  |   1.29  |   0.22  |
| 7   | 2005-01-01 06:00:00 |   0.23  |   1.13  |   0.21  |   1.64  |   0.26  |
| 8   | 2005-01-01 07:00:00 |   0.47  |   0.91  |   0.24  |   1.20  |   0.25  |
| 9   | 2005-01-01 08:00:00 |   0.29  |   0.81  |   0.28  |   0.60  |   0.27  |
| 10  | 2005-01-01 09:00:00 |   0.23  |   0.87  |   0.33  |   0.51  |   0.44  |
| 11  | 2005-01-01 10:00:00 |   0.43  |   0.84  |   0.34  |   0.35  |   0.89  |

------------------------------------------------------------------------

Recall that, in this post, we aim to display the air pollution map of Spain of the selected components: Sulphur dioxide, Particulate matter &lt; 10 µm, Nitrogen dioxide, Benzene, Carbon monoxide and Ozone. In order to be able to visualize the data, we need to finish prepping it, so we move forward with the last step which is saving the data in a usable and readable format.

We have two output formats for the extracted rawdata per country:

-   In R data format -&gt; .RData, with nomenclature: *<span style="color:red">ES</span>\_data.Rdata*
-   In a table structured format -&gt; .csv, with nomenclature: *<span style="color:red">ES</span>\_ts\_<span style="color:red">hour</span>\_C<span style="color:red">1</span>.csv*, where
    -   C<span style="color:red">1</span> = Sulphur dioxide.
    -   C<span style="color:red">2</span> = Particulate matter &lt; 10 µm.
    -   C<span style="color:red">3</span> = Nitrogen dioxide.
    -   C<span style="color:red">4</span> = Benzene.
    -   C<span style="color:red">5</span> = Carbon monoxide.
    -   C<span style="color:red">6</span> = Ozone.

#### **Visualize Spain air pollution data.**

The data has been fully prepped and saved, and we can now visualize it!

In the following interactive map, we can observe how and where the stations are spread out throughout Spain for an hourly sample period. A snapchat of a specific time period, which is 2007-03-02 13:00:00, is given. In adition, each layer is a different component which you can select and overlap with others, or not. For each component, an automatic clustering is provided, so we can see how the stations are grouped: this can be helpfull to identify regions or a specific information group.

To obtain a little bit more infomation on the data, you can zoom in and click on a station dot in order to display its measurement for time period provided. We encourage the reader to interact with the map and extract conclusions!

In order to be able to view the resulting map, we redirect the reader to the file map\_blog.html

The published blog post can be found inthe following [link](https://www.keedio.org/air-pollution-data/).
