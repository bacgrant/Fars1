
library(testthat)
source("~/Fars1/R/fars_functions.R")

expect_that(make_filename(2013), is_a("character"))


