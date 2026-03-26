# Brand

Top-level brand object that combines metadata, color palette, and
typography settings into a single cohesive brand definition. Can be
serialized to a \`\_brand.yml\` file via \[brand_to_list()\] and
\[brand_write_yaml()\].

## Usage

``` r
Brand(meta = BrandMeta(), color = BrandColor(), typography = BrandTypography())
```

## Arguments

- meta:

  A \[BrandMeta\] object with brand metadata. Defaults to \`NULL\`.

- color:

  A \[BrandColor\] object with brand colors. Defaults to \`NULL\`.

- typography:

  A \[BrandTypography\] object with brand typography. Defaults to
  \`NULL\`.
