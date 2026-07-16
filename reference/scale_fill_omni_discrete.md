# Discrete fill scale based on OMNI colors

Discrete fill scale based on OMNI colors

## Usage

``` r
scale_fill_omni_discrete(
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

  Additional arguments passed to discrete_scale()

## Examples

``` r
library(ggplot2)
ggplot(mpg, aes(x = drv, fill = drv)) +
  geom_bar() +
  scale_fill_omni_discrete()
```
