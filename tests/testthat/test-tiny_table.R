test_df <- data.frame(
  species = c("Adelie", "Adelie", "Gentoo", "Gentoo"),
  x = 1:4,
  y = 5:8
)

test_that("omni_tinytable returns a tinytable object", {
  result <- omni_tinytable(test_df)
  expect_s4_class(result, "tinytable")
})

test_that("omni_tinytable works with no styling options", {
  expect_no_error(omni_tinytable(test_df))
  expect_no_error(omni_tinytable(test_df, with_stripes = FALSE))
  expect_no_error(omni_tinytable(test_df, first_col_gray = TRUE))
})

test_that("omni_tinytable groups rows without erroring", {
  expect_no_error(omni_tinytable(test_df, group_by = "species"))
  expect_no_error(
    omni_tinytable(test_df, group_by = "species", dark_group_rows = TRUE)
  )
})

test_that("omni_tinytable accepts an arbitrary brand color", {
  result <- omni_tinytable(
    test_df,
    group_by = "species",
    brand_color = "#921C4C",
    first_col_gray = TRUE
  )
  expect_s4_class(result, "tinytable")
})

test_that("lighten_color blends a hex color toward white", {
  lightened <- lighten_color("#000000", amount = 0.5)
  expect_equal(
    unname(grDevices::col2rgb(lightened)[, 1]),
    c(128L, 128L, 128L)
  )

  unchanged <- lighten_color("#123456", amount = 0)
  expect_equal(toupper(unchanged), "#123456")
})
