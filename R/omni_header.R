# Helpers for assembling the standard Omni chart header (the five text elements) and its
# companion structural pieces. These build on theme_omni(): omni_header() overrides the title
# with a ggtext textbox (so the eyebrow + finding stack and long findings wrap) and the caption
# with marquee (so a key phrase can be colored and given the left stripe).

#' Wrap the first occurrence of `phrase` in `text` using `wrapper(phrase)`
#'
#' Returns `text` unchanged (with a warning) if `phrase` is `NULL` or not found verbatim.
#'
#' @noRd
.wrap_first <- function(text, phrase, wrapper, fn_name) {
  if (is.null(phrase)) {
    return(text)
  }
  if (!stringr::str_detect(text, stringr::fixed(phrase))) {
    warning(
      stringr::str_glue("{fn_name}: '{phrase}' not found; left uncolored."),
      call. = FALSE
    )
    return(text)
  }
  stringr::str_replace(text, stringr::fixed(phrase), wrapper(phrase))
}

#' Omni chart header - the five text elements + their theme
#'
#' Assembles the standard Omni header (top header / eyebrow, primary finding, measure
#' description, secondary finding, source & N) into a list of ggplot additions. Add it to a
#' plot with `+`. Every element except `primary` is optional - pass `NULL` (the default) to
#' omit it. Text-only and geometry-agnostic; pair with [omni_baseline()] and
#' [omni_highlight_labels()] as needed.
#'
#' For a comparison header that names two colors instead of one keyword, skip `keyword` and
#' write `primary` yourself with one [omni_span()] per called-out phrase.
#'
#' @param primary Required. The finding, written as a sentence.
#' @param keyword Substring of `primary` to color (first occurrence). `NULL` = all navy.
#' @param top_header Eyebrow line, e.g. `"PROGRAM REACH - FY2024"`. `NULL` = no eyebrow.
#' @param measure Measure description (subtitle). `NULL` = no subtitle.
#' @param finding Secondary finding sentence (caption). `NULL` = no secondary line.
#' @param finding_keyword Leading phrase of `finding` to color + give the stripe.
#' @param source Data source; rendered as `"Source: <source>."`.
#' @param n Sample size; rendered as `"N = <n>."`.
#' @param color The chart's one highlight color name (title keyword + finding keyword/stripe).
#' @param primary_size,eyebrow_size Font sizes in pt.
#'
#' @return A list of ggplot components (`labs()` + `theme()`).
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   omni_header(
#'     top_header = "MOTOR TRENDS - 1974",
#'     keyword    = "Heavier cars",
#'     primary    = "Heavier cars use more fuel",
#'     measure    = "Fuel economy by weight",
#'     source     = "mtcars",
#'     n          = 32
#'   )
omni_header <- function(
  primary,
  keyword = NULL,
  top_header = NULL,
  measure = NULL,
  finding = NULL,
  finding_keyword = NULL,
  source = NULL,
  n = NULL,
  color = "orange-red-600",
  primary_size = 18,
  eyebrow_size = 10
) {
  hex_navy <- omni_colors("navy")
  hex_gray <- omni_colors("chart-gray")

  # --- title: eyebrow (optional) + primary, via ggtext HTML spans ---
  primary_html <- .wrap_first(
    primary,
    keyword,
    function(k) {
      stringr::str_glue("<span style='color:{omni_colors(color)}'>{k}</span>")
    },
    "omni_header()"
  )
  primary_span <- stringr::str_glue(
    "<span style='font-size:{primary_size}pt;font-weight:bold;color:{hex_navy}'>{primary_html}</span>"
  )
  title <- if (!is.null(top_header)) {
    eyebrow_span <- stringr::str_glue(
      "<span style='font-size:{eyebrow_size}pt;font-weight:bold;color:{hex_gray}'>{top_header}</span>"
    )
    stringr::str_glue("{eyebrow_span}<br>{primary_span}")
  } else {
    primary_span
  }

  # --- caption: secondary finding (stripe + colored keyword) then source/N, via marquee ---
  finding_md <- if (!is.null(finding)) {
    .wrap_first(
      finding,
      finding_keyword,
      function(k) stringr::str_glue("{{.{color} \u258c {k}}}"),
      "omni_header()"
    )
  } else {
    NULL
  }
  source_line <- if (!is.null(source) && !is.null(n)) {
    stringr::str_glue("Source: {source}. N = {n}.")
  } else if (!is.null(source)) {
    stringr::str_glue("Source: {source}.")
  } else if (!is.null(n)) {
    stringr::str_glue("N = {n}.")
  } else {
    NULL
  }
  caption_parts <- c(
    if (!is.null(finding_md)) as.character(finding_md),
    if (!is.null(source_line)) as.character(source_line)
  )
  caption <- if (length(caption_parts)) {
    paste(caption_parts, collapse = "\n\n")
  } else {
    NULL
  }

  list(
    # axis titles are dropped per the standard - the measure description (subtitle) carries
    # "what's measured". Add labs(x = ...) / labs(y = ...) after the header if you need one.
    ggplot2::labs(
      title = as.character(title),
      subtitle = measure,
      caption = caption,
      x = NULL,
      y = NULL
    ),
    ggplot2::theme(
      plot.title.position = "plot",
      plot.caption.position = "plot",
      # element_textbox_simple (not element_markdown) so long findings wrap to the plot width
      plot.title = ggtext::element_textbox_simple(
        lineheight = 1.4,
        margin = ggplot2::margin(b = 14),
        padding = ggplot2::margin(0, 0, 0, 0)
      ),
      plot.subtitle = ggplot2::element_text(colour = hex_gray),
      plot.caption = marquee::element_marquee(hjust = 0, colour = hex_gray)
    )
  )
}

#' Omni baseline axis line (non-bar/column charts only)
#'
#' Draws the light navy baseline next to the category labels, spanning only the data rows
#' (not the full panel height). Omit on bar/column charts, where the bars already begin at
#' the labels.
#'
#' @param n Number of categories on the categorical axis.
#' @param orientation `"vertical"` line (horizontal charts) or `"horizontal"` (vertical charts).
#' @param at Baseline position on the value axis (usually 0).
#' @param pad Extension beyond the first/last category center.
#'
#' @return A single `annotate("segment", ...)` layer.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, factor(cyl))) +
#'   geom_point() +
#'   omni_baseline(n = 3)
omni_baseline <- function(
  n,
  orientation = c("vertical", "horizontal"),
  at = 0,
  pad = 0.3
) {
  orientation <- match.arg(orientation)
  lo <- 1 - pad
  hi <- n + pad
  if (orientation == "vertical") {
    ggplot2::annotate(
      "segment",
      x = at,
      xend = at,
      y = lo,
      yend = hi,
      color = omni_colors("navy"),
      linewidth = 0.2
    )
  } else {
    ggplot2::annotate(
      "segment",
      x = lo,
      xend = hi,
      y = at,
      yend = at,
      color = omni_colors("navy"),
      linewidth = 0.2
    )
  }
}

#' Highlight a category label
#'
#' Returns a labelling function (for `scale_*_discrete(labels = ...)`) that wraps any label in
#' `highlight` in a colored span. Requires the categorical axis text to render as markdown in
#' the chart gray, e.g.
#' `theme(axis.text.y.left = ggtext::element_markdown(colour = omni_colors("chart-gray")))`.
#'
#' @param highlight One or more category labels to color.
#' @param color The highlight color name.
#'
#' @return A function suitable for the `labels` argument of a discrete scale.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, rownames(mtcars))) +
#'   geom_point() +
#'   scale_y_discrete(labels = omni_highlight_labels("Valiant"))
omni_highlight_labels <- function(highlight, color = "orange-red-600") {
  hex <- omni_colors(color)
  function(lbls) {
    out <- as.character(lbls)
    hit <- out %in% highlight
    out[hit] <- as.character(
      stringr::str_glue("<span style='color:{hex}'>{out[hit]}</span>")
    )
    out
  }
}

#' Color a phrase inside a header (or any ggtext/HTML text)
#'
#' Returns an inline HTML `<span>` that sets `text` to a 600-level brand color. Use it to build
#' multi-color primary headers by hand: skip [omni_header()]'s `keyword`/`color` shortcut (which
#' colors a single phrase) and write the primary with one `omni_span()` per called-out phrase,
#' composed with `stringr::str_glue()`. [omni_header()] wraps the whole primary in navy, so each
#' span overrides it for its phrase. Also works inside a `scale_*_discrete(labels = ...)`
#' labeller to color category labels to match.
#'
#' @param text Phrase to color (scalar or vector).
#' @param color A brand color name, e.g. `"periwinkle-600"`.
#'
#' @return A character HTML `<span>` string.
#' @export
#'
#' @examples
#' stringr::str_glue("{omni_span('Housing', 'periwinkle-600')} led the requests")
omni_span <- function(text, color) {
  as.character(
    stringr::str_glue("<span style='color:{omni_colors(color)}'>{text}</span>")
  )
}
