# Set an explicit running footer title

Point the running footer string at a dedicated element instead of the
report title. paged.js only supports \`content(text)\` in
\`string-set\`, so a literal string cannot be used; \`pdf_report()\`
pairs this with a hidden carrier element emitted at the top of the body.

## Usage

``` r
set_footer_title(file)
```

## Arguments

- file:

  CSS file path
