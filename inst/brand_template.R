# Copied version from R/get_brand_template to be accessible after package is installed.
brand_template <- function() {
  # Begin default branding (leave line for get_brand_template() function)
  Brand(
    meta = BrandMeta(name = "brand.yml"),
    color = BrandColor(
      foreground = "#081c39",
      background = "#ffffff",
      primary = "#081c39",
      secondary = "#677384",
      my_custom_col1 = '#ff5e34',
      my_custom_col2 = '#f7b925'
    ),
    typography = BrandTypography(
      fonts = list(
        Font(family = 'Open Sans', source = 'google'),
        Font(family = 'Inter Tight', source = 'google'),
        Font(
          family = 'Helvetica Neue',
          source = 'system',
          dir_source = 'inst/fonts/helvetica_neue'
        )
      ),
      base = FontSpec(
        family = 'Helvetica Neue',
        'line-height' = 1.6
      ),
      headings = FontSpec(
        family = "Inter Tight",
        weight = "bold"
      ),
      link = FontSpec(color = "#5776b2")
    )
  )
  # End default branding (leave line for get_brand_template() function)
}
