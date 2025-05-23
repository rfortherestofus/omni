#' Create a quote box
#'
#' This function creates the HTML & CSS for the desired quote boxes. It can use the "version 600" colors of the color palette and highlight specific text via `<highlight>` tags.
#'
#' @name quote_box
#' @param text The text of the quote box. Character vector of length 1. Text that is supposed to be highlighted needs to be wrapped in <highlight></highlight> tags.
#' @param author The author of quote box. Character vector of length 1 or NULL (in case author line isn't required)
#' @param color The color of the quote box. One of the "version 600" colors from omni_colors(), i.e. "orange-red 600", "golden-yellow 600", "teal 600", "plum 600", "periwinkle 600"
#' @param fixed_width_px Width of the quote box in px. Must be numeric vector of length 1. Defaults to 300.
#'
#' @return HTML & CSS that of the desired quote box
#'
#' @examples
#'
#' htmltools::browsable(
#'   quote_box(
#'     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     author = 'John Jacob, random guy',
#'     color = 'olive-green 600'
#'   )
#' )
#'
#' htmltools::browsable(
#'   quote_box(
#'     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     author = 'John Jacob, random guy',
#'     color = 'periwinkle 600'
#'   )
#' )
#'
#' @export
quote_box <- function(
  text,
  author,
  color,
  fixed_width_px = 300
) {
  # Checks on text, author and fixed_width_px arguments -------------------------------
  if (length(text) != 1 || !is.character(text)) {
    cli::cli_abort('{.var text} must be character vector of length 1.')
  }
  if (!(is.null(author) || (length(author) == 1 && is.character(author)))) {
    cli::cli_abort(
      '{.var author} must be character vector of length 1 or NULL.'
    )
  }
  if (!is.null(fixed_width_px) && !is.numeric(fixed_width_px)) {
    cli::cli_abort('{.var fixed_width_px} must be numeric vector of length 1.')
  }

  # Checks on color argument ----------------------------------------------------------
  allowed_colors <- omni_colors(named = TRUE)
  # Allow only colors that have a dark "600" version
  # This is useful for later highlighting text with the "200" version of the same color
  allowed_dark_colors <- allowed_colors[stringr::str_detect(
    names(allowed_colors),
    '600'
  )]
  allowed_color_names <- names(allowed_dark_colors)
  if (!(color %in% allowed_color_names)) {
    cli::cli_abort(
      '{.var color} must be one of {.val {allowed_color_names}}. See the dark "600" colors in {.help [{.fun omni_colors}](omni::omni_colors)}.'
    )
  }

  # Preprocess colors  ----------------------------------------------------------------
  color_hex <- allowed_colors[color]
  color_hex_highlight <- allowed_colors[
    color |> stringr::str_replace('600', '200')
  ]
  width_textbox <- paste0(fixed_width_px, 'px')

  # convert highlight text to span tags  -----------------------------------------------
  preprocessed_text <- text |>
    stringr::str_replace_all(
      stringr::fixed('<highlight>'),
      glue::glue(
        '<span style="color:{color_hex_highlight}; background: {color_hex} !important;">'
      )
    ) |>
    stringr::str_replace(
      stringr::fixed('</highlight>'),
      '</span>'
    )

  # Assemble HTML & CSS for quote box  -----------------------------------------------
  htmltools::div(
    style = htmltools::css(
      width = width_textbox
    ),
    htmltools::div(
      style = htmltools::css(
        padding = '25px 20px',
        background = paste(color_hex, '!important;'),
        color = 'white'
      ),
      htmltools::HTML(paste0('"', preprocessed_text, '"')),
      if (!is.null(author)) {
        htmltools::div(
          style = htmltools::css(
            font_size = 'smaller',
            margin_top = '15px',
            background = paste(color_hex, '!important;')
          ),
          paste('—', author)
        )
      }
    ),
    htmltools::div(
      style = htmltools::css(
        width = '0',
        height = '0',
        border_left = '20px solid transparent',
        border_right = '0px solid transparent',
        border_top = paste('20px solid', color_hex),
        margin_left = 'auto'
      )
    )
  )
}


