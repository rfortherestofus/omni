#' Load resources - shortcut to system.file
#'
#' @param ... Diverses arguments
pkg_resource <- function(...) {
  system.file("assets", ..., package = "omni", mustWork = TRUE)
}
