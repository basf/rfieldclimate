context("parsers")

testthat::skip_on_cran()
skip_if(Sys.getenv("FC_PRIVATE_KEY") == "")

stations <- fc_get_user_stations()
data <- fc_get_data_range(
  station_id = stations[[1]]$station_name,
  data_group = "raw",
  from = as.integer(as.POSIXct(Sys.time() - 60 * 60 * 24)),
  to =  as.integer(as.POSIXct(Sys.time())))
parsed_data <- fc_parse_data(data)
parsed_stations <- fc_parse_stations(stations)

test_that("fc_parse_data() works", {
  expect_is(parsed_data, "data.frame")
})

test_that("fc_parse_stations() works", {
  expect_is(parsed_stations, "data.frame")
})
