#' Function to extract WVC colors as hex codes
#'
#' omni_colors() enables you to pull colors directly from the WVC palette.
#' Choose from:
#' "white", "ivory", "ivory-400", "orange-red-200", "orange-red-400",
#' "orange-red-600", "golden-yellow-200", "golden-yellow-400", "golden-yellow-600",
#' "olive-green-200", "olive-green-400", "olive-green-600", "teal-200", "teal-400",
#' "teal-600", "plum-200", "plum-400", "plum-600", "periwinkle-200", "periwinkle-400",
#' "periwinkle-600", "steel-blue-200", "steel-blue-400", "steel-blue-600"
#'
#' @name omni_colors
#' @param colors_sub Character vector of color names.
#' @param named Logical, should output be named? Default is FALSE.
#' @return A vector of hex codes.
#' @export
#' @examples
#' omni_colors("orange-red-400")
#' omni_colors(c("plum-400", "golden-yellow-400", "teal-400"))
#' omni_colors(c("steel-blue-200", "olive-green-400"), named = TRUE)
omni_colors <- function(
    colors_sub = c(
        "white",
        "ivory",
        "ivory-400",
        "orange-red-200",
        "orange-red-400",
        "orange-red-600",
        "golden-yellow-200",
        "golden-yellow-400",
        "golden-yellow-600",
        "olive-green-200",
        "olive-green-400",
        "olive-green-600",
        "teal-200",
        "teal-400",
        "teal-600",
        "plum-200",
        "plum-400",
        "plum-600",
        "periwinkle-200",
        "periwinkle-400",
        "periwinkle-600",
        "steel-blue-200",
        "steel-blue-400",
        "steel-blue-600",
        "navy"
    ),
    named = FALSE
) {
    allowed_colors <- c(
        "white",
        "ivory",
        "ivory-400",
        "orange-red-200",
        "orange-red-400",
        "orange-red-600",
        "golden-yellow-200",
        "golden-yellow-400",
        "golden-yellow-600",
        "olive-green-200",
        "olive-green-400",
        "olive-green-600",
        "teal-200",
        "teal-400",
        "teal-600",
        "plum-200",
        "plum-400",
        "plum-600",
        "periwinkle-200",
        "periwinkle-400",
        "periwinkle-600",
        "steel-blue-200",
        "steel-blue-400",
        "steel-blue-600",
        "navy"
    )

    wrong_colors <- colors_sub[!(colors_sub %in% allowed_colors)]
    contains_not_allowed_colors <- length(wrong_colors) > 0
    if (contains_not_allowed_colors) {
        cli::cli_abort(
            'All colors in {.var colors_sub} must be one of {.val {allowed_colors}}.
            The following colors are not allowed: {.val {wrong_colors}}'
        )
    }

    omni_color_vector <- c(
        `white` = "#ffffff",
        `ivory` = "#F9F7F4",
        `ivory-400` = "#E9DFCF",
        `orange-red-200` = "#FF9E85",
        `orange-red-400` = "#FF5E34",
        `orange-red-600` = "#CC4100",
        `golden-yellow-200` = "#FDE880",
        `golden-yellow-400` = "#FCD82B",
        `golden-yellow-600` = "#F7B925",
        `olive-green-200` = "#B8C690",
        `olive-green-400` = "#89A046",
        `olive-green-600` = "#3B5530",
        `teal-200` = "#C5DFD9",
        `teal-400` = "#8AC0B3",
        `teal-600` = "#41816F",
        `plum-200` = "#DD9CB9",
        `plum-400` = "#C65A8B",
        `plum-600` = "#821C4C",
        `periwinkle-200` = "#D4DDEB",
        `periwinkle-400` = "#A9BAD8",
        `periwinkle-600` = "#5776B2",
        `steel-blue-200` = "#BFCBD3",
        `steel-blue-400` = "#677384",
        `steel-blue-600` = "#405065",
        `navy` = "#081C39"
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
#' omni_palette <- omni_pal(c("periwinkle-600", "orange-red-400"))
#' omni_palette(10)
omni_pal <- function(
    palette = c(
        "orange-red-400",
        "golden-yellow-400",
        "olive-green-400",
        "teal-400",
        "plum-400",
        "periwinkle-400"
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
#' @param palette Character vector of OMNI colors OR one of `c("orange-red", "golden-yellow", "olive-green", "plum", "teal", "periwinkle")`.
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
    if (palette == "orange-red") {
        palette = c("orange-red-200", "orange-red-400", "orange-red-600")
    } else if (palette == "golden-yellow") {
        palette = c(
            "golden-yellow-200",
            "golden-yellow-400",
            "golden-yellow-600"
        )
    } else if (palette == "olive-green") {
        palette = c("olive-green-200", "olive-green-400", "olive-green-600")
    } else if (palette == "teal") {
        palette = c("teal-200", "teal-400", "teal-600")
    } else if (palette == "plum") {
        palette = c("plum-200", "plum-400", "plum-600")
    } else if (palette == "periwinkle") {
        palette = c("periwinkle-200", "periwinkle-400", "periwinkle-600")
    }
    ggplot2::scale_color_gradientn(
        colors = omni_pal(palette, reverse)(256),
        ...
    )
}

#' Continuous fill scale based on OMNI colors
#'
#' @name scale_fill_omni_continuous
#' @param palette Character vector of OMNI colors OR one of `c("orange-red", "golden-yellow", "olive-green", "plum", "teal", "periwinkle")`.
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
    if (palette == "orange-red") {
        palette = c("orange-red-200", "orange-red-400", "orange-red-600")
    } else if (palette == "golden-yellow") {
        palette = c(
            "golden-yellow-200",
            "golden-yellow-400",
            "golden-yellow-600"
        )
    } else if (palette == "olive-green") {
        palette = c("olive-green-200", "olive-green-400", "olive-green-600")
    } else if (palette == "teal") {
        palette = c("teal-200", "teal-400", "teal-600")
    } else if (palette == "plum") {
        palette = c("plum-200", "plum-400", "plum-600")
    } else if (palette == "periwinkle") {
        palette = c("periwinkle-200", "periwinkle-400", "periwinkle-600")
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
        "orange-red-400",
        "golden-yellow-400",
        "olive-green-400",
        "teal-400",
        "plum-400",
        "periwinkle-400"
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
        "orange-red-400",
        "golden-yellow-400",
        "olive-green-400",
        "teal-400",
        "plum-400",
        "periwinkle-400"
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
