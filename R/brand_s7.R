# --- Sub-classes ---

#' Brand Metadata
#'
#' @param name A character string that become the name inside the _brand.yml file
#'
#' @export
BrandMeta <- S7::new_class(
  "BrandMeta",
  properties = list(
    name = S7::new_property(S7::class_character, default = NULL)
  )
)

#' Font Definition
#'
#' @description
#' Defines a font family and its source for use in brand typography.
#' When `source` is `"system"`, a `dir_source` path to the local font
#' files must be provided.
#'
#' @param family A character string with the font family name (e.g. `"Helvetica Neue"`).
#' @param source A character string specifying the font source. Must be one of
#'   `"system"` (local files) or `"google"` (Google Fonts).
#' @param dir_source A character string with the path to the directory containing
#'   local font files. Required when `source` is `"system"`, ignored otherwise.
#'
#' @export
Font <- S7::new_class(
  "Font",
  properties = list(
    family = S7::new_property(S7::class_character),
    source = S7::new_property(S7::class_character),
    dir_source = S7::new_property(S7::class_character | NULL, default = NULL)
  ),
  validator = function(self) {
    valid_sources <- c("system", "google")
    is_invalid_source <- !(self@source %in% valid_sources)
    if (is_invalid_source) {
      cli::cli_abort(
        "{.arg source} must be one of {.or {.val {valid_sources}}}"
      )
    }

    is_no_source_for_system_font <- self@source == "system" &&
      is.null(self@dir_source)
    if (is_no_source_for_system_font) {
      cli::cli_abort(
        "{.arg dir_source} must be provided when {.arg source} is {.val system}",
      )
    }

    NULL
  }
)

#' Font Specification
#'
#' @description
#' Specifies typographic properties for a text role (e.g. base, headings, links),
#' such as font family, weight, size, color, and line height.
#'
#' @param family A character string with the font family name.
#' @param weight An optional character string with the font weight (e.g. `"400"`, `"bold"`).
#' @param size An optional character string with the font size (e.g. `"1rem"`, `"16px"`).
#' @param color An optionalcharacter string with the font color as a hex code or CSS value.
#' @param line-height An optional numeric value for the line height (e.g. `1.5`).
#'
#' @export
FontSpec <- S7::new_class(
  "FontSpec",
  properties = list(
    family = S7::new_property(S7::class_character | NULL, default = NULL),
    weight = S7::new_property(S7::class_character | NULL, default = NULL),
    size = S7::new_property(S7::class_character | NULL, default = NULL),
    color = S7::new_property(S7::class_character | NULL, default = NULL),
    'line-height' = S7::new_property(S7::class_numeric | NULL, default = NULL)
  )
)

#' Brand Color Palette
#'
#' @description
#' Defines the color scheme for a brand, including semantic roles such as
#' `foreground`, `background`, `primary`, and `secondary`, as well as an
#' arbitrary named palette of additional colors passed via `...`.
#'
#' @param foreground A character string with the foreground (text) color.
#' @param background A character string with the background color.
#' @param primary A character string with the primary brand color.
#' @param secondary A character string with the secondary brand color.
#' @param ... Additional named character strings added to the color palette
#'   (e.g. `accent = "#FF5733"`). Each must be a single character string.
#'
#' @export
BrandColor <- S7::new_class(
  "BrandColor",
  properties = list(
    foreground = S7::new_property(S7::class_character),
    background = S7::new_property(S7::class_character),
    primary = S7::new_property(S7::class_character),
    secondary = S7::new_property(S7::class_character),
    palette = S7::new_property(S7::class_list, default = list())
  ),
  # Custom constructor that routes unknown args into palette
  constructor = function(
    foreground = NULL,
    background = NULL,
    primary = NULL,
    secondary = NULL,
    ...
  ) {
    palette <- list(...)

    # Validate that all palette values are single strings
    bad_configs <- palette |>
      purrr::keep(\(x) !is.character(x) || length(x) != 1L) |>
      names()
    if (length(bad_configs)) {
      cli::cli_abort("Palette values must be single character strings")
    }

    S7::new_object(
      BrandColor,
      foreground = foreground,
      background = background,
      primary = primary,
      secondary = secondary,
      palette = palette
    )
  }
)

