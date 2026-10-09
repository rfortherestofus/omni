#' Evaluate inline R code in a string
#'
#' @description
#' Evaluate the knitr inline code chunks contained in a string and return the
#' string with each of them replaced by its value. Anything that is not inline
#' code is left untouched.
#'
#' @param x A character string.
#' @param envir Environment used to evaluate the code.
#'
#' @return A character string.
#'
#' @noRd
eval_inline_code <- function(x, envir = knitr::knit_global()) {
  # Same shape as knitr's own inline code pattern: a backtick, "r", a
  # separator, then anything up to the closing backtick.
  matches <- gregexpr("`r[ #\n][^`]*`", x)

  regmatches(x, matches) <- lapply(
    regmatches(x, matches),
    function(code) {
      vapply(
        code,
        eval_one_inline_code,
        FUN.VALUE = character(1),
        envir = envir,
        USE.NAMES = FALSE
      )
    }
  )

  x
}

eval_one_inline_code <- function(code, envir) {
  expr <- sub("^`r[ #\n]", "", code)
  expr <- sub("`$", "", expr)

  value <- eval(parse(text = expr), envir = envir)

  paste(as.character(value), collapse = ", ")
}

#' Get a YAML metadata field, with inline R code evaluated
#'
#' @description
#' [rmarkdown::metadata] returns the YAML front matter exactly as it was
#' written, so a field that contains inline R code - a `title` built from
#' `params$site`, for instance - comes back as the code itself rather than as
#' its value. `omni_meta()` returns the same field with any inline code
#' evaluated, which is what report templates need when the same template is
#' rendered repeatedly with different `params`.
#'
#' @param field Name of the YAML field, such as `"title"`.
#' @param default Value returned when the field is missing or empty.
#' @param envir Environment used to evaluate the inline code. Defaults to the
#'   knitting environment, which is where `params` lives.
#'
#' @return A character string.
#' @export
#'
#' @examples
#' \dontrun{
#' omni_meta("title")
#'
#' omni_meta("acknowledgements", default = "our partners")
#' }
omni_meta <- function(field, default = "", envir = knitr::knit_global()) {
  value <- rmarkdown::metadata[[field]]

  if (is.null(value) || length(value) == 0) {
    return(default)
  }

  value <- paste(as.character(value), collapse = " ")

  if (!nzchar(trimws(value))) {
    return(default)
  }

  tryCatch(
    eval_inline_code(value, envir = envir),
    error = function(e) {
      cli::cli_abort(
        c(
          "Can't evaluate the inline R code in the {.field {field}} YAML field.",
          "x" = conditionMessage(e)
        ),
        call = NULL
      )
    }
  )
}
