# Brand Color Palette

Defines the color scheme for a brand, including semantic roles such as
\`foreground\`, \`background\`, \`primary\`, and \`secondary\`, as well
as an arbitrary named palette of additional colors passed via \`...\`.

## Usage

``` r
BrandColor(
  foreground = NULL,
  background = NULL,
  primary = NULL,
  secondary = NULL,
  ...
)
```

## Arguments

- foreground:

  A character string with the foreground (text) color.

- background:

  A character string with the background color.

- primary:

  A character string with the primary brand color.

- secondary:

  A character string with the secondary brand color.

- ...:

  Additional named character strings added to the color palette (e.g.
  \`accent = "#FF5733"\`). Each must be a single character string.
