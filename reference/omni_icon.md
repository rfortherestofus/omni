# Get one of the pre-defined Omni icons

This function creates the HTML & CSS for the icon that should be placed
into the text icon grid. The HTML container of the icon always centers
inside the surrounding environment.

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

## Value

HTML & CSS that of the desired icon (can be transformed into plain text
using \`as.character()\`)

## Examples

``` r
omni_icon('education', 50, 'teal 600', 'white')
#> Error in omni_icon("education", 50, "teal 600", "white"): `icon_color_bg` must be one of "white", "ivory", "ivory-400",
#> "orange-red-200", "orange-red-400", "orange-red-600", "golden-yellow-200",
#> "golden-yellow-400", "golden-yellow-600", "olive-green-200", "olive-green-400",
#> "olive-green-600", "teal-200", "teal-400", "teal-600", "plum-200", "plum-400",
#> "plum-600", …, "steel-blue-600", and "navy". See `omni_colors()`
#> (`?omni::omni_colors()`).
```
