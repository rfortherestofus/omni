# Place icons and texts on grid

This function creates the HTML & CSS that places the icons and texts
from \`omni_icon()\` and \`icon_text()\` on a grid.

## Usage

``` r
icon_text_grid(..., width_px = 50, column_gap_px = 10, row_gap_px = 20)
```

## Arguments

- ...:

  Contents to be place on grid. Should consist of \`omni_icon()\` and
  \`icon_text()\` calls.

- width_px:

  Width of the circle in px. Numeric vector of length 1.

- column_gap_px:

  Gap between icon and text in px. Numeric vector of length 1.

- row_gap_px:

  Gap between rows in px. Numeric vector of length 1.

## Value

HTML & CSS

## Examples

``` r
width_px <- 50
icon_color_fg <- "white"
icon_color_bg <- 'teal-600'

icon_text_grid(
  omni_icon('education', width_px, icon_color_bg, icon_color_fg),
  icon_text(
    text = '**71.9%:** Any person younger than 21 caught with or suspected of consuming alcohol or marijuana is charged with Minor in Possession (MIP).'
  ),
  omni_icon('security', width_px, icon_color_bg, icon_color_fg),
  icon_text(
    '**69.8%:** Adults in Colorado who knowingly hep someone younger than 18 break the law - which includes providing minors with alcohol or drubgs - can be charged with a Class 4 felony.'
  ),
  omni_icon('vault', width_px, icon_color_bg, icon_color_fg),
  icon_text(
    '**34.4%:** It is legal for a person ages 18-20 to possess marijuana with a medical marijuana card.'
  ),
  width_px = width_px
) |>
  htmltools::browsable()

  
    


  
  
71.9%: Any person younger than 21 caught with or suspected of consuming alcohol or marijuana is charged with Minor in Possession (MIP).

  
    


  
  
69.8%: Adults in Colorado who knowingly hep someone younger than 18 break the law - which includes providing minors with alcohol or drubgs - can be charged with a Class 4 felony.

  
    


  
  
34.4%: It is legal for a person ages 18-20 to possess marijuana with a medical marijuana card.


```
