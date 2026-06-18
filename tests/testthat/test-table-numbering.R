testthat::test_that("Omni tables support bookdown numbering in Paged.js", {
  testthat::skip_if_not(rmarkdown::pandoc_available())

  input_dir <- tempfile("omni-table-numbering-")
  dir.create(input_dir)
  input <- file.path(input_dir, "numbering.Rmd")

  writeLines(
    c(
      "---",
      "title: Numbering test",
      "output:",
      "  bookdown::html_document2:",
      "    self_contained: false",
      "---",
      "",
      "```{r setup, include=FALSE}",
      "knitr::opts_knit$set('is.paged.js' = TRUE)",
      "```",
      "",
      "See Table \\@ref(tab:fruit).",
      "",
      "```{r fruit, tab.cap='Fruit sales'}",
      "omni::omni_table(tibble::tibble(fruit = 'Apple', sold = 2))",
      "```",
      "",
      "```{r literal-caption}",
      paste0(
        "omni::omni_table(tibble::tibble(fruit = 'Pear', sold = 3), ",
        "caption = 'Literal caption')"
      ),
      "```",
      "",
      "```{r vegetable, tab.cap='Vegetable sales'}",
      "omni::omni_table(tibble::tibble(vegetable = 'Carrot', sold = 4))",
      "```"
    ),
    input
  )

  output <- rmarkdown::render(input, quiet = TRUE)
  html <- paste(readLines(output, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl('href="#tab:fruit">1</a>', html, fixed = TRUE))
  testthat::expect_true(grepl('id="tab:fruit">Table 1:', html, fixed = TRUE))
  testthat::expect_true(grepl("no-shadow-dom", html, fixed = TRUE))
  testthat::expect_true(grepl("Literal caption", html, fixed = TRUE))
  testthat::expect_true(
    grepl('id="tab:vegetable">Table 2:', html, fixed = TRUE)
  )
  testthat::expect_false(grepl("Table 3:", html, fixed = TRUE))
})

testthat::test_that("omni_table returns a flextable-compatible object", {
  table <- omni_table(tibble::tibble(value = 1))

  testthat::expect_s3_class(table, "omni_table")
  testthat::expect_s3_class(table, "flextable")
})
