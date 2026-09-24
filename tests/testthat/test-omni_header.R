test_that("chart-gray replaces the old two-gray split", {
  expect_equal(unname(omni_colors("chart-gray")), "#767676")
  expect_error(omni_colors("bar-gray"))
  expect_error(omni_colors("label-gray"))
})

test_that("omni_span wraps text in a colored span", {
  out <- omni_span("Housing", "periwinkle-600")
  expect_type(out, "character")
  expect_match(out, omni_colors("periwinkle-600"), fixed = TRUE)
  expect_match(out, "Housing", fixed = TRUE)
})

test_that("omni_header returns labs + theme components", {
  h <- omni_header(
    primary = "Test finding",
    keyword = "finding",
    top_header = "TOPIC - FY2024",
    measure = "What is measured",
    finding = "A second point",
    finding_keyword = "second",
    source = "data",
    n = 100
  )
  expect_type(h, "list")
  expect_length(h, 2)
  expect_true("title" %in% names(h[[1]]))
  expect_s3_class(h[[2]], "theme")
})

test_that("omni_header colors the keyword and warns on a missing one", {
  h <- omni_header(primary = "Housing led", keyword = "Housing")
  expect_match(h[[1]]$title, omni_colors("orange-red-600"), fixed = TRUE)
  expect_warning(omni_header(primary = "Housing led", keyword = "Nope"))
})

test_that("omni_header's caption carries its own marquee style (regression: finding_keyword gray fallback)", {
  # omni_header()'s finding_keyword coloring works by wrapping it in marquee
  # class markdown (e.g. "{.plum-600 ...}"), which only resolves to a color
  # if plot.caption's element_marquee() has a style with that class
  # registered. It must supply that style itself rather than relying on
  # ggplot2's theme-merge to backfill it from a pre-existing plot.caption
  # element (e.g. theme_omni()'s) - that only works by accident, and breaks
  # the moment anything resets plot.caption first (as a fix for the
  # title/subtitle theme-merge issue does).
  h <- omni_header(
    primary = "Test finding",
    finding = "A second point",
    finding_keyword = "second",
    color = "plum-600"
  )
  caption_style <- h[[2]]$plot.caption$style
  expect_false(is.null(caption_style))
  expect_identical(caption_style, .omni_marquee_style())
})

test_that("omni_header gives the eyebrow space above it and the measure space below it", {
  h <- omni_header(
    primary = "Test finding",
    top_header = "TOPIC - FY2024",
    measure = "What is measured"
  )
  expect_equal(h[[2]]$plot.title$margin, ggplot2::margin(t = 8, b = 14))
  expect_equal(h[[2]]$plot.subtitle$margin, ggplot2::margin(b = 12))
})

test_that("omni_highlight_labels colors only matched labels", {
  labeller <- omni_highlight_labels("North", color = "teal-600")
  out <- labeller(c("North", "South"))
  expect_match(out[1], omni_colors("teal-600"), fixed = TRUE)
  expect_equal(out[2], "South")
})

test_that("omni_baseline returns a ggplot layer", {
  expect_s3_class(omni_baseline(n = 5), "ggproto")
})
