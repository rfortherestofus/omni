#' Build the marquee style shared by Omni's title/subtitle/caption text
#'
#' Registers each brand color name (e.g. `"plum-600"`) as a marquee tag, so
#' `{.plum-600 text}` markdown resolves to that color. Used by [theme_omni()]
#' (which layers per-slot overrides, e.g. size/weight, on top of this) and by
#' [omni_header()]'s `plot.caption`, which needs the same color tags
#' available for `finding_keyword` but builds its own `element_marquee()`
#' independently of whatever theme is already applied - it must not rely on
#' inheriting a style from a prior `plot.caption` element via ggplot2's
#' theme-merge behavior, which only backfills unset fields when one exists
#' to backfill from.
#'
#' @noRd
.omni_marquee_style <- function() {
  style_wo_colors <- marquee::style_set(
    base = marquee::base_style(weight = "bold", size = 13),
    str = marquee::style(weight = "bold"),
    em = marquee::style(italic = TRUE),
    u = marquee::style(underline = TRUE)
  )

  colors_named <- omni_colors(named = TRUE)
  purrr::reduce2(
    .x = names(colors_named),
    # color names
    .y = unname(colors_named),
    # color hex codes
    .f = \(style, color_name, color_hex) {
      style |>
        marquee::modify_style(
          tag = color_name,
          color = color_hex
        )
    },
    .init = style_wo_colors
  )
}

#' Build the marquee style for caption text
#'
#' [.omni_marquee_style()] with the caption's quieter typography layered on
#' top: smaller, normal weight, italic. The caption sits below the plot and
#' must read as subordinate to the subtitle above it, so it must not inherit
#' the shared base's larger bold setting.
#'
#' Both [theme_omni()] and [omni_header()] set `plot.caption` themselves, and
#' each must pass a fully-specified style rather than relying on ggplot2's
#' theme-merge to backfill one from the other (see [.omni_marquee_style()]).
#' They share this helper so the two can't drift apart - they have twice
#' before, once on color and once on size/weight.
#'
#' @noRd
.omni_caption_style <- function() {
  .omni_marquee_style() |>
    marquee::modify_style(
      "base",
      size = 12,
      weight = "normal",
      italic = TRUE
    )
}

#' Build the marquee style for the measure description (subtitle)
#'
#' [.omni_marquee_style()] with the measure description's typography layered
#' on top: normal weight, not italic, in the chart gray. Mirrors
#' [.omni_caption_style()], so each of [omni_header()]'s three slots is built
#' from a named style helper rather than assembled inline.
#'
#' This is [omni_header()]'s subtitle, not [theme_omni()]'s. `theme_omni()`
#' keeps its own subtitle treatment (larger, darker) for charts that carry a
#' plain subtitle without the header - matching them would restyle those
#' charts, which is a separate decision.
#'
#' The base carries no bottom margin: a margin there applies to every
#' paragraph, so it would add space below a wrapped subtitle's last line as
#' well as between its lines.
#'
#' @noRd
.omni_subtitle_style <- function() {
  .omni_marquee_style() |>
    marquee::modify_style(
      "base",
      weight = "normal",
      italic = FALSE,
      color = omni_colors("chart-gray"),
      margin = marquee::trbl(0, 0, 0)
    )
}

#' OMNI Institute ggplot2 theme
#'
#' @description Applies the OMNI Institute theme to the plot.
#' This also allows for colorizing inline texts and using Markdown notation in title, subtitle and caption of the plot.
#'
#' @param show_legend Whether or not to show the legend. FALSE by default.
#' @param base_family Base font family. Inter Tight by default.
#' @param show_grid_lines Whether or not to show grid lines. FALSE by default.
#' @param plot_background_color Plot background color. White by default, can be set to Ivory.
#'
#' @return A ggplot2 theme
#' @export
#'
#' @importFrom ggplot2 theme_minimal theme element_blank element_text margin
theme_omni <- function(
  show_grid_lines = FALSE,
  show_legend = FALSE,
  base_family = "Inter Tight",
  plot_background_color = "White"
) {
  omni_style <- .omni_marquee_style()
  # general theme based on theme_minimal
  omni_theme <- theme_minimal(base_family = base_family) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(
        linewidth = 0.25,
        color = omni_colors("steel-blue-200")
      ),
      axis.ticks = element_blank(),
      axis.title.x = element_text(
        margin = margin(15, 0, 0, 0),
        size = 14,
        color = omni_colors("chart-gray")
      ),
      axis.title.y = element_text(
        margin = margin(0, 15, 0, 0),
        size = 12,
        color = omni_colors("chart-gray")
      ),
      axis.text = element_text(size = 12, color = omni_colors("chart-gray")),
      plot.title = marquee::element_marquee(
        margin = margin(0, 0, 0, 0),
        color = "#666665",
        # see omni_header(): element_marquee()'s own size beats the style base,
        # so a size set only in the style never applies.
        size = 13,
        style = omni_style,
        width = 1
      ),
      plot.title.position = "plot",
      plot.subtitle = marquee::element_marquee(
        width = 1,
        margin = margin(-4, 0, 0, 0),
        size = 13,
        style = omni_style |>
          marquee::modify_style(
            "base",
            size = 13,
            color = "#333333",
            weight = "normal"
          )
      ),
      # hjust = 0 is set explicitly: ggplot2 right-aligns captions by default,
      # and this theme previously overrode the caption's size, weight and
      # italic but not its alignment - so a chart built with theme_omni()
      # alone put source/N bottom-right, while the same chart built through
      # omni_header() (which sets hjust = 0) put it bottom-left. Left is the
      # brand standard; both paths now agree regardless of the order they
      # are applied in.
      # width = 1 on the subtitle and caption as well as the title: these two
      # were the only marquee slots without it, so long text was clipped at
      # the canvas edge instead of wrapping. Keeping the field set on all
      # three also stops this slot pair drifting from omni_header()'s a
      # fourth time, after color (#267), size/weight (#276) and alignment.
      plot.caption = marquee::element_marquee(
        width = 1,
        hjust = 0,
        size = 12,
        style = .omni_caption_style()
      ),
      plot.margin = margin(
        t = 7,
        r = 7,
        b = 7,
        l = 7,
        unit = "points"
      ),
      plot.background = element_rect(
        fill = omni_colors("white"),
        color = omni_colors("white")
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

  if (plot_background_color |> stringr::str_to_lower() == "ivory") {
    omni_theme <- omni_theme +
      theme(
        plot.background = element_rect(
          fill = omni_colors("ivory"),
          color = omni_colors("ivory")
        )
      )
  }

  # return
  omni_theme
}

#' Create theme for OMNI's clients.
#'
#' @param show_legend Whether or not to show the legend. FALSE by default.
#' @param base_family Base font family. Inter Tight by default.
#' @param show_grid_lines Whether or not to show grid lines. FALSE by default.
#' @param plot_background_color Plot background color. White by default, can be set to Ivory.
#'
#' @return A ggplot2 theme
#' @export
#'
#' @importFrom ggplot2 theme_minimal theme element_blank element_text margin
theme_client <- function(
  show_grid_lines = FALSE,
  show_legend = FALSE,
  base_family = "Inter Tight",
  plot_background_color = "White"
) {
  theme_omni(
    show_grid_lines = show_grid_lines,
    show_legend = show_legend,
    base_family = base_family,
    plot_background_color = plot_background_color
  )
}
