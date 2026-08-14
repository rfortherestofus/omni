# Place icons and texts on grid (Typst)

This function creates the Typst markup that places the icons and texts
from \`omni_icon_typst()\` and \`icon_text_typst()\` on a grid.

## Usage

``` r
icon_text_grid_typst(..., width_px = 50, column_gap_px = 10, row_gap_px = 20)
```

## Arguments

- ...:

  Contents to be place on grid. Should consist of \`omni_icon_html()\`
  and \`icon_text_html()\` calls.

- width_px:

  Width of the circle in px. Numeric vector of length 1.

- column_gap_px:

  Gap between icon and text in px. Numeric vector of length 1.

- row_gap_px:

  Gap between rows in px. Numeric vector of length 1.

## Value

Raw Typst markup, inserted via \`knitr::asis_output()\`.
