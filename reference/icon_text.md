# Text for Icon-Text-Grid

Renders text for the icon-text-grid, dispatching to \[icon_text_html()\]
or \[icon_text_typst()\] depending on the output format (via
\`knitr::is_html_output()\`).

## Usage

``` r
icon_text(text, width_px = 400)
```

## Arguments

- text:

  Text that is placed ont the grid. Must be character vector of
  length 1. Can use Markdown notation.

- width_px:

  Width of the text. Must be numeric vector of length 1. Defaults to 400

## See also

\[icon_text_html()\], \[icon_text_typst()\]
