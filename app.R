# Entry point kept at the package root so rsconnect/shinyapps.io detects
# this repository as an "app-as-package" deployment: it builds and
# installs the expenseMonitor package from DESCRIPTION, then runs this
# file to launch it.
library(expenseMonitor)

expenseMonitor::run_app()
