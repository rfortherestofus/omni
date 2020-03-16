
<!-- README.md is generated from README.Rmd. Please edit that file -->

# omni

<!-- badges: start -->

<!-- badges: end -->

The goal of omni is to …

## Installation

You can install `omni` from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dgkeyes/omni")
```

## Example

``` r
library(tidyverse)
#> ── Attaching packages ───────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.0     ✓ purrr   0.3.3
#> ✓ tibble  2.1.3     ✓ dplyr   0.8.3
#> ✓ tidyr   1.0.0     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.4.0
#> ── Conflicts ──────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(omni)

iris %>%
  group_by(Species) %>%
  summarise(sepal_length_mean = mean(Sepal.Length)) %>%
  ggplot(aes(x = Species, y = sepal_length_mean, fill = Species)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  # scale_fill_omni_discrete() +
  theme_omni()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />
