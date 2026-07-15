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


.cl-f59fee7e{table-layout:auto;width:100%;}.cl-f597d8a6{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(255, 255, 255, 1.00);background-color:transparent;}.cl-f597d8ba{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(51, 51, 51, 1.00);background-color:transparent;}.cl-f59b477a{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-f59b478e{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-f59b7e7a{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7e84{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7e8e{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7e8f{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7e90{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7e98{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7e99{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7ea2{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7ea3{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7eac{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7ead{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7eb6{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7eb7{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7ec0{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7ec1{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f59b7eca{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


species
```
