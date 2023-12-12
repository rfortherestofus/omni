#' Omni Paged PDF template
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
omni_pdf_report <- function(...) {
  # fichiers de style
  css_style <-
    pkg_resource("omni_rmd_template/css/", "omni-style.css")
  css_page <-
    pkg_resource("omni_rmd_template/css/", "omni-page.css")
  css_default <-
    pkg_resource("omni_rmd_template/css/", "omni-default.css")

  # template
  pagedown::html_paged(
    self_contained = TRUE,
    toc = TRUE,
    number_sections = FALSE,
    fig_caption = TRUE,
    css = c(css_style, css_page, css_default),
    # include = rmarkdown::includes(in_header = pkg_resource(
    #   "omni_rmd_template/js/meta_lof_js.html"
    # )),
    ...
  )
}


#' OMNI Word Template
#'
#' @param ... Other params to bookdown::word_document2
#' @param toc Table of content as True/False
#' @param number_sections Number sections as true/false
#'
#' @return An rmd format
#' @export
#'
omni_word_report <- function(toc = FALSE,
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

#' Omni HTML internal template
#'
#' @param hypothesis Add Hypothesis
#' @param ... Other params to bookdown::html_document2
#'
#' @return An rmd format
#' @export
#'
omni_html_memo <- function(hypothesis = FALSE, ...) {
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

#' Omni HTML Slidy template
#'
#' @param hypothesis Add Hypothesis
#' @param ... Other params to rmarkdown::slidy_presentation
#'
#' @return An rmd format
#' @export
#'
omni_html_slidy <- function(hypothesis = FALSE, ...) {
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
