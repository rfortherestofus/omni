# Code adapted from https://omni.svbtle.com/creating-corporate-colour-palettes-for-ggplot2

#' Function to extract OMNI colors as hex codes
#'
#' omni_colors() enables you to pull colors directly from the OMNI palette.
#' Choose one of the following options: Gray, Medium Gray, Dark Gray, Dark Blue, Medium Blue,
#' Light Blue, Teal, Orange, or Tan. You'll use this function as follows:
#' omni_colors("Dark Blue") returns the hex value of the OMNI Dark Blue.
#'
#'
#' @param colors_sub color or colors you want to return - vector
#' @param variations_sub Variation, default to 0 - vector
#' @param named Snould the output be named ? FALSE by default
#'
#' @return A color vector
#' @export
#'
#' @importFrom dplyr mutate filter
#' @importFrom stringr str_sub
#'
#' @examples
#' omni_colors(c("Dark Blue", "Light Blue"))
#'
omni_colors <- function(colors_sub = c("Dark Blue",
                                       "Medium Blue",
                                       "Light Blue",
                                       "Teal",
                                       "Orange",
                                       "Tan"),
                        variations_sub = "0",
                        named = FALSE) {
  # base color vector
  omni_colors_vector_base <- c(
    "White0" = "#ffffff",
    "Black0" = "#000000",
    "Gray0" = "#666666",
    "Dark Gray0" = "#333333",
    "Dark Blue0" = "#314160",
    "Medium Blue0" = "#347686",
    "Light Blue0" = "#779aab",
    "Teal0" = "#8bc0b2",
    "Orange0" = "#eab66f",
    "Tan0" = "#7b7754"
  )

  # variations
  omni_colors_vector_variations <- c(
    "White1" = "#f2f2f2",
    "White2" = "#d9d9d9",
    "White3" = "#bfbfbf",
    "White4" = "#a6a6a6",
    "White5" = "#807f80",

    "Black1" = "#807f80",
    "Black2" = "#595959",
    "Black3" = "#404040",
    "Black4" = "#262626",
    "Black5" = "#0d0d0d",

    "Gray1" = "#e0e0e0",
    "Gray2" = "#c2c2c1",
    "Gray3" = "#a3a3a3",
    "Gray4" = "#4d4c4c",
    "Gray5" = "#333333",

    "Dark Gray1" = "#d6d6d6",
    "Dark Gray2" = "#adadad",
    "Dark Gray3" = "#858585",
    "Dark Gray4" = "#262626",
    "Dark Gray5" = "#1a191a",

    "Dark Blue1" = "#ced7e7",
    "Dark Blue2" = "#9dafcd",
    "Dark Blue3" = "#6c87b5",
    "Dark Blue4" = "#243147",
    "Dark Blue5" = "#182130",

    "Medium Blue1" = "#d0e7ed",
    "Medium Blue2" = "#a1cfdb",
    "Medium Blue3" = "#72b7c9",
    "Medium Blue4" = "#265865",
    "Medium Blue5" = "#1a3a43",

    "Light Blue1" = "#e4ebee",
    "Light Blue2" = "#c8d6dd",
    "Light Blue3" = "#adc2cd",
    "Light Blue4" = "#537587",
    "Light Blue5" = "#374e5a",

    "Teal1" = "#e8f2f0",
    "Teal2" = "#d0e6e0",
    "Teal3" = "#b8d9d1",
    "Teal4" = "#57a18d",
    "Teal5" = "#3a6b5f",

    "Orange1" = "#fbf0e2",
    "Orange2" = "#f6e2c5",
    "Orange3" = "#f2d3a8",
    "Orange4" = "#dd9124",
    "Orange5" = "#956116",

    "Tan1" = "#e7e5da",
    "Tan2" = "#ceccb6",
    "Tan3" = "#b6b292",
    "Tan4" = "#5c593e",
    "Tan5" = "#3e3b2a"
  )

  # concatenate vectors
  omni_colors_vector <-
    c(omni_colors_vector_base, omni_colors_vector_variations)

  # get number and id
  df_palette <- data.frame(color = omni_colors_vector,
                           palette = names(omni_colors_vector)) |>
    mutate(variation =  str_sub(.data$palette,-1,-1),
           palette = str_sub(.data$palette, 0,-2))

  # filter
  df_palette_filter <- df_palette |>
    filter(.data$palette %in% colors_sub &
             .data$variation %in% variations_sub)

  # return a color palette
  output_colors <- df_palette_filter$color
  names(output_colors) <-
    paste0(df_palette_filter$palette, df_palette_filter$variation)

  # named
  if(named){
    output_colors
  }else{
    unname(output_colors)
  }
}

#' Return function to interpolate an OMNI color palette
#'
#' @param palette Character name of palette in omni_palettes
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to colorRampPalette()
#' @keywords internal
#'
#' @importFrom grDevices colorRampPalette
#'
omni_pal <- function(palette = "Main",
                     reverse = FALSE,
                     ...) {
  if (length(palette) > 1) {
    pal <- omni_colors(colors_sub = palette)
  } else if (palette == "Main") {
    pal <- omni_colors()
  } else if (palette == "Blues") {
    pal <-
      omni_colors(colors_sub = c("Dark Blue", "Medium Blue", "Light Blue"))
  } else{
    pal <-
      omni_colors(colors_sub = palette,
                  variations_sub = c("1", "2", "3", "4", "5"))
  }

  if (reverse == TRUE) {
    pal <- rev(pal)
  }

  colorRampPalette(pal, ...)
}

#' Discrete color scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
#' @importFrom ggplot2 discrete_scale
#'
#' @export
scale_color_omni_discrete <-
  function(palette = "Main",
           reverse = FALSE,
           ...) {
    discrete_scale(
      aesthetics = "color",
      scale_name = paste0("omni_", palette),
      palette = omni_pal(palette = palette,
                         reverse = reverse),
      ...
    )

  }

#' Continuous color scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_gradientn()
#'
#' @importFrom ggplot2 scale_color_gradientn
#'
#' @export
scale_color_omni_continuous <-
  function(palette = "Main",
           reverse = FALSE,
           ...) {
    ggplot2::scale_color_gradientn(colors = omni_pal(palette = palette,
                                                     reverse = reverse)(256),
                                   ...)

  }


#' Discrete fill scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale()
#'
#' @importFrom ggplot2 discrete_scale
#'
#' @export
#'
scale_fill_omni_discrete <-
  function(palette = "Main",
           reverse = FALSE,
           ...) {
    ggplot2::discrete_scale(
      aesthetics = "fill",
      scale_name = paste0("omni_", palette),
      palette = omni_pal(palette = palette,
                         reverse = reverse),
      ...
    )
  }

#' Continuous fill scale based on OMNI colors
#'
#' @param palette Character name of palette in omni_palettes ("Main" or "Blues")
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to scale_color_gradientn()
#'
#' @importFrom ggplot2 scale_color_gradientn
#'
#' @export
scale_fill_omni_continuous <-
  function(palette = "Main",
           reverse = FALSE,
           ...) {
    ggplot2::scale_fill_gradientn(colors = omni_pal(palette = palette,
                                                    reverse = reverse)(256), ...)

  }
