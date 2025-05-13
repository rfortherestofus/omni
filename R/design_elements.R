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
      glue::glue('<span style="color:{color_hex_highlight};">')
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
        background = color_hex,
        color = 'white'
      ),
      htmltools::HTML(paste0('"', preprocessed_text, '"')),
      if (!is.null(author)) {
        htmltools::div(
          style = htmltools::css(
            font_size = 'smaller',
            margin_top = '15px',
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

# htmltools::browsable(
#   quote_box(
#     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#     author = 'John Jacob, random guy',
#     color = 'olive-green 600'
#   )
# ) |>
#   print()

# htmltools::browsable(
#   quote_box(
#     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#     author = 'John Jacob, random guy',
#     color = 'periwinkle 600'
#   )
# ) |>
#   print()

# htmltools::browsable(
#   quote_box(
#     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#     author = NULL,
#     color = 'periwinkle 600'
#   )
# ) |>
#   print()

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
