# Function to extract WVC colors as hex codes

omni_colors() enables you to pull colors directly from the WVC palette.
Choose from: "white", "ivory", "ivory-400", "orange-red-200",
"orange-red-400", "orange-red-600", "golden-yellow-200",
"golden-yellow-400", "golden-yellow-600", "olive-green-200",
"olive-green-400", "olive-green-600", "teal-200", "teal-400",
"teal-600", "plum-200", "plum-400", "plum-600", "periwinkle-200",
"periwinkle-400", "periwinkle-600", "steel-blue-200", "steel-blue-400",
"steel-blue-600"

## Usage

``` r
omni_colors(
  colors_sub = c("white", "ivory", "ivory-400", "orange-red-200", "orange-red-400",
    "orange-red-600", "golden-yellow-200", "golden-yellow-400", "golden-yellow-600",
    "olive-green-200", "olive-green-400", "olive-green-600", "teal-200", "teal-400",
    "teal-600", "plum-200", "plum-400", "plum-600", "periwinkle-200", "periwinkle-400",
    "periwinkle-600", "steel-blue-200", "steel-blue-400", "steel-blue-600", "navy"),
  named = FALSE
)
```

## Arguments

- colors_sub:

  Character vector of color names.

- named:

  Logical, should output be named? Default is FALSE.

## Value

A vector of hex codes.

## Examples

``` r
omni_colors("orange-red-400")
#> [1] "#FF5E34"
omni_colors(c("plum-400", "golden-yellow-400", "teal-400"))
#> [1] "#C65A8B" "#FCD82B" "#8AC0B3"
omni_colors(c("steel-blue-200", "olive-green-400"), named = TRUE)
#>  steel-blue-200 olive-green-400 
#>       "#BFCBD3"       "#89A046" 
```