#' Create a callout box
#'
#' This function creates the HTML & CSS for the desired callout boxes. It can use the "version 600" colors of the color palette and highlight specific text via `<highlight>` tags.
#'
#' @name callout_box
#' @param text The text of the callout box. Character vector of length 1. Text that is supposed to be highlighted needs to be wrapped in <highlight></highlight> tags.
#' @param color The color of the callout box. One of the "version 600" colors from omni_colors(), i.e. "orange-red 600", "golden-yellow 600", "teal 600", "plum 600", "periwinkle 600"
#' @param fixed_width_px Width of the callout box in px. Must be numeric vector of length 1. Defaults to 300.
#'
#' @return HTML & CSS that of the desired callout box
#'
#' @examples
#'
#' htmltools::browsable(
#'   callout_box(
#'     text = 'This is a callout box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     color = 'olive-green 600'
#'   )
#' )
#'
#' htmltools::browsable(
#'   callout_box(
#'     text = 'This is a callout box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     color = 'orange-red 600'
#'   )
#' )
#'
#' @export
callout_box <- function(
  text,
  color,
  fixed_width_px = 300
) {
  # Checks on text and fixed_width_px arguments -------------------------------
  if (length(text) != 1 || !is.character(text)) {
    cli::cli_abort('{.var text} must be character vector of length 1.')
  }
  if (!is.null(fixed_width_px) && !is.numeric(fixed_width_px)) {
    cli::cli_abort('{.var fixed_width_px} must be numeric vector of length 1.')
  }

  # Checks on color argument ----------------------------------------------------------
  allowed_colors <- omni_colors(named = TRUE)
  # Allow only colors that have a dark "600" version
  # This is useful for later highlighting text with the "200" version of the same color
  allowed_dark_colors <- allowed_colors[stringr::str_detect(
    names(allowed_colors),
    '600'
  )]
  allowed_color_names <- names(allowed_dark_colors)
  if (!(color %in% allowed_color_names)) {
    cli::cli_abort(
      '{.var color} must be one of {.val {allowed_color_names}}. See the dark "600" colors in {.help [{.fun omni_colors}](omni::omni_colors)}.'
    )
  }

  # Preprocess colors  ----------------------------------------------------------------
  color_hex <- allowed_colors[color]
  width_textbox <- paste0(fixed_width_px, 'px')

  # convert highlight text to span tags  -----------------------------------------------
  preprocessed_text <- text |>
    stringr::str_replace_all(
      stringr::fixed('<highlight>'),
      glue::glue('<span style="color:{color_hex};">')
    ) |>
    stringr::str_replace(
      stringr::fixed('</highlight>'),
      '</span>'
    )

  # Assemble HTML & CSS for callout box  -----------------------------------------------
  htmltools::div(
    style = htmltools::css(
      width = width_textbox
    ),
    htmltools::div(
      style = htmltools::css(
        padding_left = '10px',
        color = allowed_colors['navy'],
        border_left = paste('5px solid', color_hex)
      ),
      htmltools::HTML(preprocessed_text),
    )
  )
}


