# Omni chart header - the five text elements + their theme

Assembles the standard Omni header (top header / eyebrow, primary
finding, measure description, secondary finding, source & N) into a list
of ggplot additions. Add it to a plot with \`+\`. Every element except
\`primary\` is optional - pass \`NULL\` (the default) to omit it.
Text-only and geometry-agnostic; pair with \[omni_baseline()\] and
\[omni_highlight_labels()\] as needed.

## Usage

``` r
omni_header(
  primary,
  keyword = NULL,
  top_header = NULL,
  measure = NULL,
  finding = NULL,
  finding_keyword = NULL,
  source = NULL,
  n = NULL,
  color = "orange-red-600",
  primary_size = 18,
  eyebrow_size = 10
)
```

## Arguments

- primary:

  Required. The finding, written as a sentence.

- keyword:

  Substring of \`primary\` to color (first occurrence). \`NULL\` = all
  navy.

- top_header:

  Eyebrow line, e.g. \`"PROGRAM REACH - FY2024"\`. \`NULL\` = no
  eyebrow.

- measure:

  Measure description (subtitle). \`NULL\` = no subtitle.

- finding:

  Secondary finding sentence (caption). \`NULL\` = no secondary line.

- finding_keyword:

  Leading phrase of \`finding\` to color + give the stripe.

- source:

  Data source; rendered as \`"Source: \<source\>."\`.

- n:

  Sample size; rendered as \`"N = \<n\>."\`.

- color:

  The chart's one highlight color name (title keyword + finding
  keyword/stripe).

- primary_size, eyebrow_size:

  Font sizes in pt.

## Value

A list of ggplot components (\`labs()\` + \`theme()\`).

## Details

For a comparison header that names two colors instead of one keyword,
skip \`keyword\` and write \`primary\` yourself with one \[omni_span()\]
per called-out phrase.

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  omni_header(
    top_header = "MOTOR TRENDS - 1974",
    keyword    = "Heavier cars",
    primary    = "Heavier cars use more fuel",
    measure    = "Fuel economy by weight",
    source     = "mtcars",
    n          = 32
  )
```
