

#' Search yr.no for a place.
#'
#' @param place The place you wan't to search for. Keep
#'     the search as simple as possible. This function will
#'     only return the fist page of the search result from
#'     yr.no
#' @param country Two letter country code. Ex: DK, US, DE.
#' @export
#' @examples
#'
#' library(yrno)
#'
#' yr_search("Copenhagen")
#' yr_search("Copenhagen", "US")
#' yr_search("New York")
#' yr_search("London")
#'
yr_search <- function(place, country = NULL){

  place <- stringr::str_replace_all(place, " ", "+")


  au <- httr::user_agent("http://github.com/krose/yrno")

  place_url <- "https://www.yr.no/soek/soek.aspx?region1=&sok=Search&spr=eng&sted="
  place_url <- paste0(place_url, place)
  if(!is.null(country)){
    place_url <- paste0(place_url, "&land=", country)
    rm("country")
  }
  rm("place")

  place_search <- xml2::read_html(place_url, encoding = "UTF-8")

  place_search_no <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_text() %>%
    as.integer()

  if(length(place_search_no) < 1){
    stop("There are no search results for that place.", call. = FALSE)
  }

  place_place <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(2) a") %>%
    rvest::html_text()

  place_url <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(2) a") %>%
    rvest::html_attr("href")
  place_url <- paste0("https://www.yr.no", place_url)

  place_elevation <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(3)") %>%
    rvest::html_text() %>%
    as.integer()

  place_municipality <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(4)") %>%
    rvest::html_text()

  place_region <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(5)") %>%
    rvest::html_text()

  place_country <-
    place_search %>%
    rvest::html_nodes("table.yr-table.yr-table-search-results") %>%
    rvest::html_nodes("td:nth-child(6) a") %>%
    rvest::html_text()

  tibble::tibble(search_no = place_search_no,
                 place = place_place,
                 elevation = place_elevation,
                 municipality = place_municipality,
                 region = place_region,
                 country = place_country,
                 url = place_url)
}
