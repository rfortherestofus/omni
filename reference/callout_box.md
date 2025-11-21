# Create a callout box

This function creates the HTML & CSS for the desired callout boxes. It
can use the "version 600" colors of the color palette and highlight
specific text via \`\<highlight\>\` tags.

## Usage

``` r
callout_box(text, color, fixed_width_px = 300)
```

## Arguments

- text:

  The text of the callout box. Character vector of length 1. Text that
  is supposed to be highlighted needs to be wrapped in
  \<highlight\>\</highlight\> tags.

- color:

  The color of the callout box. One of the "version 600" colors from
  omni_colors(), i.e. "orange-red-600", "golden-yellow-600", "teal-600",
  "plum-600", "periwinkle-600"

- fixed_width_px:

  Width of the callout box in px. Must be numeric vector of length 1.
  Defaults to 300.

## Value

HTML & CSS that of the desired callout box

## Examples

``` r
htmltools::browsable(
  callout_box(
    text = 'This is a callout box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
    color = 'olive-green-600'
  )
)

  


This is a callout box. You can change text color to
highlight certain parts, or just leave the text all white.
Change the background color as desired to match the page.



htmltools::browsable(
  callout_box(
    text = 'This is a callout box. You can <highlight>change text color to highlight certain parts</highlight>, or just leave the text all white. Change the background color as desired to match the page.',
    color = 'orange-red-600'
  )
)

  


This is a callout box. You can change text color to
highlight certain parts, or just leave the text all white.
Change the background color as desired to match the page.


```
