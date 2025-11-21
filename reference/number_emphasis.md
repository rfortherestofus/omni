# Create a number emphasis element

This function creates the HTML & CSS for the desired number emphasis.

## Usage

``` r
number_emphasis(number, text, color, font_size_pt = 16, fixed_width_px = 300)
```

## Arguments

- number:

  The emphasized number. Numeric or character vector of length 1.

- text:

  The info text. Character vector of length 1.

- color:

  Desired background color. Must be one \`omni::omni_colors()\`

- font_size_pt:

  Font size of emphasized number in pt. Numeric vector of length 1.
  Defaults to 16.

- fixed_width_px:

  Width of the number emphasis in px. Must be numeric vector of
  length 1. Defaults to 300.

## Value

HTML & CSS that of the desired number emphasis

## Examples
