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
  omni_style <- marquee::style_set(
    base = marquee::base_style(),
    str = marquee::style(weight = 'bold'),
    em = marquee::style(italic = TRUE),
    u = marquee::style(underline = TRUE),
    `periwinkle-600` = marquee::style(
      color = omni::omni_colors("periwinkle-600")
    ),
    `plum-400` = marquee::style(
      color = omni::omni_colors("plum-400")
    )
  )

  omni_theme <- theme_minimal(base_family = base_family) +
    theme(
      panel.grid.minor = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_text(
        margin = margin(15, 0, 0, 0),
        size = 10,
        color = "#333333"
      ),
      axis.title.y = element_text(
        margin = margin(0, 15, 0, 0),
        size = 14,
        color = "#333333"
      ),
      axis.text = element_text(size = 11),
      plot.title = marquee::element_marquee(
        #margin = margin(0, 0, 15, 0),
        #color = "#666665",
        #face = "bold",
        #size = 13,
        style = omni_style,
        width = 1
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
