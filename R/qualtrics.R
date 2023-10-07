#' Write API key to the system - run only once
#'
#' @param organization_name Name of your organization (e.g. OMNI)
#' @param api_key Your Qualtrics API key
#' @param base_url Base URL
#'
#' @return Env variables
#' @export
#'
qualtrics_register <-
  function(organization_name = "OMNI", api_key, base_url) {
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
      paste0("QUALTRICS_API_KEY_", organization_name, " = '", api_key,
             "'")
    urlconcat <-
      paste0("QUALTRICS_BASE_URL_",
             organization_name,
             " = '",
             base_url,
             "'")
    write(keyconcat, renv, sep = "\n", append = TRUE)
    write(urlconcat, renv, sep = "\n", append = TRUE)

  }

#' Connect to Qualtrics - need to have API key register before
#'
#' @param organization_name Organization name
#'
#' @return Connection to Qualtrics
#' @export
#'
qualtrics_connect <- function(organization_name = "OMNI") {
  readRenviron("~/.Renviron")

  suppressMessages(
    qualtRics::qualtrics_api_credentials(api_key = Sys.getenv(
      paste0("QUALTRICS_API_KEY_", organization_name)
    ),
    base_url = Sys.getenv(
      paste0("QUALTRICS_BASE_URL_", organization_name)
    ))
  )
}

#' Get surveys
#'
#' @return A tibble with all surveys
#' @export
#'
qualtrics_list_surveys <- function() {
  qualtRics::all_surveys()
}

#' Get survey by name of ID
#'
#' @param survey_id_name Survey name or ID
#' @param convert Convert characters, default to FALSE
#' @param var_labels qualtRics::fetch_survey add_var_labels parameter, default to FALSE
#' @param ... Others args
#'
#' @return A survey
#' @export
#'
#' @importFrom rlang .data
qualtrics_get_survey <-
  function(survey_id_name,
           convert = FALSE,
           var_labels = FALSE,
           ...) {
    if (substr(survey_id_name, 1, 3) == "SV_") {
      # by ID
      qualtRics::fetch_survey(
        surveyID = survey_id_name,
        label = TRUE,
        convert = convert,
        force_request = TRUE,
        verbose = FALSE,
        add_var_labels = var_labels,
        ...
      )
    } else{
      # by name
      survey_id <- qualtRics::all_surveys() |>
        dplyr::filter(.data$name == survey_id_name) |>
        dplyr::pull(.data$id)

      qualtRics::fetch_survey(
        surveyID = survey_id,
        label = TRUE,
        convert = convert,
        force_request = TRUE,
        verbose = FALSE,
        add_var_labels = var_labels,
        ...
      )
    }
  }
