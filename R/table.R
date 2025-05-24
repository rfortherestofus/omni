#' OMNI Table Function
#'
#' This function creates a table in OMNI's style.
#'
#' @param df The data frame to be put into the table
#' @param group_by Character vector containing of grouping variables
#' @param first_col_grey Should the first column be grey. Default to FALSE
#' @param caption The caption of the table
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
#'    omni_table(first_col_grey = TRUE)
#'
#'  palmerpenguins::penguins |>
#'    dplyr::slice(1:3, .by = species) |>
#'    omni_table(group_by = 'species')
#'
#'  palmerpenguins::penguins |>
#'    dplyr::slice(1:3) |>
#'    omni_table(caption = 'Table 1. [Insert Table Name]')
#'

omni_table <-
  function(
    df,
    group_by = NULL,
    first_col_grey = FALSE,
    caption = NULL
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
        even_body = omni_colors('steel-blue-200'),
        odd_body = omni_colors('white')
      ) |>
      bold(part = 'header', bold = FALSE) |>
      fontsize(part = "all", size = 11) |>
      font(part = "all", fontname = "Inter Tight") |>
      bg(part = "header", bg = omni_colors("steel-blue")) |>
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
          bg = omni_colors("steel-blue")
        ) |>
        color(
          part = "body",
          j = 1,
          i = grouped_row_nb,
          color = "white"
        )
    }

    # first column
    if (first_col_grey) {
      table <- table |>
        bg(part = "body", j = 1, bg = omni_colors("steel-blue")) |>
        color(part = "body", j = 1, color = "white")
    }
    # add caption within flextable
    if (!is.null(caption)) {
      # valid without rmd
      if (!is.null(knitr::opts_knit$get("rmarkdown.pandoc.to"))) {
        # if rmd format is word
        if (knitr::opts_knit$get("rmarkdown.pandoc.to") == "docx") {
          table <- table |>
            set_caption(
              as_paragraph(as_chunk(
                caption,
                props = fp_text_default(font.family = "Inter Tight")
              )),
              word_stylename = "Table Caption"
            )
        } else {
          table <- table |>
            set_caption(
              caption = as_paragraph(
                as_chunk(
                  caption,
                  props = fp_text_default(
                    font.family = "Inter Tight",
                    bold = TRUE
                  )
                )
              )
            )
        }
      } else {
        table <- table |>
          set_caption(
            caption = as_paragraph(
              as_chunk(
                caption,
                props = fp_text_default(
                  font.family = "Inter Tight",
                  font.size = 11
                )
              )
            ),
            align_with_table = FALSE
          )
      }
    }

    table
  }

# The guide isn't clear on alignment.
# I'd go with numbers right-aligned and rest is left-aligned

# The bg color of the striped background is using `#DDE1E5` in the Word doc.
# That's not a defined brand color.
# I'm going with `steel-blue-200` (`#BFCBD3`) here as this is closest to the color in the Word doc.

# The argument `first_col_blue` was translated to `first_col_grey`.
# Is this feature still required? For now, I've defaulted it to `FALSE`
