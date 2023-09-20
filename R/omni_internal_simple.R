#' Omni internal RMD template
#'
#' @param ... Other params to bookdown::html_document2
#'
#' @return An rmd format
#' @export
#'
omni_internal_simple <- function(...) {
  # fichiers de style
  css_style <-
    pkg_resource("omni_internal_simple/", "css_style.css")

  # template
  bookdown::html_document2(
    css = css_style,
    toc = TRUE,
    toc_float = TRUE,
    fig_caption = TRUE,
    number_sections = TRUE,
    ...
  )
}
