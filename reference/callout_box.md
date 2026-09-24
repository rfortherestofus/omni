# Create a callout box

Renders a callout box, dispatching to \[callout_box_html()\] or
\[callout_box_typst()\] depending on the output format (via
\`knitr::is_html_output()\`).

## Usage

``` r
callout_box(text, color, fixed_width_px = 300)
```

## Arguments

- text:

  The text of the callout box. Character vector of length 1. Text that
  is supposed to be highlighted needs to be wrapped in
  \<highlight\>\</highlight\> tags.

- color:

  The color of the callout box. One of the "version 600" colors from
  omni_colors(), i.e. "orange-red-600", "golden-yellow-600", "teal-600",
  "plum-600", "periwinkle-600"

- fixed_width_px:

  Width of the callout box in px. Must be numeric vector of length 1.
  Defaults to 300.

## See also

\[callout_box_html()\], \[callout_box_typst()\]
