#' Function to extract WVC colors as hex codes
#'
#' omni_colors() enables you to pull colors directly from the WVC palette.
#' Choose from:
#' "White", "Ivory", "Ivory 400", "Orange-Red 200", "Orange-Red 400",
#' "Orange-Red 600", "Golden-Yellow 200", "Golden-Yellow 400", "Golden-Yellow 600",
#' "Olive-Green 200", "Olive-Green 400", "Olive-Green 600", "Teal 200", "Teal 400",
#' "Teal 600", "Plum 200", "Plum 400", "Plum 600", "Periwinkle 200", "Periwinkle 400",
#' "Periwinkle 600", "Steel Blue 200", "Steel Blue"
#'
#' @name omni_colors
#' @param colors_sub Character vector of color names.
#' @param named Logical, should output be named? Default is FALSE.
#' @return A vector of hex codes.
#' @export
#' @examples
#' omni_colors("Orange-Red 400")
#' omni_colors(c("Plum 400", "Golden-Yellow 400", "Teal 400"))
#' omni_colors(c("Steel Blue 200", "Olive-Green 400"), named = TRUE)
omni_colors <- function(
    colors_sub = c(
        "White",
        "Ivory",
        "Ivory 400",
        "Orange-Red 200",
        "Orange-Red 400",
        "Orange-Red 600",
        "Golden-Yellow 200",
        "Golden-Yellow 400",
        "Golden-Yellow 600",
        "Olive-Green 200",
        "Olive-Green 400",
        "Olive-Green 600",
        "Teal 200",
        "Teal 400",
        "Teal 600",
        "Plum 200",
        "Plum 400",
        "Plum 600",
        "Periwinkle 200",
        "Periwinkle 400",
        "Periwinkle 600",
        "Steel Blue 200",
        "Steel Blue",
        "Navy"
    ),
    named = FALSE
) {
    omni_color_vector <- c(
        `White` = "#ffffff",
        `Ivory` = "#F9F7F4",
        `Ivory 400` = "#E9DFCF",
        `Orange-Red 200` = "#FF9E85",
        `Orange-Red 400` = "#FF5E34",
        `Orange-Red 600` = "#CC4100",
        `Golden-Yellow 200` = "#FDE880",
        `Golden-Yellow 400` = "#FCD82B",
        `Golden-Yellow 600` = "#F7B925",
        `Olive-Green 200` = "#B8C690",
        `Olive-Green 400` = "#89A046",
        `Olive-Green 600` = "#3B5530",
        `Teal 200` = "#C5DFD9",
        `Teal 400` = "#8AC0B3",
        `Teal 600` = "#41816F",
        `Plum 200` = "#DD9CB9",
        `Plum 400` = "#C65A8B",
        `Plum 600` = "#821C4C",
        `Periwinkle 200` = "#D4DDEB",
        `Periwinkle 400` = "#A9BAD8",
        `Periwinkle 600` = "#5776B2",
        `Steel Blue 200` = "#BFCBD3",
        `Steel Blue` = "#677384",
        `Navy` = "#081C39"
    )

    output_colors <- omni_color_vector[colors_sub]

    if (named) {
        return(output_colors)
    } else {
        return(unname(output_colors))
    }
}

#' Function to interpolate a OMNI color palette
#'
#' @name omni_pal
#' @param palette Character vector of OMNI colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments for colorRampPalette()
#' @return A function that generates interpolated colors.
#' @export
#' @examples
#' omni_palette <- omni_pal(c("Periwinkle 600", "Orange-Red 400"))
#' omni_palette(10)
omni_pal <- function(
    palette = c(
        "Orange-Red 400",
        "Golden-Yellow 400",
        "Olive-Green 400",
        "Teal 400",
        "Plum 400",
        "Periwinkle 400"
    ),
    reverse = FALSE,
    ...
) {
    pal <- omni_colors(palette)

    if (reverse) {
        pal <- rev(pal)
    }

    grDevices::colorRampPalette(pal, ...)
}