#' Create a number emphasis element
#'
#' This function creates the HTML & CSS for the desired number emphasis.
#'
#' @name number_emphasis
#' @param number The emphasized number. Numeric or character vector of length 1.
#' @param text The info text. Character vector of length 1.
#' @param color Desired background color. Must be one `omni::omni_colors()`
#' @param font_size_pt Font size of emphasized number in pt. Numeric vector of length 1. Defaults to 16.
#' @param fixed_width_px Width of the number emphasis in px. Must be numeric vector of length 1. Defaults to 300.
#'
#' @return HTML & CSS that of the desired number emphasis
#'
#' @examples
#'
#' number_emphasis(
#'    number = 1234,
#'    text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'    color = 'teal 400'
#' ),
#'
#' htmltools::browsable(
#'  htmltools::div(
#'    style = 'font-family: "Inter Tight"',
#'    number_emphasis(
#'      number = 1,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal 400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis(
#'      number = 12,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal 400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis(
#'      number = 123,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal 400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis(
#'      number = 1234,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal 400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis(
#'      number = '12.1K',
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal 400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis(
#'      number = '123,456',
#'      text = 'and some shorter text as well.',
#'      color = 'teal 400',
#'      font_size_pt = 14
#'    )
#'  )
#') |>
#'  print()
#'
#' @export
number_emphasis <- function(
  number,
  text,
  color,
  font_size_pt = 16,
  fixed_width_px = 300
) {
  # Checks on text and fixed_width_px arguments -------------------------------
  if (length(text) != 1 || !is.character(text)) {
    cli::cli_abort('{.var text} must be character vector of length 1.')
  }
  if (!is.numeric(fixed_width_px)) {
    cli::cli_abort('{.var fixed_width_px} must be numeric vector of length 1.')
  }

  if (!is.numeric(font_size_pt)) {
    cli::cli_abort('{.var font_size_pt} must be numeric vector of length 1.')
  }

  # Checks on number arguments -------------------------------
  if (length(number) != 1 || !(is.character(number) || is.numeric(number))) {
    cli::cli_abort(
      '{.var number} must be character or numeric vector of length 1.'
    )
  }

  # Checks on color argument ----------------------------------------------------------
  allowed_colors <- omni_colors(named = TRUE)
  allowed_color_names <- names(allowed_colors)
  if (!(color %in% allowed_color_names)) {
    cli::cli_abort(
      '{.var color} must be one of {.val {allowed_color_names}}. See {.help [{.fun omni_colors}](omni::omni_colors)}.'
    )
  }

  # Preprocess settings  ----------------------------------------------------------------
  color_hex <- allowed_colors[color]
  width_textbox <- paste0(fixed_width_px, 'px')
  font_size <- paste0(font_size_pt, 'pt')
  border_width_px <- 5

  # Assemble HTML & CSS ----------------------------------------------------------------
  htmltools::div(
    style = htmltools::css(
      width = width_textbox,
      display = 'flex',
      font_weight = 600
    ),
    htmltools::div(
      style = htmltools::css(
        font_size = font_size,
        color = 'black',
        background = 'white !important',
        border = paste0(border_width_px, 'px solid ', color_hex),
        border_radius = '100%',
        aspect_ratio = 1,
        width = '75px',
        height = '75px',
        display = 'flex',
        z_index = 1
      ),
      htmltools::div(
        style = htmltools::css(
          margin = 'auto',
          background = 'white !important',
        ),
        number
      )
    ),
    htmltools::div(
      style = htmltools::css(
        background = color_hex,
        height = '80%',
        font_size = '12pt',
        margin_top = 'auto',
        margin_bottom = 'auto',
        margin_left = '-30px',
        padding_left = '55px',
        padding_right = '10px',
        padding_top = '2px',
        padding_bottom = '2px',
        z_index = 0
      ),
      text
    )
  )
}


#' List all available Omni icons
#'
#' This function creates the HTML & CSS for the desired number emphasis.
#'
#' @returns Character vector full of available omni icon names
#' @export
omni_icons <- function() {
  path_all_icons <- system.file('assets/icon_svg', package = 'omni')
  fs::dir_ls(path_all_icons) |>
    fs::path_file() |>
    fs::path_ext_remove()
}
omni_icons()


#' Get one of the pre-defined Omni icons
#'
#' This function creates the HTML & CSS for the icon that should be placed into the text icon grid.
#' The HTML container of the icon always centers inside the surrounding environment.
#'
#' @name omni_icon
#' @param icon_name The icon name. Must be character vector of length 1.
#' @param width_px Width of the circle in px. Numeric vector of length 1.
#' @param icon_color_bg Desired background color. Must be one `omni::omni_colors()`.
#' @param icon_color_fg Desired icon color. Should be 'white' or 'black' but technically all hex codes and CSS colors work.
#'
#' @returns HTML & CSS that of the desired icon (can be transformed into plain text using `as.character()`)
#'
#' @examples
#' omni_icon('education', 50, 'teal 600', 'white')
#'
#' @export
omni_icon <- function(
  icon_name,
  width_px,
  icon_color_bg,
  icon_color_fg
) {
  allowed_icon_names <- omni_icons()
  if (!(icon_name %in% allowed_icon_names)) {
    cli::cli_abort(
      '{.var icon_name} must be one of {.val {allowed_icon_names}}. See {.help [{.fun omni_colors}](omni::omni_icons)}.'
    )
  }

  # Get original svg
  icon_path_within_pkg <- fs::path('assets/icon_svg', icon_name, ext = 'svg')
  icon_path <- system.file(icon_path_within_pkg, package = 'omni')
  icon_svg <- xml2::read_xml(icon_path)

  # Checks on color argument ----------------------------------------------------------
  allowed_colors <- omni_colors(named = TRUE)
  allowed_color_names <- names(allowed_colors)
  if (!(icon_color_bg %in% allowed_color_names)) {
    cli::cli_abort(
      '{.var icon_color_bg} must be one of {.val {allowed_color_names}}. See {.help [{.fun omni_colors}](omni::omni_colors)}.'
    )
  }

  icon_color_bg_hex <- allowed_colors[icon_color_bg]
  container_width <- paste0(width_px, 'px')
  padding_container_px <- 10
  padding_container <- paste0(padding_container_px, 'px')
  icon_width <- paste0(width_px - 2 * padding_container_px, 'px')

  # Resize and recolor svg
  # 1. Get namespace
  ns <- xml2::xml_ns(icon_svg)
  # 2. Explicitly register the default namespace as "svg"
  svg_ns <- c(svg = ns[[1]])
  # 3. Find only <path> elements that have a 'fill' attribute
  path_nodes_with_fill <- xml2::xml_find_all(
    icon_svg,
    ".//svg:path[@fill]",
    ns = svg_ns
  )
  # 4. Set the fill attribute
  xml2::xml_set_attr(path_nodes_with_fill, "fill", icon_color_fg)
  xml2::xml_set_attr(icon_svg, "width", icon_width)
  xml2::xml_set_attr(icon_svg, "height", icon_width)
  xml2::xml_set_attr(
    icon_svg,
    "style",
    htmltools::css(background = icon_color_bg_hex)
  )
  ## -- After this icon_svg is modified

  icon_html <- icon_svg |>
    as.character() |>
    htmltools::HTML()

  htmltools::div(
    style = htmltools::css(
      background = icon_color_bg_hex,
      width = icon_width,
      height = icon_width,
      display = 'flex',
      margin = 'auto',
      border_radius = '100%',
      padding = padding_container,
      box_sizing = 'content-box'
    ),
    htmltools::div(
      style = htmltools::css(
        margin = 'auto',
        background = icon_color_bg_hex,
      ),
      icon_html
    )
  )
}


#' Text for Icon-Text-Grid
#'
#' This function creates the HTML & CSS that contains the text for the icon-text-grid
#'
#' @name icon_text
#' @param text Text that is placed ont the grid. Must be character vector of length 1. Can use Markdown notation.
#' @param width_px Width of the text. Must be numeric vector of length 1. Defaults to 400
#'
#' @returns HTML & CSS
#'
#' @export
icon_text <- function(text, width_px = 400) {
  text_html <- text |>
    commonmark::markdown_html() |>
    stringr::str_replace(
      stringr::fixed("<p>"),
      stringr::fixed("<p style = 'margin: 0'>")
    ) |>
    htmltools::HTML()

  htmltools::div(
    style = htmltools::css(
      display = 'flex',
      margin_top = 'auto',
      margin_bottom = 'auto',
      width = if (!is.null(width_px)) paste0(width_px, 'px')
    ),
    text_html
  )
}

#' Place icons and texts on grid
#'
#' This function creates the HTML & CSS that places the icons and texts from `omni_icon()` and `icon_text()` on a grid.
#'
#' @name icon_text_grid
#' @param ... Contents to be place on grid. Should consist of `omni_icon()` and `icon_text()` calls.
#' @param width_px Width of the circle in px. Numeric vector of length 1.
#' @param column_gap_px Gap between icon and text in px. Numeric vector of length 1.
#' @param row_gap_px Gap between rows in px. Numeric vector of length 1.
#'
#' @returns HTML & CSS
#'
#' @examples
#'
#' width_px <- 50
#' icon_color_fg <- "white"
#' icon_color_bg <- 'teal 600'
#'
#' icon_text_grid(
#'   omni_icon('education', width_px, icon_color_bg, icon_color_fg),
#'   icon_text(
#'     text = '**71.9%:** Any person younger than 21 caught with or suspected of consuming alcohol or marijuana is charged with Minor in Possession (MIP).'
#'   ),
#'   omni_icon('security', width_px, icon_color_bg, icon_color_fg),
#'   icon_text(
#'     '**69.8%:** Adults in Colorado who knowingly hep someone younger than 18 break the law - which includes providing minors with alcohol or drubgs - can be charged with a Class 4 felony.'
#'   ),
#'   omni_icon('vault', width_px, icon_color_bg, icon_color_fg),
#'   icon_text(
#'     '**34.4%:** It is legal for a person ages 18-20 to possess marijuana with a medical marijuana card.'
#'   ),
#'   width_px = width_px
#' ) |>
#'   htmltools::browsable()
#'
#' @export
icon_text_grid <- function(
  ...,
  width_px = 50,
  column_gap_px = 10,
  row_gap_px = 20
) {
  htmltools::div(
    style = htmltools::css(
      display = 'grid',
      grid_template_columns = paste0(width_px, 'px 1fr'),
      column_gap = paste0(column_gap_px, 'px'),
      row_gap = paste0(row_gap_px, 'px')
    ),
    ...
  )
}
