# OMNI Institute ggplot2 theme

Applies the OMNI Institute theme to the plot. This also allows for
colorizing inline texts and using Markdown notation in title, subtitle
and caption of the plot.

## Usage

``` r
theme_omni(
  show_grid_lines = FALSE,
  show_legend = FALSE,
  base_family = "Inter Tight",
  plot_background_color = "White"
)
```

## Arguments

- show_grid_lines:

  Whether or not to show grid lines. FALSE by default.

- show_legend:

  Whether or not to show the legend. FALSE by default.

- base_family:

  Base font family. Inter Tight by default.

- plot_background_color:

  Plot background color. White by default, can be set to Ivory.

## Value

A ggplot2 theme