#' Continuous color scale based on OMNI colors
#'
#' @name scale_color_omni_continuous
#' @param palette Character vector of OMNI colors OR one of `c("Orange-Red", "Golden-Yellow", "Olive-Green", "Plum", "Teal", "Periwinkle")`.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to scale_color_gradientn()
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_omni_continuous()
scale_color_omni_continuous <- function(
    palette,
    reverse = FALSE,
    ...
) {
    if (palette == "Orange-Red") {
        palette = c("Orange-Red 200", "Orange-Red 400", "Orange-Red 600")
    } else if (palette == "Golden-Yellow") {
        palette = c(
            "Golden-Yellow 200",
            "Golden-Yellow 400",
            "Golden-Yellow 600"
        )
    } else if (palette == "Olive-Green") {
        palette = c("Olive-Green 200", "Olive-Green 400", "Olive-Green 600")
    } else if (palette == "Teal") {
        palette = c("Teal 200", "Teal 400", "Teal 600")
    } else if (palette == "Plum") {
        palette = c("Plum 200", "Plum 400", "Plum 600")
    } else if (palette == "Periwinkle") {
        palette = c("Periwinkle 200", "Periwinkle 400", "Periwinkle 600")
    }
    ggplot2::scale_color_gradientn(
        colors = omni_pal(palette, reverse)(256),
        ...
    )
}

#' Continuous fill scale based on OMNI colors
#'
#' @name scale_fill_omni_continuous
#' @param palette Character vector of OMNI colors OR one of `c("Orange-Red", "Golden-Yellow", "Olive-Green", "Plum", "Teal", "Periwinkle")`.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to scale_fill_gradientn()
#' @export
#' @examples
#' library(ggplot2)
#' library(dplyr)
#'
#' mpg_summary <- mpg |>
#'  group_by(class) |>
#'  summarise(avg_hwy = mean(hwy))
#'
#' ggplot(mpg_summary, aes(x = class, y = avg_hwy, fill = avg_hwy)) +
#'   geom_bar(stat = "identity") +
#'   scale_fill_omni_continuous()
scale_fill_omni_continuous <- function(
    palette,
    reverse = FALSE,
    ...
) {
    if (palette == "Orange-Red") {
        palette = c("Orange-Red 200", "Orange-Red 400", "Orange-Red 600")
    } else if (palette == "Golden-Yellow") {
        palette = c(
            "Golden-Yellow 200",
            "Golden-Yellow 400",
            "Golden-Yellow 600"
        )
    } else if (palette == "Olive-Green") {
        palette = c("Olive-Green 200", "Olive-Green 400", "Olive-Green 600")
    } else if (palette == "Teal") {
        palette = c("Teal 200", "Teal 400", "Teal 600")
    } else if (palette == "Plum") {
        palette = c("Plum 200", "Plum 400", "Plum 600")
    } else if (palette == "Periwinkle") {
        palette = c("Periwinkle 200", "Periwinkle 400", "Periwinkle 600")
    }

    ggplot2::scale_fill_gradientn(colors = omni_pal(palette, reverse)(256), ...)
}


#' Discrete fill scale based on OMNI colors
#'
#' @name scale_fill_omni_discrete
#' @param palette Character vector of OMNI colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to discrete_scale()
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = class, fill = class)) +
#'   geom_bar() +
#'   scale_fill_omni_discrete()
scale_fill_omni_discrete <- function(
    palette = c(
        "Orange-Red 400",
        "Golden-Yellow 400",
        "Olive-Green 400",
        "Teal 400",
        "Plum 400",
        "Periwinkle 400"
    ),
    reverse = FALSE,
    ...
) {
    ggplot2::discrete_scale(
        aesthetics = "fill",
        scale_name = "omni",
        palette = omni_pal(palette, reverse),
        ...
    )
}

#' Discrete color scale based on OMNI colors
#'
#' @name scale_color_omni_discrete
#' @param palette Character vector of OMNI colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to discrete_scale()
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
#'     geom_point(size = 2.5) +
#'     scale_color_omni_discrete()
scale_color_omni_discrete <- function(
    palette = c(
        "Orange-Red 400",
        "Golden-Yellow 400",
        "Olive-Green 400",
        "Teal 400",
        "Plum 400",
        "Periwinkle 400"
    ),
    reverse = FALSE,
    ...
) {
    ggplot2::discrete_scale(
        aesthetics = "color",
        scale_name = "omni",
        palette = omni_pal(palette, reverse),
        ...
    )
}
