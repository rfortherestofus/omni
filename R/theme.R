#' OMNI Institute ggplot2 theme
#'
#' @param grid_lines Boolean to indicate whether to have grid_lines (TRUE by default)
#' @param show_legend Whether or not to show the legend (TRUE by default)
#'
#' @return
#' @export
#'
#' @examples
theme_omni <- function(show_grid_lines = TRUE,
                       show_legend = TRUE) {

  # Determine user OS
  # https://stackoverflow.com/questions/4463087/detecting-operating-system-in-r-e-g-for-adaptive-rprofile-files
  user_os <- Sys.info()[['sysname']]

  if (user_os == "Windows") {
    grDevices::windowsFonts(`Lato` = grDevices::windowsFont("Lato"))
    grDevices::windowsFonts(`Lato Light` = grDevices::windowsFont("Lato Light"))
    grDevices::windowsFonts(`Lato Black` = grDevices::windowsFont("Lato Black"))
  } else {
    suppressWarnings(suppressMessages(extrafont::font_import(pattern = "Lato", prompt=FALSE)))
  }

  usethis::ui_done("Lato font has been imported and can be used")

  omni_theme <- ggplot2::theme_minimal(base_family = "Lato") +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   axis.title.x = ggplot2::element_text(margin = ggplot2::margin(15, 0, 0, 0)),
                   axis.title.y = ggplot2::element_text(margin = ggplot2::margin(0, 15, 0, 0)),
                   plot.title = ggplot2::element_text(margin = ggplot2::margin(0, 0, 15, 0),
                                                      face = "bold"))

  if (show_grid_lines == FALSE) {

    omni_theme <- omni_theme +
      ggplot2::theme(panel.grid.major = ggplot2::element_blank())

  }

  if (show_legend == FALSE) {

    omni_theme <- omni_theme +
      ggplot2::theme(legend.position = "none")

  }

  omni_theme

}

