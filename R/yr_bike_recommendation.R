
#' Figure out if you are going to be wet, if you ride your bike to work.
#'
#' Function to get the forecasts for when you are going to ride your
#' bike to and from work.
#'
#' @param place City you want to ride your bike from. It is recommended to
#'     use the place_url instead of place (and country) as these params needs
#'     more requests and webscraping to get to the final results.
#' @param country To two digit country code. Ex: "DK", "SE", "US".
#' @param place_url The page you get, when you search for a place on YR.no.
#'     Ex http://www.yr.no/place/Denmark/Capital/Copenhagen
#' @param hour The hour you want to ride your bike.
#' @param forecast_date Default is current date.
#' @param hours_safety The safety margin subtracted and
#'     added to the hour param.
#' @param return_boolean Do you want the function to return a boolean?
#'
#' @export
#'
#' @examples
#'
#' yr_bike_recommendation("Copenhagen", 7, Sys.Date() + 1, hours_safety = 1)
#' yr_bike_recommendation(hour = 7, forecast_date = Sys.Date() + 1,
#'                 hours_safety = 1,
#'                 place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/")
#' yr_bike_recommendation(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
#'                 hour = 7, forecast_date = Sys.Date() + 1,
#'                 hours_safety = 1,
#'                 max_list = list(temperature_value = 5))
#' yr_bike_recommendation(place_url = "https://www.yr.no/place/Denmark/Capital/Copenhagen/",
#'                 hour = 7, forecast_date = Sys.Date() + 1,
#'                 hours_safety = 1,
#'                 min_list = list(temperature_value = 5),
#'                 max_list = list(precipitation_value = 0.1))
#'
yr_bike_recommendation <- function(place = NULL,
                                   country = NULL,
                                   place_url = NULL,
                                   hour,
                                   forecast_date = Sys.Date() + 1,
                                   hours_safety = 0,
                                   min_list = NULL,
                                   max_list = NULL,
                                   return_boolean = FALSE){

  # Get and subset the data
  place_data <- yr_bike_df(place = place,
                           country = country,
                           place_url = place_url,
                           hour = hour,
                           forecast_date = forecast_date,
                           hours_safety = hours_safety)


  ####################################
  # Recommendation
  ####################################

  expectations <- list(hours = sprintf("\n\nIn the hours between %i and %i, the weather is expected to be %s.\n",
                                       min(place_data$hour_of_day),
                                       max(place_data$hour_of_day),
                                       tolower(paste(unique(place_data$symbol_name), collapse = " / "))),
                       precipitation = sprintf("Max precipitation is forecasted at %s mm.\n",
                                               as.character(suppressWarnings(round(max(c(place_data$precipitation_maxvalue,
                                                                                         place_data$precipitation_minvalue,
                                                                                         place_data$precipitation_value),
                                                                                       na.rm = TRUE), digits = 2)))),
                       windspeed = sprintf("Windspeed will be a %s coming from %s at max %i km/h.\n",
                                           tolower(paste(unique(place_data$windspeed_name), collapse = " / ")),
                                           tolower(paste(unique(place_data$winddirection_name), collapse = " / ")),
                                           as.integer(round(max(place_data$windspeed_kmh)), 0)),
                       temperature = sprintf("Temperatures are forecasted between %i (F: %i) and %i (F: %i) degrees celcius.",
                                             as.integer(min(place_data$temperature_value, na.rm = TRUE)),
                                             as.integer(round(min(place_data$temperature_value_f), 0)),
                                             max(place_data$temperature_value),
                                             as.integer(round(max(max(place_data$temperature_value_f)), 0))))

  if(!is.null(max_list)){
    max_list_test <- lapply(seq_along(max_list),
                            function(x){
                              max_list_name <- names(max_list)
                              max_list_name <- max_list_name[x]

                              all(place_data[[max_list_name]] <= max_list[[x]])
                            })
    names(max_list_test) <- names(max_list)

    max_list_rec <- lapply(seq_along(max_list_test),
                           function(x){
                             if(max_list_test[[x]]){
                               sprintf("%s: OK\n",
                                       names(max_list)[x])
                             } else {
                               sprintf("%s: WARNING! Failed with a maximum value of %f.\n",
                                       names(max_list)[x],
                                       max(place_data[[names(max_list)[x]]]))
                             }
                           })
    names(max_list_rec) <- paste0("max_test_", names(max_list))

    expectations <- append(max_list_rec, expectations)
  }

  if(!is.null(min_list)){
    min_list_test <- lapply(seq_along(min_list),
                            function(x){
                              min_list_name <- names(min_list)
                              min_list_name <- min_list_name[x]

                              all(place_data[[min_list_name]] >= min_list[[x]])
                            })
    names(min_list_test) <- names(min_list)

    min_list_rec <- lapply(seq_along(min_list_test),
                           function(x){
                             if(min_list_test[[x]]){
                               sprintf("%s: OK\n",
                                       names(min_list)[x])
                             } else {
                               sprintf("%s: WARNING! Failed with a maximum value of %f.\n",
                                       names(min_list)[x],
                                       min(place_data[[names(min_list)[x]]]))
                             }
                           })
    names(min_list_rec) <- paste0("min_test_", names(min_list))

    expectations <- append(min_list_rec, expectations)
  }

  expectations <- unlist(expectations)
  expectations <- paste(expectations, collapse = "")

  if(return_boolean){

    expectations <- all(unlist(append(min_list_test, max_list_test)))
  }

  return(expectations)
}
