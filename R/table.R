#' Create a table in OMNI's style
#'
#' Turns a data frame into a table styled with OMNI Institute's fonts,
#' colours and row striping. The result is a \pkg{flextable} object, so it can
#' be piped into any \pkg{flextable} function for further customisation (for
#' example to set column widths, merge cells, or format specific rows).
#'
#' @param df The data frame to turn into a table.
#' @param group_by Optional character vector of grouping variable(s). When
#'   supplied, the data is grouped and the group-label rows are shaded.
#'   Defaults to \code{NULL} (no grouping).
#' @param first_col_gray Should the first column be shaded gray (with white
#'   text)? Defaults to \code{FALSE}.
#' @param caption The table caption. Defaults to \code{NULL} (no caption).
#' @param with_stripes Should rows use a striped (zebra) pattern? Defaults to
#'   \code{TRUE}.
#' @param dark_group_rows When \code{group_by} is supplied, should the group
#'   rows use a darker navy shade instead of steel blue? Defaults to
#'   \code{FALSE}.
#'
#' @details
#' By default the table uses an autofit layout and fills the width of the page
#' or container, sizing each column to fit its content.
#'
#' When rendered in the OMNI PDF report, column widths are held constant where
#' a table breaks across pages, and the header row is repeated at the top of
#' each page the table spans. This is handled automatically and needs no extra
#' code.
#'
#' To control the relative width of columns, pipe the result through
#' \code{\link[flextable]{width}} and switch the layout to \code{"fixed"} with
#' \code{\link[flextable]{set_table_properties}}. The widths act as
#' proportions and are scaled to fill the available width. There must be one
#' width per column:
#'
#' \preformatted{
#' omni_table(df) |>
#'   flextable::width(width = c(2.5, 1, 1, 1)) |>
#'   flextable::set_table_properties(layout = "fixed", width = 1)
#' }
#'
#' @return A \pkg{flextable} object (of class \code{omni_table}).
#'
#' @seealso \code{\link[flextable]{width}} and
#'   \code{\link[flextable]{set_table_properties}} for adjusting column widths
#'   and the table layout.
#'
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
#' # Basic table
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table()
#'
#' # Shade the first column
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table(first_col_gray = TRUE)
#'
#' # Group rows by a variable
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3, .by = species) |>
#'   omni_table(group_by = "species")
#'
#' # Add a caption
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table(caption = "Table 1. [Insert Table Name]")
#'
#' # Without the striped pattern
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table(with_stripes = FALSE)
#'
#' # Overwrite number formatting by transforming to character first
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   dplyr::mutate(year = as.character(year)) |>
#'   omni_table()
#'
#' # Set column widths manually. Pipe through flextable::width() and switch
#' # the layout to "fixed" so the widths are respected. The width vector needs
#' # one entry per column (palmerpenguins::penguins has 8); here the first
#' # column is made wider than the rest.
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table() |>
#'   flextable::width(width = c(2, 1, 1, 1, 1, 1, 1, 1)) |>
#'   flextable::set_table_properties(layout = "fixed", width = 1)
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

  # In the paged (PDF) context, give the table explicit content-proportional
  # column widths and a fixed layout. Combined with `table-layout: fixed` in
  # pdf_report.css this keeps columns from being recomputed (and shifting)
  # where the table breaks across pages, while preserving the content-based
  # proportions of the default autofit layout. Skipped when the caller has
  # already set a fixed layout, so a manual
  # `width() |> set_table_properties(layout = "fixed")` is left untouched.
  if (is.null(x$properties$layout) || identical(x$properties$layout, "autofit")) {
    col_widths <- flextable::dim_pretty(x, part = "all")$widths
    x <- x |>
      flextable::width(width = col_widths) |>
      flextable::set_table_properties(layout = "fixed", width = 1)
  }

  extra_class <- x$properties$opts_html$extra_class
  x$properties$opts_html$extra_class <- unique(c(extra_class, "no-shadow-dom"))
  knitr::opts_knit$set("is.paged.js" = FALSE)

  NextMethod()
}
