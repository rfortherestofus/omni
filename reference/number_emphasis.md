# Create a number emphasis element

This function creates the HTML & CSS for the desired number emphasis.

## Usage

``` r
number_emphasis(number, text, color, font_size_pt = 16, fixed_width_px = 300)
```

## Arguments

- number:

  The emphasized number. Numeric or character vector of length 1.

- text:

  The info text. Character vector of length 1.

- color:

  Desired background color. Must be one \`omni::omni_colors()\`

- font_size_pt:

  Font size of emphasized number in pt. Numeric vector of length 1.
  Defaults to 16.

- fixed_width_px:

  Width of the number emphasis in px. Must be numeric vector of
  length 1. Defaults to 300.

## Value

HTML & CSS that of the desired number emphasis

## Examples

``` r
number_emphasis(
   number = 1234,
   text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
   color = 'teal-400'
)
#> <div style="width:300px;display:flex;font-weight:600;">
#>   <div style="font-size:16pt;color:black;background:white !important;border:5px solid #8AC0B3;border-radius:100%;aspect-ratio:1;width:75px;height:75px;display:flex;z-index:1;">
#>     <div style="margin:auto;background:white !important;">1234</div>
#>   </div>
#>   <div style="background:#8AC0B3;height:80%;font-size:12pt;margin-top:auto;margin-bottom:auto;margin-left:-30px;padding-left:55px;padding-right:10px;padding-top:2px;padding-bottom:2px;z-index:0;">pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.</div>
#> </div>

htmltools::browsable(
 htmltools::div(
   style = 'font-family: "Inter Tight"',
   number_emphasis(
     number = 1,
     text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
     color = 'teal-400'
   ),
   htmltools::br(),
   number_emphasis(
     number = 12,
     text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
     color = 'teal-400'
   ),
   htmltools::br(),
   number_emphasis(
     number = 123,
     text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
     color = 'teal-400'
   ),
   htmltools::br(),
   number_emphasis(
     number = 1234,
     text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
     color = 'teal-400'
   ),
   htmltools::br(),
   number_emphasis(
     number = '12.1K',
     text = 'pt. Inter Tight for stats numbers. 12 pt Inter Tight for stats content.',
     color = 'teal-400'
   ),
   htmltools::br(),
   number_emphasis(
     number = '123,456',
     text = 'and some shorter text as well.',
     color = 'teal-400',
     font_size_pt = 14
   )
 )
) |>
 print()
```
