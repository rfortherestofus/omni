# Get one of the pre-defined Omni icons

Renders an icon, dispatching to \[omni_icon_html()\] or
\[omni_icon_typst()\] depending on the output format (via
\`knitr::is_html_output()\`).

## Usage

``` r
omni_icon(icon_name, width_px, icon_color_bg, icon_color_fg)
```

## Arguments

- icon_name:

  The icon name. Must be character vector of length 1.

- width_px:

  Width of the circle in px. Numeric vector of length 1.

- icon_color_bg:

  Desired background color. Must be one \`omni::omni_colors()\`.

- icon_color_fg:

  Desired icon color. Should be 'white' or 'black' but technically all
  hex codes and CSS colors work.

## See also

\[omni_icon_html()\], \[omni_icon_typst()\]
