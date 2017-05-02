


yr_time <- function(yr_content){

  yr_list <- list()


  try(yr_list$yr_time <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_time) <- paste0("time_", names(yr_list$yr_time)))


  try(yr_list$yr_symbol <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_nodes(., "symbol")) %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~.[[1]]) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_symbol) <- paste0("symbol_", names(yr_list$yr_symbol)), silent = TRUE)
  try(yr_list$yr_symbol$symbol_number <- as.integer(yr_list$yr_symbol$symbol_number), silent = TRUE)
  try(yr_list$yr_symbol$symbol_numberex <- as.integer(yr_list$yr_symbol$symbol_numberex), silent = TRUE)

  try(yr_list$yr_precipitation <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_nodes(., "precipitation")) %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~.[[1]]) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_precipitation) <- paste0("precipitation_", names(yr_list$yr_precipitation)))
  try(yr_list$yr_precipitation$precipitation_value <- as.double(yr_list$yr_precipitation$precipitation_value), silent = TRUE)


  try(yr_list$yr_winddirection <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_nodes(., "winddirection")) %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~.[[1]]) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_winddirection) <- paste0("winddirection_", names(yr_list$yr_winddirection)))
  try(yr_list$yr_winddirection$winddirection_deg <- as.double(yr_list$yr_winddirection$winddirection_deg), silent = TRUE)

  try(yr_list$yr_windspeed <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_nodes(., "windspeed")) %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~.[[1]]) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_windspeed) <- paste0("windspeed_", names(yr_list$yr_windspeed)))
  try(yr_list$yr_windspeed$windspeed_mps <- as.double(yr_list$yr_windspeed$windspeed_mps), silent = TRUE)

  try(yr_list$yr_temperature <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_nodes(., "temperature")) %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~.[[1]]) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_temperature) <- paste0("temperature_", names(yr_list$yr_temperature)))
  try(yr_list$yr_temperature$temperature_value <- as.double(yr_list$yr_temperature$temperature_value), silent = TRUE)

  try(yr_list$yr_pressure <-
        yr_content %>%
        rvest::html_nodes("time") %>%
        purrr::map(~rvest::html_nodes(., "pressure")) %>%
        purrr::map(~rvest::html_attrs(.)) %>%
        purrr::map(~.[[1]]) %>%
        purrr::map(~data.frame(variable = names(.), value = ., row.names = NULL, stringsAsFactors = FALSE)) %>%
        purrr::map(~tidyr::spread(., variable, value)) %>%
        dplyr::bind_rows(), silent = TRUE)
  try(names(yr_list$yr_pressure) <- paste0("pressure_", names(yr_list$yr_pressure)))
  try(yr_list$yr_pressure$pressure_value <- as.double(yr_list$yr_pressure$pressure_value), silent = TRUE)

  yr_df <-
    yr_list %>%
    dplyr::bind_cols() %>%
    tibble::as_data_frame()

  try(yr_df$tz <-
        yr_content %>%
        rvest::html_node("weatherdata location timezone") %>%
        rvest::html_attr("id"),
      silent = TRUE)

  try(yr_df$windspeed_kmh <- yr_df$windspeed_mps * 1.609, silent = TRUE)
  try(yr_df$temperature_value_f <- yr_df$temperature_value * 9/5 + 32, silent = TRUE)

  yr_df$time_from <- as.POSIXct(strptime(x = yr_df$time_from,
                                         format = "%Y-%m-%dT%H:%M:%S",
                                         tz = unique(yr_df$tz)))
  yr_df$time_to <- as.POSIXct(strptime(x = yr_df$time_to,
                                       format = "%Y-%m-%dT%H:%M:%S",
                                       tz = unique(yr_df$tz)))

  yr_df
}


