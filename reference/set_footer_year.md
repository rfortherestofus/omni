# Set the copyright year in an HTML report footer

Replaces the hard-coded year in a footer include with the current year,
so knitted reports always show the year in which they were rendered. The
hard-coded year in the footer file acts as a fallback.

## Usage

``` r
set_footer_year(file)
```

## Arguments

- file:

  Footer HTML file path

## Value

Path to a temporary footer file with the year updated.
