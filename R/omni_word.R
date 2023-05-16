#' OMNI Word Template
#'
#' @param ... Other params to bookdown::word_document2
#' @param toc Table of content as True/False
#' @param number_sections Number sections as true/false
#'
#' @return An rmd format
#' @export
#'
omni_word <- function(toc = FALSE,
                      number_sections = TRUE,
                      ...) {
  # word template
  word_template <-
    pkg_resource("word_template.docx")

  # template
  bookdown::word_document2(
    reference_docx = word_template,
    toc = toc,
    toc_float = FALSE,
    fig_caption = TRUE,
    number_sections = number_sections,
    ...
  )
}
