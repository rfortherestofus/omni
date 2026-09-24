# Create a table in OMNI's style, powered by tinytable

Turns a data frame into a table styled with OMNI Institute's colours and
row striping. The result is a tinytable object, so it can be piped into
any tinytable function for further customisation. Unlike
\`[omni_table](https://rfortherestofus.github.io/omni/reference/omni_table.md)\`,
which is built on flextable and only renders well in HTML and Word,
\`omni_tinytable()\` is built on tinytable, which has native support for
Typst, so it renders correctly in omni's Typst-based PDF reports as well
as HTML and Word.

## Usage

``` r
omni_tinytable(
  df,
  group_by = NULL,
  first_col_gray = FALSE,
  with_stripes = TRUE,
  dark_group_rows = FALSE,
  brand_color = omni_colors("steel-blue-400"),
  stripe_color = NULL,
  dark_color = omni_colors("navy"),
  lighten_amount = 0.65
)
```

## Arguments

- df:

  The data frame to turn into a table.

- group_by:

  Optional name of a single grouping column. When supplied, the data is
  grouped and a full-width label row is inserted before each group.
  Defaults to \`NULL\` (no grouping).

- first_col_gray:

  Should the first column be shaded with \`brand_color\` (with white
  text)? Defaults to \`FALSE\`.

- with_stripes:

  Should rows use a striped (zebra) pattern? Defaults to \`TRUE\`.

- dark_group_rows:

  When \`group_by\` is supplied, should the group label rows use
  \`dark_color\` instead of \`brand_color\`? Defaults to \`FALSE\`.

- brand_color:

  Hex color used for the header row, and for group label rows and the
  shaded first column unless overridden. Defaults to OMNI's steel blue.
  Pass any organization's brand color here (for example a client's
  primary color) to restyle the table without changing anything else.

- stripe_color:

  Hex color used for the striped rows. Defaults to \`NULL\`, which
  derives a light tint of \`brand_color\` automatically.

- dark_color:

  Hex color used for group label rows when \`dark_group_rows = TRUE\`.
  Defaults to OMNI's navy.

- lighten_amount:

  Fraction of the remaining distance to white used when deriving
  \`stripe_color\` from \`brand_color\`, between \`0\` (no change) and
  \`1\` (white). Ignored if \`stripe_color\` is supplied directly.
  Defaults to \`0.65\`.

## Value

A tinytable object.

## Examples

``` r
# Basic table
palmerpenguins::penguins |>
  dplyr::slice(1:3) |>
  omni_tinytable()
#> 
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year |
#> +=========+===========+================+===============+===================+=============+========+======+
#> | Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3750        | male   | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3800        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3250        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+ 

# Shade the first column
palmerpenguins::penguins |>
  dplyr::slice(1:3) |>
  omni_tinytable(first_col_gray = TRUE)
#> 
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year |
#> +=========+===========+================+===============+===================+=============+========+======+
#> | Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3750        | male   | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3800        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3250        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+ 

# Group rows by a variable
palmerpenguins::penguins |>
  dplyr::slice(1:3, .by = species) |>
  omni_tinytable(group_by = "species")
#> 
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year |
#> +===========+================+===============+===================+=============+========+======+
#> | Adelie                                                                                       |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Torgersen | 39.1           | 18.7          | 181               | 3750        | male   | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Torgersen | 39.5           | 17.4          | 186               | 3800        | female | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Torgersen | 40.3           | 18.0          | 195               | 3250        | female | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Gentoo                                                                                       |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Biscoe    | 46.1           | 13.2          | 211               | 4500        | female | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Biscoe    | 50.0           | 16.3          | 230               | 5700        | male   | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Biscoe    | 48.7           | 14.1          | 210               | 4450        | female | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Chinstrap                                                                                    |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Dream     | 46.5           | 17.9          | 192               | 3500        | female | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Dream     | 50.0           | 19.5          | 196               | 3900        | male   | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Dream     | 51.3           | 19.2          | 193               | 3650        | male   | 2007 |
#> +-----------+----------------+---------------+-------------------+-------------+--------+------+ 

# Without the striped pattern
palmerpenguins::penguins |>
  dplyr::slice(1:3) |>
  omni_tinytable(with_stripes = FALSE)
#> 
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year |
#> +=========+===========+================+===============+===================+=============+========+======+
#> | Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3750        | male   | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3800        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3250        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+ 

# Restyle for another organization's brand color (e.g. a client report)
palmerpenguins::penguins |>
  dplyr::slice(1:3) |>
  omni_tinytable(brand_color = "#921C4C") # red/purple-ish
#> 
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | species | island    | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g | sex    | year |
#> +=========+===========+================+===============+===================+=============+========+======+
#> | Adelie  | Torgersen | 39.1           | 18.7          | 181               | 3750        | male   | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 39.5           | 17.4          | 186               | 3800        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+
#> | Adelie  | Torgersen | 40.3           | 18.0          | 195               | 3250        | female | 2007 |
#> +---------+-----------+----------------+---------------+-------------------+-------------+--------+------+ 
```
