# Create a new Quarto website

\`create_website()\` creates a new directory with pre-defined Quarto
documents based on Omni branding.

## Usage

``` r
create_website(output_dir, brand = NULL, use_csi_logos = FALSE)
```

## Arguments

- output_dir:

  New directory that will contain the Quarto files.

- brand:

  Optional Brand object for custom branding (created with \`Brand()\`.
  Default template available via \`get_brand_template()\`). If not
  specified uses default \_brand.yml file.

- use_csi_logos:

  Boolean that determines whether CSI logos will be used. Defaults to
  \`FALSE\`.
