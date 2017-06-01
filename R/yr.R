


#' Function to retrieve and parse the xml forecast data from YR.no
#'
#' @param xml_url the url pointing to the xml file.
#' @param return_location Boolean. If false it returns only the tidy data.frame of forecast data.
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(yrno)
#'
#' aarhus <- "http://www.yr.no/place/Denmark/Central_Jutland/Aarhus/forecast.xml"
#' cph <- "http://www.yr.no/sted/Danmark/Hovedstaden/København/varsel_time_for_time.xml"
#'
#' yr(aarhus)
#' yr(cph)
#' }
#' @export
yr <- function(xml_url = "http://www.yr.no/place/Denmark/Central_Jutland/Aarhus/forecast.xml", return_location = FALSE){

  # set user agent
  ua <- httr::user_agent("http://github.com/krose/yrno")

  yr_request <- httr::GET(url = xml_url, ua)

  if(httr::http_type(yr_request) != "text/xml"){
    stop("API did not return XML", call. = FALSE)
  }

  if(httr::http_error(yr_request) | httr::status_code(yr_request) != 200){
    stop(paste0("API request failed with status code .",
                httr::status_code(yr_request),
                ". ",
                httr::warn_for_status(yr_request)),
         call. = FALSE)
  }

  yr_content <- httr::content(yr_request, as = "text", encoding = "UTF-8")

  yr_content <- xml2::read_html(yr_content)

  yr_time <- yr_time(yr_content)

  if(return_location){
    yr_content <-
      list(location = yr_location(yr_content),
           forcast = yr_time)
  } else {
    yr_content <- yr_time
  }

  yr_content
}

