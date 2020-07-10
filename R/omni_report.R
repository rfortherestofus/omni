# https://github.com/rstudio/rstudio/issues/3331

#' Create a new report using the OMNI RMarkdown template
#'
#' @param file_name The name of the file for your RMarkdown document. Defaults to "report" and creates a file called report.Rmd
#' @param type_of_report The type of report you're creating ("General", "Simple Report", or "Cleaning")
#'
#' @return
#' @export
#'
#' @examples
new_omni_report <- function(file_name = "report",
                            type_of_report = "General") {

  if (type_of_report == "General") {
    type_of_report = "omni-rmarkdown-template"
  }

  if (type_of_report == "Simple Report") {
    type_of_report = "simple-report"
  }

  if (type_of_report == "Cleaning") {
    type_of_report = "cleaning"
  }

  rmarkdown::draft(file = stringr::str_glue("{file_name}.Rmd"),
                   template = type_of_report,
                   package = "omni",
                   create_dir = FALSE,
                   edit = FALSE)
}
