#' @title Create a new Quarto website
#'
#' @description
#' `create_website()` creates a new directory with pre-defined
#' Quarto documents based on Omni branding.
#'
#' @param output_dir New directory that will contain the Quarto
#' files.
#' @param brand Optional Brand object for custom branding
#' (created with `Brand()`. Default template available via `get_brand_template()`).
#' If not specified uses default _brand.yml file.
#'
#' @export
#'
#' @importFrom utils file.edit
create_website <- function(output_dir, brand = NULL) {
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

  use_default_branding <- is.null(brand)
  if (use_default_branding) {
    cli::cli_alert_info('Using default branding.')
    return(file.edit(file.path(output_dir_full, "index.qmd")))
  }

  if (!inherits(brand, "omni::Brand")) {
    cli::cli_abort(
      "{.arg brand} must be Brand object (created with {.fun Brand})"
    )
  }
  cli::cli_alert_info('Using custom branding.')

  path_new_brand_file <- here::here(output_dir_full, '_brand.yml')
  brand |>
    brand_to_list() |>
    yaml::write_yaml(path_new_brand_file)

  write_custom_css_files(output_dir_full, brand)
  copy_custom_font_files(output_dir_full, brand)

  file.edit(file.path(output_dir_full, "index.qmd"))
}


copy_custom_font_files <- function(output_dir_full, brand) {
  list_system_fonts <- brand@typography@fonts |>
    purrr::keep(\(font) font@source == 'system')
  list_system_fonts |>
    purrr::walk(\(font) {
      fs::dir_copy(
        font@dir_source,
        fs::path(output_dir_full, "fonts", font@dir_source),
        overwrite = TRUE
      )
    })
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
  list_system_fonts <- brand@typography@fonts |>
    purrr::keep(\(font) font@source == 'system')
  css_fonts <- list_system_fonts |>
    purrr::map(
      \(font) {
        generate_font_face_css(
          family_name = font@family,
          source_dir = font@dir_source,
          output_dir = fs::path("fonts", font@dir_source)
        )
      }
    ) |>
    paste0(collapse = "\n")
  writeLines(css_fonts, path_fonts_css_file)
}

create_brand_css <- function(brand) {
  if (!inherits(brand, "omni::Brand")) {
    cli::cli_abort(
      "{.arg brand} must be Brand object (created with {.fun Brand})"
    )
  }
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
  # Weight name mapping
  weight_map <- c(
    "thin" = 100,
    "ultralight" = 200,
    "extralight" = 200,
    "light" = 300,
    "roman" = 400,
    "regular" = 400,
    "medium" = 500,
    "semibold" = 600,
    "bold" = 700,
    "heavy" = 800,
    "extrabold" = 800,
    "black" = 900
  )

  format_map <- c(
    "otf" = "opentype",
    "ttf" = "truetype",
    "woff" = "woff",
    "woff2" = "woff2"
  )

  fs::dir_ls(source_dir, regexp = "\\.(otf|ttf|woff|woff2)$") |>
    purrr::map_chr(\(file_path) {
      file_name <- fs::path_ext_remove(fs::path_file(file_path))
      file_ext <- fs::path_ext(file_path) |> stringr::str_to_lower()
      name_lower <- stringr::str_to_lower(file_name)

      style <- if (stringr::str_detect(name_lower, "italic")) {
        "italic"
      } else {
        "normal"
      }

      # Detect weight by finding first matching keyword
      idx_weight_match <- purrr::detect(names(weight_map), \(key) {
        stringr::str_detect(name_lower, key)
      })
      weight <- weight_map[idx_weight_match]
      weight <- if (length(weight) == 0 || is.na(weight)) {
        400
      } else {
        as.integer(weight)
      }

      fmt <- format_map[[file_ext]]
      glue::glue(
        '@font-face {{\n',
        '  font-family: "{family_name}";\n',
        '  src: url("{output_dir}/{fs::path_file(file_path)}") format("{fmt}");\n',
        '  font-weight: {weight};\n',
        '  font-style: {style};\n',
        '}}'
      )
    }) |>
    stringr::str_c(collapse = "\n\n")
}
