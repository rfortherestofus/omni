#' OMNI Institute ggplot2 theme
#'
#' @param show_legend Whether or not to show the legend. FALSE by default.
#' @param base_family Base font family. Inter Tight by default.
#' @param show_grid_lines Whether or not to show grid lines. FALSE by default.
#'
#' @return A ggplot2 theme
#' @export
#'
#' @importFrom ggplot2 theme_minimal theme element_blank element_text margin
#' @importFrom ggtext element_markdown
theme_omni <- function(
  show_grid_lines = FALSE,
  show_legend = FALSE,
  base_family = "Inter Tight"
) {
  # general theme based on theme_minimal
  omni_theme <- theme_minimal(base_family = base_family) +
    theme(
      panel.grid.minor = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_text(
        margin = margin(15, 0, 0, 0),
        size = 14,
        color = "#333333"
      ),
      axis.title.y = element_text(
        margin = margin(0, 15, 0, 0),
        size = 14,
        color = "#333333"
      ),
      axis.text = element_text(size = 11),
      plot.title = element_markdown(
        margin = margin(0, 0, 15, 0),
        color = "#666665",
        face = "bold",
        size = 13
      ),
      plot.title.position = "plot",
      plot.subtitle = element_markdown(
        size = 11,
        color = "#333333"
      ),
      plot.caption = element_text(
        size = 11,
        face = "italic"
      ),
      plot.margin = margin(
        t = 7,
        r = 7,
        b = 7,
        l = 7,
        unit = "points"
      )
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
