# Color a phrase inside a header

Returns a marquee markdown span that sets \`text\` to a 600-level brand
color. Use it to build multi-color primary headers by hand: skip
\[omni_header()\]'s \`keyword\`/\`color\` shortcut (which colors a
single phrase) and write the primary with one \`omni_span()\` per
called-out phrase, composed with \`stringr::str_glue()\`.
\[omni_header()\] renders the whole primary in navy, so each span
overrides it for its phrase.

## Usage

``` r
omni_span(text, color)
```

## Arguments

- text:

  Phrase to color (scalar or vector).

- color:

  A brand color name, e.g. \`"periwinkle-600"\`.

## Value

A character marquee markdown string.

## Details

This is for \[omni_header()\]'s \`primary\` and \`top_header\`, which
are marquee markdown. To color a category label on an axis, use
\[omni_highlight_labels()\] instead - axis text is rendered by ggtext,
which reads HTML rather than marquee markdown, so the two are not
interchangeable.

## Examples

``` r
stringr::str_glue("{omni_span('Housing', 'periwinkle-600')} led the requests")
#> {.periwinkle-600 Housing} led the requests
```
