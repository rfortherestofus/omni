#' Load resources - shortcut to system.file
#'
#' @param ... Diverses arguments
pkg_resource <- function(...) {
  system.file("assets", ..., package = "omni", mustWork = TRUE)
}

#' Remove cover page from PDF
#'
#' @description
#' Remove the first page of a PDF file.
#'
#' @param path Path to a PDF file
#' @export
#'
#' @examples
#' \dontrun{
#' remove_cover_page_pdf("my_file.pdf")
#'
#' remove_cover_page_pdf("path/to/my/file.pdf")
#' }
remove_cover_page_pdf <- function(path) {
  if (dir.exists(path)) {
    stop("The provided path is a directory, not a PDF file: '", path, "'")
  }

  if (!file.exists(path)) {
    stop("The specified file does not exist: '", path, "'")
  }

  pdf_length <- qpdf::pdf_length(path)

  if (pdf_length < 2) {
    stop("PDF has less than 2 pages; nothing to remove.")
  }

  path_temp <- paste0(dirname(path), "/temp-", basename(path))

  qpdf::pdf_subset(path, pages = 2:pdf_length, output = path_temp)

  unlink(path)
  file.rename(path_temp, path)
}
