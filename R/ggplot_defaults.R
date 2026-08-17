#' Resolve a primary colour argument to a hex string
#'
#' Accepts a brand colour name (`"periwinkle-600"`) or a literal hex, so
#' [set_client_defaults()] can keep passing a non-brand client colour. Also
#' carries the `base_color` deprecation.
#'
#' @noRd
.resolve_primary_color <- function(primary_color, base_color, fn) {
  if (!is.null(base_color)) {
    cli::cli_warn(c(
      "!" = "{.arg base_color} is deprecated in {.fn {fn}}; use {.arg primary_color}.",
      "i" = "It sets the chart's primary data colour, which now defaults to
             {.val periwinkle-600} rather than the old chart gray."
    ))
    primary_color <- base_color
  }
  if (grepl("^#[0-9A-Fa-f]{6}$", primary_color)) {
    unname(primary_color)
  } else {
    unname(omni_colors(primary_color))
  }
}

#' Update defaults to OMNI's theme
#'
#' @details
#' `primary_color` is the colour of the data itself - bars, points, lines,
#' boxplots and their stat equivalents - for charts that do not call out one
#' group. Per the data viz guidance that is a 600-level brand colour, not the
#' chart gray, which is reserved for de-emphasising the *other* groups when one
#' group is highlighted.
#'
#' To use a different colour for one figure, set it on the geom rather than
#' calling this function again:
#'
#' ```r
#' geom_col(fill = omni_colors("orange-red-600"))
#' ```
#'
#' That is not just a style preference. `ggplot2::update_geom_defaults()`,
#' which this function uses, is resolved when a plot is *drawn*, not when it is
#' built - so calling `set_omni_defaults()` a second time repaints every plot
#' object that has not been printed yet. A report that builds figures into a
#' list, patchworks them, or saves them at the end would silently get the last
#' colour set for all of them. A colour passed to the geom is captured when the
#' layer is created and is immune to that.
#'
#' @param base_family The base font family for the theme.
#' @param primary_color The chart's primary data colour: a brand colour name
#'   such as `"periwinkle-600"`, or a hex string. Defaults to
#'   `"periwinkle-600"`.
#' @param base_color Deprecated. Use `primary_color`.
#'
#' @import ggplot2
#' @import ggrepel
#'
#' @export
set_omni_defaults <- function(
  base_family = "Inter Tight",
  primary_color = "periwinkle-600",
  base_color = NULL
) {
  base_color <- .resolve_primary_color(primary_color, base_color, "set_omni_defaults")
  # set default theme -----------------------------------------------------

  ggplot2::theme_set(omni::theme_omni(
    base_family = base_family,
    plot_background_color = "White"
  ))

  # add base_family font to text and label geoms ---------------------------

  ggplot2::update_geom_defaults(
    "text",
    list(
      family = base_family,
      size = 12 / .pt,
      color = omni_colors("chart-gray"),
      fontface = "bold"
    )
  )
  ggplot2::update_geom_defaults(
    "label",
    list(
      family = base_family,
      size = 12 / .pt,
      color = omni_colors("chart-gray"),
      fontface = "bold"
    )
  )
  ggplot2::update_geom_defaults(
    "text_repel",
    list(
      family = base_family,
      size = 12 / .pt,
      color = omni_colors("chart-gray"),
      fontface = "bold"
    )
  )
  ggplot2::update_geom_defaults(
    "label_repel",
    list(
      family = base_family,
      size = 12 / .pt,
      color = omni_colors("chart-gray"),
      fontface = "bold"
    )
  )

  # set default color scales for continuous variables -----------------------

  options(
    ggplot2.continuous.colour = "gradient",
    ggplot2.continuous.fill = "gradient"
  )

  # set default colors for monochromatic geoms ------------------------------

  ggplot2::update_geom_defaults("bar", list(fill = base_color))
  ggplot2::update_geom_defaults("col", list(fill = base_color))
  ggplot2::update_geom_defaults("point", list(colour = base_color))
  ggplot2::update_geom_defaults("line", list(colour = base_color))
  ggplot2::update_geom_defaults("step", list(colour = base_color))
  ggplot2::update_geom_defaults("path", list(colour = base_color))
  ggplot2::update_geom_defaults("boxplot", list(fill = base_color))
  ggplot2::update_geom_defaults("density", list(fill = base_color))
  ggplot2::update_geom_defaults("violin", list(fill = base_color))

  # set default colors for monochromatic stats ------------------------------

  ggplot2::update_stat_defaults("count", list(fill = base_color))
  ggplot2::update_stat_defaults("boxplot", list(fill = base_color))
  ggplot2::update_stat_defaults("density", list(fill = base_color))
  ggplot2::update_stat_defaults("ydensity", list(fill = base_color))

  # width and sizes ---------------------------------------------------------

  # this aren't aes
  # --> will need to solve something about importing ggplot2 order
  formals(geom_bar)$width <- 0.7
  formals(geom_col)$width <- 0.7

  # this are
  ggplot2::update_geom_defaults("line", list(linewidth = 1))
  ggplot2::update_geom_defaults("step", list(linewidth = 1))
  ggplot2::update_geom_defaults("path", list(linewidth = 1))
  ggplot2::update_geom_defaults("point", list(size = 3))
}

