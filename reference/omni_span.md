# Color a phrase inside a header (or any ggtext/HTML text)

Returns an inline HTML \`\<span\>\` that sets \`text\` to a 600-level
brand color. Use it to build multi-color primary headers by hand: skip
\[omni_header()\]'s \`keyword\`/\`color\` shortcut (which colors a
single phrase) and write the primary with one \`omni_span()\` per
called-out phrase, composed with \`stringr::str_glue()\`.
\[omni_header()\] wraps the whole primary in navy, so each span
overrides it for its phrase. Also works inside a
\`scale\_\*\_discrete(labels = ...)\` labeller to color category labels
to match.

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

A character HTML \`\<span\>\` string.

## Examples

``` r
stringr::str_glue("{omni_span('Housing', 'periwinkle-600')} led the requests")
#> <span style='color:#5776B2'>Housing</span> led the requests
```
