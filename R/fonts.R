#' Function to import the Lato font
#'
#' This function imports the Lato font and makes it available
#' for use in R. You just need to run this function once on each computer.
#' Under the surface, this function uses fontextra::font_import(). For more
#' info on this process, please see
#' https://www.andrewheiss.com/blog/2017/09/27/working-with-r-cairo-graphics-custom-fonts-and-ggplot/
#'
#' @return
#' @export
#'
#' @examples
import_lato <- function() {

  # Determine user OS
  # https://stackoverflow.com/questions/4463087/detecting-operating-system-in-r-e-g-for-adaptive-rprofile-files
  user_os <- Sys.info()[['sysname']]

  if (user_os == "Windows") {
    grDevices::windowsFonts(`Lato` = grDevices::windowsFont("Lato Regular"))
    grDevices::windowsFonts(`Lato Light` = grDevices::windowsFont("Lato Light"))
    grDevices::windowsFonts(`Lato Black` = grDevices::windowsFont("Lato Black"))
  } else {
    suppressWarnings(suppressMessages(extrafont::font_import(pattern = "Lato", prompt=FALSE)))
  }

  usethis::ui_done("Lato font has been imported and can be used")

}
