#' Remove logo files in CSS
#'
#' @param file CSS file path
#'
#' @keywords internal
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
#'
#' @keywords internal
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
#'
#' @keywords internal
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
#'
#' @keywords internal
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
#' @keywords internal
add_hide_cover_page_css <- function(file) {
    css_lines <- readLines(file)

    rule <- '[data-page-number="1"] {\n  display: none !important\n}'
    css_lines <- c(css_lines, "", rule)

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}

#' Add CSS rule to hide .logo class
#'
#' @param file CSS file path
#'
#' @keywords internal
add_hide_logo_css <- function(file) {
    css_lines <- readLines(file)

    rule <- '.logo {\n  display: none !important;\n}'
    css_lines <- c(css_lines, "", rule)

    temp_css <- file.path(dirname(file), "temp.css")
    writeLines(css_lines, temp_css)
    return(temp_css)
}
