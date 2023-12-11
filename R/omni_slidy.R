#' Omni Slidy template
#'
#' @param add_hypothesis Add Hypothesis
#' @param ... Other params to rmarkdown::slidy_presentation
#'
#' @return An rmd format
#' @export
#'
omni_slidy <- function(hypothesis = FALSE, ...) {
  # fichiers de style
  css_slidy <-
    pkg_resource("slidy", "css_slidy.css")

  # template
  rmarkdown::slidy_presentation(
    css = c(css_slidy),
    includes = rmarkdown::includes(before_body = include_hypothesis(hypothesis)),
    ...
  )
}
