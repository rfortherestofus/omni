# Create a number emphasis element

Renders a number emphasis element, dispatching to
\[number_emphasis_html()\] or \[number_emphasis_typst()\] depending on
the output format (via \`knitr::is_html_output()\`).

## Usage

``` r
number_emphasis(
  number,
  text,
  color,
  font_size_pt = 16,
  text_font_size_pt = 12,
  fixed_width_px = 300
)
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

- text_font_size_pt:

  Font size of the info text in pt. Numeric vector of length 1. Defaults
  to 12.

- fixed_width_px:

  Width of the number emphasis in px. Must be numeric vector of
  length 1. Defaults to 300.

## See also

\[number_emphasis_html()\], \[number_emphasis_typst()\]
