# Font Definition

Defines a font family and its source for use in brand typography. When
\`source\` is \`"system"\`, a \`dir_source\` path to the local font
files must be provided.

## Usage

``` r
Font(family = character(0), source = character(0), dir_source = character(0))
```

## Arguments

- family:

  A character string with the font family name (e.g. \`"Helvetica
  Neue"\`).

- source:

  A character string specifying the font source. Must be one of
  \`"system"\` (local files) or \`"google"\` (Google Fonts).

- dir_source:

  A character string with the path to the directory containing local
  font files. Required when \`source\` is \`"system"\`, ignored
  otherwise.
