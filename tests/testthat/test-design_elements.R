testthat::test_that("quote_box_html's `fixed_width_px` accepts only numeric", {
  testthat::expect_error(quote_box_html(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600',
    fixed_width_px = '200px'
  ))
  testthat::expect_no_error(quote_box_html(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600'
  ))
  testthat::expect_no_error(quote_box_html(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600',
    fixed_width_px = 200
  ))
})


testthat::test_that('quote boxes only use allowed colors', {
  testthat::expect_error(quote_box_html(
    'bla',
    author = 'John Jacob, random guy',
    'red'
  ))
  testthat::expect_error(quote_box_html(
    'bla',
    author = 'John Jacob, random guy',
    'teal-400'
  ))
  testthat::expect_no_error(quote_box_html(
    'bla',
    author = 'John Jacob, random guy',
    'teal-600'
  ))
})


testthat::test_that("callout_box_html's `fixed_width_px` accepts only numeric", {
  testthat::expect_error(callout_box_html(
    'bla',
    'teal-600',
    fixed_width_px = '200px'
  ))
  testthat::expect_no_error(callout_box_html(
    'bla',
    'teal-600'
  ))
  testthat::expect_no_error(callout_box_html(
    'bla',
    'teal-600',
    fixed_width_px = 200
  ))
})


testthat::test_that('callout boxes only use allowed colors', {
  testthat::expect_error(callout_box_html(
    'bla',
    'red'
  ))
  testthat::expect_error(callout_box_html(
    'bla',
    'teal-400'
  ))
  testthat::expect_no_error(callout_box_html(
    'bla',
    'teal-600'
  ))
})


testthat::test_that("number_emphasis_html's `fixed_width_px` and `font_size_pt` accept only numeric", {
  testthat::expect_error(number_emphasis_html(
    1234,
    'bla',
    'teal-600',
    fixed_width_px = '200px'
  ))
  testthat::expect_error(number_emphasis_html(
    1234,
    'bla',
    'teal-600',
    font_size_pt = '16pt'
  ))
  testthat::expect_no_error(number_emphasis_html(
    1234,
    'bla',
    'teal-600'
  ))
})


testthat::test_that('number emphasis only uses allowed colors', {
  testthat::expect_error(number_emphasis_html(1234, 'bla', 'red'))
  testthat::expect_no_error(number_emphasis_html(1234, 'bla', 'teal-400'))
  testthat::expect_no_error(number_emphasis_html(1234, 'bla', 'teal-600'))
})


testthat::test_that('omni_icon_html only uses allowed icon names and colors', {
  testthat::expect_error(omni_icon_html('not-a-real-icon', 50, 'teal-600', 'white'))
  testthat::expect_error(omni_icon_html('education', 50, 'red', 'white'))
  testthat::expect_no_error(omni_icon_html('education', 50, 'teal-600', 'white'))
})


testthat::test_that('icon_text_html accepts Markdown text', {
  testthat::expect_no_error(icon_text_html('**bold** text'))
})


# *_typst() smoke tests -------------------------------------------------
# These don't invoke a Typst compiler; they only check that each *_typst()
# function returns raw Typst wrapped in a `{=typst}` fence via `as_typst()`,
# so a Quarto Typst render will pick it up as raw markup rather than escaped
# text.

expect_typst_fence <- function(x) {
  testthat::expect_s3_class(x, 'knit_asis')
  testthat::expect_match(unclass(x), '```\\{=typst\\}', fixed = FALSE)
}

testthat::test_that('quote_box_typst() returns a Typst raw block', {
  expect_typst_fence(quote_box_typst(
    'bla <highlight>bla</highlight>',
    author = 'John Jacob, random guy',
    color = 'teal-600'
  ))
})

testthat::test_that('callout_box_typst() returns a Typst raw block', {
  expect_typst_fence(callout_box_typst(
    'bla <highlight>bla</highlight>',
    color = 'teal-600'
  ))
})

testthat::test_that('number_emphasis_typst() returns a Typst raw block', {
  expect_typst_fence(number_emphasis_typst(1234, 'bla', 'teal-600'))
})

testthat::test_that('omni_icon_typst() returns a Typst raw block', {
  expect_typst_fence(omni_icon_typst('education', 50, 'teal-600', 'white'))
})

testthat::test_that('icon_text_typst() returns a Typst raw block', {
  expect_typst_fence(icon_text_typst('**bold** text'))
})

testthat::test_that('icon_text_grid_typst() returns a Typst raw block', {
  expect_typst_fence(icon_text_grid_typst(
    omni_icon_typst('education', 50, 'teal-600', 'white'),
    icon_text_typst('bla')
  ))
})
