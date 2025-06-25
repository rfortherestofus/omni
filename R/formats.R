#' Omni Word Report
#'
#' @param ... Other params to rmarkdown::word_document
#'
#' @return An rmd format
#' @export
#'
word_report <- function(...) {
    reference <- pkg_resource("reference.docx")

    rmarkdown::word_document(
        reference_docx = reference,
        ...
    )
}

#' Omni Paged PDF Report
#'
#' @param main_font Main font
#' @param secondary_font Secondary font
#' @param background_cover_image Image to use for the background in the cover page. It must be one of (case insensitive): `c("01-yellow", "02-teal", "03-orangered", "06-teal", "07-periwinkle", "07-olive", "08-plum")`.
#' @param background_color Background color of the document
#' @param primary_font_color Primary color, mostly used in titles.
#' @param remove_logo Whether to remove Omni logos from the document.
#' @param remove_cover_page Whether to remove the cover page.
#' @param remove_title_page Whether to remove the title page.
#' @param remove_toc_page Whether to remove the TOC (table of content) page.
#' @param ... Additional arguments passed to `pagedown::html_paged()`
#'
#' @return An rmd format
#'
#' @export
pdf_report <- function(
    main_font = NULL,
    secondary_font = NULL,
    background_cover_image = NULL,
    background_color = NULL,
    primary_font_color = NULL,
    remove_logo = FALSE,
    remove_cover_page = FALSE,
    remove_title_page = FALSE,
    remove_toc_page = FALSE,
    ...
) {
    css_file <- pkg_resource("pdf_report.css")
    colors <- pkg_resource("colors.css")
    interface_css <- pkg_resource("interface.css")
    custom_js <- c(pkg_resource("pdf_report_js.html"))

    if (remove_cover_page) {
        custom_js <- c(
            custom_js,
            pkg_resource("pdf-report_remove_cover_page.html")
        )
    }

    if (remove_title_page) {
        custom_js <- c(
            custom_js,
            pkg_resource("pdf-report_remove_title_page.html")
        )
    }

    if (remove_toc_page) {
        custom_js <- c(
            custom_js,
            pkg_resource("pdf-report_remove_toc_page.html")
        )
    }

    css_file <- change_fonts(
        file = css_file,
        main_font = main_font,
        secondary_font = secondary_font
    )

    css_file <- change_colors(
        file = css_file,
        background_color = background_color,
        primary_font_color = primary_font_color
    )

    css_file <- change_background_image(
        file = css_file,
        background_cover_image = background_cover_image
    )

    if (remove_logo) {
        css_file <- remove_logo(file = css_file)
    }

    print(custom_js)

    pagedown::html_paged(
        css = c(interface_css, css_file, colors),
        self_contained = TRUE,
        toc = TRUE,
        fig_caption = TRUE,
        includes = rmarkdown::includes(in_header = custom_js),
        ...
    )
}

#' Omni HTML Report
#'
#' @param ... Params to pagedown::html_paged
#'
#' @return An rmd format
#'
#' @export
html_report <- function(
    main_font = NULL,
    background_color = NULL,
    remove_logo = FALSE,
    ...
) {
    css_file <- pkg_resource("html_report.css")
    colors <- pkg_resource("colors.css")
    header <- pkg_resource("header-htmlreport.html")
    footer <- pkg_resource("footer-htmlreport.html")

    css_file <- change_fonts(
        file = css_file,
        main_font = main_font,
    )

    css_file <- change_colors(
        file = css_file,
        background_color = background_color
    )

    if (remove_logo) {
        css_file <- add_hide_logo_css(file = css_file)
    }

    rmarkdown::html_document(
        css = c(css_file, colors),
        self_contained = TRUE,
        includes = rmarkdown::includes(
            before_body = header,
            after_body = footer
        ),
        ...
    )
}
