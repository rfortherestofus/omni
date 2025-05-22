#' Omni Paged PDF Report
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
pdf_report <- function(main_font = NULL, secondary_font = NULL, ...) {
    css <- pkg_resource("pdf_report.css")
    interface_css <- pkg_resource("interface.css")
    fix_toc_html <- pkg_resource("fix-toc.html")

    css <- change_fonts(
        css,
        new_main_font = main_font,
        new_secondary_font = secondary_font
    )

    pagedown::html_paged(
        css = c(css, interface_css),
        self_contained = TRUE,
        toc = TRUE,
        fig_caption = TRUE,
        includes = rmarkdown::includes(in_header = fix_toc_html),
        ...
    )
}

#' Change main fonts in CSS
#'
#' @param file CSS file path
#' @param new_main_font New main font (optionnal)
#' @param new_secondary_font New secondary font (optionnal)
change_fonts <- function(
    file,
    new_main_font = NULL,
    new_secondary_font = NULL
) {
    css_lines <- readLines(file)

    if (!(is.null(new_main_font))) {
        css_lines <- gsub(
            '--main-font:.*?;',
            glue::glue('--main-font: "{new_main_font}";'),
            css_lines
        )
        css_lines <- gsub(
            '--header-font:.*?;',
            glue::glue('--header-font: "{new_main_font}";'),
            css_lines
        )
    }

    if (!(is.null(new_secondary_font))) {
        css_lines <- gsub(
            '--secondary-font:.*?;',
            glue::glue('--secondary-font: "{new_secondary_font}";'),
            css_lines
        )
    }

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}
