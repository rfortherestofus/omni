# Internal Typst helpers -----------------------------------------------------
# Shared by the *_typst() functions below to build raw Typst function calls
# and insert them into the document as literal (=typst) raw blocks, bypassing
# Pandoc's Markdown escaping.

#' @noRd
as_typst <- function(typst_code) {
  knitr::asis_output(paste0("\n\n```{=typst}\n", typst_code, "\n```\n\n"))
}

#' @noRd
strip_typst_fence <- function(x) {
  unclass(x) |>
    stringr::str_remove('^\\n*```\\{=typst\\}\\n') |>
    stringr::str_remove('\\n```\\n*$')
}

#' @noRd
typst_escape_str <- function(x) {
  x |>
    stringr::str_replace_all(stringr::fixed('\\'), '\\\\') |>
    stringr::str_replace_all(stringr::fixed('"'), '\\"') |>
    stringr::str_replace_all('\n', '\\n')
}

#' @noRd
typst_escape_content <- function(x) {
  x |>
    stringr::str_replace_all(stringr::fixed('\\'), '\\\\') |>
    stringr::str_replace_all('([#\\[\\]_*`@])', '\\\\\\1')
}

#' @noRd
markdown_to_typst <- function(text) {
  # Shells out to `quarto pandoc` (rather than rmarkdown::pandoc_convert())
  # so this always resolves Quarto's own bundled, Typst-capable pandoc --
  # rmarkdown's pandoc detection can otherwise pick up an older system
  # pandoc without Typst writer support when not running inside an active
  # `quarto render` (which sets the RSTUDIO_PANDOC env var itself).
  quarto_bin <- Sys.which("quarto")
  if (quarto_bin == "") {
    cli::cli_abort(
      "The {.field quarto} CLI must be on the PATH to convert Markdown to Typst."
    )
  }

  tmp_md <- tempfile(fileext = ".md")
  cat(text, file = tmp_md)

  result <- system2(
    quarto_bin,
    c("pandoc", "-f", "markdown", "-t", "typst", shQuote(tmp_md)),
    stdout = TRUE,
    stderr = TRUE
  )
  paste(result, collapse = "\n")
}

#' @noRd
px_to_pt <- function(px) px * 72 / 96


#' Create a quote box (HTML)
#'
#' This function creates the HTML & CSS for the desired quote boxes. It can use the "version 600" colors of the color palette and highlight specific text via `<highlight>` tags.
#'
#' @name quote_box_html
#' @param text The text of the quote box. Character vector of length 1. Text that is supposed to be highlighted needs to be wrapped in <highlight></highlight> tags.
#' @param author The author of quote box. Character vector of length 1 or NULL (in case author line isn't required)
#' @param color The color of the quote box. One of the "version 600" colors from omni_colors(), i.e. "orange-red-600", "golden-yellow-600", "teal-600", "plum-600", "periwinkle-600"
#' @param fixed_width_px Width of the quote box in px. Must be numeric vector of length 1. Defaults to 300.
#'
#' @return HTML & CSS that of the desired quote box
#'
#' @examples
#'
#' htmltools::browsable(
#'   quote_box_html(
#'     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     author = 'John Jacob, random guy',
#'     color = 'olive-green-600'
#'   )
#' )
#'
#' htmltools::browsable(
#'   quote_box_html(
#'     text = 'This is a quote box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     author = 'John Jacob, random guy',
#'     color = 'periwinkle-600'
#'   )
#' )
#'
#' @export
quote_box_html <- function(
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
  width_textbox <- paste0(fixed_width_px, 'px')

  # convert highlight text to span tags  -----------------------------------------------
  # Previously recolored the text to a "200" tint of the same family on the
  # unchanged "600" background — measured as low as 3.3:1 (need 4.5:1) for at
  # least one family, and would need re-verifying per family since a tint that
  # clears AA for one color isn't guaranteed to for another. Weight/underline
  # differentiates the phrase without touching color, so it inherits the same
  # white-on-600 contrast already used for the rest of the quote.
  preprocessed_text <- text |>
    stringr::str_replace_all(
      stringr::fixed('<highlight>'),
      '<span style="font-weight: 700; text-decoration: underline;">'
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
        font_size = '11pt',
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
          paste('-', author)
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
        margin_left = 'auto',
        # Shift triangle a tiny bit upwards to avoid line in pdf
        margin_top = '-2px',
        background = 'transparent'
      )
    )
  )
}

