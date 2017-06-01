
#' Get the data on the on the hours you want to ride your bike.
#'
#' If you want to ride your bike, but care about getting your feet
#' wet, then you need weather forecasts about the hours you expect
#' to ride your bike.
#'
#' @param place City you want to ride your bike from.
#' @param country To two digit country code. Ex: "DK", "SE", "US".
#' @param hour The hour you want to ride your bike.
#' @param forecast_date Default is current date.
#' @param hours_safety The safety margin subtracted and
#'     to the hour param.
#' @param place_url The place url. Ex http://www.yr.no/place/Denmark/Capital/Copenhagen
#'
#' @export
#'
#' @examples
#'
#' library(yrno)
#'
#' yr_bike_df(place = "Copenhagen",
#'            country = "DK",
#'            hour = 7,
#'            forecast_date = Sys.Date() + 1,
#'            hours_safety = 1)
#' yr_bike_df(hour = 7, forecast_date = Sys.Date() + 1,
#'            hours_safety = 1,
#'            place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/")
#' yr_bike_df(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
#'            hour = 7, forecast_date = Sys.Date() + 1,
#'            hours_safety = 1)
#' yr_bike_df(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
#'            hour = 7,
#'            forecast_date = Sys.Date() + 1,
#'            hours_safety = 1)
#'
yr_bike_df <- function(place = NULL,
                       country = NULL,
                       place_url = NULL,
                       hour,
                       forecast_date = Sys.Date(),
                       hours_safety = 0){

  # Get the data. Use the URL if it is supplied
  if(is.null(place_url)){
    place_data <- yrno::yr_hour_by_hour(place = place, country = country)
  } else {
    place_data <- yrno::yr_hour_by_hour(place_url = place_url)
  }

  # Keep only the relevant day
  place_data <- place_data[as.Date(place_data$time_from) == forecast_date, ]

  # Create a variable called hour_of_day to filter the hours
  # the user wants to ride their bike.
  place_data$hour_of_day <- lubridate::hour(place_data$time_from)

  #################################
  # Keep only the relevant hours
  #################################

  # subset the data to keep the relevant hours, by first
  # defining the hours and then subseting to keep those
  # hours
  place_hour_from <- hour - hours_safety
  place_hour_to <- hour + hours_safety

  place_test <-
    place_data$hour_of_day >= place_hour_from &
    place_data$hour_of_day <= place_hour_to

  place_data <- place_data[place_test, ]

  place_data
}
