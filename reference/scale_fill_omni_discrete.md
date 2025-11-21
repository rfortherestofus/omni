# Discrete fill scale based on OMNI colors

Discrete fill scale based on OMNI colors

## Usage

``` r
scale_fill_omni_discrete(
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

  Additional arguments passed to discrete_scale()

## Examples

``` r
library(ggplot2)
ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  scale_fill_omni_discrete()
```