#' Create a quote box (Typst)
#'
#' This function creates the Typst markup for the desired quote boxes. It can use the "version 600" colors of the color palette and highlight specific text via `<highlight>` tags.
#'
#' @name quote_box_typst
#' @inheritParams quote_box_html
#'
#' @return Raw Typst markup for the desired quote box, inserted via `knitr::asis_output()`.
#'
#' @export
quote_box_typst <- function(
  text,
  author,
  color,
  fixed_width_px = 300
) {
  as_typst(quote_box_typst_raw(text, author, color, fixed_width_px))
}

#' @noRd
quote_box_typst_raw <- function(
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

  color_hex <- allowed_colors[[color]]
  width_pt <- px_to_pt(fixed_width_px)

  # convert highlight text to a Typst function call ------------------------
  # text isn't Markdown here, so it's escaped for Typst content mode first;
  # typst_escape_content() doesn't touch < > /, so the <highlight> markers
  # survive untouched and can still be matched by the replacements below.
  quote_content <- text |>
    typst_escape_content() |>
    stringr::str_replace_all(
      stringr::fixed('<highlight>'),
      '#underline[#text(weight: "bold")['
    ) |>
    stringr::str_replace_all(
      stringr::fixed('</highlight>'),
      ']]'
    )
  quote_content <- paste0('"', quote_content, '"')

  author_arg <- if (is.null(author)) {
    'none'
  } else {
    paste0('"', typst_escape_str(author), '"')
  }

  glue::glue(
    '#quote-box(body: [{quote_content}], author: {author_arg}, color: rgb("{color_hex}"), width: {width_pt}pt)'
  )
}

#' Create a quote box
#'
#' Renders a quote box, dispatching to [quote_box_html()] or [quote_box_typst()]
#' depending on the output format (via `knitr::is_html_output()`).
#'
#' @name quote_box
#' @inheritParams quote_box_html
#' @seealso [quote_box_html()], [quote_box_typst()]
#' @export
quote_box <- function(text, author, color, fixed_width_px = 300) {
  if (knitr::is_html_output()) {
    quote_box_html(
      text = text,
      author = author,
      color = color,
      fixed_width_px = fixed_width_px
    )
  } else {
    quote_box_typst(
      text = text,
      author = author,
      color = color,
      fixed_width_px = fixed_width_px
    )
  }
}


#' Create a callout box (HTML)
#'
#' This function creates the HTML & CSS for the desired callout boxes. It can use the "version 600" colors of the color palette and highlight specific text via `<highlight>` tags.
#'
#' @name callout_box_html
#' @param text The text of the callout box. Character vector of length 1. Text that is supposed to be highlighted needs to be wrapped in <highlight></highlight> tags.
#' @param color The color of the callout box. One of the "version 600" colors from omni_colors(), i.e. "orange-red-600", "golden-yellow-600", "teal-600", "plum-600", "periwinkle-600"
#' @param fixed_width_px Width of the callout box in px. Must be numeric vector of length 1. Defaults to 300.
#'
#' @return HTML & CSS that of the desired callout box
#'
#' @examples
#'
#' htmltools::browsable(
#'   callout_box_html(
#'     text = 'This is a callout box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     color = 'olive-green-600'
#'   )
#' )
#'
#' htmltools::browsable(
#'   callout_box_html(
#'     text = 'This is a callout box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
#'     color = 'orange-red-600'
#'   )
#' )
#'
#' @export
callout_box_html <- function(
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
    stringr::str_replace_all(
      stringr::fixed('</highlight>'),
      '</span>'
    )

  tmp_rmd <- tempfile(fileext = ".Rmd")
  tmp_html <- tempfile(fileext = ".html")

  cat(text, file = tmp_rmd)

  rmarkdown::render(
    input = tmp_rmd,
    output_format = "html_fragment",
    output_file = tmp_html,
    quiet = TRUE
  )

  rendered_text <- paste(readLines(tmp_html), collapse = "\n")

  # Assemble HTML & CSS for callout box  -----------------------------------------------
  htmltools::div(
    style = htmltools::css(
      width = width_textbox
    ),
    htmltools::div(
      style = htmltools::css(
        padding_left = '10px',
        padding_bottom = '3px',
        color = allowed_colors['navy'],
        border_left = paste('5px solid', color_hex),
        font_size = '11pt'
      ),
      htmltools::HTML(rendered_text),
    )
  )
}

