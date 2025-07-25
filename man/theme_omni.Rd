% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/theme.R
\name{theme_omni}
\alias{theme_omni}
\title{OMNI Institute ggplot2 theme}
\usage{
theme_omni(
  show_grid_lines = FALSE,
  show_legend = FALSE,
  base_family = "Inter Tight",
  plot_background_color = "Ivory"
)
}
\arguments{
\item{show_grid_lines}{Whether or not to show grid lines. FALSE by default.}

\item{show_legend}{Whether or not to show the legend. FALSE by default.}

\item{base_family}{Base font family. Inter Tight by default.}

\item{plot_background_color}{Whether to make background color Ivory or White}
}
\value{
A ggplot2 theme
}
\description{
Applies the OMNI Institute theme to the plot.
This also allows for colorizing inline texts and using Markdown notation in title, subtitle and caption of the plot.
}
