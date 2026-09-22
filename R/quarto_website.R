#' @title Create a new Quarto website
#'
#' @description
#' `create_website()` creates a new directory with pre-defined
#' Quarto documents based on Omni branding.
#'
#' @param output_dir New directory that will contain the Quarto
#' files.
#' @param brand Optional Brand object for custom branding
#' (created with `Brand()`. Default template available via `brand_template()`).
#' If not specified uses default _brand.yml file.
#' @param use_csi_logos Boolean that determines whether CSI logos will be used. Defaults to `FALSE`.
#'
#' @export
#'
#' @importFrom utils file.edit
create_website <- function(output_dir, brand = NULL, use_csi_logos = FALSE) {
  ## Copy Quarto template -----
  source_dir <- system.file(
    "qmd-website",
    package = "omni",
    mustWork = TRUE
  )
  output_dir_full <- here::here(output_dir)

  files <- list.files(source_dir, full.names = TRUE)
  dir.create(output_dir_full, recursive = TRUE, showWarnings = FALSE)
  suppressWarnings(
    out <- file.copy(
      from = files,
      to = file.path(output_dir_full, basename(files)),
      recursive = TRUE
    )
  )

  ## Modify logo if needed -----
  if (use_csi_logos) {
    path_out_quarto_settings <- fs::path(output_dir_full, '_quarto.yml')
    set_csi_logos_in_quarto_yml(path_out_quarto_settings)
  }

  ## Branding -----
  is_custom_branding <- write_brand_yml(output_dir_full, brand)
  if (is_custom_branding) {
    write_custom_css_files(output_dir_full, brand)
    copy_custom_font_files(output_dir_full, brand)
  }

  file.edit(file.path(output_dir_full, "index.qmd"))
}


set_csi_logos_in_quarto_yml <- function(path_quarto_settings) {
  list_quarto_yml <- yaml::read_yaml(path_quarto_settings)

  url_logo <- "https://github.com/rfortherestofus/omni/blob/main/inst/assets/images/logo-no-text-csi.png?raw=true"
  list_quarto_yml$website$navbar$logo <- url_logo

  footer_logo <- "[![](https://github.com/rfortherestofus/omni/blob/main/inst/assets/images/logo-csi.png?raw=true){fig-alt=\"Omni institute\" width=100px}](https://www.omni.org/)\n"
  list_quarto_yml$website$`page-footer`$right <- footer_logo

  list_quarto_yml |>
    yaml::write_yaml(
      file = path_quarto_settings,
      handlers = list(
        logical = function(x) {
          result <- ifelse(x, "true", "false")
          class(result) <- "verbatim"
          result
        }
      )
    )
}


write_custom_css_files <- function(output_dir_full, brand) {
  # Prepare colors in styles.css
  path_style_file <- here::here(output_dir_full, 'styles.css')
  class_texts <- create_brand_css(brand)
  cat(
    "\n\n/* --- brand colors --- */\n",
    file = path_style_file,
    append = TRUE
  )
  cat(class_texts, file = path_style_file, append = TRUE)

  # Prepare fonts in fonts.css
  path_fonts_css_file <- here::here(output_dir_full, 'fonts.css')
  css_fonts <- brand_system_fonts(brand) |>
    purrr::map(
      \(font) {
        generate_font_face_css(
          family_name = font@family,
          source_dir = font@dir_source,
          output_dir = font_output_dir(font)
        )
      }
    ) |>
    paste0(collapse = "\n")
  writeLines(css_fonts, path_fonts_css_file)
}

create_brand_css <- function(brand) {
  check_brand(brand)
  brand_colors <- brand@color |>
    S7::props() |>
    purrr::flatten()
  brand_colors |>
    purrr::imap(\(val, name) {
      paste0(".brand_", name, " {\n  ", htmltools::css(color = val), "\n}\n")
    }) |>
    paste0(collapse = '\n')
}

generate_font_face_css <- function(
  source_dir,
  family_name,
  output_dir
) {
  font_file_specs(source_dir) |>
    purrr::map_chr(\(spec) {
      glue::glue(
        '@font-face {{\n',
        '  font-family: "{family_name}";\n',
        '  src: url("{output_dir}/{spec$file}") format("{spec$format}");\n',
        '  font-weight: {spec$weight};\n',
        '  font-style: {spec$style};\n',
        '}}'
      )
    }) |>
    stringr::str_c(collapse = "\n\n")
}
