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
    ...
) {
    css_file <- pkg_resource("pdf_report.css")
    colors <- pkg_resource("colors.css")
    interface_css <- pkg_resource("interface.css")
    fix_toc_html <- pkg_resource("pdf_report_js.html")

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

    if (remove_cover_page) {
        css_file <- add_hide_cover_page_css(file = css_file)
    }

    if (remove_logo) {
        css_file <- remove_logo(file = css_file)
    }

    pagedown::html_paged(
        css = c(interface_css, css_file, colors),
        self_contained = TRUE,
        toc = TRUE,
        fig_caption = TRUE,
        includes = rmarkdown::includes(in_header = fix_toc_html),
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
html_report <- function(...) {
    css_file <- pkg_resource("html_report.css")
    colors <- pkg_resource("colors.css")
    header <- pkg_resource("header-htmlreport.html")
    footer <- pkg_resource("footer-htmlreport.html")

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

#' Remove logo files in CSS
#'
#' @param file CSS file path
remove_logo <- function(file) {
    css_lines <- readLines(file)

    css_lines <- gsub(
        '--logo-bottom:.*?;',
        '--logo-bottom: none;',
        css_lines
    )

    css_lines <- gsub(
        '--logo-cover:.*?;',
        '--logo-cover: none;',
        css_lines
    )

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}

#' Remove logo files in CSS
#'
#' @param file CSS file path
#' @param background_cover_image Path to the new background image
change_background_image <- function(file, background_cover_image) {
    css_lines <- readLines(file)

    if (!(is.null(background_cover_image))) {
        background_cover_image <- tolower(background_cover_image)

        valid_background_image <- c(
            "01-yellow",
            "02-teal",
            "03-orangered",
            "06-teal",
            "07-periwinkle",
            "07-olive",
            "08-plum"
        )

        if (!(background_cover_image %in% valid_background_image)) {
            stop(
                "Invalid background image input. Valid options are: ",
                paste(valid_background_image, collapse = ", ")
            )
        }

        image_mapper <- setNames(
            paste0("images/pattern-cover-", valid_background_image, ".png"),
            valid_background_image
        )
        image_path <- image_mapper[background_cover_image]

        css_lines <- gsub(
            '--background-cover-page:.*?;',
            glue::glue(
                '--background-cover-page: url("{image_path}");'
            ),
            css_lines
        )
    }

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}

#' Change main colors in CSS
#'
#' @param file CSS file path
#' @param background_color Background color (optionnal)
#' @param primary_font_color Primary color (optionnal)
change_colors <- function(
    file,
    background_color = NULL,
    primary_font_color = NULL
) {
    css_lines <- readLines(file)

    if (!(is.null(background_color))) {
        css_lines <- gsub(
            '--background-color:.*?;',
            glue::glue('--background-color: {background_color};'),
            css_lines
        )
    }

    if (!(is.null(primary_font_color))) {
        css_lines <- gsub(
            '--primary-color:.*?;',
            glue::glue('--primary-color: {primary_font_color};'),
            css_lines
        )
    }

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}

#' Change main fonts in CSS
#'
#' @param file CSS file path
#' @param main_font New main font (optionnal)
#' @param secondary_font New secondary font (optionnal)
change_fonts <- function(
    file,
    main_font = NULL,
    secondary_font = NULL
) {
    css_lines <- readLines(file)

    if (!(is.null(main_font))) {
        css_lines <- gsub(
            '--main-font:.*?;',
            glue::glue('--main-font: "{main_font}";'),
            css_lines
        )
        css_lines <- gsub(
            '--header-font:.*?;',
            glue::glue('--header-font: "{main_font}";'),
            css_lines
        )
    }

    if (!(is.null(secondary_font))) {
        css_lines <- gsub(
            '--secondary-font:.*?;',
            glue::glue('--secondary-font: "{secondary_font}";'),
            css_lines
        )
    }

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}


#' Add CSS rule to hide cover page ([data-page-number="1"])
#'
#' @param file CSS file path
#'
add_hide_cover_page_css <- function(file) {
    css_lines <- readLines(file)

    rule <- '[data-page-number="1"] {\n  display: none !important\n}'
    css_lines <- c(css_lines, "", rule)

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}
