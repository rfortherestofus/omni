#' OMNI Table Function
#'
#' This function creates a table in OMNI's style. In order to use it, you have
#' to give the function a name for each table. This is because, behind the
#' scenes, the function actually saves each table as an image, and each image
#' must have a unique file name when it is saved.
#'
#' @param df The data frame to be put into the table
#' @param table_name The name of the table
#'
#' @return
#' @export
#'
#' @examples
omni_table <- function(df, table_name, no_image = FALSE) {


  table <- df %>%
    flextable::flextable() %>%
    flextable::theme_zebra(even_body = "#9DAECE",
                           odd_body = "#CED6E6") %>%
    flextable::fontsize(part = "all", size = 11) %>%
    flextable::font(part = "all", fontname = "Lato") %>%
    flextable::bold(part = "header", bold = TRUE) %>%
    flextable::bold(part = "body", j = 1, bold = TRUE) %>%
    flextable::align(part = "all", align = "center") %>%
    flextable::bg(part = "header", bg = omni_colors("Dark Blue")) %>%
    flextable::color(part = "header", color = "white") %>%
    flextable::color(part = "body", color = "#333333") %>%
    flextable::bg(part = "body", j = 1, bg = omni_colors("Dark Blue")) %>%
    flextable::color(part = "body", j = 1, color = "white") %>%
    flextable::height_all(height = 0.4) %>%
    flextable::border_inner(part = "body", border = officer::fp_border(color = "white")) %>%
    flextable::border(part = "header", border.bottom = officer::fp_border(color = "white"))

  if (no_image == FALSE) {


    if (!fs::dir_exists("images")) {
      fs::dir_create("images")
    }

    table_name <- table_name %>%
      stringr::str_to_lower() %>%
      stringr::str_replace_all("[[:punct:]]", " ") %>%
      stringr::str_replace_all(" ", "-")

    table_file_name <- stringr::str_glue("images/{table_name}.png")

    table %>%
      flextable::save_as_image(table_file_name)

    knitr::include_graphics(table_file_name)

  } else {
    table
  }


}

