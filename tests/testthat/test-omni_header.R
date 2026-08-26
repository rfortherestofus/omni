test_that("chart-gray replaces the old two-gray split", {
  expect_equal(unname(omni_colors("chart-gray")), "#767676")
  expect_error(omni_colors("bar-gray"))
  expect_error(omni_colors("label-gray"))
})

test_that("omni_span wraps text in a colored span", {
  out <- omni_span("Housing", "periwinkle-600")
  expect_type(out, "character")
  expect_equal(out, "{.periwinkle-600 Housing}")
})

test_that("omni_span rejects a colour name that is not a brand colour", {
  # Without this the tag would simply be unregistered and the phrase would
  # render in the base colour - silently, like every other marquee colour
  # failure in this file.
  expect_error(omni_span("Housing", "not-a-colour"))
})

# Every coloured phrase in the header resolves through a marquee tag, and when
# a tag is malformed or unregistered marquee emits no error and no warning - it
# just draws the base colour. Asserting on the *string* is not enough: the
# previous omni_span() built "{##5776B2 Housing}" (omni_colors() already
# returns a leading "#"), which still contained the hex and so passed a
# substring check while rendering navy. These parse the markup the same way the
# renderer does and assert the colour actually resolves.
resolved_colour <- function(md, phrase) {
  parsed <- marquee::marquee_parse(md, style = .omni_marquee_style())
  # contains, not equals: the finding keyword's node also carries the stripe
  # glyph ("▌ Housing"), so an exact match would miss it
  row <- parsed[grepl(phrase, parsed$text, fixed = TRUE), ]
  if (!nrow(row)) return(NA_character_)
  row$color[1]
}

test_that("omni_span's colour resolves when the markup is parsed", {
  md <- paste(omni_span("Housing", "plum-600"), "led the requests")
  expect_equal(resolved_colour(md, "Housing"), unname(omni_colors("plum-600")))
})

test_that("the title keyword's colour resolves when the markup is parsed", {
  h <- omni_header(primary = "Housing led", keyword = "Housing", color = "teal-600")
  expect_equal(resolved_colour(h[[1]]$title, "Housing"), unname(omni_colors("teal-600")))
})

test_that("the finding keyword's colour resolves when the markup is parsed", {
  h <- omni_header(
    primary = "x",
    finding = "Housing led the requests",
    finding_keyword = "Housing",
    color = "olive-green-600"
  )
  expect_equal(resolved_colour(h[[1]]$caption, "Housing"), unname(omni_colors("olive-green-600")))
})

test_that("omni_header returns labs + theme components", {
  h <- omni_header(
    primary = "Test finding",
    keyword = "finding",
    top_header = "TOPIC - FY2024",
    measure = "What is measured",
    finding = "A second point",
    finding_keyword = "second",
    source = "data",
    n = 100
  )
  expect_type(h, "list")
  expect_length(h, 2)
  expect_true("title" %in% names(h[[1]]))
  expect_s3_class(h[[2]], "theme")
})

test_that("omni_header colors the keyword and warns on a missing one", {
  # The title is marquee markdown, so the keyword carries the brand color's
  # tag name; .omni_marquee_style() is what resolves it to a hex.
  h <- omni_header(primary = "Housing led", keyword = "Housing")
  expect_match(h[[1]]$title, "{.orange-red-600 Housing}", fixed = TRUE)
  expect_warning(omni_header(primary = "Housing led", keyword = "Nope"))
})

test_that("omni_header renders the eyebrow as a heading block so the gap is adjustable", {
  # The eyebrow must be a block (a level-1 heading), not an inline span:
  # margins are a block property, so a margin on an inline span is silently
  # ignored and eyebrow_gap would do nothing.
  h <- omni_header(primary = "Housing led", top_header = "TOPIC - FY2024")
  expect_match(h[[1]]$title, "# TOPIC - FY2024", fixed = TRUE)

  # No eyebrow -> no heading block at all.
  h_none <- omni_header(primary = "Housing led")
  expect_false(grepl("^# ", h_none[[1]]$title))
})

test_that("eyebrow_gap sets the eyebrow's bottom margin and nothing else", {
  tight <- omni_header(primary = "x", top_header = "T", eyebrow_gap = 0)
  loose <- omni_header(primary = "x", top_header = "T", eyebrow_gap = 0.9)

  style_of <- function(h, tag) {
    paste(format(unclass(h[[2]]$plot.title$style)[[1]][[tag]]), collapse = " | ")
  }

  # the gap lands on h1's bottom margin ...
  expect_match(style_of(tight, "h1"), "margin_bottom: rem(0)", fixed = TRUE)
  expect_match(style_of(loose, "h1"), "margin_bottom: rem(0.9)", fixed = TRUE)

  # ... and nowhere else: base carries no bottom margin, so the space below
  # the primary finding does not move with eyebrow_gap
  expect_identical(style_of(tight, "base"), style_of(loose, "base"))
  expect_identical(tight[[2]]$plot.title$margin, loose[[2]]$plot.title$margin)
})

