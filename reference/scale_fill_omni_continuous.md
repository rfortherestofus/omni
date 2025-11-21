# Continuous fill scale based on OMNI colors

Continuous fill scale based on OMNI colors

## Usage

``` r
scale_fill_omni_continuous(palette, reverse = FALSE, ...)
```

## Arguments

- palette:

  Character vector of OMNI colors OR one of \`c("orange-red",
  "golden-yellow", "olive-green", "plum", "teal", "periwinkle")\`.

- reverse:

  Boolean, should palette be reversed?

- ...:

  Additional arguments passed to scale_fill_gradientn()

## Examples

``` r
library(ggplot2)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

mpg_summary <- mpg |>
 group_by(class) |>
 summarise(avg_hwy = mean(hwy))

ggplot(mpg_summary, aes(x = class, y = avg_hwy, fill = avg_hwy)) +
  geom_bar(stat = "identity") +
  scale_fill_omni_continuous()
#> Error in scale_fill_omni_continuous(): argument "palette" is missing, with no default
```
