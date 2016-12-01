

yr_location <- function(yr_content){

  yr_name <-
    yr_content %>%
    rvest::html_node("location") %>%
    rvest::html_node("name") %>%
    rvest::html_text()

  yr_type <-
    yr_content %>%
    rvest::html_node("location") %>%
    rvest::html_node("type") %>%
    rvest::html_text()

  yr_country <-
    yr_content %>%
    rvest::html_node("location") %>%
    rvest::html_node("country") %>%
    rvest::html_text()

  yr_timezone <-
    yr_content %>%
    rvest::html_node("location") %>%
    rvest::html_node("timezone")  %>%
    rvest::html_attrs() %>%
    data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE) %>%
    tidyr::spread(variable, value)

  yr_location <-
    yr_content %>%
    rvest::html_node("location") %>%
    rvest::html_node("location") %>%
    rvest::html_attrs() %>%
    data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE) %>%
    tidyr::spread(variable, value)

  yr_tidy <- dplyr::bind_cols(tibble::data_frame(name = yr_name, type = yr_type, country = yr_country),
                              yr_timezone,
                              yr_location)

  yr_tidy$utcoffsetminutes <- try(as.integer(yr_tidy$utcoffsetminutes))
  yr_tidy$altitude <- try(as.double(yr_tidy$altitude))
  yr_tidy$geobaseid <- try(as.integer(yr_tidy$geobaseid))
  yr_tidy$latitude <- try(as.double(yr_tidy$latitude))
  yr_tidy$longitude <- try(as.double(yr_tidy$longitude))

  yr_tidy
}

