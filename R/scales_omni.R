# Code adapted from https://omni.svbtle.com/creating-corporate-colour-palettes-for-ggplot2

#' Function to extract OMNI colors as hex codes
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
omni_colors <- function(...) {

  omni_colors_vector <- c(`Gray` = "#666666",
                          `Dark Gray` = "#333333",
                          `Dark Blue` = "#314160",
                          `Medium Blue` = "#347686",
                          `Light Blue` = "#779aab",
                          `Teal` = "#8bc0b2",
                          `Orange` = "#eab66f",
                          `Tan` = "#7b7754")

  cols <- c(...)

  cols <- stringr::str_to_title(cols)

  if (is.null(cols))
    return (omni_colors_vector)

  omni_colors_vector[cols]

}

omni_palettes <- list(

  `Main` = omni_colors("Dark Blue", "Medium Blue", "Light Blue", "Teal", "Orange"),

  `Blues` = omni_colors("Dark Blue", "Medium Blue", "Light Blue")
)


#' Return function to interpolate an OMNI color palette
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#'
omni_pal <- function(palette = "Main", reverse = FALSE, ...) {
  pal <- omni_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}


#' Discrete color scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
scale_colour_omni_discrete <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::discrete_scale("colour", paste0("omni_", palette), palette = pal, ...)

}

#' @rdname scale_color_omni_discrete
#' @export
scale_color_omni_discrete <- scale_colour_omni_discrete

#' Continuous color scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
scale_colour_omni_continuous <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::scale_color_gradientn(colours = pal(256), ...)

}

#' @rdname scale_colour_omni_continuous
#' @export
scale_color_omni_continuous <- scale_colour_omni_continuous




#' Discrete fill scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
scale_fill_omni_discrete <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::discrete_scale("fill", paste0("omni_", palette), palette = pal, ...)

}

#' Continuous fill scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
scale_fill_omni_continuous <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::scale_fill_gradientn(colours = pal(256), ...)

}

