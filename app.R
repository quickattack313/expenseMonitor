# Entry point kept at the package root. Platforms differ in how they
# run this: shinyapps.io's rsconnect::deployApp() can build and install
# this repo as a package first (in which case library(expenseMonitor)
# below is what makes run_app() available), while git-based deploys
# (e.g. Posit Connect Cloud) just run this file directly and source
# every file in R/ via Shiny's own loadSupport() -- no package install
# step happens there, so the dependencies our R/ code relies on
# unqualified (shiny, bslib, dplyr, tidyr, ggplot2, plotly, lubridate,
# shinyFeedback, magrittr, tools) need to be attached explicitly here
# too. Loading them is harmless either way.
library(shiny)
library(bslib)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(lubridate)
library(shinyFeedback)
library(magrittr)
library(tools)

if (requireNamespace("expenseMonitor", quietly = TRUE)) {
  library(expenseMonitor)
}

run_app()
