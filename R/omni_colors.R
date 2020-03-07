#' Function to extract OMNI colors as hex codes
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
omni_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (omni_colors)

  omni_colors[cols]
}


