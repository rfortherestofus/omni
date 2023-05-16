#' Write API key to the system - run only once
#'
#' @param people_name Your name
#' @param api_key Your Qualtrics API key
#'
#' @return Env variables
#' @export
#'
qualtromni_register <- function(people_name, api_key, base_url) {
  # taken from qualtrics function - write with name
  home <- Sys.getenv("HOME")
  renv <- file.path(home, ".Renviron")
  if (file.exists(renv)) {
    file.copy(renv, file.path(home, ".Renviron_backup"))
  }
  if (!file.exists(renv)) {
    file.create(renv)
  }
  keyconcat <- paste0("QUALTRICS_API_KEY_", people_name, " = '", api_key,
                      "'")
  urlconcat <- paste0("QUALTRICS_BASE_URL_", people_name, " = '", base_url,
                      "'")
  write(keyconcat, renv, sep = "\n", append = TRUE)
  write(urlconcat, renv, sep = "\n", append = TRUE)

}

#' Connect to Qualtrics - need to have API key register before
#'
#' @return Connection to Qualtrics
#' @export
#'
qualtromni_connect <- function(people_name) {
  readRenviron("~/.Renviron")

  suppressMessages(qualtrics_api_credentials(api_key = Sys.getenv(
    paste0("QUALTRICS_API_KEY_", people_name)
  ),
  base_url = Sys.getenv(
    paste0("QUALTRICS_BASE_URL_", people_name)
  )))
}

#' Title
#'
#' @return
#' @export
#'
#' @examples
qualtromni_list_survey <- function() {

}

