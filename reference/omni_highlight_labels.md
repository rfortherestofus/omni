# Highlight a category label

Returns a labelling function (for \`scale\_\*\_discrete(labels = ...)\`)
that wraps any label in \`highlight\` in a colored span. Requires the
categorical axis text to render as markdown in the chart gray, e.g.
\`theme(axis.text.y.left = ggtext::element_markdown(colour =
omni_colors("chart-gray")))\`.

## Usage

``` r
omni_highlight_labels(highlight, color = "orange-red-600")
```

## Arguments

- highlight:

  One or more category labels to color.

- color:

  The highlight color name.

## Value

A function suitable for the \`labels\` argument of a discrete scale.

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(mpg, rownames(mtcars))) +
  geom_point() +
  scale_y_discrete(labels = omni_highlight_labels("Valiant"))
```
