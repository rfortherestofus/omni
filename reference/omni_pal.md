# Function to interpolate a OMNI color palette

Function to interpolate a OMNI color palette

## Usage

``` r
omni_pal(
  palette = c("periwinkle-600", "orange-red-600", "plum-600", "olive-green-600",
    "teal-600"),
  reverse = FALSE,
  ...
)
```

## Arguments

- palette:

  Character vector of OMNI colors. The default is the 600-level
  colorblind-ordered categorical palette; golden-yellow is excluded
  because it fails contrast on a white background.

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
