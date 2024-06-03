#' Omni Paged PDF Report
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
omni_pdf_report <- function(...) {
  # style
  css_style <-
    pkg_resource("omni_pdf_report.css")

  # template
  pagedown::html_paged(
    self_contained = TRUE,
    toc = TRUE,
    number_sections = FALSE,
    fig_caption = TRUE,
    css = css_style,
    ...
  )
}

#' Omni Paged PDF Report - new style
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
omni_pdf_report_new <- function(...) {
  # style
  css_style <-
    pkg_resource("omni_pdf_report_new.css")

  # template
  pagedown::html_paged(
    self_contained = TRUE,
    toc = FALSE,
    number_sections = FALSE,
    fig_caption = TRUE,
    css = css_style,
    ...
  )
}

#' Omni Paged PDF Memo
#'
#' @param ... Other params to pagedown::html_paged
#' @param main_font Main font
#' @param header_font Header font
#' @param main_color Main color
#'
#' @return An rmd format
#' @export
#'
omni_pdf_memo <-
  function(main_font = NULL,
           header_font = NULL,
           main_color = NULL,
           ...) {
    # style
    css_style <-
      pkg_resource("omni_pdf_memo.css")

    # change CSS variables
    if (!is.null(main_font)) {
      main_font_css <- paste0("--main-font: ", main_font , ";")
    } else{
      main_font_css <- ""
    }

    if (!is.null(header_font)) {
      header_font_css <- paste0("--header-font: ", header_font , ";")
    } else{
      header_font_css <- ""
    }

    if (!is.null(main_color)) {
      main_color_css <- paste0("--main-color: ", main_color , ";")
    } else{
      main_color_css <- ""
    }

    additional_css <-
      paste0(":root{",
             main_font_css,
             header_font_css,
             main_color_css,
             "}")

    # write tempfile
    tempfile_name <- paste0(tempfile(), ".css")

    writeLines(additional_css, tempfile_name)

    # template
    pagedown::html_paged(
      self_contained = TRUE,
      toc = FALSE,
      number_sections = FALSE,
      fig_caption = TRUE,
      css = c(css_style, tempfile_name),
      ...
    )

  }


#' OMNI Word Template
#'
#' @param ... Other params to bookdown::word_document2
#' @param number_sections Number sections as true/false
#'
#' @return An rmd format
#' @export
#'
omni_word_report <- function(number_sections = TRUE,
                             ...) {
  # word template
  word_template <-
    pkg_resource("omni_word_report.docx")

  # template
  officedown::rdocx_document(
    reference_docx = word_template,
    fig_caption = TRUE,
    number_sections = number_sections,
    base_format = "bookdown::word_document2",
    ...
  )
}

#' OMNI Word Template
#'
#' @param ... Other params to bookdown::word_document2
#' @param number_sections Number sections as true/false
#'
#' @return An rmd format
#' @export
#'
omni_word_report_new <- function(number_sections = TRUE,
                             ...) {
  # word template
  word_template <-
    pkg_resource("omni_word_report_new.docx")

  # template
  officedown::rdocx_document(
    reference_docx = word_template,
    fig_caption = TRUE,
    number_sections = number_sections,
    base_format = "bookdown::word_document2",
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
  # style
  css_style <-
    pkg_resource("omni_html_memo.css")

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

#' Omni HTML Report to share with clients
#'
#' @param hypothesis Add Hypothesis
#' @param ... Other params to bookdown::html_document2
#'
#' @return An rmd format
#' @export
#'
omni_html_report <- function(hypothesis = FALSE, ...) {
  # style
  css_style <-
    pkg_resource("omni_html_report.css")

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
  # style
  css_slidy <-
    pkg_resource("omni_html_slidy.css")

  # template
  rmarkdown::slidy_presentation(
    css = c(css_slidy),
    includes = rmarkdown::includes(before_body = include_hypothesis(hypothesis)),
    ...
  )
}
