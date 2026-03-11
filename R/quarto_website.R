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
create_website <- function(output_dir, brand_details = NULL) {
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

  if (!is.null(brand_details)) {
    if (!inherits(brand_details, "omni::Brand")) {
      cli::cli_abort(
        "{.arg brand_details} must be Brand object (created with {.fun Brand})"
      )
    }
    cli::cli_alert_info('Using custom branding.')
  } else {
    cli::cli_alert_info('Using default branding.')
    brand_details <- get_default_brand()
  }

  path_new_brand_file <- here::here(output_dir_full, '_brand.yml')
  brand_details |>
    brand_to_list() |>
    yaml::write_yaml(path_new_brand_file)

  file.edit(file.path(output_dir_full, "index.qmd"))
}
