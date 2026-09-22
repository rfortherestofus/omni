#' @title Create a new Omni report
#'
#' @description
#' `create_report()` creates a new directory with a pre-defined
#' Quarto report document (HTML or PDF) based on Omni branding.
#'
#' @param output_dir New directory that will contain the Quarto
#' report files.
#' @param format Report output format, either `"pdf"` or `"html"`.
#' @param use_csi_logos Boolean that determines whether CSI logos will be
#' used. Defaults to `FALSE`.
#'
#' @return The path to the created `template.qmd`, invisibly. In an
#' interactive session the file is also opened for editing.
#'
#' @export
#'
#' @importFrom utils file.edit
create_report <- function(
  output_dir,
  format = c("pdf", "html"),
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

  if (rlang::is_interactive()) {
    file.edit(path_template_qmd)
  }
  invisible(path_template_qmd)
}


#' Activate the requested output format in the report `template.qmd`
#'
#' @description
#' The shipped template lists both `omni_report-html` and
#' `omni_report-typst` under the top-level `format:` key of the YAML
#' front matter, one of them commented out. If the requested format is
#' the commented one, the two blocks are swapped: commented lines are
#' uncommented and active lines are commented out. `use-csi-style` is
#' then set on the active block. The file is modified in place, so the
#' template stays the single source of truth for the format options.
#'
#' @param path_template_qmd Path to the copied `template.qmd`.
#' @param format `"pdf"` or `"html"`.
#' @param use_csi_logos Whether to set `use-csi-style: true`.
#'
#' @return `path_template_qmd`, invisibly.
#'
#' @noRd
set_report_format_in_qmd <- function(path_template_qmd, format, use_csi_logos) {
  lines <- readLines(path_template_qmd)

  ## Locate the `format:` block in the front matter -----
  delims <- which(lines == "---")
  if (length(delims) < 2) {
    cli::cli_abort("No YAML front matter found in {.file {path_template_qmd}}.")
  }
  idx_frontmatter <- seq(delims[1] + 1, delims[2] - 1)
  idx_format <- idx_frontmatter[lines[idx_frontmatter] == "format:"]
  if (length(idx_format) != 1) {
    cli::cli_abort(
      "Expected one top-level {.field format:} key in {.file {path_template_qmd}}."
    )
  }
  idx_after_format <- idx_frontmatter[idx_frontmatter > idx_format]
  is_top_level <- stringr::str_detect(lines[idx_after_format], "^\\S")
  idx_block <- idx_after_format[cumsum(is_top_level) == 0]
  block <- lines[idx_block]

  ## Swap commented and active lines if needed -----
  format_key <- c(pdf = "omni_report-typst:", html = "omni_report-html:")
  idx_requested <- stringr::str_which(
    block,
    stringr::fixed(format_key[[format]])
  )
  if (length(idx_requested) != 1) {
    cli::cli_abort(
      "Expected one {.field {format_key[[format]]}} entry in {.file {path_template_qmd}}."
    )
  }
  is_commented <- stringr::str_detect(block, "^\\s*#")
  if (is_commented[idx_requested]) {
    block <- ifelse(
      is_commented,
      stringr::str_replace(block, "^(\\s*)# ?", "\\1"),
      stringr::str_replace(block, "^(\\s*)(\\S)", "\\1# \\2")
    )
  }

  ## Set CSI style on the active block -----
  use_csi_style <- if (isTRUE(use_csi_logos)) "true" else "false"
  block <- stringr::str_replace(
    block,
    "^(\\s*use-csi-style:).*$",
    paste0("\\1 ", use_csi_style)
  )

  lines[idx_block] <- block
  writeLines(lines, path_template_qmd)
  invisible(path_template_qmd)
}
