# Continuous color scale based on OMNI colors

Continuous color scale based on OMNI colors

## Usage

``` r
scale_color_omni_continuous(palette, reverse = FALSE, ...)
```

## Arguments

- palette:

  Character vector of OMNI colors OR one of \`c("orange-red",
  "golden-yellow", "olive-green", "plum", "teal", "periwinkle")\`.

- reverse:

  Boolean, should palette be reversed?

- ...:

  Additional arguments passed to scale_color_gradientn()

## Examples

``` r
library(ggplot2)
ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
    geom_point(size = 2.5) +
    scale_color_omni_continuous()
#> Error in scale_color_omni_continuous(): argument "palette" is missing, with no default
```
