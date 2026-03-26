# Brand Typography

Defines the typographic settings for a brand, including font definitions
and role-specific font specs for base text, headings, links, and
monospace.

## Usage

``` r
BrandTypography(
  fonts = list(),
  base = FontSpec(),
  headings = FontSpec(),
  link = FontSpec(),
  monospace = FontSpec()
)
```

## Arguments

- fonts:

  A list of \[Font\] objects defining available font families.

- base:

  A \[FontSpec\] object for base body text. Defaults to \`NULL\`.

- headings:

  A \[FontSpec\] object for heading text. Defaults to \`NULL\`.

- link:

  A \[FontSpec\] object for link text. Defaults to \`NULL\`.

- monospace:

  A \[FontSpec\] object for monospace/code text. Defaults to \`NULL\`.
