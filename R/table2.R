# Internal helpers ------------------------------------------------------

#' Lighten a hex color by blending it toward white
#'
#' Used to derive a stripe color from a single brand color when the caller
#' does not supply one explicitly, so `omni_table2()` can be handed any
#' organization's brand color and still produce a sensible zebra stripe.
#'
#' @noRd
lighten_color <- function(hex, amount = 0.65) {
  rgb_mat <- grDevices::col2rgb(hex) / 255
  lightened <- rgb_mat + (1 - rgb_mat) * amount
  grDevices::rgb(lightened[1, ], lightened[2, ], lightened[3, ])
}

#' Create a table in OMNI's style, powered by tinytable
#'
#' Turns a data frame into a table styled with OMNI Institute's colours and
#' row striping. The result is a \pkg{tinytable} object, so it can be piped
#' into any \pkg{tinytable} function for further customisation. Unlike
#' \code{\link{omni_table}}, which is built on \pkg{flextable} and only
#' renders well in HTML and Word, \code{omni_table2()} is built on
#' \pkg{tinytable}, which has native support for Typst, so it renders
#' correctly in \pkg{omni}'s Typst-based PDF reports as well as HTML and Word.
#'
#' @param df The data frame to turn into a table.
#' @param group_by Optional name of a single grouping column. When supplied,
#'   the data is grouped and a full-width label row is inserted before each
#'   group. Defaults to \code{NULL} (no grouping).
#' @param first_col_gray Should the first column be shaded with
#'   \code{brand_color} (with white text)? Defaults to \code{FALSE}.
#' @param with_stripes Should rows use a striped (zebra) pattern? Defaults to
#'   \code{TRUE}.
#' @param dark_group_rows When \code{group_by} is supplied, should the group
#'   label rows use \code{dark_color} instead of \code{brand_color}? Defaults
#'   to \code{FALSE}.
#' @param brand_color Hex color used for the header row, and for group label
#'   rows and the shaded first column unless overridden. Defaults to OMNI's
#'   steel blue. Pass any organization's brand color here (for example a
#'   client's primary color) to restyle the table without changing anything
#'   else.
#' @param stripe_color Hex color used for the striped rows. Defaults to
#'   \code{NULL}, which derives a light tint of \code{brand_color}
#'   automatically.
#' @param dark_color Hex color used for group label rows when
#'   \code{dark_group_rows = TRUE}. Defaults to OMNI's navy.
#'
#' @return A \pkg{tinytable} object.
#'
#' @details
#' To add a caption, use Quarto's own \code{tbl-cap} chunk option rather than
#' \pkg{tinytable}'s own \code{caption} argument (which \code{omni_table2()}
#' does not expose): Quarto's HTML/Word writers render it fine, but its
#' Markdown-to-Typst conversion silently drops a caption set through
#' \pkg{tinytable} directly, while \code{tbl-cap} survives the conversion and
#' additionally supports cross-references (\verb{@tbl-my-label}).
#'
#' \preformatted{
#' #| label: tbl-fruit-sales
#' #| tbl-cap: "Quarterly sales of nonsense fruit."
#' fruit_sales |>
#'   omni_table2()
#' }
#'
#' @export
#'
#' @import tinytable
#'
#' @examples
#' # Basic table
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table2()
#'
#' # Shade the first column
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table2(first_col_gray = TRUE)
#'
#' # Group rows by a variable
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3, .by = species) |>
#'   omni_table2(group_by = "species")
#'
#' # Without the striped pattern
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table2(with_stripes = FALSE)
#'
#' # Restyle for another organization's brand color (e.g. a client report)
#' palmerpenguins::penguins |>
#'   dplyr::slice(1:3) |>
#'   omni_table2(brand_color = "#921C4C")
omni_table2 <- function(
  df,
  group_by = NULL,
  first_col_gray = FALSE,
  with_stripes = TRUE,
  dark_group_rows = FALSE,
  brand_color = omni_colors("steel-blue-400"),
  stripe_color = NULL,
  dark_color = omni_colors("navy")
) {
  if (is.null(stripe_color)) {
    stripe_color <- lighten_color(brand_color)
  }

  if (!is.null(group_by)) {
    group_values <- df[[group_by]]
    df <- df[order(match(group_values, unique(group_values))), , drop = FALSE]
    group_values <- df[[group_by]]
    body_df <- df[, setdiff(names(df), group_by), drop = FALSE]

    group_runs <- rle(as.character(group_values))
    group_starts <- c(1, cumsum(group_runs$lengths) + 1)[
      seq_along(group_runs$lengths)
    ]
    group_i <- stats::setNames(as.list(group_starts), group_runs$values)
  } else {
    body_df <- df
    group_i <- NULL
  }

  n_row <- nrow(body_df)
  n_render <- n_row + length(group_i)

  table <- body_df |>
    tt() |>
    theme_html(portable = TRUE) |>
    theme_typst(multipage = TRUE) |>
    style_tt(i = 0, color = "white", background = brand_color, bold = FALSE) |>
    style_tt(i = seq_len(n_render), color = "#333333")

  if (!is.null(group_i)) {
    table <- table |>
      group_tt(i = group_i)
  }

  if (with_stripes && n_render >= 2) {
    table <- table |>
      style_tt(i = seq(2, n_render, by = 2), background = stripe_color)
  }

  if (first_col_gray) {
    table <- table |>
      style_tt(
        i = seq_len(n_render),
        j = 1,
        background = brand_color,
        color = "white"
      )
  }

  if (!is.null(group_i)) {
    table <- table |>
      style_tt(
        i = "groupi",
        background = if (dark_group_rows) dark_color else brand_color,
        color = "white"
      )
  }

  table
}
