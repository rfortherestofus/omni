# https://github.com/rstudio/rstudio/issues/3331

#' Create a new report using the OMNI RMarkdown template
#'
#' @param file_name The name of the file for your RMarkdown document. Defaults to "report" and creates a file called report.Rmd
#'
#' @return
#' @export
#'
#' @examples
omni_report <- function(file_name = "report") {
  rmarkdown::draft(file = stringr::str_glue("{file_name}.Rmd"), template = "omni-rmarkdown-template", package = "omni", create_dir = FALSE)
}
