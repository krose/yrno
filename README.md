
This package is a wrapper for the [yr.no](https://www.yr.no) website and it makes it possible to retrieve and parse the weather data in the XML files.

The main functions in the package are:

-   yr: This function parse the xml files and it needs a direct link to a file.
-   yr\_search: This function returns the first page of the search result, that you get if you do a manual search on the yr.no website.
-   yr\_bike\_recomendation: If you ride your bike to work, it might be nice to know if it is going to rain or be really windy. You can create tests for minimum and/or maximum values and get a written recommendation or a Boolean.

The functions below a basically helper functions for the bike recomendation, but I have exported them in case someone might find them usefull.

-   yr\_hour\_by\_hour: This is a specific function to get the hourly weather forecast.
-   yr\_bike\_df: Returns hourly forecast data for a specified period.

Install and load the package
----------------------------

``` r
if(!require(yrno)){
  devtools::install_github("krose/yrno")
}
```

    ## Loading required package: yrno

``` r
library(yrno)
```

Baby you should ride your ca.. no, sorry.. bike
-----------------------------------------------

But only if it doesn't rain, isn't to windy or cold! I know.. I should just get on the bike, but bear with me.

In the call below to the yr\_bike\_recommendation function I define the place and country I want the forecast for. I'm interested in the hours around 7 a.m. for tomorrow, so I define the hour param to 7 and set the hours\_safety param to 1, so the forecast period I test is from 6 to 9 a.m. I use a named list for the min\_list and max\_list, and these lists are used to test if a weather variable should be higher or lower than some value. In the call below I make sure the temperature is at least 7 degrees celcius, there's no expected rain and I won't be biking through a storm.

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
    ## precipitation_value: WARNING! Failed with a maximum value of 0.100000.
    ## windspeed_kmh: OK
    ## 
    ## 
    ## In the hours between 6 and 8, the weather is expected to be lett regn / skyet.
    ## Max precipitation is forecasted at 0.4 mm.
    ## Windspeed will be a svak vind coming from sør / sør-sørvest at max 5 km/h.
    ## Temperatures are forecasted between 11 (F: 52) and 12 (F: 54) degrees celcius.

If you're not interested in a written recommendation, then you can get a Boolean instead.

You can test the numeric values in the tibble.

``` r
yr_bike_df(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
           hour = 7, 
           forecast_date = Sys.Date() + 1,
           hours_safety = 1)
```

    ## # A tibble: 3 × 22
    ##             time_from             time_to symbol_name symbol_number
    ##                <dttm>              <dttm>       <chr>         <int>
    ## 1 2017-05-17 06:00:00 2017-05-17 07:00:00  Light rain             9
    ## 2 2017-05-17 07:00:00 2017-05-17 08:00:00      Cloudy             4
    ## 3 2017-05-17 08:00:00 2017-05-17 09:00:00      Cloudy             4
    ## # ... with 18 more variables: symbol_numberex <int>, symbol_var <chr>,
    ## #   precipitation_maxvalue <chr>, precipitation_minvalue <chr>,
    ## #   precipitation_value <dbl>, winddirection_code <chr>,
    ## #   winddirection_deg <dbl>, winddirection_name <chr>,
    ## #   windspeed_mps <dbl>, windspeed_name <chr>, temperature_unit <chr>,
    ## #   temperature_value <dbl>, pressure_unit <chr>, pressure_value <dbl>,
    ## #   tz <chr>, windspeed_kmh <dbl>, temperature_value_f <dbl>,
    ## #   hour_of_day <int>

I recommend that you supply the place\_url instead like this, as the call above is rather slow. You can finde the url by using the search function or just copy the url from the yr.no website.

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
    ## precipitation_value: WARNING! Failed with a maximum value of 0.100000.
    ## windspeed_kmh: OK
    ## 
    ## 
    ## In the hours between 6 and 8, the weather is expected to be light rain / cloudy.
    ## Max precipitation is forecasted at 0.4 mm.
    ## Windspeed will be a light breeze coming from south / south-southwest at max 5 km/h.
    ## Temperatures are forecasted between 11 (F: 52) and 12 (F: 54) degrees celcius.

You can use other packages to push messages to your phone or inbox with the recommnedation to use your bike or not. I know that you might not all be as lazy or afraid of water as I am, so you could also just use the package to simply get the forecast and conquer the bad weather with appropriate clothes. Some of the packages you can use to push messages, that I know about are:

-   [mailR](https://cran.r-project.org/web/packages/mailR/index.html)
-   [gmailr](https://cran.r-project.org/web/packages/gmailr/index.html)
-   [Rpushbullet](https://cran.r-project.org/web/packages/RPushbullet/index.html)
-   [pushoverr](https://cran.r-project.org/web/packages/pushoverr/index.html)

Weather data
------------

You might not be interested in riding your bike to work, but are instead looking for weather data to use for fun or professionally. If it's for fun, I'd love to know about your project :)

The links to the XML files are static, but you need to do a bit of work to get the links. Use the yr\_search function or find the links manually on the [yr.no](https://www.yr.no).

``` r
library(yrno)

aarhus <- "http://www.yr.no/place/Denmark/Central_Jutland/Aarhus/forecast.xml"

str(yr(xml_url = aarhus))
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    39 obs. of  22 variables:
    ##  $ time_from             : POSIXct, format: "2017-05-16 23:00:00" "2017-05-17 00:00:00" ...
    ##  $ time_period           : chr  "3" "0" "1" "2" ...
    ##  $ time_to               : POSIXct, format: "2017-05-17 00:00:00" "2017-05-17 06:00:00" ...
    ##  $ symbol_name           : chr  "Cloudy" "Cloudy" "Light rain" "Cloudy" ...
    ##  $ symbol_number         : int  4 4 9 4 3 3 3 3 9 4 ...
    ##  $ symbol_numberex       : int  4 4 46 4 3 3 3 3 46 4 ...
    ##  $ symbol_var            : chr  "04" "04" "46" "04" ...
    ##  $ precipitation_value   : num  0 0 0.6 0 0 0 0 0 0.6 0 ...
    ##  $ precipitation_maxvalue: chr  NA "0.5" "0.8" "0.1" ...
    ##  $ precipitation_minvalue: chr  NA "0" "0.3" "0" ...
    ##  $ winddirection_code    : chr  "S" "S" "WSW" "SW" ...
    ##  $ winddirection_deg     : num  181 190 241 234 140 ...
    ##  $ winddirection_name    : chr  "South" "South" "West-southwest" "Southwest" ...
    ##  $ windspeed_mps         : num  3.2 3.2 2.4 2.3 2.2 2.5 4.7 5.9 3.9 2.9 ...
    ##  $ windspeed_name        : chr  "Light breeze" "Light breeze" "Light breeze" "Light breeze" ...
    ##  $ temperature_unit      : chr  "celsius" "celsius" "celsius" "celsius" ...
    ##  $ temperature_value     : num  14 14 15 15 16 14 14 18 22 16 ...
    ##  $ pressure_unit         : chr  "hPa" "hPa" "hPa" "hPa" ...
    ##  $ pressure_value        : num  1024 1024 1022 1022 1019 ...
    ##  $ tz                    : chr  "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" ...
    ##  $ windspeed_kmh         : num  5.15 5.15 3.86 3.7 3.54 ...
    ##  $ temperature_value_f   : num  57.2 57.2 59 59 60.8 57.2 57.2 64.4 71.6 60.8 ...

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
    ##  $ forcast :Classes 'tbl_df', 'tbl' and 'data.frame':    39 obs. of  22 variables:
    ##   ..$ time_from             : POSIXct[1:39], format: "2017-05-16 23:00:00" ...
    ##   ..$ time_period           : chr [1:39] "3" "0" "1" "2" ...
    ##   ..$ time_to               : POSIXct[1:39], format: "2017-05-17 00:00:00" ...
    ##   ..$ symbol_name           : chr [1:39] "Cloudy" "Cloudy" "Light rain" "Cloudy" ...
    ##   ..$ symbol_number         : int [1:39] 4 4 9 4 3 3 3 3 9 4 ...
    ##   ..$ symbol_numberex       : int [1:39] 4 4 46 4 3 3 3 3 46 4 ...
    ##   ..$ symbol_var            : chr [1:39] "04" "04" "46" "04" ...
    ##   ..$ precipitation_value   : num [1:39] 0 0 0.6 0 0 0 0 0 0.6 0 ...
    ##   ..$ precipitation_maxvalue: chr [1:39] NA "0.5" "0.8" "0.1" ...
    ##   ..$ precipitation_minvalue: chr [1:39] NA "0" "0.3" "0" ...
    ##   ..$ winddirection_code    : chr [1:39] "S" "S" "WSW" "SW" ...
    ##   ..$ winddirection_deg     : num [1:39] 181 190 241 234 140 ...
    ##   ..$ winddirection_name    : chr [1:39] "South" "South" "West-southwest" "Southwest" ...
    ##   ..$ windspeed_mps         : num [1:39] 3.2 3.2 2.4 2.3 2.2 2.5 4.7 5.9 3.9 2.9 ...
    ##   ..$ windspeed_name        : chr [1:39] "Light breeze" "Light breeze" "Light breeze" "Light breeze" ...
    ##   ..$ temperature_unit      : chr [1:39] "celsius" "celsius" "celsius" "celsius" ...
    ##   ..$ temperature_value     : num [1:39] 14 14 15 15 16 14 14 18 22 16 ...
    ##   ..$ pressure_unit         : chr [1:39] "hPa" "hPa" "hPa" "hPa" ...
    ##   ..$ pressure_value        : num [1:39] 1024 1024 1022 1022 1019 ...
    ##   ..$ tz                    : chr [1:39] "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" "Europe/Copenhagen" ...
    ##   ..$ windspeed_kmh         : num [1:39] 5.15 5.15 3.86 3.7 3.54 ...
    ##   ..$ temperature_value_f   : num [1:39] 57.2 57.2 59 59 60.8 57.2 57.2 64.4 71.6 60.8 ...
