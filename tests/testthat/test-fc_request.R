context("fc_request")

testthat::skip_on_cran()
testthat::skip_if(!fc_ping())

test_that("fc_request fails with invalid credentials", {
  expect_error(fc_request("GET", "/user",
      public_key = "invalid", private_key = "invalid"),
    regexp = "fieldclimate API request failed")
})

test_that("fc_request fails with missing credentials", {
  skip_if(Sys.getenv("FC_PRIVATE_KEY") == "")

  expect_error(fc_request("GET", "/user", public_key = ""),
               regexp = "public_key missing")
  expect_error(fc_request("GET", "/user", private_key = ""),
               regexp = "private_key missing")
})

test_that("fc_request work", {
  skip_if(Sys.getenv("FC_PRIVATE_KEY") == "")

  expect_message(
    {usr <- fc_request("GET", "/user", verbose = TRUE)},
    "GET https")
  expect_is(usr, "list")
  expect_true(names(usr)[[1]] == "username")
})
