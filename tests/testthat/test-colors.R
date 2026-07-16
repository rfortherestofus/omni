test_that("omni_pal_discrete returns the first k brand colors, in order", {
  expect_equal(
    omni_pal_discrete()(3),
    unname(omni_colors(c("periwinkle-600", "orange-red-600", "plum-600")))
  )

  expect_equal(
    omni_pal_discrete()(5),
    unname(omni_colors(c(
      "periwinkle-600",
      "orange-red-600",
      "plum-600",
      "olive-green-600",
      "teal-600"
    )))
  )
})

test_that("omni_pal_discrete reverses the palette when asked", {
  # reversing the full five then taking the first two yields teal, olive-green
  expect_equal(
    omni_pal_discrete(reverse = TRUE)(2),
    unname(omni_colors(c("teal-600", "olive-green-600")))
  )
})

test_that("the discrete scales use first-k selection, not interpolation", {
  # 4 categories must be exact brand colors, not interpolated midtones
  expect_equal(
    scale_fill_omni_discrete()$palette(4),
    unname(omni_colors(c(
      "periwinkle-600",
      "orange-red-600",
      "plum-600",
      "olive-green-600"
    )))
  )
  expect_equal(
    scale_color_omni_discrete()$palette(3),
    unname(omni_colors(c("periwinkle-600", "orange-red-600", "plum-600")))
  )
})

test_that("requesting more categories than the palette has errors clearly", {
  expect_error(omni_pal_discrete()(6), "categories")
})
