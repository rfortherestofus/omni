#' Omni Paged PDF Report
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
pdf_report <- function(...) {
    css <- pkg_resource("pdf_report.css")
    fix_toc_html <- pkg_resource("fix-toc.html")

    pagedown::html_paged(
        css = css,
        self_contained = TRUE,
        toc = TRUE,
        fig_caption = TRUE,
        includes = rmarkdown::includes(in_header = fix_toc_html),
        ...
    )
}
