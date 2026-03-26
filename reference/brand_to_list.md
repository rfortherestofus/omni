# Coerce a Brand object to a plain list

Converts a \[Brand\] object into a nested plain list suitable for
serialization to YAML via \[yaml::write_yaml()\]. \`NULL\` values are
dropped at each level.

## Usage

``` r
brand_to_list(x)
```

## Arguments

- x:

  A \[Brand\] object.

## Value

A named list representation of the brand, ready for YAML serialization.
