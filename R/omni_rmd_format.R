#' Omni RMD template
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
omni_rmd_template <- function(...) {
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
