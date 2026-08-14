testthat::test_that("quote_box's `fixed_width_px` accepts only numeric", {
  testthat::expect_error(quote_box(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600',
    fixed_width_px = '200px'
  ))
  testthat::expect_no_error(quote_box(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600'
  ))
  testthat::expect_no_error(quote_box(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600',
    fixed_width_px = 200
  ))
})


testthat::test_that('quote boxes only use allowed colors', {
  testthat::expect_error(quote_box(
    'bla',
    author = 'John Jacob, random guy',
    'red'
  ))
  testthat::expect_error(quote_box(
    'bla',
    author = 'John Jacob, random guy',
    'teal-400'
  ))
  testthat::expect_no_error(quote_box(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600'
  ))
})


testthat::test_that("callout box's `fixed_width_px` accepts only numeric", {
  testthat::expect_error(callout_box(
    'bla',
    'teal-600',
    fixed_width_px = '200px'
  ))
  testthat::expect_no_error(callout_box(
    'bla',
    'teal-600'
  ))
  testthat::expect_no_error(callout_box(
    'bla',
    'teal-600',
    fixed_width_px = 200
  ))
})


testthat::test_that('callout boxes only use allowed colors', {
  testthat::expect_error(callout_box(
    'bla',
    'red'
  ))
  testthat::expect_error(callout_box(
    'bla',
    'teal-400'
  ))
  testthat::expect_no_error(callout_box(
    'bla',
    'teal-600'
  ))
})
