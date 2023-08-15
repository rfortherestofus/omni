#' OMNI Institute ggplot2 theme
#'
#' @param show_legend Whether or not to show the legend (TRUE by default)
#' @param base_family Base font family (Lato by default). If you want to use a custom font, you need to register it first.
#' @param show_grid_lines Show grid lines or not
#'
#' @return
#' @export
#'
#' @examples
theme_omni <- function(show_grid_lines = TRUE,
                       show_legend = TRUE,
                       base_family = "Calibri") {
#
#   import_lato()

  omni_theme <- ggplot2::theme_minimal(base_family = base_family) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_text(margin = ggplot2::margin(15, 0, 0, 0)),
                   axis.title.y = ggplot2::element_text(margin = ggplot2::margin(0, 15, 0, 0)),
                   plot.title = ggplot2::element_text(margin = ggplot2::margin(0, 0, 15, 0),
                                                      face = "bold"))

  if (show_grid_lines == FALSE) {

    omni_theme <- omni_theme +
      ggplot2::theme(panel.grid.major = ggplot2::element_blank())

  }

  if (show_legend == FALSE) {

    omni_theme <- omni_theme +
      ggplot2::theme(legend.position = "none")

  }

  omni_theme

}

