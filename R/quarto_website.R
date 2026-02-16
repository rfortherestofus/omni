#' @title Create a new Quarto website
#'
#' @description
#' `create_website()` creates a new directory with pre-defined
#' Quarto documents based on Omni branding.
#'
#' @param output_dir New directory that will contain the Quarto
#' files.
#'
#' @export
#'
#' @importFrom utils file.edit
create_website <- function(output_dir) {
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

  file.edit(file.path(output_dir_full, "index.qmd"))
}