test_that("omni_header's caption carries its own marquee style (regression: finding_keyword gray fallback)", {
  # omni_header()'s finding_keyword coloring works by wrapping it in marquee
  # class markdown (e.g. "{.plum-600 ...}"), which only resolves to a color
  # if plot.caption's element_marquee() has a style with that class
  # registered. It must supply that style itself rather than relying on
  # ggplot2's theme-merge to backfill it from a pre-existing plot.caption
  # element (e.g. theme_omni()'s) - that only works by accident, and breaks
  # the moment anything resets plot.caption first (as a fix for the
  # title/subtitle theme-merge issue does).
  h <- omni_header(
    primary = "Test finding",
    finding = "A second point",
    finding_keyword = "second",
    color = "plum-600"
  )
  caption_style <- h[[2]]$plot.caption$style
  expect_false(is.null(caption_style))
  expect_identical(caption_style, .omni_caption_style())
})

test_that("omni_header's caption is quieter than the subtitle, not louder", {
  # The caption sits below the plot and must read as subordinate to the
  # subtitle above it. The shared base style (.omni_marquee_style()) is
  # larger and bold, so passing it straight through renders the secondary
  # finding and source/N heavier than the subtitle - the reverse of the
  # intended hierarchy. Regression: the fix for the finding_keyword color
  # bug started passing the base style explicitly and silently took the
  # caption's own size/weight/italic with it.
  h <- omni_header(
    primary = "Test finding",
    finding = "A second point",
    finding_keyword = "second"
  )
  base <- unclass(h[[2]]$plot.caption$style)[[1]]$base
  expect_equal(base$size, 12)
  expect_equal(base$weight, 400) # normal, not 700/bold
  expect_true(base$italic)
})

test_that("omni_header's subtitle is a marquee element, matching theme_omni's class", {
  # plot.subtitle was the last slot where the two disagreed on class
  # (theme_omni marquee vs omni_header element_text). The mismatch is the
  # shape that caused theme-merge trouble on the title and caption before
  # those were converted, and it also denied the measure description any
  # wrapping - a long one ran off the right edge and clipped.
  h <- omni_header(primary = "x", measure = "What is measured")
  sub <- h[[2]]$plot.subtitle
  expect_s3_class(sub, "element_marquee")
  expect_s3_class(theme_omni()$plot.subtitle, "element_marquee")
  expect_identical(sub$style, .omni_subtitle_style())
  expect_equal(sub$hjust, 0)
  # colour is set on the element too: the element's colour overrides the
  # style's base, so leaving it NULL would inherit the active theme's
  expect_identical(sub$colour, unname(omni_colors("chart-gray")))
})

test_that("every marquee header slot wraps, in both functions", {
  # A slot with no `width` does not wrap: long text runs off the canvas and is
  # clipped mid-word, silently. plot.caption was the last one missing it, and
  # theme_omni() was missing it on the subtitle too. Asserting all six keeps
  # this field from drifting the way color (#267), size/weight (#276) and
  # alignment already did.
  slots <- c("plot.title", "plot.subtitle", "plot.caption")

  hdr <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    omni_header(primary = "P", measure = "M", finding = "F", finding_keyword = "F")
  resolved <- ggplot2::ggplot_build(hdr)$plot$theme
  for (sl in slots) expect_equal(resolved[[sl]]$width, 1, info = sl)

  th <- theme_omni()
  for (sl in slots) expect_equal(th[[sl]]$width, 1, info = sl)
})

test_that("every marquee header slot sets size on the element, not only the style", {
  # element_marquee() carries its own `size`, and it takes precedence over the
  # marquee style's `base` size. Both functions previously set the intended
  # size only inside the style, so all three slots silently rendered at
  # whatever the base theme supplied - theme_minimal(11)'s rel() defaults of
  # 13.2 / 11 / 8.8pt - rather than the brand 18 / 13 / 12. `primary_size` had
  # no effect at all: the rendered title measured the same at 12, 18, 24 and
  # 30. Class-level sizes were never affected, which is why `eyebrow_size`
  # (an h1 tag) worked and masked the problem.
  #
  # Fifth field these two functions have disagreed with intent on, after
  # colour (#267), size/weight (#276), alignment and width (#299), so this
  # pins all six slots rather than the one that was reported.
  hdr <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    theme_omni() +
    omni_header(primary = "P", measure = "M", finding = "F", source = "s", n = 1)
  th <- ggplot2::ggplot_build(hdr)$plot$theme
  expect_equal(ggplot2::calc_element("plot.title", th)$size, 18)
  expect_equal(ggplot2::calc_element("plot.subtitle", th)$size, 13)
  expect_equal(ggplot2::calc_element("plot.caption", th)$size, 12)

  only <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() + theme_omni() +
    ggplot2::labs(title = "T", subtitle = "S", caption = "C")
  th2 <- ggplot2::ggplot_build(only)$plot$theme
  expect_equal(ggplot2::calc_element("plot.title", th2)$size, 13)
  expect_equal(ggplot2::calc_element("plot.subtitle", th2)$size, 13)
  expect_equal(ggplot2::calc_element("plot.caption", th2)$size, 12)
})

