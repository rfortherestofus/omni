# omni 1.1.0

## ggplot color scales

* `scale_fill_omni_discrete()` and `scale_color_omni_discrete()` now use the
  first *k* palette colors for *k* categories instead of interpolating *k*
  colors across the five-color ramp. Categorical charts get the exact brand
  colors at every count (three categories are periwinkle, orange-red and plum;
  four add olive-green), and the scale errors clearly when more categories than
  palette colors are requested (#242).

## omni_span()

* Fixed the colour never applying. `omni_span()` built a raw-hex marquee tag
  by prefixing `"{#"` and then interpolating `omni_colors()`, which already
  returns a leading `#` - so it emitted `{##5776B2 Housing}`, which marquee
  cannot parse. The phrase rendered in the base colour with no error and no
  warning. It now emits the class-based tag, `{.periwinkle-600 Housing}`,
  which is what `omni_header()`'s own documentation already described and
  what `keyword` and `finding_keyword` have always used internally - one
  resolution path for every coloured phrase in the header instead of two.
* `omni_span()` now errors on a colour name that is not a brand colour.
  Previously an unknown name produced an unregistered tag, which fails the
  same silent way the malformed hex did.

## Chart defaults

* **Breaking-ish:** data marks now default to a 600-level brand colour
  (`periwinkle-600`) instead of the chart gray. `set_omni_defaults()` was
  setting every bar, column, point, line, boxplot, density and violin - and
  the matching stat defaults - to `chart-gray`, so any chart that did not
  call out a single group came out entirely gray. The guidance is that the
  chart gray is for de-emphasising the *other* groups when one group is
  highlighted, not for the whole chart.
* `set_omni_defaults()`'s `base_color` argument is renamed `primary_color`,
  which better describes what it does, and now accepts a brand colour name
  (`"orange-red-600"`) as well as a hex. `base_color` still works and warns.
  Same for `set_client_defaults()`, whose client blue is unchanged.
* Documented that switching the colour part-way through a report by calling
  `set_omni_defaults()` again is unsafe: `update_geom_defaults()` resolves
  when a plot is *drawn*, not when it is built, so a second call repaints
  every plot object that has not been printed yet - a report that builds
  figures into a list or saves them at the end would silently get the last
  colour for all of them. To vary the colour per figure, set it on the geom
  (`geom_col(fill = omni_colors("orange-red-600"))`), which is captured when
  the layer is created.

## omni_header()

* Fixed `finding_keyword` (the secondary-finding stripe/text in the caption)
  silently rendering gray instead of `color`. It colors via marquee markdown
  (`{.color ...}`), which only resolves if `plot.caption`'s style has that
  color registered as a tag - `omni_header()` was never supplying that style
  itself, so it only worked by accident, when `theme_omni()`'s own
  `plot.caption` element (which does carry the right style) was still in
  place immediately beforehand for ggplot2's theme-merge to inherit it from.
  Any code resetting `plot.caption` first - including a fix for an unrelated
  title/subtitle theme-merge issue - broke it. `omni_header()` now supplies
  its own style unconditionally, independent of theme order.
* Fixed the header elements feeling scrunched together: added space above
  the eyebrow (`top_header`), which previously sat flush against the plot's
  outer margin, and more room below the measure description (`measure`)
  before the panel starts. The gap between the eyebrow and the primary
  finding itself is unchanged - the markdown renderer behind that text box
  only offers that specific gap in one fixed size, and design feedback was
  that size reads as too much space.
* Fixed the caption (secondary finding and source/N) rendering larger and
  bold, heavier than the measure description above it - the reverse of the
  intended hierarchy. It now renders at the smaller, normal-weight, italic
  styling `theme_omni()` has always specified for captions. This was a
  regression from the `finding_keyword` color fix above: passing the shared
  base style explicitly fixed the color but silently brought the base's own
  larger, bold typography with it. `theme_omni()` and `omni_header()` now
  build `plot.caption`'s style from one shared helper, so the two can't
  drift apart again.
* Captions are now left-aligned under `theme_omni()` as well as under
  `omni_header()`. `theme_omni()` styled the caption's size, weight and
  italic but never its alignment, leaving ggplot2's right-aligned default -
  so a chart built with `theme_omni()` alone put source/N bottom-right,
  while the same chart built through `omni_header()` put it bottom-left.
  Left is the brand standard. Note this changes existing figures that use
  `theme_omni()` with a caption but without `omni_header()`: their caption
  moves from the bottom-right to the bottom-left when re-rendered.

* Fixed the primary finding rendering in `theme_omni()`'s title gray
  (`#666665`) instead of navy. `omni_header()` set `plot.title`'s style but
  not its `colour`, and `element_marquee()`'s own `colour` overrides the
  style's base color - so with `colour` left unset it inherited whatever
  `plot.title` the active theme already had. The colored keyword was
  unaffected (it is a tag, which overrides the base), which is part of why
  this survived review. Third instance of one shape: an element built
  without being fully specified inheriting stale state from `theme_omni()`.

## omni_highlight_labels()

* **Breaking:** `color` is now required instead of defaulting to
  `"orange-red-600"`. A chart uses one highlight color and the colored axis
  label has to match the bar or point it labels, but the default silently
  produced an orange-red label on charts highlighted in any other color -
  a brand violation with nothing in the rendered output to flag it, and
  invisible to anyone using a tool that writes the call for them. Omitting
  `color` now raises an error naming the fix. Update existing calls by
  passing the same color given to `omni_header()`; calls that were relying
  on the default and are genuinely orange-red charts need
  `color = "orange-red-600"` added.

* Tightened the header's vertical rhythm against design feedback that the
  elements sat too far apart: the gap between the primary finding and the
  measure description is down ~60% and the gap between the measure
  description and the plot panel is down ~10%. Both were set by measuring
  the rendered output rather than by picking margin values, since the
  visible gap is the margin plus the font's own line box.
* The gap between the eyebrow (`top_header`) and the primary finding is now
  adjustable, via a new `eyebrow_gap` argument (default `0`, the tightest
  the two lines go - the residual gap there is the fonts' line boxes, which
  no margin can shrink). Previously the header's five
  elements read as scrunched together, but this particular gap could not be
  opened up: the title was rendered by ggtext, whose renderer only offers
  that gap in one fixed step - too large per design feedback - with no
  font-size or line-height trick able to shrink it. The title is now
  rendered by marquee, which exposes the gap as a real block margin while
  still wrapping long findings to the plot width (the reason ggtext's
  textbox was chosen originally). `eyebrow_gap` only moves the eyebrow; the
  space below the primary finding is unchanged.
* **Breaking:** because the title is now marquee markdown rather than HTML,
  `omni_span()` returns marquee markdown instead of an HTML `<span>`.
  Existing `omni_span()` calls inside `primary` keep working. But
  `omni_span()` no longer works for coloring axis labels - axis text is
  rendered by ggtext, which reads HTML, not marquee markdown. Use
  `omni_highlight_labels()` for axis labels, which is what it is for. Note
  that an HTML span passed into `primary` now renders as *uncolored* text
  rather than erroring, so any hand-written `<span>` in a header needs
  converting.

## PDF report tables

* Table columns no longer change width where a table breaks across pages.
  Tables now keep consistent, content-proportional column widths on every
  page (#238).
* Table header rows now repeat at the top of each page a table spans (#238).
* Tables no longer draw white horizontal lines between rows; rows are
  separated by the zebra shading and the vertical column dividers are kept.
  Applies to HTML, Word and PDF output (#240).
* `omni_table()` gained a fuller help page, including how to set column
  widths manually with `flextable::width()` and
  `flextable::set_table_properties(layout = "fixed")` (#238).

## PDF report layout

* Fixed the spacing between paragraphs so paragraphs are clearly separated.
  Previously the gap between paragraphs matched the line spacing within a
  paragraph, so paragraphs ran together; manual blank lines are no longer
  needed to separate them (#237).
* Fixed spacing above and below section headings (`##`/`###`/`####`) so it
  matches the Word brand template (Report Template.dotx). The primary
  heading level (`##`) previously had almost no space below it before body
  text, and the two lower levels had spacing that didn't match Word either.
* Corrected the heading spacing values from the fix above. They were
  measured from the Word template's built-in "Heading 1/2/3" styles, which
  the template doesn't actually use (they render in an unbranded orange, not
  Omni's navy) - the real reference is the template's custom "Omni Header
  1/2/3" styles, which give uniform spacing across all three levels rather
  than the hierarchical spacing the built-in styles have. All three levels
  (`##`/`###`/`####`) now get the same ~11pt before / ~12pt after spacing.
* Added a manual fix for a heading that lands at the top of a printed page:
  the normal spacing above a heading looks like too much space there since
  there's nothing above it on that page to separate from, and the renderer
  has no way to detect that position automatically at CSS-authoring time.
  After knitting, add the `remove-header-space` class to a heading that
  visibly lands at the top of a page and re-knit.
* Corrected how to apply the `remove-header-space` class from the fix
  above. It must be added as a header attribute -
  `## My Heading {.remove-header-space}` - not by wrapping the heading in a
  fenced div (`::: {.remove-header-space}` / heading / `:::`), which was
  the originally documented form. The fenced-div form forces the heading's
  own section to close immediately after it, orphaning any subsections -
  and their table-of-contents entries - that should nest inside it as flat
  siblings instead, breaking the table of contents for the rest of that
  section.

## HTML report

* The report footer now shows the year the report is knitted rather than a
  hard-coded year, so it no longer needs a manual update each January (#243).
* Fixed spacing above and below section headings (h1-h4) so it matches the
  Word brand template (Report Template.dotx). Previously every heading level
  used the same spacing, which didn't match Word's per-level spacing and, for
  h1, was visibly tighter than the gap under a top-level heading in Word
  (#257).
* Fixed spacing between paragraphs and around bulleted/numbered lists, which
  was noticeably tighter than the Word brand template. Paragraph-to-paragraph
  and list spacing now match the gaps in Word.
* Corrected which heading level receives which spacing from the fix above.
  The report-html skeleton starts sections at `##`, not `#`, so h2/h3/h4 are
  the levels actually used for primary/subtopic/sub-subtopic headings in
  practice; the previous fix had applied each level's spacing one tag too
  high.
* Corrected the heading spacing values themselves, for the same reason as
  the PDF report fix above: they were measured from the Word template's
  unbranded built-in "Heading 1/2/3" styles rather than its custom "Omni
  Header 1/2/3" styles. All heading levels now get the same ~11pt before /
  ~12pt after spacing, matching Omni Header 1/2/3's uniform spacing.
