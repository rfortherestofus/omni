# Get a YAML metadata field, with inline R code evaluated

\[rmarkdown::metadata\] returns the YAML front matter exactly as it was
written, so a field that contains inline R code - a \`title\` built from
\`params\$site\`, for instance - comes back as the code itself rather
than as its value. \`omni_meta()\` returns the same field with any
inline code evaluated, which is what report templates need when the same
template is rendered repeatedly with different \`params\`.

## Usage

``` r
omni_meta(field, default = "", envir = knitr::knit_global())
```

## Arguments

- field:

  Name of the YAML field, such as \`"title"\`.

- default:

  Value returned when the field is missing or empty.

- envir:

  Environment used to evaluate the inline code. Defaults to the knitting
  environment, which is where \`params\` lives.

## Value

A character string.

## Examples

``` r
if (FALSE) { # \dontrun{
omni_meta("title")

omni_meta("acknowledgements", default = "our partners")
} # }
```
