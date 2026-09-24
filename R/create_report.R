#' @title Create a new Omni report
#'
#' @description
#' `create_report()` creates a new directory with a pre-defined
#' Quarto report document based on Omni branding. The `template.qmd`
#' front matter lists both output formats (`omni_report-html` and
#' `omni_report-typst` for PDF). Remove the one you do not need.
#'
#' @param output_dir New directory that will contain the Quarto
#' report files.
#'
#' @return The path to the created `template.qmd`, invisibly. In an
#' interactive session the file is also opened for editing.
#'
#' @export
#'
#' @importFrom utils file.edit
create_report <- function(output_dir) {
  source_dir <- system.file(
    "omni_report",
    package = "omni",
    mustWork = TRUE
  )
  output_dir_full <- here::here(output_dir)

  fs::dir_copy(source_dir, output_dir_full, overwrite = TRUE)

  path_template_qmd <- fs::path(output_dir_full, "template.qmd")
  if (rlang::is_interactive()) {
    file.edit(path_template_qmd)
  }
  invisible(path_template_qmd)
}