#' Resets to default setting
#'
#' @import ggplot2
#' @import ggrepel
#'
#' @export
#'
ggplot_defaults <- function() {
  ggplot2::theme_set(ggplot2::theme_grey())

  # add Inter Tight font to text and label geoms ---------------------------

  ggplot2::update_geom_defaults("text", list(family = "Inter Tight"))
  ggplot2::update_geom_defaults("label", list(family = "Inter Tight"))
  ggplot2::update_geom_defaults("text_repel", list(family = "Inter Tight"))
  ggplot2::update_geom_defaults("label_repel", list(family = "Inter Tight"))

  # set default colours for monochromatic geoms -----------------------------

  ggplot2::update_geom_defaults("bar", list(fill = "#595959"))
  ggplot2::update_geom_defaults("col", list(fill = "#595959"))
  ggplot2::update_geom_defaults("point", list(colour = "black"))
  ggplot2::update_geom_defaults("line", list(colour = "#595959"))
  ggplot2::update_geom_defaults("boxplot", list(fill = "#595959"))
  ggplot2::update_geom_defaults("density", list(fill = "#595959"))
  ggplot2::update_geom_defaults("violin", list(fill = "#595959"))

  # set default colours for monochromatic stats -----------------------------

  ggplot2::update_stat_defaults("count", list(fill = "#595959"))
  ggplot2::update_stat_defaults("boxplot", list(fill = "#595959"))
  ggplot2::update_stat_defaults("density", list(fill = "#595959"))
  ggplot2::update_stat_defaults("ydensity", list(fill = "#595959"))

  # width and sizes ---------------------------------------------------------

  # this aren't aes
  formals(geom_bar)$width <- NULL
  formals(geom_col)$width <- NULL

  # this are
  ggplot2::update_geom_defaults("line", list(linewidth = .5))
  ggplot2::update_geom_defaults("step", list(linewidth = .5))
  ggplot2::update_geom_defaults("path", list(linewidth = .5))
  ggplot2::update_geom_defaults("point", list(size = 1.5))
  ggplot2::update_geom_defaults("text", list(size = 3.88))
}


#' Update defaults to OMNI's client theme
#'
#'
#' @param base_family The base font family for the theme.
#' @param primary_color The chart's primary data colour: a brand colour name or
#'   a hex string. Defaults to the client blue, `"#405065"`.
#' @param base_color Deprecated. Use `primary_color`.
#'
#' @import ggplot2
#' @import ggrepel
#'
#' @export
set_client_defaults <- function(
  base_family = "Inter Tight",
  primary_color = "#405065",
  base_color = NULL
) {
  primary_color <- .resolve_primary_color(
    primary_color,
    base_color,
    "set_client_defaults"
  )
  set_omni_defaults(
    base_family = base_family,
    primary_color = primary_color
  )
}
