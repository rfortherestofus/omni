#' Include Hypothesis in Rmd
#'
#' @param add_hypothesis TRUE/FALSE
#'
#' @return Hypothesis included
#' @export
#'
include_hypothesis <- function(add_hypothesis) {
  if (add_hypothesis == TRUE) {
    pkg_resource("hypothesis.html")
  } else {
    pkg_resource("hypothesis_void.html")
  }
}
