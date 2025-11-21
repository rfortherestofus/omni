# Omni Paged PDF Report

Omni Paged PDF Report

## Usage

``` r
pdf_report(
  main_font = NULL,
  secondary_font = NULL,
  background_cover_image = NULL,
  background_color = NULL,
  primary_font_color = NULL,
  remove_logo = FALSE,
  remove_cover_page = FALSE,
  remove_title_page = FALSE,
  remove_toc_page = FALSE,
  use_csi_style = FALSE,
  ...
)
```

## Arguments

- main_font:

  Main font

- secondary_font:

  Secondary font

- background_cover_image:

  Image to use for the background in the cover page. It must be one of
  (case insensitive): \`c("01-yellow", "02-teal", "03-orangered",
  "06-teal", "07-periwinkle", "07-olive", "08-plum")\`.

- background_color:

  Background color of the document

- primary_font_color:

  Primary color, mostly used in titles.

- remove_logo:

  Whether to remove Omni logos from the document.

- remove_cover_page:

  Whether to remove the cover page.

- remove_title_page:

  Whether to remove the title page.

- remove_toc_page:

  Whether to remove the TOC (table of content) page.

- use_csi_style:

  Whether to use CSI (Center for Social Investment) styling. This
  basically change logos and text in the footer.

- ...:

  Additional arguments passed to \`pagedown::html_paged()\`

## Value

An rmd format