#' Create a callout box (Typst)
#'
#' This function creates the Typst markup for the desired callout boxes. It can use the "version 600" colors of the color palette and highlight specific text via `<highlight>` tags.
#'
#' @name callout_box_typst
#' @inheritParams callout_box_html
#'
#' @return Raw Typst markup for the desired callout box, inserted via `knitr::asis_output()`.
#'
#' @export
callout_box_typst <- function(
  text,
  color,
  fixed_width_px = 300
) {
  as_typst(callout_box_typst_raw(text, color, fixed_width_px))
}

#' @noRd
callout_box_typst_raw <- function(
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

  color_hex <- allowed_colors[[color]]
  width_pt <- px_to_pt(fixed_width_px)

  # text is full Markdown, so <highlight> tags are converted to a raw-inline
  # Typst span *before* the whole string is run through the Markdown-to-Typst
  # converter, keeping the highlighted portion's Markdown formatting intact.
  open_tag <- paste0('`#text(fill: rgb("', color_hex, '"))[`{=typst}')
  close_tag <- '`]`{=typst}'
  preprocessed_text <- text |>
    stringr::str_replace_all(stringr::fixed('<highlight>'), open_tag) |>
    stringr::str_replace_all(stringr::fixed('</highlight>'), close_tag)

  typst_body <- markdown_to_typst(preprocessed_text)

  glue::glue(
    '#callout-box(body: [{typst_body}], color: rgb("{color_hex}"), width: {width_pt}pt)'
  )
}

#' Create a callout box
#'
#' Renders a callout box, dispatching to [callout_box_html()] or
#' [callout_box_typst()] depending on the output format (via
#' `knitr::is_html_output()`).
#'
#' @name callout_box
#' @inheritParams callout_box_html
#' @seealso [callout_box_html()], [callout_box_typst()]
#' @export
callout_box <- function(text, color, fixed_width_px = 300) {
  if (knitr::is_html_output()) {
    callout_box_html(text = text, color = color, fixed_width_px = fixed_width_px)
  } else {
    callout_box_typst(text = text, color = color, fixed_width_px = fixed_width_px)
  }
}

#' Create a number emphasis element (HTML)
#'
#' This function creates the HTML & CSS for the desired number emphasis.
#'
#' @name number_emphasis_html
#' @param number The emphasized number. Numeric or character vector of length 1.
#' @param text The info text. Character vector of length 1.
#' @param color Desired background color. Must be one `omni::omni_colors()`
#' @param font_size_pt Font size of emphasized number in pt. Numeric vector of length 1. Defaults to 16.
#' @param text_font_size_pt Font size of the info text in pt. Numeric vector of length 1. Defaults to 12.
#' @param fixed_width_px Width of the number emphasis in px. Must be numeric vector of length 1. Defaults to 300.
#'
#' @return HTML & CSS that of the desired number emphasis
#'
#' @examples
#'
#' number_emphasis_html(
#'    number = 1234,
#'    text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'    color = 'teal-400'
#' )
#'
#' htmltools::browsable(
#'  htmltools::div(
#'    style = 'font-family: "Inter Tight"',
#'    number_emphasis_html(
#'      number = 1,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal-400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis_html(
#'      number = 12,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal-400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis_html(
#'      number = 123,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal-400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis_html(
#'      number = 1234,
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal-400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis_html(
#'      number = '12.1K',
#'      text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
#'      color = 'teal-400'
#'    ),
#'    htmltools::br(),
#'    number_emphasis_html(
#'      number = '123,456',
#'      text = 'and some shorter text as well.',
#'      color = 'teal-400',
#'      font_size_pt = 14
#'    )
#'  )
#') |>
#'  print()
#'
#' @export
number_emphasis_html <- function(
  number,
  text,
  color,
  font_size_pt = 16,
  text_font_size_pt = 12,
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

  if (!is.numeric(text_font_size_pt)) {
    cli::cli_abort('{.var text_font_size_pt} must be numeric vector of length 1.')
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
        color = 'white',
        height = '80%',
        font_size = paste0(text_font_size_pt, 'pt'),
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

#' Create a number emphasis element (Typst)
#'
#' This function creates the Typst markup for the desired number emphasis.
#'
#' @name number_emphasis_typst
#' @inheritParams number_emphasis_html
#'
#' @return Raw Typst markup for the desired number emphasis, inserted via `knitr::asis_output()`.
#'
#' @export
number_emphasis_typst <- function(
  number,
  text,
  color,
  font_size_pt = 16,
  text_font_size_pt = 12,
  fixed_width_px = 300
) {
  as_typst(number_emphasis_typst_raw(
    number,
    text,
    color,
    font_size_pt,
    text_font_size_pt,
    fixed_width_px
  ))
}

#' @noRd
number_emphasis_typst_raw <- function(
  number,
  text,
  color,
  font_size_pt = 16,
  text_font_size_pt = 12,
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

  if (!is.numeric(text_font_size_pt)) {
    cli::cli_abort('{.var text_font_size_pt} must be numeric vector of length 1.')
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

  color_hex <- allowed_colors[[color]]
  width_pt <- px_to_pt(fixed_width_px)

  glue::glue(
    '#number-emphasis(number: "{typst_escape_str(as.character(number))}", body: [{typst_escape_content(text)}], color: rgb("{color_hex}"), font-size: {font_size_pt}pt, body-font-size: {text_font_size_pt}pt, width: {width_pt}pt)'
  )
}

#' Create a number emphasis element
#'
#' Renders a number emphasis element, dispatching to [number_emphasis_html()]
#' or [number_emphasis_typst()] depending on the output format (via
#' `knitr::is_html_output()`).
#'
#' @name number_emphasis
#' @inheritParams number_emphasis_html
#' @seealso [number_emphasis_html()], [number_emphasis_typst()]
#' @export
number_emphasis <- function(
  number,
  text,
  color,
  font_size_pt = 16,
  text_font_size_pt = 12,
  fixed_width_px = 300
) {
  if (knitr::is_html_output()) {
    number_emphasis_html(
      number = number,
      text = text,
      color = color,
      font_size_pt = font_size_pt,
      text_font_size_pt = text_font_size_pt,
      fixed_width_px = fixed_width_px
    )
  } else {
    number_emphasis_typst(
      number = number,
      text = text,
      color = color,
      font_size_pt = font_size_pt,
      text_font_size_pt = text_font_size_pt,
      fixed_width_px = fixed_width_px
    )
  }
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


#' Get one of the pre-defined Omni icons (HTML)
#'
#' This function creates the HTML & CSS for the icon that should be placed into the text icon grid.
#' The HTML container of the icon always centers inside the surrounding environment.
#'
#' @name omni_icon_html
#' @param icon_name The icon name. Must be character vector of length 1.
#' @param width_px Width of the circle in px. Numeric vector of length 1.
#' @param icon_color_bg Desired background color. Must be one `omni::omni_colors()`.
#' @param icon_color_fg Desired icon color. Should be 'white' or 'black' but technically all hex codes and CSS colors work.
#'
#' @returns HTML & CSS that of the desired icon (can be transformed into plain text using `as.character()`)
#'
#' @examples
#' omni_icon_html('education', 50, 'teal-600', 'white')
#'
#' @export
omni_icon_html <- function(
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

#' Get one of the pre-defined Omni icons (Typst)
#'
#' This function creates the Typst markup for the icon that should be placed into the text icon grid.
#'
#' @name omni_icon_typst
#' @inheritParams omni_icon_html
#'
#' @returns Raw Typst markup for the desired icon, inserted via `knitr::asis_output()`.
#'
#' @examples
#' omni_icon_typst('education', 50, 'teal-600', 'white')
#'
#' @export
omni_icon_typst <- function(
  icon_name,
  width_px,
  icon_color_bg,
  icon_color_fg
) {
  as_typst(omni_icon_typst_raw(icon_name, width_px, icon_color_bg, icon_color_fg))
}

#' @noRd
omni_icon_typst_raw <- function(
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

  icon_color_bg_hex <- allowed_colors[[icon_color_bg]]

  # Recolor svg (same approach as omni_icon_html(), just serialized as a
  # string for embedding into Typst rather than wrapped as HTML)
  ns <- xml2::xml_ns(icon_svg)
  svg_ns <- c(svg = ns[[1]])
  path_nodes_with_fill <- xml2::xml_find_all(
    icon_svg,
    ".//svg:path[@fill]",
    ns = svg_ns
  )
  xml2::xml_set_attr(path_nodes_with_fill, "fill", icon_color_fg)
  ## -- After this icon_svg is modified

  svg_string <- icon_svg |>
    as.character() |>
    stringr::str_replace_all('\n', '')

  width_pt <- px_to_pt(width_px)

  glue::glue(
    '#icon-badge(svg: "{typst_escape_str(svg_string)}", size: {width_pt}pt, bg: rgb("{icon_color_bg_hex}"))'
  )
}

#' Get one of the pre-defined Omni icons
#'
#' Renders an icon, dispatching to [omni_icon_html()] or [omni_icon_typst()]
#' depending on the output format (via `knitr::is_html_output()`).
#'
#' @name omni_icon
#' @inheritParams omni_icon_html
#' @seealso [omni_icon_html()], [omni_icon_typst()]
#' @export
omni_icon <- function(icon_name, width_px, icon_color_bg, icon_color_fg) {
  if (knitr::is_html_output()) {
    omni_icon_html(
      icon_name = icon_name,
      width_px = width_px,
      icon_color_bg = icon_color_bg,
      icon_color_fg = icon_color_fg
    )
  } else {
    omni_icon_typst(
      icon_name = icon_name,
      width_px = width_px,
      icon_color_bg = icon_color_bg,
      icon_color_fg = icon_color_fg
    )
  }
}


#' Text for Icon-Text-Grid (HTML)
#'
#' This function creates the HTML & CSS that contains the text for the icon-text-grid
#'
#' @name icon_text_html
#' @param text Text that is placed ont the grid. Must be character vector of length 1. Can use Markdown notation.
#' @param width_px Width of the text. Must be numeric vector of length 1. Defaults to 400
#'
#' @returns HTML & CSS
#'
#' @export
icon_text_html <- function(text, width_px = 400) {
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

#' Text for Icon-Text-Grid (Typst)
#'
#' This function creates the Typst markup that contains the text for the icon-text-grid
#'
#' @name icon_text_typst
#' @inheritParams icon_text_html
#'
#' @returns Raw Typst markup, inserted via `knitr::asis_output()`.
#'
#' @export
icon_text_typst <- function(text, width_px = 400) {
  as_typst(icon_text_typst_raw(text, width_px))
}

#' @noRd
icon_text_typst_raw <- function(text, width_px = 400) {
  width_pt <- px_to_pt(width_px)
  typst_body <- markdown_to_typst(text)
  glue::glue('#icon-text(body: [{typst_body}], width: {width_pt}pt)')
}

#' Text for Icon-Text-Grid
#'
#' Renders text for the icon-text-grid, dispatching to [icon_text_html()] or
#' [icon_text_typst()] depending on the output format (via
#' `knitr::is_html_output()`).
#'
#' @name icon_text
#' @inheritParams icon_text_html
#' @seealso [icon_text_html()], [icon_text_typst()]
#' @export
icon_text <- function(text, width_px = 400) {
  if (knitr::is_html_output()) {
    icon_text_html(text = text, width_px = width_px)
  } else {
    icon_text_typst(text = text, width_px = width_px)
  }
}

#' Place icons and texts on grid (HTML)
#'
#' This function creates the HTML & CSS that places the icons and texts from `omni_icon_html()` and `icon_text_html()` on a grid.
#'
#' @name icon_text_grid_html
#' @param ... Contents to be place on grid. Should consist of `omni_icon_html()` and `icon_text_html()` calls.
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
#' icon_color_bg <- 'teal-600'
#'
#' icon_text_grid_html(
#'   omni_icon_html('education', width_px, icon_color_bg, icon_color_fg),
#'   icon_text_html(
#'     text = '**71.9%:** Any person younger than 21 caught with or suspected of consuming alcohol or marijuana is charged with Minor in Possession (MIP).'
#'   ),
#'   omni_icon_html('security', width_px, icon_color_bg, icon_color_fg),
#'   icon_text_html(
#'     '**69.8%:** Adults in Colorado who knowingly hep someone younger than 18 break the law - which includes providing minors with alcohol or drubgs - can be charged with a Class 4 felony.'
#'   ),
#'   omni_icon_html('vault', width_px, icon_color_bg, icon_color_fg),
#'   icon_text_html(
#'     '**34.4%:** It is legal for a person ages 18-20 to possess marijuana with a medical marijuana card.'
#'   ),
#'   width_px = width_px
#' ) |>
#'   htmltools::browsable()
#'
#' @export
icon_text_grid_html <- function(
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

#' Place icons and texts on grid (Typst)
#'
#' This function creates the Typst markup that places the icons and texts from `omni_icon_typst()` and `icon_text_typst()` on a grid.
#'
#' @name icon_text_grid_typst
#' @inheritParams icon_text_grid_html
#'
#' @returns Raw Typst markup, inserted via `knitr::asis_output()`.
#'
#' @export
icon_text_grid_typst <- function(
  ...,
  width_px = 50,
  column_gap_px = 10,
  row_gap_px = 20
) {
  as_typst(icon_text_grid_typst_raw(
    ...,
    width_px = width_px,
    column_gap_px = column_gap_px,
    row_gap_px = row_gap_px
  ))
}

#' @noRd
icon_text_grid_typst_raw <- function(
  ...,
  width_px = 50,
  column_gap_px = 10,
  row_gap_px = 20
) {
  # Each element of `...` is typically produced by calling the omni_icon()/
  # icon_text() dispatchers, which return already-fenced ```{=typst}``` output
  # (knit_asis strings) -- strip that fence back off so the raw call can be
  # nested inside the `cells` array literal passed to #icon-grid(). strip_typst_fence()
  # is a no-op on already-bare strings, so calling the *_typst_raw() builders
  # directly here also works. The leading `#` (needed to switch from markup
  # into code mode at the top level) must also be dropped, since array
  # elements are already code mode. Every element gets a trailing comma so a
  # single-cell call still produces an array literal rather than a
  # parenthesized expression (Typst's `(x)` vs `(x,)` distinction).
  cells <- vapply(list(...), strip_typst_fence, character(1)) |>
    stringr::str_remove('^#') |>
    paste0(',')
  width_pt <- px_to_pt(width_px)
  column_gap_pt <- px_to_pt(column_gap_px)
  row_gap_pt <- px_to_pt(row_gap_px)

  glue::glue(
    '#icon-grid(
      cells: (
        {paste(cells, collapse = "\n        ")}
      ),
      width: {width_pt}pt,
      column-gap: {column_gap_pt}pt,
      row-gap: {row_gap_pt}pt,
    )'
  )
}

#' Place icons and texts on grid
#'
#' Renders an icon-text grid, dispatching to [icon_text_grid_html()] or
#' [icon_text_grid_typst()] depending on the output format (via
#' `knitr::is_html_output()`).
#'
#' @name icon_text_grid
#' @param ... Contents to be placed on grid (`omni_icon()`/`icon_text()` calls).
#' @inheritParams icon_text_grid_html
#' @seealso [icon_text_grid_html()], [icon_text_grid_typst()]
#' @export
icon_text_grid <- function(
  ...,
  width_px = 50,
  column_gap_px = 10,
  row_gap_px = 20
) {
  if (knitr::is_html_output()) {
    icon_text_grid_html(
      ...,
      width_px = width_px,
      column_gap_px = column_gap_px,
      row_gap_px = row_gap_px
    )
  } else {
    icon_text_grid_typst(
      ...,
      width_px = width_px,
      column_gap_px = column_gap_px,
      row_gap_px = row_gap_px
    )
  }
}
