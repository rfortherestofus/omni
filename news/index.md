# Changelog

## omni 1.1.0

### PDF report tables

- Table columns no longer change width where a table breaks across
  pages. Tables now keep consistent, content-proportional column widths
  on every page
  ([\#238](https://github.com/rfortherestofus/omni/issues/238)).
- Table header rows now repeat at the top of each page a table spans
  ([\#238](https://github.com/rfortherestofus/omni/issues/238)).
- [`omni_table()`](https://rfortherestofus.github.io/omni/reference/omni_table.md)
  gained a fuller help page, including how to set column widths manually
  with
  [`flextable::width()`](https://davidgohel.github.io/flextable/reference/width.html)
  and `flextable::set_table_properties(layout = "fixed")`
  ([\#238](https://github.com/rfortherestofus/omni/issues/238)).

### PDF report layout

- Fixed the spacing between paragraphs so paragraphs are clearly
  separated. Previously the gap between paragraphs matched the line
  spacing within a paragraph, so paragraphs ran together; manual blank
  lines are no longer needed to separate them
  ([\#237](https://github.com/rfortherestofus/omni/issues/237)).
