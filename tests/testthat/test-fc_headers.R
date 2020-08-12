context("fc_headers")

h <-  fc_headers(path = "/user", public_key = "invalid", private_key = "invalid")

test_that("fc_headers works", {
  expect_is(h, "request")
  expect_equal(names(h$headers), c("Date", "Authorization"))
  expect_true(grepl("^hmac invalid\\:", h$headers[["Authorization"]]))
})
