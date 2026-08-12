# omni 1.1.0

## ggplot color scales

* `scale_fill_omni_discrete()` and `scale_color_omni_discrete()` now use the
  first *k* palette colors for *k* categories instead of interpolating *k*
  colors across the five-color ramp. Categorical charts get the exact brand
  colors at every count (three categories are periwinkle, orange-red and plum;
  four add olive-green), and the scale errors clearly when more categories than
  palette colors are requested (#242).

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
