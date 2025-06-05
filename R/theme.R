#' OMNI Institute ggplot2 theme
#'
#' @description Applies the OMNI Institute theme to the plot.
#' This also allows for colorizing inline texts and using Markdown notation in title, subtitle and caption of the plot.
#'
#' @param show_legend Whether or not to show the legend. FALSE by default.
#' @param base_family Base font family. Inter Tight by default.
#' @param show_grid_lines Whether or not to show grid lines. FALSE by default.
#' @param plot_background_color Whether to make background color Ivory or White
#'
#' @return A ggplot2 theme
#' @export
#'
#' @importFrom ggplot2 theme_minimal theme element_blank element_text margin
theme_omni <- function(
  show_grid_lines = FALSE,
  show_legend = FALSE,
  base_family = "Inter Tight",
  plot_background_color = "Ivory"
) {
  style_wo_colors <- marquee::style_set(
    base = marquee::base_style(weight = 'bold', size = 13),
    str = marquee::style(weight = 'bold'),
    em = marquee::style(italic = TRUE),
    u = marquee::style(underline = TRUE)
  )

  # Iteratively add the color tag styles
  omni_colors <- omni_colors(named = TRUE)
  omni_style <- purrr::reduce2(
    .x = names(omni_colors), # color names
    .y = unname(omni_colors), # color hex codes
    .f = \(style, color_name, color_hex) {
      style |>
        marquee::modify_style(
          tag = color_name,
          color = color_hex
        )
    },
    .init = style_wo_colors
  )
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
        size = 12,
        color = "#333333"
      ),
      axis.text = element_text(size = 11),
      plot.title = marquee::element_marquee(
        margin = margin(0, 0, 15, 0),
        color = "#666665",
        style = omni_style,
        width = 1
      ),
      plot.title.position = "plot",
      plot.subtitle = marquee::element_marquee(
        style = omni_style |>
          marquee::modify_style(
            "base",
            size = 13,
            color = "#333333",
            weight = 'normal'
          )
      ),
      plot.caption = marquee::element_marquee(
        style = omni_style |>
          marquee::modify_style(
            "base",
            size = 12,
            weight = 'normal',
            italic = TRUE
          )
      ),
      plot.margin = margin(
        t = 7,
        r = 7,
        b = 7,
        l = 7,
        unit = "points"
      ),
      plot.background = 
        element_rect(
          fill = omni_colors("ivory"),
          color = omni_colors("ivory")
        )
    )

  if (show_grid_lines == FALSE) {
    omni_theme <- omni_theme +
      theme(panel.grid.major = element_blank())
  }

  if (show_legend == FALSE) {
    omni_theme <- omni_theme +
      theme(legend.position = "none")
  }
  
  if (plot_background_color |> stringr::str_to_lower() == "white") {
    omni_theme <- omni_theme +
      theme(plot.background = 
              element_rect(
                fill = omni_colors("white"),
                color = omni_colors("white")
              ))
  }

  # return
  omni_theme
}
