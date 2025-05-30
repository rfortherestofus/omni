#' Create page break
#'
#' @description
#' Creates a page break page for the pdf report
#'
#' @param page_break_title title of the page break
#' @param color Desired color. Must be one of 'yellow', 'teal', 'orangered', 'periwinkle', 'plum'.
#' @param nmbr_pattern Desired pattern number. Most colors (except Teal) have only one.
#' @export
omni_page_break <- function(page_break_title, color, nmbr_pattern = 1) {
  
  allowed_colors <- c('yellow', 'teal', 'orangered', 'periwinkle', 'plum')
  if (length(color) != 1) {
    cli::cli_abort('{.var color} must be character vector of length 1.')
  }
  if (!(color %in% allowed_colors)) {
    cli::cli_abort('{.var color} must be one of {.val {allowed_colors}}.')
  }
  
  
  htmltools::tagList(
    htmltools::div(class = "page-break-before"),
    htmltools::tags$section(
      class = glue::glue("cover-page-full cover-{color}-{nmbr_pattern}"),
      htmltools::div(
        class = "cover-content",
        htmltools::h2(page_break_title)
      )
    ),
    htmltools::div(class="page-break-after")
  )
}