test_that("footer_title_include() writes a carrier element", {
  f <- footer_title_include("Adams County No Wrong Door Evaluation")

  expect_true(file.exists(f))
  expect_equal(
    readLines(f),
    '<div class="footer-title">Adams County No Wrong Door Evaluation</div>'
  )
})

test_that("footer_title_include() escapes HTML", {
  f <- footer_title_include("Coffee & Tea <Evaluation>")

  expect_equal(
    readLines(f),
    '<div class="footer-title">Coffee &amp; Tea &lt;Evaluation&gt;</div>'
  )
})

test_that("footer_title_include() rejects non-strings", {
  expect_error(footer_title_include(c("a", "b")), "single string")
  expect_error(footer_title_include(NA_character_), "single string")
})

test_that("set_footer_title() moves the running title to .footer-title", {
  css <- withr::local_tempfile(fileext = ".css")
  writeLines(
    c("h1.title {", "  string-set: h1-title content(text);", "}"),
    css
  )

  out <- readLines(set_footer_title(css))

  # the report title no longer drives the footer string
  expect_equal(out[1:3], c("h1.title {", "  string-set: none; /* footer title comes from .footer-title */", "}"))

  # a .footer-title rule now does, and it is hidden
  expect_true(".footer-title {" %in% out)
  expect_true("  string-set: h1-title content(text);" %in% out)
  expect_true("  height: 0;" %in% out)
})

test_that("pdf_report() accepts footer_title without touching the shipped CSS", {
  css <- pkg_resource("pdf_report.css")
  before <- readLines(css)

  expect_no_error(pdf_report(footer_title = "A Short Title"))

  expect_equal(readLines(css), before)
})
