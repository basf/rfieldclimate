#' parse data into long data.frame
#' @rdname fc_parsers
#' @param obj data object as returned by e.g. [fc_get_data_range()]
#' @importFrom purrr map_df
#' @export
#' @examples
#' \dontrun{
#' stations <- fc_get_user_stations()
#' obj <- fc_get_data_range(
#'   station_id = stations[[1]]$station_name,
#'   data_group = "raw",
#'   from = as.integer(as.POSIXct(Sys.time() - 60*60*24)),
#'   to =  as.integer(as.POSIXct(Sys.time())))
#' fc_parse_data(obj)
#' }
fc_parse_data <- function(obj) {
  sensors <- obj$sensors
  data <- obj$data

  parsed_sensors <- purrr::map_df(sensors, parse_sensor)
  parsed_data <- purrr::map_df(data, parse_timepoint)
  # variable encodes <X>CH_MAC_SERIAL_CODE_AGGREGATION
  res <- parsed_data %>%
    dplyr::left_join(parsed_sensors, by = c("ch", "mac", "serial", "code"))

  return(res)
}

#' parse a timepoint into a long data.frame
#' @importFrom tidyr pivot_longer
#' @importFrom lubridate as_datetime
#' @importFrom dplyr mutate .data
#' @param timepoint a timepoint
parse_timepoint <- function(timepoint) {
  as.data.frame(timepoint) %>%
    tidyr::pivot_longer(-.data$date, names_to = "variable") %>%
    dplyr::mutate(date = lubridate::as_datetime(.data$date),
      variable = gsub("^X", "", .data$variable),
      ch = gsub("^(.*)_(.*)_(.*)_(.*)_(.*)$", "\\1", .data$variable),
      mac = gsub("^(.*)_(.*)_(.*)_(.*)_(.*)$", "\\2", .data$variable),
      serial = gsub("^(.*)_(.*)_(.*)_(.*)_(.*)$", "\\3", .data$variable),
      code = gsub("^(.*)_(.*)_(.*)_(.*)_(.*)$", "\\4", .data$variable),
      aggregation = gsub("^(.*)_(.*)_(.*)_(.*)_(.*)$", "\\5", .data$variable)
      )
}

#' parse a sensor
#' @importFrom dplyr mutate_all
#' @param sensor a sensor
parse_sensor <- function(sensor) {
  data.frame(sensor[c("name", "unit", "ch", "mac", "serial", "code")]) %>%
    dplyr::mutate_all(as.character)
}


#' parse stations into data.frame
#' @rdname fc_parsers
#' @param obj stations object as returned by e.g. [fc_get_user_stations()]
#' @importFrom purrr map_df
#' @export
#' @examples
#' \dontrun{
#' stations <- fc_get_user_stations()
#' fc_parse_stations(stations)
#' }
fc_parse_stations <- function(obj) {
  parsed <- purrr::map_df(obj, parse_station)
  return(parsed)
}

#' parse a station
#' @importFrom dplyr mutate
#' @param station a stations
parse_station <- function(station) {
  data.frame(station[c("station_name", "custom_name")]) %>%
    dplyr::mutate(
           latitude = station$position$geo$coordinates[[2]],
           longitude = station$position$geo$coordinates[[1]],
           altitude = station$position$altitude,
           start_date = station$db$min_date,
           end_date = station$db$max_date
           )
}
