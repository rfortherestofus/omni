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
  keyconcat <-
    paste0("QUALTRICS_API_KEY_", people_name, " = '", api_key,
           "'")
  urlconcat <-
    paste0("QUALTRICS_BASE_URL_", people_name, " = '", base_url,
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

  suppressMessages(
    qualtRics::qualtrics_api_credentials(api_key = Sys.getenv(
      paste0("QUALTRICS_API_KEY_", people_name)
    ),
    base_url = Sys.getenv(
      paste0("QUALTRICS_BASE_URL_", people_name)
    ))
  )
}

#' Get surveys
#'
#' @return A tibble with all surveys
#' @export
#'
qualtromni_list_survey <- function() {
  qualtRics::all_surveys()
}

#' Get survey by name of ID
#'
#' @param survey_id_name Survey name or ID, whatever
#'
#' @return A survey
#' @export
#'
qualtromni_get_survey <- function(survey_id_name) {
  if (substr(survey_id_name, 1, 3) == "SV_") {
    # by ID
    qualtRics::fetch_survey(survey_id_name)
  } else{
    # by name
    survey_id <- qualtRics::all_surveys() |>
      dplyr::filter(name == survey_id_name) |>
      dplyr::pull(id)

    qualtRics::fetch_survey(survey_id)
  }
}
