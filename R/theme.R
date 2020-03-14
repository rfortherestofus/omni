#' OMNI Institute ggplot2 theme
#'
#' @param grid_lines
#' @param base_theme
#'
#' @return
#' @export
#'
#' @examples
theme_omni <- function(grid_lines = TRUE,
                       base_theme = ggplot2::theme_minimal(base_family = "Lato")) {


  omni_theme <- base_theme +
    ggplot2::theme(panel.grid.minor = element_blank(),
                   axis.ticks = element_blank(),
                   axis.title.x = element_text(margin = ggplot2::margin(15, 0, 0, 0)),
                   axis.title.y = element_text(margin = ggplot2::margin(0, 15, 0, 0)),
                   plot.title = element_text(margin = ggplot2::margin(0, 0, 15, 0),
                                             face = "bold"),)

  if (grid_lines == FALSE) {

    omni_theme <- omni_theme +
      ggplot2::theme(panel.grid.major = element_blank())

  }

  omni_theme

}

