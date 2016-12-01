


#' Function to retrieve and parse the xml forecast data from YR.no
#'
#' @param xml_url the url pointing to the xml file.
#' @param return_location Boolean. If false it returns only the tidy data.frame of forecast data.
#' @importFrom dplyr %>%
#' @export
yr <- function(xml_url = "http://www.yr.no/place/Denmark/Central_Jutland/Aarhus/forecast.xml", return_location = FALSE){

  yr_request <- httr::GET(url = xml_url)
  yr_content <- httr::content(yr_request, as = "text", encoding = "UTF-8")

  yr_content <- xml2::read_html(yr_content)

  yr_time <- yr_time(yr_content)

  if(return_location){
    yr_content <-
      list(location = yr_location(yr_content),
           forcast = yr_time)
  }

  yr_content
}

