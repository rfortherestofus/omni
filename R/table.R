#' OMNI Table Function
#'
#' This function creates a table in OMNI's style.
#'
#' @param df The data frame to be put into the table
#' @param option flextable (by default) or gt
#' @param grouped Only with option="flextable", use grouped output
#' @param first_col_blue Should the first column be blue. Default to TRUE
#'
#' @return A table themed
#' @export
#'
#' @import flextable
#' @import gt
#' @importFrom officer fp_border
#' @importFrom stringr str_to_lower str_replace_all str_glue
#' @importFrom fs dir_create dir_exists
#' @importFrom knitr include_graphics
#'

omni_table <-
  function(df,
           option = "flextable",
           grouped = NULL,
           first_col_blue = TRUE) {
    if (option == "flextable")
    {
      # handle group
      if (!is.null(grouped)) {
        table <- df |>
          as_grouped_data(grouped) |>
          as_flextable(hide_grouplabel = TRUE)
      } else{
        table <- df |>
          flextable()
      }

      # table theme with flextable
      table <- table |>
        theme_zebra(even_body = "#9DAECE",
                    odd_body = "#CED6E6")  |>
        fontsize(part = "all", size = 11) |>
        font(part = "all", fontname = "Calibri") |>
        bold(part = "header", bold = TRUE) |>
        align(part = "all", align = "center") |>
        bg(part = "header", bg = omni_colors("Dark Blue")) |>
        color(part = "header", color = "white") |>
        color(part = "body", color = "#333333") |>
        height_all(height = 0.4) |>
        border_inner(part = "body", border = fp_border(color = "white")) |>
        border(part = "header",
               border.bottom = fp_border(color = "white"))

      # highlight grouped row
      if (!is.null(grouped)) {
        # get row nb of grouped row
        grouped_row_nb <- df |>
          group_by(!!sym(grouped)) |>
          slice(1) |>
          ungroup() |>
          rowid_to_column(var = "rowid2") |>
          mutate(rowid = rowid + rowid2 - 1) |>
          pull(rowid)


        table <- table |>
          bg(
            part = "body",
            j = 1,
            i = grouped_row_nb,
            bg = omni_colors("Dark Blue")
          ) |>
          bold(
            part = "body",
            j = 1,
            i = grouped_row_nb,
            bold = TRUE
          )  |>
          color(
            part = "body",
            j = 1,
            i = grouped_row_nb,
            color = "white"
          )
      }

      # first column
      if (first_col_blue) {
        table <- table  |>
          bg(part = "body",
             j = 1,
             bg = omni_colors("Dark Blue")) |>
          bold(part = "body",
               j = 1,
               bold = TRUE)  |>
          color(part = "body",
                j = 1,
                color = "white")
      }
    } else if (option == "gt") {
      # table theme with gt
      table <- df |>
        gt() |>
        tab_style(style = list(cell_text(
          font = "Calibri",
          size = 11,
          color = "#333333"
        )),
        locations = list(cells_body())) |>
        tab_style(
          style = list(
            cell_text(
              font = "Calibri",
              size = 11,
              weight = "bold",
              color = "white"
            ),
            cell_fill(color = omni_colors("Dark Blue"))
          ),
          locations = list(cells_column_labels())
        ) |>
        tab_style(style = cell_borders(color = "white"),
                  locations = cells_body()) |>
        tab_style(style = cell_borders("b", color = "white"),
                  locations = cells_column_labels()) |>
        cols_align(align = "center") |>
        tab_options(
          table.background.color = "#9DAECE",
          row.striping.background_color  = "#CED6E6"
        ) |>
        opt_row_striping()

      if (first_col_blue) {
        table <- table   |>
          tab_style(style = list(
            cell_text(weight = "bold",
                      color = "white"),
            cell_fill(color = omni_colors("Dark Blue"))
          ),
          locations = cells_body(columns = 1))
      }
    }
    # return table
    table
  }
