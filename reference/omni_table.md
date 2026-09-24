# Create a table in OMNI's style

`omni_table()` is superseded by
[omni_tinytable](https://rfortherestofus.github.io/omni/reference/omni_tinytable.md).
`omni_table()` is built on flextable and only renders well in HTML and
Word, while
[`omni_tinytable()`](https://rfortherestofus.github.io/omni/reference/omni_tinytable.md)
is built on tinytable, which also has native Typst support and so
renders correctly in omni's Typst-based PDF reports. New code is
recommended to use
[`omni_tinytable()`](https://rfortherestofus.github.io/omni/reference/omni_tinytable.md).

## Usage

``` r
omni_table(
  df,
  group_by = NULL,
  first_col_gray = FALSE,
  caption = NULL,
  with_stripes = TRUE,
  dark_group_rows = FALSE
)
```

## Arguments

- df:

  The data frame to turn into a table.

- group_by:

  Optional character vector of grouping variable(s). When supplied, the
  data is grouped and the group-label rows are shaded. Defaults to
  `NULL` (no grouping).

- first_col_gray:

  Should the first column be shaded gray (with white text)? Defaults to
  `FALSE`.

- caption:

  The table caption. Defaults to `NULL` (no caption).

- with_stripes:

  Should rows use a striped (zebra) pattern? Defaults to `TRUE`.

- dark_group_rows:

  When `group_by` is supplied, should the group rows use a darker navy
  shade instead of steel blue? Defaults to `FALSE`.

## Value

A flextable object (of class `omni_table`).

## Details

Turns a data frame into a table styled with OMNI Institute's fonts,
colours and row striping. The result is a flextable object, so it can be
piped into any flextable function for further customisation (for example
to set column widths, merge cells, or format specific rows).

By default the table uses an autofit layout and fills the width of the
page or container, sizing each column to fit its content.

When rendered in the OMNI PDF report, column widths are held constant
where a table breaks across pages, and the header row is repeated at the
top of each page the table spans. This is handled automatically and
needs no extra code.

To control the relative width of columns, pipe the result through
[`width`](https://davidgohel.github.io/flextable/reference/width.html)
and switch the layout to `"fixed"` with
[`set_table_properties`](https://davidgohel.github.io/flextable/reference/set_table_properties.html).
The widths act as proportions and are scaled to fill the available
width. There must be one width per column:


    omni_table(df) |>
      flextable::width(width = c(2.5, 1, 1, 1)) |>
      flextable::set_table_properties(layout = "fixed", width = 1)

## See also

[`width`](https://davidgohel.github.io/flextable/reference/width.html)
and
[`set_table_properties`](https://davidgohel.github.io/flextable/reference/set_table_properties.html)
for adjusting column widths and the table layout.

## Examples

``` r
# Basic table
palmerpenguins::penguins |>
  dplyr::slice(1:3) |>
  omni_table()
#> Warning: `omni_table()` was deprecated in omni 1.2.0.
#> ℹ Please use `omni_tinytable()` instead.


.cl-eefbcfb5{table-layout:auto;width:100%;}.cl-4f3d7beb{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(255, 255, 255, 1.00);background-color:transparent;}.cl-baaca0d0{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(51, 51, 51, 1.00);background-color:transparent;}.cl-6477613b{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-a1958ec5{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-02d19fd6{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-c986aefc{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-2b593dcb{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-7ef97f85{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-99a15d44{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-820fe896{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-d8366e6b{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-aa4e6e76{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-b3e10a76{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-ba1aa77f{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-879b304b{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-866eb6d4{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


species
```
