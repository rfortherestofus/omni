#' Omni Paged PDF Report
#'
#' @param ... Other params to pagedown::html_paged
#'
#' @return An rmd format
#' @export
#'
pdf_report <- function(
    main_font = NULL,
    secondary_font = NULL,
    background_color = NULL,
    primary_color = NULL,
    remove_logo = FALSE,
    ...
) {
    css_file <- pkg_resource("pdf_report.css")
    interface_css <- pkg_resource("interface.css")
    fix_toc_html <- pkg_resource("fix-toc.html")

    css_file <- change_fonts(
        file = css_file,
        main_font = main_font,
        secondary_font = secondary_font
    )

    css_file <- change_colors(
        file = css_file,
        background_color = background_color,
        primary_color = primary_color
    )

    if (remove_logo) css_file <- remove_logo(file = css_file)

    pagedown::html_paged(
        css = c(css_file, interface_css),
        self_contained = TRUE,
        toc = TRUE,
        fig_caption = TRUE,
        includes = rmarkdown::includes(in_header = fix_toc_html),
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

#' Change main colors in CSS
#'
#' @param file CSS file path
#' @param background_color Background color (optionnal)
#' @param primary_color Primary color (optionnal)
change_colors <- function(
    file,
    background_color = NULL,
    primary_color = NULL
) {
    css_lines <- readLines(file)

    if (!(is.null(background_color))) {
        css_lines <- gsub(
            '--background-color:.*?;',
            glue::glue('--background-color: {background_color};'),
            css_lines
        )
    }

    if (!(is.null(primary_color))) {
        css_lines <- gsub(
            '--primary-color:.*?;',
            glue::glue('--primary-color: {primary_color};'),
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
