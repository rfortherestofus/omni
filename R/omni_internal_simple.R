#' Omni internal RMD template
#'
#' @param add_hypothesis Add Hypothesis
#' @param ... Other params to bookdown::html_document2
#'
#' @return An rmd format
#' @export
#'
omni_internal_simple <- function(hypothesis = FALSE,...) {
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
    includes = rmarkdown::includes(before_body = include_hypothesis(hypothesis)),
    ...
  )
}
