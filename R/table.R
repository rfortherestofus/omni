#' OMNI Table Function
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
omni_table <- function(df) {

  df %>%
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
    flextable::border(part = "header", border.bottom = officer::fp_border(color = "white")) %>%
    flextable::save_as_image("test_flextable.png")

  knitr::include_graphics("test_flextable.png")
}
