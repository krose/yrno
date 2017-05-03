

#' Get hourly forecast from YR.no
#'
#' Function to get the hourly forecast from YR.no, by supplying
#' a city name or a place_url copied from YR.no.
#'
#' @param place Place name. Ex 'Copenhagen', 'Frederiksberg' 'New York'.
#'     The place name is used to find the place_url by using the yr_search function.
#'     The search results are dependent on your location and language, so if
#'     you want to be certain that you get the correct forecast, then supply
#'     a place_url that you get from either the yr_search function or directly
#'     from the YR.no website.
#' @param country The two digit country code. Ex 'US', 'DK', 'SE'
#' @param place_url The place_url can be copied directly from the YR.no
#'     website and used instead of the place param.
#'
#' @examples
#'
#' library(yrno)
#'
#' yr_hour_by_hour(place = "Copenhagen")
#' yr_hour_by_hour(place = "Copenhagen", country = "DK")
#' yr_hour_by_hour(place_url = yr_search(place = "Copenhagen")$url[1])
#'
#' @export
yr_hour_by_hour <- function(place = NULL, country = NULL, place_url = NULL, search_no = 1){

  if(is.null(place_url)){

    place_search <- yr_search(place = place, country = country)

    place_url <-
      xml2::read_html(x = paste0(place_search$url[search_no], "data.html"),
                      encoding = "UTF-8") %>%
      rvest::html_node("#xml h2+ p a") %>%
      rvest::html_attr("href")

  } else {

    place_url <-
      xml2::read_html(x = paste0(place_url, "data.html"),
                      encoding = "UTF-8") %>%
      rvest::html_node("#xml h2+ p a") %>%
      rvest::html_attr("href")

  }

  # set user agent
  ua <- httr::user_agent("http://github.com/krose/yrno")

  yr_request <- httr::GET(url = place_url, ua)

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

  yr_id <-
    yr_content %>%
    rvest::html_node("weatherdata") %>%
    rvest::html_node("links") %>%
    rvest::html_nodes("link") %>%
    rvest::html_attr("id")

  yr_links <-
    yr_content %>%
    rvest::html_node("weatherdata") %>%
    rvest::html_node("links") %>%
    rvest::html_nodes("link") %>%
    rvest::html_attr("url")

  yr_data <- yr(xml_url = yr_links[yr_id == "xmlSourceHourByHour"])

  yr_data
}
