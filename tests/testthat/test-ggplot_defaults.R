# set_omni_defaults() mutates global ggplot2 geom/stat defaults, so each test
# restores what it found. Without this a failure here would silently change the
# colours every later test renders with.
local_geom_defaults <- function(env = parent.frame()) {
  before <- list(
    col = ggplot2::GeomCol$default_aes$fill,
    point = ggplot2::GeomPoint$default_aes$colour,
    count = ggplot2::StatCount$default_aes$fill
  )
  withr::defer(
    {
      ggplot2::update_geom_defaults("col", list(fill = before$col))
      ggplot2::update_geom_defaults("point", list(colour = before$point))
      ggplot2::update_stat_defaults("count", list(fill = before$count))
    },
    envir = env
  )
}

test_that("data marks default to a 600 brand colour, not the chart gray", {
  # The guidance is that a chart with no highlighted group is drawn in one
  # 600-level colour. The old default was chart-gray, which is meant for
  # de-emphasising the other groups *when* one group is highlighted - so every
  # unhighlighted chart came out entirely gray.
  local_geom_defaults()
  set_omni_defaults()
  expect_equal(ggplot2::GeomCol$default_aes$fill, unname(omni_colors("periwinkle-600")))
  expect_false(ggplot2::GeomCol$default_aes$fill == unname(omni_colors("chart-gray")))
})

test_that("primary_color accepts a brand name or a hex, and reaches stats too", {
  local_geom_defaults()

  set_omni_defaults(primary_color = "orange-red-600")
  expect_equal(ggplot2::GeomCol$default_aes$fill, unname(omni_colors("orange-red-600")))
  expect_equal(ggplot2::GeomPoint$default_aes$colour, unname(omni_colors("orange-red-600")))
  # stat defaults must move with the geoms or stat_count bars drift out of sync
  expect_equal(ggplot2::StatCount$default_aes$fill, unname(omni_colors("orange-red-600")))

  set_omni_defaults(primary_color = "#123456")
  expect_equal(ggplot2::GeomCol$default_aes$fill, "#123456")
})

test_that("base_color still works but warns", {
  local_geom_defaults()
  expect_warning(
    set_omni_defaults(base_color = omni_colors("plum-600")),
    "deprecated"
  )
  expect_equal(ggplot2::GeomCol$default_aes$fill, unname(omni_colors("plum-600")))
})

test_that("set_client_defaults keeps its client colour", {
  local_geom_defaults()
  set_client_defaults()
  expect_equal(ggplot2::GeomCol$default_aes$fill, "#405065")
})
