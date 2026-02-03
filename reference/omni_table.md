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


.cl-f90a1558{table-layout:auto;width:100%;}.cl-f901d910{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(255, 255, 255, 1.00);background-color:transparent;}.cl-f901d91a{font-family:'Inter Tight';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(51, 51, 51, 1.00);background-color:transparent;}.cl-f9051d96{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-f9051daa{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-f905518a{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f9055194{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f9055195{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f905519e{background-color:rgba(103, 115, 132, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551a8{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551a9{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551aa{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551b2{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551b3{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551b4{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551b5{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551bc{background-color:rgba(191, 203, 211, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551bd{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551be{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551bf{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 1pt solid rgba(255, 255, 255, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-f90551c6{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(255, 255, 255, 1.00);border-left: 1pt solid rgba(255, 255, 255, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


species
```

island

bill_length_mm

bill_depth_mm

flipper_length_mm

body_mass_g

sex

year

Adelie

Torgersen

39.1

18.7

181

3,750

male

2,007

Adelie

Torgersen

39.5

17.4

186

3,800

female

2,007

Adelie

Torgersen

40.3

18.0

195

3,250

female

2,007

palmerpenguins::[penguins](https://allisonhorst.github.io/palmerpenguins/reference/penguins.html)
\|\>
dplyr::[slice](https://dplyr.tidyverse.org/reference/slice.html)(1:3)
\|\> omni_table(first_col_gray = TRUE)

| species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year  |
|---------|-----------|----------------|---------------|-------------------|-------------|--------|-------|
| Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3,750       | male   | 2,007 |
| Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3,800       | female | 2,007 |
| Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3,250       | female | 2,007 |

palmerpenguins::[penguins](https://allisonhorst.github.io/palmerpenguins/reference/penguins.html)
\|\>
dplyr::[slice](https://dplyr.tidyverse.org/reference/slice.html)(1:3,
.by = species) \|\> omni_table(group_by = 'species')

| island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year  |
|-----------|----------------|---------------|-------------------|-------------|--------|-------|
| Adelie    |                |               |                   |             |        |       |
| Torgersen | 39.1           | 18.7          | 181               | 3,750       | male   | 2,007 |
| Torgersen | 39.5           | 17.4          | 186               | 3,800       | female | 2,007 |
| Torgersen | 40.3           | 18.0          | 195               | 3,250       | female | 2,007 |
| Gentoo    |                |               |                   |             |        |       |
| Biscoe    | 46.1           | 13.2          | 211               | 4,500       | female | 2,007 |
| Biscoe    | 50.0           | 16.3          | 230               | 5,700       | male   | 2,007 |
| Biscoe    | 48.7           | 14.1          | 210               | 4,450       | female | 2,007 |
| Chinstrap |                |               |                   |             |        |       |
| Dream     | 46.5           | 17.9          | 192               | 3,500       | female | 2,007 |
| Dream     | 50.0           | 19.5          | 196               | 3,900       | male   | 2,007 |
| Dream     | 51.3           | 19.2          | 193               | 3,650       | male   | 2,007 |

palmerpenguins::[penguins](https://allisonhorst.github.io/palmerpenguins/reference/penguins.html)
\|\>
dplyr::[slice](https://dplyr.tidyverse.org/reference/slice.html)(1:3)
\|\> omni_table(caption = 'Table 1. \[Insert Table Name\]')

| species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year  |
|---------|-----------|----------------|---------------|-------------------|-------------|--------|-------|
| Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3,750       | male   | 2,007 |
| Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3,800       | female | 2,007 |
| Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3,250       | female | 2,007 |

Table 1. \[Insert Table Name\]

\# Without striped pattern
palmerpenguins::[penguins](https://allisonhorst.github.io/palmerpenguins/reference/penguins.html)
\|\>
dplyr::[slice](https://dplyr.tidyverse.org/reference/slice.html)(1:3)
\|\> omni_table(with_stripes = FALSE)

| species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year  |
|---------|-----------|----------------|---------------|-------------------|-------------|--------|-------|
| Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3,750       | male   | 2,007 |
| Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3,800       | female | 2,007 |
| Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3,250       | female | 2,007 |

\# Overwrite number formatting by transforming to character format
palmerpenguins::[penguins](https://allisonhorst.github.io/palmerpenguins/reference/penguins.html)
\|\>
dplyr::[slice](https://dplyr.tidyverse.org/reference/slice.html)(1:3)
\|\>
dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(year
= [as.character](https://rdrr.io/r/base/character.html)(year)) \|\>
omni_table()

| species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year |
|---------|-----------|----------------|---------------|-------------------|-------------|--------|------|
| Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3,750       | male   | 2007 |
| Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3,800       | female | 2007 |
| Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3,250       | female | 2007 |
