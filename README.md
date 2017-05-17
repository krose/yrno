
Introduction
------------

This package is a wrapper for the [yr.no](https://www.yr.no) website and it makes it possible to retrieve and parse the weather data in the XML files.

The main functions in the package are:

-   `yr`: This function parse the XML files and it needs a direct link to a file.
-   `yr_search`: This function returns the first page of the search result, that you get if you do a manual search on the yr.no website.
-   `yr_bike_recommendation`: If you ride your bike to work, it might be nice to know if it is going to rain or be really windy. You can create tests for minimum and/or maximum values and get a written recommendation or a Boolean.

The functions below are helper functions for the bike recommendation, but I have exported them in case someone might find them useful.

-   `yr_hour_by_hour`: This is a specific function to get the hourly weather forecast.
-   `yr_bike_df`: Returns hourly forecast data for a specified period.

Install and load the package
----------------------------

``` r
if(!require(yrno)){
  devtools::install_github("krose/yrno")
}

library(yrno)
```

Baby you should ride your ca.. no, sorry.. bike
-----------------------------------------------

But only if it doesn't rain, isn't to windy or cold! I know.. I should just get on the bike, but bear with me.

In the call below to the `yr_bike_recommendation` function I define the place and country I want the forecast for. I'm interested in the hours around 7 a.m. for tomorrow, so I define the hour param to 7 and set the hours\_safety param to 1, so the forecast period I test is from 6 to 9 a.m. I use a named list for the min\_list and max\_list, and these lists are used to test if a weather variable should be higher or lower than some value. In the call below I make sure, that the temperature is at least 7 degrees Celsius, there's no expected rain and I won't be biking through a storm.

``` r
cat(yr_bike_recommendation(place = "Copenhagen", 
                           country = "DK", 
                           hour = 7, 
                           forecast_date = Sys.Date() + 1, 
                           hours_safety = 1, 
                           min_list = list(temperature_value = 7), 
                           max_list = list(precipitation_value = 0, 
                                           windspeed_kmh = 7)))
```

    ## temperature_value: OK
    ## precipitation_value: OK
    ## windspeed_kmh: OK
    ## 
    ## 
    ## In the hours between 6 and 8, the weather is expected to be delvis skyet / klarvær.
    ## Max precipitation is forecasted at 0 mm.
    ## Windspeed will be a svak vind / lett bris coming from sørøst at max 7 km/h.
    ## Temperatures are forecasted between 13 (F: 55) and 15 (F: 59) degrees celcius.

If you're not interested in a written recommendation, then you can get a Boolean instead.

You can test the numeric values in the tibble.

``` r
yr_bike_df(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
           hour = 7, 
           forecast_date = Sys.Date() + 1,
           hours_safety = 1)
```

    ## # A tibble: 3 × 20
    ##             time_from             time_to   symbol_name symbol_number
    ##                <dttm>              <dttm>         <chr>         <int>
    ## 1 2017-05-18 06:00:00 2017-05-18 07:00:00 Partly cloudy             3
    ## 2 2017-05-18 07:00:00 2017-05-18 08:00:00 Partly cloudy             3
    ## 3 2017-05-18 08:00:00 2017-05-18 09:00:00     Clear sky             1
    ## # ... with 16 more variables: symbol_numberex <int>, symbol_var <chr>,
    ## #   precipitation_value <dbl>, winddirection_code <chr>,
    ## #   winddirection_deg <dbl>, winddirection_name <chr>,
    ## #   windspeed_mps <dbl>, windspeed_name <chr>, temperature_unit <chr>,
    ## #   temperature_value <dbl>, pressure_unit <chr>, pressure_value <dbl>,
    ## #   tz <chr>, windspeed_kmh <dbl>, temperature_value_f <dbl>,
    ## #   hour_of_day <int>

I recommend that you supply the place\_url param instead like in the function above, as the call with place is rather slow as the function needs to do a search before parsing the data. You can find the URL by using the search function or just copy the URL from the yr.no website.

``` r
cat(yr_bike_recommendation(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
                           hour = 7, 
                           forecast_date = Sys.Date() + 1, 
                           hours_safety = 1, 
                           min_list = list(temperature_value = 7), 
                           max_list = list(precipitation_value = 0, 
                                           windspeed_kmh = 7)))
```

    ## temperature_value: OK
    ## precipitation_value: OK
    ## windspeed_kmh: OK
    ## 
    ## 
    ## In the hours between 6 and 8, the weather is expected to be partly cloudy / clear sky.
    ## Max precipitation is forecasted at 0 mm.
    ## Windspeed will be a light breeze / gentle breeze coming from southeast at max 7 km/h.
    ## Temperatures are forecasted between 13 (F: 55) and 15 (F: 59) degrees celcius.

### How to combine this with other functions

You can use other packages to push messages to your phone or inbox with the recommendation to use your bike or not. I know that you might not all be as lazy or afraid of water as I am, so you could also just use the package to simply get the forecast and conquer the bad weather with appropriate clothes. Some of the packages you can use to push messages, that I know about are:

-   [mailR](https://cran.r-project.org/web/packages/mailR/index.html)
-   [gmailr](https://cran.r-project.org/web/packages/gmailr/index.html)
-   [Rpushbullet](https://cran.r-project.org/web/packages/RPushbullet/index.html)
-   [pushoverr](https://cran.r-project.org/web/packages/pushoverr/index.html)

Weather data
------------

You might not be interested in riding your bike to work, but are instead looking for weather data to use for fun or professionally. If it's for fun, I'd love to know about your project :)

The links to the XML files are static and you need to do a bit of work to get the links. Use the yr\_search function or find the links manually on the [yr.no](https://www.yr.no).

``` r
library(yrno)

aarhus <- "http://www.yr.no/place/Denmark/Central_Jutland/Aarhus/forecast.xml"

str(yr(xml_url = aarhus))
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    37 obs. of  22 variables:
    ##  $ time_from             : POSIXct, format: "2017-05-17 10:00:00" "2017-05-17 12:00:00" ...
    ##  $ time_period           : chr  "1" "2" "3" "0" ...
    ##  $ time_to               : POSIXct, format: "2017-05-17 12:00:00" "2017-05-17 18:00:00" ...
    ##  $ symbol_name           : chr  "Cloudy" "Cloudy" "Fair" "Partly cloudy" ...
    ##  $ symbol_number         : int  4 4 2 3 3 3 4 4 4 3 ...
    ##  $ symbol_numberex       : int  4 4 2 3 3 3 4 4 4 3 ...
    ##  $ symbol_var            : chr  "04" "04" "02d" "mf/03n.75" ...
    ##  $ precipitation_maxvalue: chr  "0.2" "0.1" NA NA ...
    ##  $ precipitation_minvalue: chr  "0" "0" NA NA ...
    ##  $ precipitation_value   : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ winddirection_code    : chr  "SW" "SSW" "ESE" "SE" ...
    ##  $ winddirection_deg     : num  218 201 106 130 158 ...
    ##  $ winddirection_name    : chr  "Southwest" "South-southwest" "East-southeast" "Southeast" ...
    ##  $ windspeed_mps         : num  1.4 1.4 1.7 2.4 4.9 7.2 2.8 2.9 2 2.7 ...
    ##  $ windspeed_name        : chr  "Light air" "Light air" "Light breeze" "Light breeze" ...
    ##  $ temperature_unit      : chr  "celsius" "celsius" "celsius" "celsius" ...
    ##  $ temperature_value     : num  16 16 17 14 14 18 22 18 14 16 ...
    ##  $ pressure_unit         : chr  "hPa" "hPa" "hPa" "hPa" ...
    ##  $ pressure_value        : num  1022 1021 1019 1016 1012 ...
    ##  $ tz                    : chr  "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" ...
    ##  $ windspeed_kmh         : num  2.25 2.25 2.74 3.86 7.88 ...
    ##  $ temperature_value_f   : num  60.8 60.8 62.6 57.2 57.2 64.4 71.6 64.4 57.2 60.8 ...

Return a list with location and forecast data. Credit, links and meta data in the XML file are not parsed yet.

``` r
str(yr(xml_url = aarhus, return_location = TRUE))
```

    ## List of 2
    ##  $ location:Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  10 variables:
    ##   ..$ name            : chr "Aarhus"
    ##   ..$ type            : chr "Administration centre"
    ##   ..$ country         : chr "Denmark"
    ##   ..$ id              : chr "Europe/Copenhagen"
    ##   ..$ utcoffsetminutes: int 120
    ##   ..$ altitude        : num 10
    ##   ..$ geobase         : chr "geonames"
    ##   ..$ geobaseid       : int 2624652
    ##   ..$ latitude        : num 56.2
    ##   ..$ longitude       : num 10.2
    ##  $ forcast :Classes 'tbl_df', 'tbl' and 'data.frame':    37 obs. of  22 variables:
    ##   ..$ time_from             : POSIXct[1:37], format: "2017-05-17 10:00:00" ...
    ##   ..$ time_period           : chr [1:37] "1" "2" "3" "0" ...
    ##   ..$ time_to               : POSIXct[1:37], format: "2017-05-17 12:00:00" ...
    ##   ..$ symbol_name           : chr [1:37] "Cloudy" "Cloudy" "Fair" "Partly cloudy" ...
    ##   ..$ symbol_number         : int [1:37] 4 4 2 3 3 3 4 4 4 3 ...
    ##   ..$ symbol_numberex       : int [1:37] 4 4 2 3 3 3 4 4 4 3 ...
    ##   ..$ symbol_var            : chr [1:37] "04" "04" "02d" "mf/03n.75" ...
    ##   ..$ precipitation_maxvalue: chr [1:37] "0.2" "0.1" NA NA ...
    ##   ..$ precipitation_minvalue: chr [1:37] "0" "0" NA NA ...
    ##   ..$ precipitation_value   : num [1:37] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..$ winddirection_code    : chr [1:37] "SW" "SSW" "ESE" "SE" ...
    ##   ..$ winddirection_deg     : num [1:37] 218 201 106 130 158 ...
    ##   ..$ winddirection_name    : chr [1:37] "Southwest" "South-southwest" "East-southeast" "Southeast" ...
    ##   ..$ windspeed_mps         : num [1:37] 1.4 1.4 1.7 2.4 4.9 7.2 2.8 2.9 2 2.7 ...
    ##   ..$ windspeed_name        : chr [1:37] "Light air" "Light air" "Light breeze" "Light breeze" ...
    ##   ..$ temperature_unit      : chr [1:37] "celsius" "celsius" "celsius" "celsius" ...
    ##   ..$ temperature_value     : num [1:37] 16 16 17 14 14 18 22 18 14 16 ...
    ##   ..$ pressure_unit         : chr [1:37] "hPa" "hPa" "hPa" "hPa" ...
    ##   ..$ pressure_value        : num [1:37] 1022 1021 1019 1016 1012 ...
    ##   ..$ tz                    : chr [1:37] "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" ...
    ##   ..$ windspeed_kmh         : num [1:37] 2.25 2.25 2.74 3.86 7.88 ...
    ##   ..$ temperature_value_f   : num [1:37] 60.8 60.8 62.6 57.2 57.2 64.4 71.6 64.4 57.2 60.8 ...
