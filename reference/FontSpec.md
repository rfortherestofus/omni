# Font Specification

Specifies typographic properties for a text role (e.g. base, headings,
links), such as font family, weight, size, color, and line height.

## Usage

``` r
FontSpec(
  family = character(0),
  weight = character(0),
  size = character(0),
  color = character(0),
  `line-height` = integer(0)
)
```

## Arguments

- family:

  A character string with the font family name.

- weight:

  An optional character string with the font weight (e.g. \`"400"\`,
  \`"bold"\`).

- size:

  An optional character string with the font size (e.g. \`"1rem"\`,
  \`"16px"\`).

- color:

  An optionalcharacter string with the font color as a hex code or CSS
  value.

- line-height:

  An optional numeric value for the line height (e.g. \`1.5\`).
