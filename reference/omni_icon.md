# Get one of the pre-defined Omni icons

This function creates the HTML & CSS for the icon that should be placed
into the text icon grid. The HTML container of the icon always centers
inside the surrounding environment.

## Usage

``` r
omni_icon(icon_name, width_px, icon_color_bg, icon_color_fg)
```

## Arguments

- icon_name:

  The icon name. Must be character vector of length 1.

- width_px:

  Width of the circle in px. Numeric vector of length 1.

- icon_color_bg:

  Desired background color. Must be one \`omni::omni_colors()\`.

- icon_color_fg:

  Desired icon color. Should be 'white' or 'black' but technically all
  hex codes and CSS colors work.

## Value

HTML & CSS that of the desired icon (can be transformed into plain text
using \`as.character()\`)

## Examples

``` r
omni_icon('education', 50, 'teal-600', 'white')
#> <div style="background:#41816F;width:30px;height:30px;display:flex;margin:auto;border-radius:100%;padding:10px;box-sizing:content-box;">
#>   <div style="margin:auto;background:#41816F;"><?xml version="1.0" encoding="UTF-8"?>
#> <svg xmlns="http://www.w3.org/2000/svg" width="30px" height="30px" viewBox="0 0 70 70" fill="none" style="background:#41816F;">
#>   <path d="M11.1533 33.8992V51.0154C17.6637 55.4932 25.5468 58.1259 34.0449 58.1259C42.543 58.1259 49.6535 55.7482 55.9764 51.6604V34.2442L34.0449 42.1048L11.1533 33.8992Z" fill="white"/>
#>   <path d="M64.0792 35.0842V21.7708L34.0396 11L4 21.7708V26.6236L34.0396 37.3944L61.079 27.6962V36.1568L59.4364 36.7418V42.7873L65.7144 40.5371V34.4917L64.0717 35.0767L64.0792 35.0842ZM34.0396 23.5334C31.2419 23.5334 28.9693 22.7458 28.9693 21.7708C28.9693 20.7957 31.2419 20.0081 34.0396 20.0081C36.8373 20.0081 39.11 20.7957 39.11 21.7708C39.11 22.7458 36.8373 23.5334 34.0396 23.5334Z" fill="white"/>
#> </svg>
#> </div>
#> </div>
```
