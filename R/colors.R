# Code adapted from https://omni.svbtle.com/creating-corporate-colour-palettes-for-ggplot2

#' Function to extract OMNI colors as hex codes
#'
#' omni_colors() enables you to pull colors directly from the OMNI palette.
#' Choose one of the following options: Gray, Medium Gray, Dark Gray, Dark Blue, Medium Blue,
#' Light Blue, Teal, Orange, or Tan. You'll use this function as follows:
#' omni_colors("Dark Blue") returns the hex value of the OMNI Dark Blue.
#'
#'
#' @param ... color or colors you want to return
#'
#' @return
#' @export
#'
#' @examples
#' omni_colors("Dark Blue", "Light Blue")
#'
omni_colors <- function(...) {

  omni_colors_vector <- c(`Gray` = "#A6A6A6",
                          `Medium Gray` = "#666666",
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

  omni_colors_vector[cols] %>%
    as.vector()

}

#' Title
#'
#' @param ...
#'
#' @return
#' @export
#' @keywords internal
#'
#' @examples
omni_colors_internal <- function(...) {

  omni_colors_vector <- c(`Gray` = "#A6A6A6",
                          `Medium Gray` = "#666666",
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

  `Main` = omni_colors_internal("Dark Blue", "Medium Blue", "Gray", "Light Blue", "Teal", "Orange", "Tan"),

  `Blues` = omni_colors_internal("Dark Blue", "Medium Blue", "Light Blue", "Teal")
)

usethis::use_data(omni_palettes,
                  overwrite = TRUE)


#' Return function to interpolate an OMNI color palette
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#' @keywords internal
#'
omni_pal <- function(palette = "Main", reverse = FALSE, ...) {
  pal <- omni_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}


#' Discrete color scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
#' @example
#' iris %>%
#' group_by(Species) %>%
#' summarise(sepal_length_mean = mean(Sepal.Length)) %>%
#' ggplot(aes(x = Species, y = sepal_length_mean, fill = Species)) +
#' geom_bar(stat = "identity") +
#' coord_flip() +
#' scale_fill_omni_discrete() +
#' theme_omni()
#'
scale_color_omni_discrete <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::discrete_scale("color", paste0("omni_", palette), palette = pal, ...)

}



#' Continuous color scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_gradientn()
#'
scale_color_omni_continuous <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::scale_color_gradientn(colors = pal(256), ...)

}





#' Discrete fill scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#' @export
#'
scale_fill_omni_discrete <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::discrete_scale("fill", paste0("omni_", palette), palette = pal, ...)

}

#' Continuous fill scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_gradientn()
#' @export
scale_fill_omni_continuous <- function(palette = "Main", reverse = FALSE, ...) {

  pal <- omni_pal(palette = palette, reverse = reverse)

  ggplot2::scale_fill_gradientn(colors = pal(256), ...)

}
