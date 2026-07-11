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

test_that("omni_highlight_labels colors only matched labels", {
  labeller <- omni_highlight_labels("North", color = "teal-600")
  out <- labeller(c("North", "South"))
  expect_match(out[1], omni_colors("teal-600"), fixed = TRUE)
  expect_equal(out[2], "South")
})

test_that("omni_baseline returns a ggplot layer", {
  expect_s3_class(omni_baseline(n = 5), "ggproto")
})
