# OMNI Table Function

This function creates a table in OMNI's style.

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

  The data frame to be put into the table

- group_by:

  Character vector containing of grouping variables

- first_col_gray:

  Should the first column be gray. Default to FALSE

- caption:

  The caption of the table

- with_stripes:

  TRUE or FALSE depending on whether a striped pattern should be used.
  Defaults to TRUE (which uses stripes.)

- dark_group_rows:

  Whether or not to use a darker color (navy) for group rows when
  \`group_by\` is not NULL

## Value

A table themed

## Examples

``` r
palmerpenguins::penguins |>
 dplyr::slice(1:3) |>
   omni_table()


.cl-1aea9838{table-layout:auto;width:100%;}.cl-1ae1e18e{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(255, 255, 255, 1.00);background-color:transparent;}.cl-1ae1e1ac{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(51, 51, 51, 1.00);background-color:transparent;}.cl-1ae57f7e{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-1ae57f88{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-1ae5bbf6{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc00{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc01{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc0a{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc0b{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc0c{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc14{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc15{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc1e{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc1f{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc20{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc28{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc29{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc32{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc33{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-1ae5bc3c{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


species
```