test_that("primary_size actually changes the title size", {
  # The regression this guards is specific: primary_size reached the style but
  # not the element, so it was inert. Assert it reaches the element.
  for (ps in c(12, 18, 24)) {
    hdr <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
      ggplot2::geom_point() + theme_omni() +
      omni_header(primary = "P", primary_size = ps)
    th <- ggplot2::ggplot_build(hdr)$plot$theme
    expect_equal(ggplot2::calc_element("plot.title", th)$size, ps, info = ps)
  }
})

test_that("theme_omni and omni_header agree on caption styling", {
  # These two set plot.caption independently; they have drifted apart twice
  # (once on color, once on size/weight). Same helper, same result.
  expect_identical(
    theme_omni()$plot.caption$style,
    omni_header(primary = "x", finding = "y")[[2]]$plot.caption$style
  )
})

test_that("the caption is left-aligned no matter which order the theme is applied in", {
  # ggplot2 right-aligns captions by default. theme_omni() styled the
  # caption's text but not its alignment, so source/N landed bottom-right
  # via theme_omni() alone and bottom-left via omni_header() - the same
  # chart differing on the order two lines were written in.
  hdr <- omni_header(primary = "x", finding = "y", source = "s", n = 1)
  base <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()

  caption_hjust <- function(p) {
    ggplot2::ggplot_build(p)$plot$theme$plot.caption$hjust
  }

  expect_equal(caption_hjust(base + theme_omni() + hdr), 0)
  expect_equal(caption_hjust(base + hdr + theme_omni()), 0)
  expect_equal(caption_hjust(base + theme_omni()), 0)
})

test_that("omni_header gives the eyebrow space above it and the measure space below it", {
  h <- omni_header(
    primary = "Test finding",
    top_header = "TOPIC - FY2024",
    measure = "What is measured"
  )
  # These bottom margins are tuned against measured output, not chosen: they put
  # ~24px between the primary finding and the measure description, and ~36px
  # between the measure description and the panel. Changing them changes the
  # header's rhythm, so they are pinned here deliberately.
  expect_equal(h[[2]]$plot.title$margin, ggplot2::margin(t = 8, b = 5.3))
  # t = -1.5 compensates for the line-box leading marquee brings to this slot;
  # together with b = 4 it reproduces the spacing the plain element_text had
  expect_equal(h[[2]]$plot.subtitle$margin, ggplot2::margin(t = -1.5, b = 4))
})

test_that("omni_header's title sets its own colour rather than inheriting one", {
  # element_marquee()'s colour overrides the style's base color, and a NULL
  # colour inherits from whatever plot.title the active theme already had.
  # Left unset, the primary finding rendered in theme_omni()'s title gray
  # (#666665) instead of navy - confirmed at the pixel level, not just in the
  # theme object, which looked correct throughout. Third instance of the same
  # shape: an element built without being fully specified inherits stale state
  # from theme_omni() (see the caption's color and typography regressions).
  h <- omni_header(primary = "Housing led", top_header = "TOPIC")
  expect_identical(h[[2]]$plot.title$colour, unname(omni_colors("navy")))
})

test_that("theme_omni's title colour cannot leak into an omni_header title", {
  # The regression only appeared once theme_omni() was in play, so pin the
  # interaction rather than the element in isolation.
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    theme_omni() +
    omni_header(primary = "Housing led", top_header = "TOPIC")
  resolved <- ggplot2::ggplot_build(p)$plot$theme$plot.title
  expect_identical(resolved$colour, unname(omni_colors("navy")))
  expect_false(identical(resolved$colour, "#666665"))
})

test_that("omni_highlight_labels colors only matched labels", {
  labeller <- omni_highlight_labels("North", color = "teal-600")
  out <- labeller(c("North", "South"))
  expect_match(out[1], omni_colors("teal-600"), fixed = TRUE)
  expect_equal(out[2], "South")
})

test_that("omni_highlight_labels requires color rather than defaulting it", {
  # A default silently produced an orange-red axis label on a chart whose
  # bars and title keyword were some other highlight color - a brand
  # violation with nothing in the output to flag it, and invisible to
  # anyone using a tool that generates the call for them.
  expect_error(omni_highlight_labels("North"), "`color` is required")
})

test_that("omni_baseline returns a ggplot layer", {
  expect_s3_class(omni_baseline(n = 5), "ggproto")
})
