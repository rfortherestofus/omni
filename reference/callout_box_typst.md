# Create a callout box (Typst)

This function creates the Typst markup for the desired callout boxes. It
can use the "version 600" colors of the color palette and highlight
specific text via \`\<highlight\>\` tags.

## Usage

``` r
callout_box_typst(text, color, fixed_width_px = 300)
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

## Value

Raw Typst markup for the desired callout box, inserted via
\`knitr::asis_output()\`.
