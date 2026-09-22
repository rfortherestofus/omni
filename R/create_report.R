#' @title Create a new Omni report
#'
#' @description
#' `create_report()` creates a new directory with a pre-defined
#' Quarto report document (HTML or PDF) based on Omni branding.
#'
#' @param output_dir New directory that will contain the Quarto
#' report files.
#' @param format Report output format, either `"html"` or `"pdf"`.
#' @param brand Optional Brand object for custom branding
#' (created with `Brand()`. Default template available via `brand_template()`).
#' If not specified uses default _brand.yml file.
#' @param use_csi_logos Boolean that determines whether CSI logos will be used. Defaults to `FALSE`.
#'
#' @export
#'
#' @importFrom utils file.edit
create_report <- function(
  output_dir,
  format = c("pdf", "html"),
  brand = NULL,
  use_csi_logos = FALSE
) {
  format <- match.arg(format)

  ## Copy Quarto report template -----
  source_dir <- system.file(
    "omni_report",
    package = "omni",
    mustWork = TRUE
  )
  output_dir_full <- here::here(output_dir)

  fs::dir_copy(source_dir, output_dir_full, overwrite = TRUE)

  ## Set report format in template.qmd -----
  path_template_qmd <- fs::path(output_dir_full, "template.qmd")
  set_report_format_in_qmd(path_template_qmd, format, use_csi_logos)

  ## Check if default branding -----
  use_default_branding <- is.null(brand)
  if (use_default_branding) {
    cli::cli_alert_info('Using default branding.')
    if (rlang::is_interactive()) {
      return(file.edit(path_template_qmd))
    } else {
      return(path_template_qmd)
    }
  }

  ## Modify branding if needed -----
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

  if (rlang::is_interactive()) {
    file.edit(path_template_qmd)
  } else {
    path_template_qmd
  }
}


set_report_format_in_qmd <- function(path_template_qmd, format, use_csi_logos) {
  lines <- readLines(path_template_qmd)
  delims <- which(lines == "---")

  idx_format_start <- which(
    lines[delims[1]:delims[2]] == "format:"
  )[1] +
    delims[1] -
    1

  idx_next_top_level <- which(
    stringr::str_detect(
      lines[(idx_format_start + 1):(delims[2] - 1)],
      "^\\S"
    )
  )[1]
  idx_format_end <- if (is.na(idx_next_top_level)) {
    delims[2] - 1
  } else {
    idx_format_start + idx_next_top_level - 1
  }

  use_csi_style <- tolower(as.character(isTRUE(use_csi_logos)))

  format_block <- if (format == "pdf") {
    c(
      'format:',
      '    omni_report-typst:',
      '      cover-page: true',
      '      title-page: true',
      '      cover-pattern: pattern-cover-01-yellow',
      glue::glue('      use-csi-style: {use_csi_style}'),
      '      client-name: "[Favorite client]"',
      '      client-city: "[city]"',
      '      client-state: "[state]"',
      '      contact-email: projects@omni.org',
      '      report-year: "[year]"',
      '      acknowledgements: "**[one name, and another name, and more names, and lots of names, and even more names. There were lots of people involved with this magnificient project.]**"',
      '      start-page-number: 1'
    )
  } else {
    c(
      'format:',
      '    omni_report-html:',
      glue::glue('      use-csi-style: {use_csi_style}'),
      '      contact-email: projects@omni.org'
    )
  }

  idx_rest_frontmatter <- seq_len(delims[2] - 1)
  idx_rest_frontmatter <- idx_rest_frontmatter[
    idx_rest_frontmatter > idx_format_end
  ]

  lines <- c(
    lines[seq_len(idx_format_start - 1)],
    format_block,
    lines[idx_rest_frontmatter],
    lines[delims[2]:length(lines)]
  )

  writeLines(lines, path_template_qmd)
}
