#' Update defaults to OMNI's theme
#'
#'
#' @param base_family The base font family for the theme.
#' @param base_color Base color
#'
#' @import ggplot2
#' @import ggrepel
#'
#' @export
set_omni_defaults <- function(
  base_family = "Inter Tight",
  base_color = "#405065"
) {
  # set default theme -----------------------------------------------------

  ggplot2::theme_set(omni::theme_omni(base_family = base_family, plot_background_color = "White"))

  # add base_family font to text and label geoms ---------------------------

  ggplot2::update_geom_defaults(
    "text",
    list(
      family = base_family,
      size = 12 / .pt,
      color = "#595959"
    )
  )
  ggplot2::update_geom_defaults(
    "label",
    list(
      family = base_family,
      size = 12 / .pt,
      color = "#595959"
    )
  )
  ggplot2::update_geom_defaults(
    "text_repel",
    list(
      family = base_family,
      size = 12 / .pt,
      color = "#595959"
    )
  )
  ggplot2::update_geom_defaults(
    "label_repel",
    list(
      family = base_family,
      size = 12 / .pt,
      color = "#595959"
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
#' @param base_color Base color
#'
#' @import ggplot2
#' @import ggrepel
#'
#' @export
set_client_defaults <- function(
  base_family = "Inter Tight",
  base_color = "#405065"
) {
  set_omni_defaults(
    base_family = base_family,
    base_color = base_color
  )
}
