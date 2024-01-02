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

#' Read Renviron Qualtrics variables
#'
#' @param organization_name Organization name
#'
#' @return Environment variables loaded
#' @internal
#'
read_renviron_qualtrics <- function(organization_name = "OMNI") {
  readRenviron("~/.Renviron")

  api_key_renviron <-
    Sys.getenv(paste0("QUALTRICS_API_KEY_", organization_name))

  base_url_renviron <-
    Sys.getenv(paste0("QUALTRICS_BASE_URL_", organization_name))

  # return
  list("api_key" = api_key_renviron,
       "base_url" = base_url_renviron)
}

#' Connect to Qualtrics
#'
#' This function connect to Qualtrics. It calls omni::qualtrics_register behind the scenes
#' to provide a connection if no API key and URL are registrered (or if they are expired).
#' In that case, please provide `api_key` and `base_url`
#'
#' @param organization_name Organization name
#' @param api_key Your Qualtrics API key
#' @param base_url Base URL
#'
#' @return Connection to Qualtrics
#' @export
#'
qualtrics_connect <-
  function(organization_name = "OMNI",
           api_key = "",
           base_url = "") {
    # read Renviron
    list_connect_vars <-
      read_renviron_qualtrics(organization_name = organization_name)

    # connect
    try(suppressMessages(
      qualtRics::qualtrics_api_credentials(api_key = list_connect_vars$api_key,
                                           base_url = list_connect_vars$base_url)
    ),
    silent = TRUE)

    # test connection
    # taken from https://stackoverflow.com/questions/2158780/catching-an-error-and-then-branching-logic
    t <- try(qualtrics_list_surveys(), silent = TRUE)

    if ("try-error" %in% class(t)) {
      # ----
      # register (first use or expired API key/URL)
      print("No API key or base URL registred , or API key or base URL expired")

      if (api_key == "" | base_url == "") {
        # ----
        # missing API or URL in the function
        print("Base URL or API key are missing, please provide them")

        stop()

      } else{
        qualtrics_register(
          organization_name = organization_name,
          api_key = api_key,
          base_url = base_url
        )
      }
      # read Renviron again
      list_connect_vars <-
        read_renviron_qualtrics(organization_name = organization_name)

      # try connection again
      try(suppressMessages(
        qualtRics::qualtrics_api_credentials(
          api_key = list_connect_vars$api_key,
          base_url = list_connect_vars$base_url
        )
      ),
      silent = TRUE)

      # test connection again
      t_bis <- try(qualtrics_list_surveys(), silent = TRUE)

      if ("try-error" %in% class(t)) {
        print("Problem somewhere please check your inputs")

        stop()

      } else{
        # ----
        # ALL OK after that
        print("Connection ok")
      }

    } else{
      # ----
      # ALL OK on first try
      print("Connection ok")
    }

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

#' Get labels
#'
#' @param survey_id_name Survey name or ID
#'
#' @return A dataframe with questions codes and labels
#' @export
#'
qualtrics_get_labels <- function(survey_id_name) {
  survey_data <- qualtRics::fetch_survey(
    surveyID = survey_id_name,
    limit = 1,
    force_request = TRUE,
    verbose = FALSE
  )
  # return
  tibble::tibble(
    var_name = colnames(survey_data),
    var_label = colnames(sjlabelled::label_to_colnames(survey_data))
  )
}

#' Apply labels to survey
#'
#' @param survey_data Output or subset of omni::qualtrics_get_survey()
#' @param labels_data Output of omni::qualtrics_get_labels()
#'
#' @return survey data with columns names replaces.
#' @export
#'
qualtrics_apply_labels <- function(survey_data, labels_data) {
  # create list
  list_labels <- labels_data$var_name
  names(list_labels) <-
    make.unique(labels_data$var_label, sep = "_")

  # rename
  survey_data |>
    dplyr::rename(dplyr::any_of(list_labels))
}
