# Helpers for assembling the standard Omni chart header (the five text elements) and its
# companion structural pieces. These build on theme_omni(): omni_header() overrides both the
# title and the caption with marquee, so a key phrase can be colored, the caption can carry
# its left stripe, and the eyebrow's distance from the primary finding is adjustable.
#
# The title is marquee rather than a ggtext textbox because ggtext's renderer only offers the
# eyebrow-to-primary gap in one fixed jump - the smallest step it can produce reads as too
# much space, and no font-size or line-height trick shrinks it further. marquee exposes the
# gap as a real block margin (see .omni_title_style()) while still wrapping long findings to
# the plot width, which was the reason the textbox was chosen originally.

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

#' Marquee style for the header's title block
#'
#' The eyebrow is rendered as a level-1 heading (`# ...`) so it is a *block*,
#' which is what makes `eyebrow_gap` work: margins are a block property, so a
#' margin set on an inline span (`{.tag ...}`) is silently ignored. Putting the
#' gap on `h1`'s bottom margin - rather than on `base` - also keeps it from
#' touching the space below the primary finding, since `base`'s margin would
#' apply to every paragraph in the block.
#'
#' @noRd
.omni_title_style <- function(primary_size, eyebrow_size, eyebrow_gap) {
  .omni_marquee_style() |>
    marquee::modify_style(
      "base",
      size = primary_size,
      weight = "bold",
      color = omni_colors("navy"),
      lineheight = 1.25,
      margin = marquee::trbl(0, 0, 0)
    ) |>
    marquee::modify_style(
      "h1",
      size = eyebrow_size,
      weight = "bold",
      color = omni_colors("chart-gray"),
      margin = marquee::trbl(0, 0, marquee::rem(eyebrow_gap))
    )
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
#' `primary` and `top_header` are rendered as marquee markdown, so a brand color name in
#' braces colors a phrase directly - `"{.plum-600 Housing} led the requests"` - which is what
#' [omni_span()] produces.
#'
#' @section Spacing:
#' The five elements occupy three ggplot theme slots: the eyebrow and primary finding share
#' `plot.title`, the measure description is `plot.subtitle`, and the secondary finding and
#' source/N share `plot.caption`. The vertical gaps between them are set here to match the
#' brand standard, and are not meant to be adjusted chart by chart - a consistent header
#' rhythm across figures is the point.
#'
#' `eyebrow_gap` is the one gap deliberately left adjustable, because how close the eyebrow
#' should sit to the finding is a judgement call that varies with how long the finding is.
#' It only adds space; at its default of `0` the two lines are already as close as they go.
#' The gap that remains there is the two fonts' own line boxes - the eyebrow's descender
#' space plus the finding's ascender space - and no margin shrinks it. Negative margins are
#' clamped, and line-height has no effect on it. Reducing `eyebrow_size` is the only thing
#' that closes it further, and it buys very little (10pt to 9pt is about one pixel at
#' 150 dpi), so it is not worth trading a brand type size for.
#'
#' The remaining gaps can be overridden by adding a `theme()` *after* the header, but note
#' that the visible gap is the margin plus the font's line box, so a margin change does not
#' translate one-for-one into pixels - check the rendered output rather than trusting the
#' number. If you override `plot.title`, it must stay a [marquee::element_marquee()] carrying
#' the title style; replacing it with a plain `element_text()` silently drops the markdown,
#' so the eyebrow, the colored keyword and the text wrapping all disappear at once.
#'
#' Spacing *inside* the plotting area - how close the category labels sit to the bars, for
#' instance - is not set here. That is the scale's expansion and the axis text's margin,
#' which belong to the chart code and [theme_omni()]; `omni_header()` is text-only and
#' geometry-agnostic by design.
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
#' @param eyebrow_gap Extra space between the eyebrow and the primary finding, in `rem`.
#'   Only applies when `top_header` is given. `0` (the default) is as tight as the two lines
#'   go - the residual gap at `0` is the fonts' own line boxes, which no margin can shrink.
#'   Does not affect the space below the primary finding.
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
  eyebrow_size = 10,
  eyebrow_gap = 0
) {
  hex_gray <- omni_colors("chart-gray")

  # --- title: eyebrow (optional) + primary, as marquee markdown ---
  # Size, weight and color come from the style (see .omni_title_style()), so the
  # text itself carries only the keyword's color tag and the eyebrow's heading marker.
  primary_md <- .wrap_first(
    primary,
    keyword,
    function(k) stringr::str_glue("{{.{color} {k}}}"),
    "omni_header()"
  )
  title <- if (!is.null(top_header)) {
    stringr::str_glue("# {top_header}\n\n{primary_md}")
  } else {
    primary_md
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
      # width = 1 wraps a long primary finding to the full plot width. margin.t gives the
      # eyebrow (when present) space above it instead of sitting flush against the plot's
      # outer margin; the eyebrow-to-primary gap is `eyebrow_gap`, carried by the style.
      #
      # The bottom margins below are tuned against the rendered output rather than picked:
      # b = 5.3 puts ~24px between the primary finding and the measure description, and the
      # subtitle's b = 9 puts ~36px between the measure description and the panel (at
      # 150 dpi). Both were measured by scanning the rendered PNG for rows of ink, because
      # the visible gap is the margin plus the font's own line box - the margin alone does
      # not predict it.
      # colour is set explicitly as well as in the style: element_marquee()'s own
      # colour overrides the style's base color, and when it is left NULL it
      # inherits from whatever plot.title the active theme already had - which
      # rendered the primary finding in theme_omni()'s title gray (#666665)
      # instead of navy. Same failure shape as the caption's twice-fixed color
      # and typography bugs: an element built without being fully specified
      # picks up stale state from theme_omni(). The style's base color still
      # matters (it is what {.color ...} tags override), so both are set.
      plot.title = marquee::element_marquee(
        width = 1,
        colour = omni_colors("navy"),
        style = .omni_title_style(primary_size, eyebrow_size, eyebrow_gap),
        margin = ggplot2::margin(t = 8, b = 5.3)
      ),
      plot.subtitle = ggplot2::element_text(colour = hex_gray, margin = ggplot2::margin(b = 9)),
      # style is passed explicitly (not inherited from whatever plot.caption
      # element theme_omni() or the caller left behind) so the {.color ...}
      # class markdown built above always resolves, regardless of theme order.
      # It must be the *caption* style, not the shared base: the base is
      # larger and bold, which would render the secondary finding and
      # source/N heavier than the subtitle above them.
      plot.caption = marquee::element_marquee(
        hjust = 0,
        colour = hex_gray,
        style = .omni_caption_style()
      )
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
#' `color` is required, deliberately. A chart uses one highlight color, and the
#' colored axis label has to be that same color - it is labelling the bar or point
#' it sits next to. A default here would silently produce a label in one color and
#' a bar in another whenever the chart's highlight isn't the default, which is a
#' brand violation nothing in the rendered output flags. Pass the same color given
#' to [omni_header()].
#'
#' @param highlight One or more category labels to color.
#' @param color Required. The chart's highlight color name - the same one passed to
#'   [omni_header()].
#'
#' @return A function suitable for the `labels` argument of a discrete scale.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, rownames(mtcars))) +
#'   geom_point() +
#'   scale_y_discrete(
#'     labels = omni_highlight_labels("Valiant", color = "orange-red-600")
#'   )
omni_highlight_labels <- function(highlight, color = NULL) {
  if (is.null(color)) {
    cli::cli_abort(c(
      "{.arg color} is required.",
      "i" = "Pass the chart's highlight color - the same one given to
             {.fn omni_header} - so the label matches the bar or point it
             labels.",
      ">" = '{.code omni_highlight_labels("Denver", color = "periwinkle-600")}'
    ))
  }
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

#' Color a phrase inside a header
#'
#' Returns a marquee markdown span that sets `text` to a 600-level brand color. Use it to
#' build multi-color primary headers by hand: skip [omni_header()]'s `keyword`/`color`
#' shortcut (which colors a single phrase) and write the primary with one `omni_span()` per
#' called-out phrase, composed with `stringr::str_glue()`. [omni_header()] renders the whole
#' primary in navy, so each span overrides it for its phrase.
#'
#' This is for [omni_header()]'s `primary` and `top_header`, which are marquee markdown. To
#' color a category label on an axis, use [omni_highlight_labels()] instead - axis text is
#' rendered by ggtext, which reads HTML rather than marquee markdown, so the two are not
#' interchangeable.
#'
#' @param text Phrase to color (scalar or vector).
#' @param color A brand color name, e.g. `"periwinkle-600"`.
#'
#' @return A character marquee markdown string.
#' @export
#'
#' @examples
#' stringr::str_glue("{omni_span('Housing', 'periwinkle-600')} led the requests")
omni_span <- function(text, color) {
  # Emit the class-based tag, matching what .wrap_first() already uses for
  # `keyword` and `finding_keyword`, so every coloured phrase in the header
  # resolves through the one path registered by .omni_marquee_style().
  #
  # The previous raw-hex form built "{#" and then interpolated omni_colors(),
  # which itself returns a leading "#" - emitting "{##5776B2 Housing}", which
  # marquee cannot parse. It renders the phrase in the base colour with no
  # error and no warning, so nothing but a parsed or rendered check catches it.
  #
  # omni_colors() is called purely to validate: an unknown colour name errors
  # here instead of emitting an unregistered tag, which would fail the same
  # silent way the malformed hex did.
  omni_colors(color)
  as.character(
    stringr::str_glue("{{.{color} {text}}}")
  )
}
