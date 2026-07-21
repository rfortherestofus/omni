# omni 1.1.0

## ggplot color scales

* `scale_fill_omni_discrete()` and `scale_color_omni_discrete()` now use the
  first *k* palette colors for *k* categories instead of interpolating *k*
  colors across the five-color ramp. Categorical charts get the exact brand
  colors at every count (three categories are periwinkle, orange-red and plum;
  four add olive-green), and the scale errors clearly when more categories than
  palette colors are requested (#242).

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

## HTML report

* The report footer now shows the year the report is knitted rather than a
  hard-coded year, so it no longer needs a manual update each January (#243).
