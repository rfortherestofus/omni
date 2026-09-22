#' Check that an object is a Brand
#'
#' @param brand Object to check.
#'
#' @return `brand`, invisibly. Aborts if it is not a [Brand] object.
#'
#' @noRd
check_brand <- function(brand) {
  if (!inherits(brand, "omni::Brand")) {
    cli::cli_abort(
      "{.arg brand} must be Brand object (created with {.fun Brand})"
    )
  }
  invisible(brand)
}


#' Write a custom `_brand.yml` into a Quarto project
#'
#' @description
#' Shared by [create_report()] and [create_website()]. With `brand = NULL`
#' the shipped `_brand.yml` is kept and a message says so. Otherwise the
#' brand is validated, serialized with [brand_to_list()] and written to
#' `<output_dir_full>/_brand.yml`.
#'
#' @param output_dir_full Absolute path to the Quarto project directory.
#' @param brand A [Brand] object or `NULL` for the default branding.
#' @param fonts_as_files If `TRUE`, fonts with `source = "system"` are
#' written as brand.yml `source: file` entries pointing at the files
#' that [copy_custom_font_files()] copies under `fonts/`. Quarto then
#' embeds them itself (HTML `@font-face`, Typst `font-paths`).
#'
#' @return `TRUE` if a custom `_brand.yml` was written, `FALSE` if the
#' default branding is kept. Invisibly.
#'
#' @noRd
write_brand_yml <- function(output_dir_full, brand, fonts_as_files = FALSE) {
  if (is.null(brand)) {
    cli::cli_alert_info("Using default branding.")
    return(invisible(FALSE))
  }
  check_brand(brand)
  cli::cli_alert_info("Using custom branding.")

  brand_list <- brand_to_list(brand)
  if (fonts_as_files) {
    brand_list$typography$fonts <- brand_fonts_as_files(brand)
  }

  yaml::write_yaml(brand_list, fs::path(output_dir_full, "_brand.yml"))
  invisible(TRUE)
}


#' Fonts of a Brand as brand.yml entries, with system fonts as files
#'
#' @param brand A [Brand] object.
#'
#' @return A list of brand.yml font entries. Fonts with
#' `source = "system"` become `source: file` entries whose `files` list
#' the font files found in `dir_source`, with their weight and style, at
#' the location used by [copy_custom_font_files()].
#'
#' @noRd
brand_fonts_as_files <- function(brand) {
  brand@typography@fonts |>
    purrr::map(\(font) {
      if (font@source != "system") {
        return(S7::props(font)[c("family", "source")])
      }
      files <- font_file_specs(font@dir_source) |>
        purrr::map(\(spec) {
          list(
            path = as.character(fs::path(font_output_dir(font), spec$file)),
            weight = spec$weight,
            style = spec$style
          )
        })
      list(family = font@family, source = "file", files = files)
    })
}


#' System fonts of a Brand
#'
#' @param brand A [Brand] object.
#'
#' @return The [Font] objects with `source = "system"`.
#'
#' @noRd
brand_system_fonts <- function(brand) {
  brand@typography@fonts |>
    purrr::keep(\(font) font@source == "system")
}


#' Directory of a system font inside a Quarto project
#'
#' @param font A [Font] object with `source = "system"`.
#'
#' @return Path relative to the project root, `fonts/<dir name>`.
#'
#' @noRd
font_output_dir <- function(font) {
  fs::path("fonts", fs::path_file(font@dir_source))
}


#' Copy the system fonts of a Brand into a Quarto project
#'
#' @param output_dir_full Absolute path to the Quarto project directory.
#' @param brand A [Brand] object.
#'
#' @return `NULL`, invisibly. Called for its side effect.
#'
#' @noRd
copy_custom_font_files <- function(output_dir_full, brand) {
  brand_system_fonts(brand) |>
    purrr::walk(\(font) {
      fs::dir_copy(
        font@dir_source,
        fs::path(output_dir_full, font_output_dir(font)),
        overwrite = TRUE
      )
    })
  invisible(NULL)
}


#' Describe the font files of a directory
#'
#' @description
#' Weight and style are guessed from the file name (e.g.
#' `HelveticaNeueBoldItalic.otf` is weight 700, italic). Unknown weights
#' default to 400.
#'
#' @param source_dir Directory containing `.otf`, `.ttf`, `.woff` or
#' `.woff2` files.
#'
#' @return A list with one element per font file, each a list with
#' `file` (file name), `weight` (integer), `style` (`"normal"` or
#' `"italic"`) and `format` (CSS `format()` name).
#'
#' @noRd
font_file_specs <- function(source_dir) {
  # Longer names first so "extrabold" is not read as "bold".
  weight_map <- c(
    "thin" = 100,
    "ultralight" = 200,
    "extralight" = 200,
    "light" = 300,
    "roman" = 400,
    "regular" = 400,
    "medium" = 500,
    "semibold" = 600,
    "extrabold" = 800,
    "bold" = 700,
    "heavy" = 800,
    "black" = 900
  )
  format_map <- c(
    "otf" = "opentype",
    "ttf" = "truetype",
    "woff" = "woff",
    "woff2" = "woff2"
  )

  fs::dir_ls(source_dir, regexp = "\\.(otf|ttf|woff|woff2)$") |>
    unname() |>
    purrr::map(\(file_path) {
      file_name <- fs::path_file(file_path)
      name_lower <- stringr::str_to_lower(fs::path_ext_remove(file_name))
      file_ext <- stringr::str_to_lower(fs::path_ext(file_path))

      weight_key <- purrr::detect(names(weight_map), \(key) {
        stringr::str_detect(name_lower, key)
      })
      weight <- if (is.null(weight_key)) {
        400L
      } else {
        as.integer(weight_map[[weight_key]])
      }

      style <- if (stringr::str_detect(name_lower, "italic")) {
        "italic"
      } else {
        "normal"
      }

      list(
        file = file_name,
        weight = weight,
        style = style,
        format = format_map[[file_ext]]
      )
    })
}
