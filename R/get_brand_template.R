#' Example Brand Template
#'
#' @description
#' Returns an example [Brand] object..
#' Includes color palette, Google and system fonts, and typography specs
#' for base text, headings, and links.
#'
#' The template can be inspected as source code via [print_brand_template()],
#' and used as a starting point for custom branding passed to [create_website()].
#'
#' @return A [Brand] object.
#'
#' @seealso [print_brand_template()], [Brand()], [create_website()]
#'
#' @export
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

#' Print the example Brand Template Source
#'
#' @description
#' Prints the source code of the default brand definition from
#' [brand_template()] to the console. Useful for inspecting the default
#' settings or copy-pasting them as a starting point for customization.
#'
#'
#' @return Called for its side effect of printing to the console. Returns
#'   `NULL` invisibly.
#'
#' @seealso [brand_template()]
#'
#' @export
print_brand_template <- function() {
  path_default_brand_function <- system.file(
    "brand_template.R",
    package = "omni",
    mustWork = TRUE
  )
  lines_default_brand <- readLines(path_default_brand_function)
  idx_lines_from_to <- stringr::str_which(
    lines_default_brand,
    "(Begin|End) default branding"
  ) +
    c(1, -1)
  lines_default_brand[idx_lines_from_to[1]:idx_lines_from_to[2]] |>
    cat(sep = '\n')
}
