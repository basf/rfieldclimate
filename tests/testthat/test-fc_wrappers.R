context("wrappers")

testthat::skip_on_cran()
skip_if(Sys.getenv("FC_PRIVATE_KEY") == "")


test_that("fc_get_user() works", {
  usr <- fc_get_user()
  expect_is(usr, "list")
  expect_true(names(usr)[[1]] == "username")
})

stations <- fc_get_user_stations()
test_that("fc_get_user_stations() works", {
  expect_is(stations, "list")
  expect_true(names(stations[[1]])[[1]] == "station_name")
})

test_that("fc_get_station() works", {

  station <- fc_get_station(stations[[1]]$station_name)
  expect_is(station, "list")
  expect_true(names(station)[[1]] == "id")
})

test_that("fc_get_data() works", {
  data <- fc_get_data(stations[[1]]$station_name)
  expect_is(data, "list")
  expect_true(names(data)[[1]] == "min_date")
})

test_that("fc_get_data_range() works", {

  data <- fc_get_data_range(
      station_id = stations[[1]]$station_name,
      data_group = "raw",
      from = as.integer(as.POSIXct(Sys.time() - 60 * 60 * 24)),
      to =  as.integer(as.POSIXct(Sys.time())))
  expect_is(data, "list")
  expect_true(names(data)[[1]] == "sensors")
})

test_that("fc_get_data_range() handles 204s", {

  data <- fc_get_data_range(
    station_id = stations[[1]]$station_name,
    data_group = "raw",
    from = as.integer(as.POSIXct(stations[[1]]$db$min_date) - 100),
    to =  as.integer(as.POSIXct(stations[[1]]$db$min_date) - 10))
  expect_equal(data, NULL)
})