#' Brand Typography
#'
#' @description
#' Defines the typographic settings for a brand, including font definitions
#' and role-specific font specs for base text, headings, links, and monospace.
#'
#' @param fonts A list of [Font] objects defining available font families.
#' @param base A [FontSpec] object for base body text. Defaults to `NULL`.
#' @param headings A [FontSpec] object for heading text. Defaults to `NULL`.
#' @param link A [FontSpec] object for link text. Defaults to `NULL`.
#' @param monospace A [FontSpec] object for monospace/code text. Defaults to `NULL`.
#'
#' @export
BrandTypography <- S7::new_class(
  "BrandTypography",
  properties = list(
    fonts = S7::new_property(S7::class_list, default = list()),
    base = S7::new_property(
      FontSpec | NULL,
      default = NULL
    ),
    headings = S7::new_property(
      FontSpec | NULL,
      default = NULL
    ),
    link = S7::new_property(
      FontSpec | NULL,
      default = NULL
    ),
    monospace = S7::new_property(
      FontSpec | NULL,
      default = NULL
    )
  )
)


# --- Top-level Brand class ---

#' Brand
#'
#' @description
#' Top-level brand object that combines metadata, color palette, and typography
#' settings into a single cohesive brand definition. Can be serialized to a
#' `_brand.yml` file via [brand_to_list()] and [brand_write_yaml()].
#'
#' @param meta A [BrandMeta] object with brand metadata. Defaults to `NULL`.
#' @param color A [BrandColor] object with brand colors. Defaults to `NULL`.
#' @param typography A [BrandTypography] object with brand typography. Defaults to `NULL`.
#'
#' @export
Brand <- S7::new_class(
  "Brand",
  properties = list(
    meta = S7::new_property(BrandMeta | NULL, default = NULL),
    color = S7::new_property(BrandColor | NULL, default = NULL),
    typography = S7::new_property(
      BrandTypography | NULL,
      default = NULL
    )
  )
)


# --- Coercion to plain list (for yaml serialization) ---
drop_nulls <- function(lst) purrr::compact(lst)

#' Coerce a Brand object to a plain list
#'
#' @description
#' Converts a [Brand] object into a nested plain list suitable for
#' serialization to YAML via [yaml::write_yaml()]. `NULL` values are
#' dropped at each level.
#'
#' @param x A [Brand] object.
#'
#' @return A named list representation of the brand, ready for YAML serialization.
#'
#' @export
brand_to_list <- function(x) {
  meta_list <- if (!is.null(x@meta)) {
    drop_nulls(list(name = x@meta@name))
  }

  color_list <- if (!is.null(x@color)) {
    base <- drop_nulls(
      list(
        foreground = x@color@foreground,
        background = x@color@background,
        primary = x@color@primary,
        secondary = x@color@secondary
      )
    )
    palette <- if (length(x@color@palette) > 0) {
      list(palette = x@color@palette)
    } else {
      list()
    }
    c(base, palette)
  }

  typo_list <- if (!is.null(x@typography)) {
    t <- x@typography
    drop_nulls(
      list(
        fonts = if (length(t@fonts) > 0) {
          # _brand.yml doesn't know out source_dir attribute
          purrr::map(t@fonts, \(font) S7::props(font)[c("family", "source")])
        } else {
          NULL
        },
        base = if (!is.null(t@base)) {
          drop_nulls(S7::props(t@base))
        },
        headings = if (!is.null(t@headings)) {
          drop_nulls(S7::props(t@headings))
        },
        link = if (!is.null(t@link)) {
          drop_nulls(S7::props(t@link))
        }
      )
    )
  }

  drop_nulls(
    list(
      meta = meta_list,
      color = color_list,
      typography = typo_list
    )
  )
}


# --- Write to YAML ---

brand_write_yaml <- function(brand, path) {
  base <- if (!is.null(base_path)) yaml::read_yaml(base_path) else list()
  updated <- purrr::list_modify(base, !!!brand_to_list(brand))
  yaml::write_yaml(updated, path)
  invisible(path)
}
