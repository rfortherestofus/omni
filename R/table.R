#' OMNI Table Function
#'
#' This function creates a table in OMNI's style.
#'
#' @param df The data frame to be put into the table
#'
#' @return A table themed
#' @export
#'
#' @import flextable
#' @importFrom officer fp_border
#' @importFrom stringr str_to_lower str_replace_all str_glue
#' @importFrom fs dir_create dir_exists
#' @importFrom knitr include_graphics
#'

omni_table <- function(d) {
  # table theme
  table <- df |>
    flextable() |>
    theme_zebra(even_body = "#9DAECE",
                odd_body = "#CED6E6")  |>
    fontsize(part = "all", size = 11) |>
    font(part = "all", fontname = "Calibri") |>
    bold(part = "header", bold = TRUE) |>
    bold(part = "body", j = 1, bold = TRUE) |>
    align(part = "all", align = "center") |>
    bg(part = "header", bg = omni_colors("Dark Blue")) |>
    color(part = "header", color = "white") |>
    color(part = "body", color = "#333333") |>
    bg(part = "body",
       j = 1,
       bg = omni_colors("Dark Blue")) |>
    color(part = "body",
          j = 1,
          color = "white") |>
    height_all(height = 0.4) |>
    border_inner(part = "body", border = fp_border(color = "white")) |>
    border(part = "header", border.bottom = fp_border(color = "white"))

  # return table
  table
}
