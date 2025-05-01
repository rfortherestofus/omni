#' Function to extract WVC colors as hex codes
#'
#' omni_colors() enables you to pull colors directly from the WVC palette.
#' Choose from:
#' "white", "ivory", "ivory.dark", "orange.red.light", "orange.red",
#' "orange.red.dark", "golden.yellow.light", "golden.yellow", "golden.yellow.dark",
#' "olive.green.light", "olive.green", "olive.green.dark", "teal.light", "teal",
#' "teal.dark", "plum.light", "plum", "plum.dark", "periwinkle.light", "periwinkle",
#' "periwinkle.dark", "steel.blue.light", "steel.blue.dark"
#'
#' @name omni_colors
#' @param colors_sub Character vector of color names.
#' @param named Logical, should output be named? Default is FALSE.
#' @return A vector of hex codes.
#' @export
#' @examples
#' omni_colors("orange.red")
#' omni_colors(c("plum", "golden.yellow", "teal"))
#' omni_colors(c("steel.blue.light", "olive.green"), named = TRUE)
omni_colors <- function(
    colors_sub = c(
        "white",
        "ivory",
        "ivory.dark",
        "orange.red.light",
        "orange.red",
        "orange.red.dark",
        "golden.yellow.light",
        "golden.yellow",
        "golden.yellow.dark",
        "olive.green.light",
        "olive.green",
        "olive.green.dark",
        "teal.light",
        "teal",
        "teal.dark",
        "plum.light",
        "plum",
        "plum.dark",
        "periwinkle.light",
        "periwinkle",
        "periwinkle.dark",
        "steel.blue.light",
        "steel.blue.dark"
    ),
    named = FALSE
) {
    omni_color_vector <- c(
        white = "#ffffff",
        ivory = "#F9F7F4",
        ivory.dark = "#E9DFCF",
        orange.red.light = "#FF9E85",
        orange.red = "#FF5E34",
        orange.red.dark = "#CC4100",
        golden.yellow.light = "#FDE880",
        golden.yellow = "#FCD82B",
        golden.yellow.dark = "#F7B925",
        olive.green.light = "#B8C690",
        olive.green = "#89A046",
        olive.green.dark = "#3B5530",
        teal.light = "#C5DFD9",
        teal = "#8AC0B3",
        teal.dark = "#41816F",
        plum.light = "#DD9CB9",
        plum = "#C65A8B",
        plum.dark = "#821C4C",
        periwinkle.light = "#D4DDEB",
        periwinkle = "#A9BAD8",
        periwinkle.dark = "#5776B2",
        steel.blue.light = "#BFCBD3",
        steel.blue.dark = "#677384"
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
#' @param palette Character vector of colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments for colorRampPalette()
#' @return A function that generates interpolated colors.
#' @export
#' @examples
#' omni_palette <- omni_pal(c("periwinkle.dark", "orange.red"))
#' omni_palette(10)
omni_pal <- function(
    palette,
    reverse = FALSE,
    ...
) {
    pal <- omni_colors(palette)

    if (reverse) {
        pal <- rev(pal)
    }

    grDevices::colorRampPalette(pal, ...)
}

#' Discrete color scale based on OMNI colors
#'
#' @name scale_color_omni_discrete
#' @param palette Character vector of colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to discrete_scale()
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
#'     geom_point(size = 2.5) +
#'     scale_color_omni_discrete()
scale_color_omni_discrete <- function(
    palette = c("periwinkle.dark", "orange.red"),
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

#' Continuous color scale based on OMNI colors
#'
#' @name scale_color_omni_continuous
#' @param palette Character vector of colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to scale_color_gradientn()
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_omni_continuous()
scale_color_omni_continuous <- function(
    palette = c("periwinkle.dark", "orange.red"),
    reverse = FALSE,
    ...
) {
    ggplot2::scale_color_gradientn(
        colors = omni_pal(palette, reverse)(256),
        ...
    )
}

#' Orange-red continuous color scale based on OMNI colors
#'
#' @name scale_color_orange_red_omni_continuous
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to `scale_color_gradientn()`
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_orange_red_omni_continuous()
scale_color_orange_red_omni_continuous <- function(reverse = FALSE, ...) {
    scale_color_omni_continuous(
        c("orange.red.light", "orange.red", "orange.red.dark"),
        reverse,
        ...
    )
}

#' Golden-yellow continuous color scale based on OMNI colors
#'
#' @name scale_color_golden_yellow_omni_continuous
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to `scale_color_gradientn()`
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_golden_yellow_omni_continuous()
scale_color_golden_yellow_omni_continuous <- function(reverse = FALSE, ...) {
    scale_color_omni_continuous(
        c("golden.yellow.light", "golden.yellow", "golden.yellow.dark"),
        reverse,
        ...
    )
}

#' Olive-green continuous color scale based on OMNI colors
#'
#' @name scale_color_olive_green_omni_continuous
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to `scale_color_gradientn()`
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_olive_green_omni_continuous()
scale_color_olive_green_omni_continuous <- function(reverse = FALSE, ...) {
    scale_color_omni_continuous(
        c("olive.green.light", "olive.green", "olive.green.dark"),
        reverse,
        ...
    )
}

#' Teal continuous color scale based on OMNI colors
#'
#' @name scale_color_teal_omni_continuous
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to `scale_color_gradientn()`
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_teal_omni_continuous()
scale_color_teal_omni_continuous <- function(reverse = FALSE, ...) {
    scale_color_omni_continuous(
        c("teal.light", "teal", "teal.dark"),
        reverse,
        ...
    )
}

#' Plum continuous color scale based on OMNI colors
#'
#' @name scale_color_plum_omni_continuous
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to `scale_color_gradientn()`
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_plum_omni_continuous()
scale_color_plum_omni_continuous <- function(reverse = FALSE, ...) {
    scale_color_omni_continuous(
        c("plum.light", "plum", "plum.dark"),
        reverse,
        ...
    )
}

#' Periwinkle continuous color scale based on OMNI colors
#'
#' @name scale_color_periwinkle_omni_continuous
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to `scale_color_gradientn()`
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = displ, y = hwy, color = hwy)) +
#'     geom_point(size = 2.5) +
#'     scale_color_periwinkle_omni_continuous()
scale_color_periwinkle_omni_continuous <- function(reverse = FALSE, ...) {
    scale_color_omni_continuous(
        c("periwinkle.light", "periwinkle", "periwinkle.dark"),
        reverse,
        ...
    )
}


#' Continuous fill scale based on OMNI colors
#'
#' @name scale_fill_omni_continuous
#' @param palette Character vector of colors.
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
scale_fill_omni_continuous <- function(palette, reverse = FALSE, ...) {
    ggplot2::scale_fill_gradientn(colors = omni_pal(palette, reverse)(256), ...)
}

#' Continuous fill scale based on OMNI colors
#'
#' @name scale_fill_omni_continuous
#' @param palette Character vector of colors.
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
scale_fill_omni_continuous <- function(palette, reverse = FALSE, ...) {
    ggplot2::scale_fill_gradientn(colors = omni_pal(palette, reverse)(256), ...)
}


#' Discrete fill scale based on OMNI colors
#'
#' @name scale_fill_omni_discrete
#' @param palette Character vector of colors.
#' @param reverse Boolean, should palette be reversed?
#' @param ... Additional arguments passed to discrete_scale()
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(x = class, fill = class)) +
#'   geom_bar() +
#'   scale_fill_omni_discrete()
scale_fill_omni_discrete <- function(
    palette,
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
