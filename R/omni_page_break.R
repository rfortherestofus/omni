#' Create page break
#'
#' @description
#' Creates a page break page for the pdf report
#'
#' @param page_break_title title of the page break
#' @param color Desired color. Currently only orange implemented
#' @export
omni_page_break <- function(page_break_title, color) {
  htmltools::tagList(
    htmltools::div(class = "page-break-before"),
    htmltools::tags$section(
      class = glue::glue("cover-page-full cover-{color}"),
      htmltools::div(
        class = "cover-content",
        htmltools::h2(page_break_title)
      )
    ),
    htmltools::div(class="page-break-after")
  )
}