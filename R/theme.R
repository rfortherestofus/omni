#' OMNI Institute ggplot2 theme
#'
#' @param show_legend Whether or not to show the legend (TRUE by default)
#' @param base_family Base font family (Lato by default). If you want to use a custom font, you need to register it first.
#' @param show_grid_lines Show grid lines or not
#'
#' @return A ggplot2 theme
#' @export
#'
#' @importFrom ggplot2 theme_minimal theme element_blank element_text margin
#' @importFrom ggtext element_markdown
theme_omni <- function(show_grid_lines = FALSE,
                       show_legend = FALSE,
                       base_family = "Calibri") {
  # general theme based on theme_minimal
  omni_theme <- theme_minimal(base_family = base_family,
                              base_size = 10) +
    theme(
      panel.grid.minor = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_text(margin = margin(15, 0, 0, 0), color = "#595959"),
      axis.title.y = element_text(margin = margin(0, 15, 0, 0), color = "#595959"),
      plot.title = element_markdown(
        margin = margin(0, 0, 15, 0),
        color = "#595959",
        face = "bold",
        size = 12
      ),
      plot.subtitle = element_markdown(size = 11, color = "#595959"),
      plot.caption = element_text(size = 11, face = "italic"),
      plot.margin = margin(t = 7, r = 7, b = 7, l = 7, unit = "points")
    )

  # grid lines option
  if (show_grid_lines == FALSE) {
    omni_theme <- omni_theme +
      theme(panel.grid.major = element_blank())
  }

  if (show_legend == FALSE) {
    omni_theme <- omni_theme +
      theme(legend.position = "none")
  }

  # return
  omni_theme
}
