
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rfieldclimate

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/rfieldclimate)](https://CRAN.R-project.org/package=rfieldclimate)
[![R build
status](https://github.com/basf/rfieldclimate/workflows/R-CMD-check/badge.svg)](https://github.com/basf/rfieldclimate/actions)
[![Codecov test
coverage](https://codecov.io/gh/basf/rfieldclimate/branch/master/graph/badge.svg?token=3OZ8Y9VVWN)](https://codecov.io/gh/basf/rfieldclimate?branch=master)
<!-- badges: end -->

An R client for [Fieldclimate
API](https://api.fieldclimate.com/v2/docs/)

## Installation

``` r
remotes::install_github("basf/rfieldclimate@develop")
```

## Examples

``` r
library("rfieldclimate")
```

### Authentication

`rfieldclimate` uses
[HMAC](https://api.fieldclimate.com/v2/docs/#authentication-hmac) for
authentication.

The public and private keys are read by default from environmental
variables `FC_PUBLIC_KEY` and `FC_PRIVATE_KEY`, but you can provide them
also in every function call using the `public_key=` and `private_key=`
arguments.

### Basic use

`fc_request()` is the workhorse of this package.

With it you can query every API endpoint, e.g.

``` r
fc_request(method = "GET", path = "/system/types") %>%
  head(2)
```

See the `Routes` tables [API
documentation](https://api.fieldclimate.com/v2/docs/#system) for
details. URL parameters must be included in the `path=` arguments, the
request body in `body=`.

## Wrappers

With `fc_request()` all the api functionality can be easily covered.
Additionally, we provide some wrappers around endpoints.

E.g. the wrapper for station information (see below) is defined as

``` r
fc_get_station
#> function(station_id = NULL, ...) {
#>   stopifnot(!is.null(station_id))
#>   path <- file.path('/station', station_id)
#>   fc_request(method = "GET", path = path, ...)
#> }
#> <bytecode: 0x564e5ee4eaf0>
#> <environment: namespace:rfieldclimate>
```

For a few other endpoints wrapper functions are provided:

  - `fc_get_user()` to list user information
  - `fc_get_user_stations()` to list available stations
  - `fc_get_station()` to get station information
  - `fc_get_data()` to get data range of a station
  - `fc_get_data_range()` to get data in range

Feel free to add more wrappers (as described above).

## Parsers

We provide also convenience wrappers for objects, like

  - `fc_parse_data()` to parse the object returned by
    `fc_get_data_range()` into a long format data.frame
  - `fc_parse_stations()` to parse the object returned by
    `fc_get_user_stations()` into a data.frame

## Unit tests

To run the full test suite with 100% coverage set valid environmental
variables `FC_PUBLIC_KEY` and `FC_PRIVATE_KEY` and run
`devtools::test()`.
