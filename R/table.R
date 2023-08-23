#' OMNI Table Function
#'
#' This function creates a table in OMNI's style. In order to use it, you have
#' to give the function a name for each table. This is because, behind the
#' scenes, the function actually saves each table as an image, and each image
#' must have a unique file name when it is saved.
#'
#' @param df The data frame to be put into the table
#' @param table_name The name of the table
#' @param use_image Convert as image
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
omni_table <- function(df, table_name, use_image = TRUE) {
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

  # use the table as an image option
  if (use_image == TRUE) {
    if (!dir_exists("images")) {
      dir_create("images")
    }

    table_name <- table_name |>
      str_to_lower() |>
      str_replace_all("[[:punct:]]", " ") |>
      str_replace_all(" ", "-")

    table_file_name <- str_glue("images/{table_name}.png")

    table |>
      save_as_image(table_file_name)

    include_graphics(table_file_name)
  } else {
    table
  }
}
