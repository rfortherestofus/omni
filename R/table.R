#' OMNI Table Function
#'
#' This function creates a table in OMNI's style.
#'
#' @param df The data frame to be put into the table
#' @param group_by Character vector containing of grouping variables
#' @param first_col_gray Should the first column be gray. Default to FALSE
#' @param caption The caption of the table
#' @param with_stripes TRUE or FALSE depending on whether a striped pattern should be used. Defaults to TRUE (which uses stripes.)
#' @param dark_group_rows Whether or not to use a darker color (navy) for group rows when `group_by` is not NULL
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
    with_stripes = TRUE,
    dark_group_rows = FALSE
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
          'transparent'
        },
        odd_body = 'transparent'
      ) |>
      bold(part = 'header', bold = FALSE) |>
      fontsize(part = "all", size = 11) |>
      font(part = "all", fontname = "Inter Tight") |>
      bg(part = "header", bg = omni_colors("steel-blue-400")) |>
      color(part = "header", color = "white") |>
      color(part = "body", color = "#333333") |>
      height_all(height = 0.4) |>
      border_inner(part = "all", border = fp_border(color = "white"))

    # highlight grouped row
    if (!is.null(group_by)) {
      # get row nb of grouped row
      grouped_df <- df |> as_grouped_data(group_by)
      grouped_row_nb <- which(!is.na(grouped_df[[group_by[1]]]))

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
          align_with_table = FALSE,
          fp_p = officer::fp_par(padding.bottom = 6, padding.top = 10)
        )
    }

    # Add border at bottom of header in column 1
    if (first_col_gray) {
      table <- table |>
        bg(part = "body", j = 1, bg = omni_colors("steel-blue-400")) |>
        color(part = "body", j = 1, color = "white") |>
        border(
          i = 1,
          part = "header",
          border.bottom = fp_border(color = "white")
        )
    }

    if (!is.null(group_by)) {
      # get row nb of grouped row
      grouped_df <- df |> as_grouped_data(group_by)
      grouped_row_nb <- which(!is.na(grouped_df$species))

      if (dark_group_rows) {
        bg_color <- omni_colors("navy")
      } else {
        bg_color <- omni_colors("steel-blue-400")
      }

      table <- table |>
        bg(part = "body", j = 1, i = grouped_row_nb, bg = bg_color)
    }

    table <- table |>
      flextable::set_table_properties(
        layout = 'autofit',
        width = 1
      )

    attr(table, "omni_explicit_caption") <- !is.null(caption)
    class(table) <- c("omni_table", class(table))
    table
  }

#' Print an Omni table in an R Markdown document
#'
#' @param x An object created by `omni_table()`.
#' @param ... Additional arguments passed to flextable's print method.
#'
#' @return The rendered table output.
#'
#' @importFrom knitr knit_print
#' @export
knit_print.omni_table <- function(x, ...) {
  is_bookdown <- isTRUE(knitr::opts_knit$get("bookdown.internal.label"))
  is_paged <- isTRUE(knitr::opts_knit$get("is.paged.js"))
  has_tab_caption <- !is.null(knitr::opts_current$get("tab.cap"))
  has_explicit_caption <- isTRUE(attr(x, "omni_explicit_caption"))

  if (
    is_bookdown &&
      knitr::is_html_output() &&
      has_explicit_caption &&
      !has_tab_caption
  ) {
    x$caption$autonum <- list()
  }

  if (!is_bookdown || !is_paged) {
    return(NextMethod())
  }

  old_is_paged <- knitr::opts_knit$get("is.paged.js")
  on.exit(knitr::opts_knit$set("is.paged.js" = old_is_paged), add = TRUE)

  extra_class <- x$properties$opts_html$extra_class
  x$properties$opts_html$extra_class <- unique(c(extra_class, "no-shadow-dom"))
  knitr::opts_knit$set("is.paged.js" = FALSE)

  NextMethod()
}
