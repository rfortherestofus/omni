# Function to interpolate a OMNI color palette

Function to interpolate a OMNI color palette

## Usage

``` r
omni_pal(
  palette = c("orange-red-400", "golden-yellow-400", "olive-green-400", "teal-400",
    "plum-400", "periwinkle-400"),
  reverse = FALSE,
  ...
)
```

## Arguments

- palette:

  Character vector of OMNI colors.

- reverse:

  Boolean, should palette be reversed?

- ...:

  Additional arguments for colorRampPalette()

## Value

A function that generates interpolated colors.

## Examples

``` r
omni_palette <- omni_pal(c("periwinkle-600", "orange-red-400"))
omni_palette(10)
#>  [1] "#5776B2" "#6973A3" "#7C7096" "#8F6E88" "#A16B79" "#B4686C" "#C7665E"
#>  [8] "#D96350" "#EC6042" "#FF5E34"
```
