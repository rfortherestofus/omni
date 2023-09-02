#' Omni Slidy template
#'
#' @param ... Other params to rmarkdown::slidy_presentation
#'
#' @return An rmd format
#' @export
#'
omni_slidy <- function(...) {
  # fichiers de style
  css_slidy <-
    pkg_resource("slidy", "css_slidy.css")

  # template
  rmarkdown::slidy_presentation(
    css = c(css_slidy),
    ...
  )
}
