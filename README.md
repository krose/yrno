
Parse the XML files from YR.no.

``` r
library(yrno)
```

Examples
--------

Return only the forecast data.

``` r
str(yr())
```

    ## List of 2
    ##  $ node:<externalptr> 
    ##  $ doc :<externalptr> 
    ##  - attr(*, "class")= chr [1:2] "xml_document" "xml_node"

Return a list with location and forecast data. Credit, links and meta data in the XML file are not parsed yet.

``` r
str(yr(return_location = TRUE))
```

    ## List of 2
    ##  $ location:Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  10 variables:
    ##   ..$ name            : chr "Aarhus"
    ##   ..$ type            : chr "Administration centre"
    ##   ..$ country         : chr "Denmark"
    ##   ..$ id              : chr "Europe/Copenhagen"
    ##   ..$ utcoffsetminutes: int 60
    ##   ..$ altitude        : num 10
    ##   ..$ geobase         : chr "geonames"
    ##   ..$ geobaseid       : int 2624652
    ##   ..$ latitude        : num 56.2
    ##   ..$ longitude       : num 10.2
    ##  $ forcast :Classes 'tbl_df', 'tbl' and 'data.frame':    38 obs. of  17 variables:
    ##   ..$ time_from          : POSIXct[1:38], format: "2016-12-01 15:00:00" ...
    ##   ..$ time_period        : chr [1:38] "2" "3" "0" "1" ...
    ##   ..$ time_to            : POSIXct[1:38], format: "2016-12-01 18:00:00" ...
    ##   ..$ symbol_name        : chr [1:38] "Partly cloudy" "Fair" "Clear sky" "Clear sky" ...
    ##   ..$ symbol_number      : int [1:38] 3 2 1 1 1 1 2 2 3 3 ...
    ##   ..$ symbol_numberex    : int [1:38] 3 2 1 1 1 1 2 2 3 3 ...
    ##   ..$ symbol_var         : chr [1:38] "03d" "mf/02n.06" "mf/01n.09" "01d" ...
    ##   ..$ precipitation_value: num [1:38] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..$ winddirection_code : chr [1:38] "WNW" "WNW" "NW" "NW" ...
    ##   ..$ winddirection_deg  : num [1:38] 296 299 313 313 324 ...
    ##   ..$ winddirection_name : chr [1:38] "West-northwest" "West-northwest" "Northwest" "Northwest" ...
    ##   ..$ windspeed_mps      : num [1:38] 9.5 8.3 6 4.6 4.1 2.3 2 2.8 3.5 2.9 ...
    ##   ..$ windspeed_name     : chr [1:38] "Fresh breeze" "Fresh breeze" "Moderate breeze" "Gentle breeze" ...
    ##   ..$ temperature_unit   : chr [1:38] "celsius" "celsius" "celsius" "celsius" ...
    ##   ..$ temperature_value  : num [1:38] 9 8 3 2 4 2 0 0 4 3 ...
    ##   ..$ pressure_unit      : chr [1:38] "hPa" "hPa" "hPa" "hPa" ...
    ##   ..$ pressure_value     : num [1:38] 1008 1008 1012 1016 1019 ...
