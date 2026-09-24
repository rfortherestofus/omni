test_that("eval_inline_code() leaves plain strings alone", {
  expect_equal(eval_inline_code("A plain title"), "A plain title")
  expect_equal(
    eval_inline_code("Use the `params` list"),
    "Use the `params` list"
  )
})

test_that("eval_inline_code() evaluates inline code", {
  env <- rlang::env(params = list(site = "Prowers"))

  expect_equal(
    eval_inline_code("`r params$site` County Evaluation", envir = env),
    "Prowers County Evaluation"
  )
  expect_equal(
    eval_inline_code(
      "`r switch(params$site, Adams = 'ECPAC', Prowers = 'CFRC')` Evaluation",
      envir = env
    ),
    "CFRC Evaluation"
  )
  expect_equal(
    eval_inline_code("`r 1 + 1` and `r 2 + 2`", envir = env),
    "2 and 4"
  )
})

test_that("omni_meta() evaluates inline code in the YAML front matter", {
  env <- rlang::env(params = list(site = "Adams"))

  local_mocked_bindings(
    metadata = list(
      title = "`r params$site` County Evaluation",
      subtitle = "",
      client_name = "Early Childhood Partnership",
      report_year = 2026
    ),
    .package = "rmarkdown"
  )

  expect_equal(omni_meta("title", envir = env), "Adams County Evaluation")
  expect_equal(
    omni_meta("client_name", envir = env),
    "Early Childhood Partnership"
  )
  expect_equal(omni_meta("report_year", envir = env), "2026")
})

test_that("omni_meta() returns the default for missing or empty fields", {
  local_mocked_bindings(
    metadata = list(title = "A title", subtitle = ""),
    .package = "rmarkdown"
  )

  expect_equal(omni_meta("subtitle"), "")
  expect_equal(omni_meta("acknowledgements"), "")
  expect_equal(omni_meta("acknowledgements", default = "our partners"), "our partners")
})

test_that("omni_meta() errors informatively on broken inline code", {
  local_mocked_bindings(
    metadata = list(title = "`r stop('nope')` Evaluation"),
    .package = "rmarkdown"
  )

  expect_error(omni_meta("title"), "title")
})
