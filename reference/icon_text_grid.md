# Place icons and texts on grid

Renders an icon-text grid, dispatching to \[icon_text_grid_html()\] or
\[icon_text_grid_typst()\] depending on the output format (via
\`knitr::is_html_output()\`).

## Usage

``` r
icon_text_grid(..., width_px = 50, column_gap_px = 10, row_gap_px = 20)
```

## Arguments

- ...:

  Contents to be placed on grid (\`omni_icon()\`/\`icon_text()\` calls).

- width_px:

  Width of the circle in px. Numeric vector of length 1.

- column_gap_px:

  Gap between icon and text in px. Numeric vector of length 1.

- row_gap_px:

  Gap between rows in px. Numeric vector of length 1.

## See also

\[icon_text_grid_html()\], \[icon_text_grid_typst()\]
