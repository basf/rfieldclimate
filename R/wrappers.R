#' Read user information
#' @rdname fc_wrappers
#' @param ... additional arguments passed to [fc_request()]
#' @return a list with user information.
#' @export
#' @examples
#' \dontrun{
#'   fc_get_user()
#' }
fc_get_user <- function(...) {
  fc_request(method = "GET", path = "/user", ...)
}

#' List of user devices.
#' @rdname fc_wrappers
#' @param ... additional arguments passed to [fc_request()]
#' @return a list with user stations information.
#' @export
#' @examples
#' \dontrun{
#' stations <- fc_get_user_stations()
#' stations
#' }
fc_get_user_stations <- function(...) {
  fc_request(method = "GET", path = "/user/stations", ...)
}

#' Get station information
#' @rdname fc_wrappers
#' @param station_id station id to query
#' @param ... additional arguments passed to [fc_request()]
#' @return a list with station details.
#' @export
#' @examples
#' \dontrun{
#' stations <- fc_get_user_stations()
#' fc_get_station(stations[[1]]$station_name)
#' }
fc_get_station <- function(station_id = NULL, ...) {
  stopifnot(!is.null(station_id))
  path <- file.path('/station', station_id)
  fc_request(method = "GET", path = path, ...)
}

#' Get  min and max date of device data availability
#' @rdname fc_wrappers
#' @param station_id station id to query
#' @param ... additional arguments passed to [fc_request()]
#' @return a list with station metadata.
#' @export
#' @examples
#' \dontrun{
#' stations <- fc_get_user_stations()
#' fc_get_data(stations[[1]]$station_name)
#' }
fc_get_data <- function(station_id = NULL, ...) {
  stopifnot(!is.null(station_id))
  path <- file.path('/data', station_id)
  fc_request(method = "GET", path = path, ...)
}

#' Getdata between specified time periods.
#' @rdname fc_wrappers
#' @param station_id station id to query
#' @param data_group how to group data
#' @param from time in unix timestamps since UTC, 
#'   e.g. via as.integer(as.POSIXct(Sys.time()))
#' @param to time in unix timestamps since UTC 
#'   as.integer(as.POSIXct(Sys.time()))
#' @param ... additional arguments passed to [fc_request()]
#' @return a list with station data.
#' @export
#' @examples
#' \dontrun{
#' stations <- fc_get_user_stations()
#' fc_get_data_range(
#'   station_id = stations[[1]]$station_name,
#'   data_group = "raw",
#'   from = as.integer(as.POSIXct(Sys.time() - 60*60*24)),
#'   to =  as.integer(as.POSIXct(Sys.time())))
#' }
fc_get_data_range <- function(
    station_id = NULL,
    data_group = c("raw", "hourly", "daily", "monthly"),
    from = NULL,
    to = NULL,
    ...) {

  stopifnot(!is.null(station_id))
  stopifnot(!is.null(from))
  stopifnot(!is.null(to))
  data_group <- match.arg(data_group)

  path <- file.path('/data', station_id, data_group, "from", from, "to", to)
  fc_request(method = "GET", path = path, ...)
}
