# Text for Icon-Text-Grid (Typst)

This function creates the Typst markup that contains the text for the
icon-text-grid

## Usage

``` r
icon_text_typst(text, width_px = 400)
```

## Arguments

- text:

  Text that is placed ont the grid. Must be character vector of
  length 1. Can use Markdown notation.

- width_px:

  Width of the text. Must be numeric vector of length 1. Defaults to 400

## Value

Raw Typst markup, inserted via \`knitr::asis_output()\`.
