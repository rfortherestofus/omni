#' OMNI Table Function
#'
#' This function creates a table in OMNI's style.
#'
#' @param df The data frame to be put into the table
#' @param group_by Character vector containing of grouping variables
#' @param first_col_gray Should the first column be gray. Default to FALSE
#' @param caption The caption of the table
#' @param with_stripes TRUE or FALSE depending on whether a striped pattern should be used. Defaults to TRUE (which uses stripes.)
#'
#' @return A table themed
#' @export
#'
#' @import flextable
#' @import gt
#' @import dplyr
#' @importFrom officer fp_border
#' @importFrom stringr str_to_lower str_replace_all str_glue
#' @importFrom fs dir_create dir_exists
#' @importFrom knitr include_graphics
#' @importFrom tibble rowid_to_column
#'
#' @examples
#' palmerpenguins::penguins |>
#'  dplyr::slice(1:3) |>
#'    omni_table()
#'
#'  palmerpenguins::penguins |>
#'    dplyr::slice(1:3) |>
#'    omni_table(first_col_gray = TRUE)
#'
#'  palmerpenguins::penguins |>
#'    dplyr::slice(1:3, .by = species) |>
#'    omni_table(group_by = 'species')
#'
#'  palmerpenguins::penguins |>
#'    dplyr::slice(1:3) |>
#'    omni_table(caption = 'Table 1. [Insert Table Name]')
#'
#' # Without striped pattern
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table(with_stripes = FALSE)
#'
#' # Overwrite number formatting by transforming to character format
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   dplyr::mutate(year = as.character(year)) |>
#'   omni_table()
#'
omni_table <-
  function(
    df,
    group_by = NULL,
    first_col_gray = FALSE,
    caption = NULL,
    with_stripes = TRUE
  ) {
    # handle group
    if (!is.null(group_by)) {
      table <- df |>
        as_grouped_data(group_by) |>
        as_flextable(hide_grouplabel = TRUE)
    } else {
      table <- df |>
        flextable()
    }

    # table theme with flextable
    table <- table |>
      theme_zebra(
        even_body = if (with_stripes) {
          omni_colors('steel-blue-200')
        } else {
          omni_colors('white')
        },
        odd_body = omni_colors('white')
      ) |>
      bold(part = 'header', bold = FALSE) |>
      fontsize(part = "all", size = 11) |>
      font(part = "all", fontname = "Inter Tight") |>
      bg(part = "header", bg = omni_colors("steel-blue-400")) |>
      color(part = "header", color = "white") |>
      color(part = "body", color = "#333333") |>
      height_all(height = 0.4) |>
      border_inner(part = "body", border = fp_border(color = "white")) |>
      border(part = "header", border.bottom = fp_border(color = "white"))

    # highlight grouped row
    if (!is.null(group_by)) {
      # get row nb of grouped row
      grouped_df <- df |> as_grouped_data(group_by)
      grouped_row_nb <- which(!is.na(grouped_df$species))

      table <- table |>
        bg(
          part = "body",
          j = 1,
          i = grouped_row_nb,
          bg = omni_colors("steel-blue-400")
        ) |>
        color(
          part = "body",
          j = 1,
          i = grouped_row_nb,
          color = "white"
        )
    }

    # first column
    if (first_col_gray) {
      table <- table |>
        bg(part = "body", j = 1, bg = omni_colors("steel-blue-400")) |>
        color(part = "body", j = 1, color = "white")
    }
    
    # add caption within flextable
    if (!is.null(caption)) {
      table <- table |>
        set_caption(
          as_paragraph(as_chunk(
            caption,
            props = fp_text_default(
              font.family = "Inter Tight",
              bold = FALSE,
              color = omni_colors('steel-blue-400')
            )
          )),
          align_with_table = FALSE
        )
    }
    
    table |> 
      flextable::set_table_properties(
        layout = 'autofit',
        width = 1
      )
  }


palmerpenguins::penguins |>
  dplyr::slice(1:3) |>
  dplyr::mutate(year = as.character(year)) |>
  omni_table(caption = 'Table 1. [Insert Table Name]')
