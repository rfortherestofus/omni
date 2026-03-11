# --- Sub-classes ---
BrandMeta <- S7::new_class(
  "BrandMeta",
  properties = list(
    name = S7::new_property(S7::class_character, default = NULL)
  )
)

Font <- S7::new_class(
  "Font",
  properties = list(
    family = S7::new_property(S7::class_character | NULL, default = NULL),
    source = S7::new_property(S7::class_character | NULL, default = NULL),
    files = S7::new_property(S7::class_list | NULL, default = NULL)
  )
)

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

BrandColor <- S7::new_class(
  "BrandColor",
  properties = list(
    foreground = S7::new_property(S7::class_character | NULL, default = NULL),
    background = S7::new_property(S7::class_character | NULL, default = NULL),
    primary = S7::new_property(S7::class_character | NULL, default = NULL),
    secondary = S7::new_property(S7::class_character | NULL, default = NULL),
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
          purrr::map(t@fonts, S7::props) |>
            purrr::map(drop_nulls)
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


get_default_brand <- function() {
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
        Font(family = 'Inter Tight', source = 'google')
      ),
      base = FontSpec(
        family = 'Inter Tight',
        'line-height' = 1.6
      ),
      headings = FontSpec(
        family = "Inter Tight",
        weight = "bold"
      ),
      link = FontSpec(color = "#5776b2")
    )
  )
}

get_brand_template <- function() {
  deparse(body(get_default_brand)) |> cat(sep = "\n")
}
